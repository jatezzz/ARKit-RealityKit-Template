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
    
    var container: ModelEntity = ModelEntity()
    
    init() {
        arView = ARView(frame: .zero)
        
        let boxAnchor = try! Experience.loadBox()
        
        boxAnchor.generateCollisionShapes(recursive: true)
        //First you have to set physic enabled on Reality Composer
        let box = boxAnchor.steelBox as? Entity & HasCollision
        arView.installGestures(for: box!)
        arView.scene.addAnchor(boxAnchor)
        arView.debugOptions = .showPhysics
    }
    
}
