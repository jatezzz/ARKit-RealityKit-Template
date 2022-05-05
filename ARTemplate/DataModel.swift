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

final class DataModel: ObservableObject {

    static var shared = DataModel()
    
    @Published var arView: ARView!
    
    var container: Entity & HasCollision
    
    @Published var context : CustomContext = CustomContext()
    
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
        
        context.setup(strategy: GestureManipulation(), arView: arView, container: container)
    }
    
    @objc func tapOnARView(sender: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        context.handleScreenTouch(sender: sender, arView: arView, container: container)
    }
    func zoomIn() {
        context.update(strategy: ManualManipulation(), arView: arView, container: container)
        context.handleButton("in", arView: arView, container: container)
    }
    
    func zoomOut() {
        context.update(strategy: ManualManipulation(), arView: arView, container: container)
        context.handleButton("out", arView: arView, container: container)
    }
    
    func toogleManipulationFlag(_ isManual: Bool) {
        context.update(strategy: isManual ?  GestureManipulation(): ManualManipulation(), arView: arView, container: container)
    }

    func toogleRecordingFlag() {
        context.update(strategy: RecordStrategy(), arView: arView, container: container)
    }
    
    func toogleMeasureFunctionality() {
        context.update(strategy: MeasureStrategy(), arView: arView, container: container)
    }
    
    func tooglePointerFlag() {
        context.update(strategy: PointerStrategy(), arView: arView, container: container)
    }

}

extension Entity {
    /// Billboards the entity to the targetPosition which should be provided in world space.
    func billboard(targetPosition: SIMD3<Float>) {
        look(at: targetPosition, from: position(relativeTo: nil), relativeTo: nil)
    }
}
