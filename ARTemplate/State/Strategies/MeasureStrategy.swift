//
//  MeasureStrategy.swift
//  ARTemplate
//
//  Created by John Trujillo on 5/5/22.
//

import Foundation
import RealityKit
import ARKit
import Combine

class MeasureStrategy: Strategy {

    var subscriptions = Set<AnyCancellable>()

    private var measurementPoints: [Entity] = []

    func setup(arView: ARView, container: Entity & HasCollision) {

    }

    func reset(arView: ARView, container: Entity & HasCollision) {
        for circle in measurementPoints {
            circle.removeFromParent()
        }
        measurementPoints.removeAll()
    }

    func handleScreenTouch(sender: UITapGestureRecognizer, arView: ARView, container: Entity & HasCollision) {
        let location = sender.location(in: arView)
        if let result = raycastResult(fromLocation: location, arView: arView) {
            addCircle(raycastResult: result, arView: arView, container: container)
        }
    }

    func handleButton(_ data: String, arView: ARView, container: Entity & HasCollision) {

    }

    private func raycastResult(fromLocation location: CGPoint, arView: ARView) -> CollisionCastHit? {
        guard let ray = arView.ray(through: location) else {
            return nil
        }

        let results = arView.scene.raycast(origin: ray.origin, direction: ray.direction)
        return results.first
    }

    private func addCircle(raycastResult: CollisionCastHit, arView: ARView, container: Entity & HasCollision) {
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
        nodesUpdated(arView: arView, container: container)
    }

    private func nodesUpdated(arView: ARView, container: Entity & HasCollision) {
        guard measurementPoints.count == 2 else {
            return
        }
        let distance = GeometryUtils.calculateDistance(firstNode: measurementPoints[0], secondNode: measurementPoints[1])
        let textModel = GeometryUtils.createText(text: "\(distance)cm")
        textModel.transform.scale = [1, 1, 1] * 0.05
        textModel.transform.rotation = Transform(pitch: 0.0, yaw: Float.pi, roll: 0.0).rotation
        textModel.setPosition(measurementPoints[1].position + [0, 0.01, 0], relativeTo: nil)
        let parentText = Entity()
        parentText.setPosition(measurementPoints[1].position + [0, 0.01, 0], relativeTo: nil)
        arView.scene.subscribe(to: SceneEvents.Update.self) { _ in
                    parentText.billboard(targetPosition: arView.cameraTransform.translation)
                }
                .store(in: &subscriptions)

        parentText.addChild(textModel, preservingWorldTransform: true)
        container.addChild(parentText)
        measurementPoints.append(textModel)
    }

}
