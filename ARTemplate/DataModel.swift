//
//  DataModel.swift
//  ARTemplate
//
//  Created by John Trujillo on 4/5/22.
//

import Foundation
import Combine
import RealityKit
import SwiftUI
import ARKit

class Context {

    private var strategy: Strategy? = nil

    func setup(strategy: Strategy, arView: ARView, container: Entity & HasCollision) {
        self.strategy = strategy
        self.strategy?.setup("",arView: arView, container:container)
    }

    func update(strategy: Strategy, arView: ARView, container: Entity & HasCollision) {
        self.strategy?.reset("",arView: arView, container:container)
        self.strategy = strategy
        self.strategy?.setup("",arView: arView, container:container)
    }

    func handleScreenTouch(arView: ARView, container: Entity & HasCollision) {
        strategy?.handleScreenTouch("",arView: arView, container: container)
    }
    func handleButton(_ data: String,arView: ARView, container: Entity & HasCollision) {
        strategy?.handleButton(data,arView: arView, container:container)
    }
}

protocol Strategy {

    func setup(_ data: String, arView: ARView, container: Entity & HasCollision)
    func reset(_ data: String, arView: ARView, container: Entity & HasCollision)
    func handleScreenTouch(_ data: String, arView: ARView, container: Entity & HasCollision)
    func handleButton(_ data: String, arView: ARView, container: Entity & HasCollision)
}

class ManualManipulation: Strategy {
    
    var factor: Float = 1
    var increment: Float = 0.3
    
    func setup(_ data: String, arView: ARView, container: Entity & HasCollision){
        factor = 1
    }
    func reset(_ data: String, arView: ARView, container: Entity & HasCollision){
        
    }
    func handleScreenTouch(_ data: String, arView: ARView, container: Entity & HasCollision) {
        
    }
    
    func handleButton(_ data: String, arView: ARView, container: Entity & HasCollision) {
        factor += increment
        container.transform.scale = [1, 1, 1] * factor
        
        factor -= increment
        container.transform.scale = [1, 1, 1] * factor
    }
}

class AutoManipulation: Strategy {
    
    var gesturesSaved: [UIGestureRecognizer] = []
    
    func setup(_ data: String, arView: ARView, container: Entity & HasCollision){
            gesturesSaved = []
        arView.installGestures([.scale, .rotation], for: container).forEach {
                gesturesSaved.append($0)
            }

    }
    func reset(_ data: String, arView: ARView, container: Entity & HasCollision){
            gesturesSaved.forEach {
                arView.removeGestureRecognizer($0)
            }
    }
    
    func handleScreenTouch(_ data: String, arView: ARView, container: Entity & HasCollision) {
       
    }

    func handleButton(_ data: String, arView: ARView, container: Entity & HasCollision) {
       
    }
}

final class DataModel: ObservableObject {
    
    static var shared = DataModel()
    
    var subscriptions = Set<AnyCancellable>()

    @Published var arView: ARView!
    
    var container: Entity & HasCollision
    
    @Published var isInMeasureFunctionality = false
    @Published var isManipulationEnabled = false
    @Published var isRecordingEnabled = false
    @Published var isPointerEnabled = false
    
    private var measurementPoints: [Entity] = []
    private var pointerPoints: [Entity] = []
    
    var customBool = false
    var savedTransform: Transform?
    var context : Context = Context()
    init() {
        
        arView = ARView(frame: .zero)
        
        let boxAnchor = try! Experience.loadBox()
        
        boxAnchor.generateCollisionShapes(recursive: true)
        //First you have to set physic enabled on Reality Composer
        container = (boxAnchor.steelBox as? Entity & HasCollision)!
        arView.scene.addAnchor(boxAnchor)
        arView.debugOptions = .showPhysics
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnARView))
        arView.addGestureRecognizer(tapGesture)
        
        context.setup(strategy: AutoManipulation(), arView: arView, container: container)
    }
    
    @objc func tapOnARView(sender: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        if isInMeasureFunctionality {
            let location = sender.location(in: arView)
            if let result = raycastResult(fromLocation: location) {
                addCircle(raycastResult: result)
            }
            return
        }
        if isRecordingEnabled {
            if customBool, let savedTransform = savedTransform {
                self.container.transform.translation = container.transform.translation - (savedTransform.translation - arView.cameraTransform.translation)
            }
            savedTransform = arView.cameraTransform
            customBool = !customBool
            return
        }

        if isPointerEnabled {
            let location = sender.location(in: arView)
            if let result = raycastResult(fromLocation: location) {
                addTemporalCircle(raycastResult: result)
            }
            return
        }

    }
    
    private func raycastResult(fromLocation location: CGPoint) -> CollisionCastHit? {
        guard let ray = self.arView.ray(through: location) else { return nil }

        let results = arView.scene.raycast(origin: ray.origin, direction: ray.direction)
        return results.first
    }

    func toogleRecordingFlag() {
        isRecordingEnabled = !isRecordingEnabled
    }
    
    func toogleMeasureFunctionality() {
        isInMeasureFunctionality = !isInMeasureFunctionality
        if !isInMeasureFunctionality, !measurementPoints.isEmpty {
            for circle in measurementPoints {
                circle.removeFromParent()
            }
            measurementPoints.removeAll()
        }
    }
    
    func tooglePointerFlag() {
        isPointerEnabled = !isPointerEnabled
        if !isPointerEnabled, !pointerPoints.isEmpty {
            for circle in pointerPoints {
                circle.removeFromParent()
            }
            pointerPoints.removeAll()
        }
    }
    
    private func addCircle(raycastResult: CollisionCastHit) {
        let circleNode = GeometryUtils.createSphere()
        if measurementPoints.count >= 2 {
            for circle in measurementPoints {
                circle.removeFromParent()
            }
            measurementPoints.removeAll()
        }

        container.addChild(circleNode)
        circleNode.setPosition(raycastResult.position, relativeTo: nil)
        measurementPoints.append(circleNode)
        nodesUpdated()
    }
    
    
    private func addTemporalCircle(raycastResult: CollisionCastHit) {
        let circleNode = GeometryUtils.createSphere(color: UIColor(red: 1, green: 0, blue: 0, alpha: 0.6))
        if pointerPoints.count >= 3 {
            for circle in pointerPoints {
                circle.removeFromParent()
            }
            pointerPoints.removeAll()
        }

        container.addChild(circleNode)
        circleNode.setPosition(raycastResult.position, relativeTo: nil)
        pointerPoints.append(circleNode)
    }


    private func nodesUpdated() {
        guard measurementPoints.count == 2 else {
            return
        }
        let distance = GeometryUtils.calculateDistance(firstNode: measurementPoints[0], secondNode: measurementPoints[1])
        let textModel = GeometryUtils.createText(text: "\(distance)m")
        textModel.transform.scale = [1, 1, 1] * 0.05
        textModel.transform.rotation = Transform(pitch: 0.0, yaw: Float.pi, roll: 0.0).rotation
        textModel.setPosition(measurementPoints[1].position + [0, 0.01, 0], relativeTo: nil)
        let parentText = Entity()
        parentText.setPosition(measurementPoints[1].position + [0, 0.01, 0], relativeTo: nil)
        arView.scene.subscribe(to: SceneEvents.Update.self) { [self] _ in
                    parentText.billboard(targetPosition: arView.cameraTransform.translation)
                }
                .store(in: &subscriptions)

        parentText.addChild(textModel, preservingWorldTransform: true)
        container.addChild(parentText)
        measurementPoints.append(textModel)
    }

}

extension Entity {
    /// Billboards the entity to the targetPosition which should be provided in world space.
    func billboard(targetPosition: SIMD3<Float>) {
        look(at: targetPosition, from: position(relativeTo: nil), relativeTo: nil)
    }
}
