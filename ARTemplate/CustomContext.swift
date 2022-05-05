//
//  Context.swift
//  ARTemplate
//
//  Created by John Trujillo on 5/5/22.
//

import Foundation
import RealityKit
import SwiftUI
import ARKit

protocol Strategy {
    func setup(arView: ARView, container: Entity & HasCollision)
    func reset(arView: ARView, container: Entity & HasCollision)
    func handleScreenTouch(sender: UITapGestureRecognizer, arView: ARView, container: Entity & HasCollision)
    func handleButton(_ data: String, arView: ARView, container: Entity & HasCollision)
}

class CustomContext {

    private var strategy: Strategy?

    func update(strategy: Strategy, arView: ARView, container: Entity & HasCollision) {
        self.strategy?.reset(arView: arView, container: container)
        self.strategy = strategy
        self.strategy?.setup(arView: arView, container: container)
    }

    func handleScreenTouch(sender: UITapGestureRecognizer, arView: ARView, container: Entity & HasCollision) {
        strategy?.handleScreenTouch(sender: sender, arView: arView, container: container)
    }
    func handleButton(_ data: String, arView: ARView, container: Entity & HasCollision) {
        strategy?.handleButton(data, arView: arView, container: container)
    }
}
