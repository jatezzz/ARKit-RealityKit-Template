//
//  ZoomStrategy.swift
//  ARTemplate
//
//  Created by John Trujillo on 5/5/22.
//

import Foundation
import ARKit
import RealityKit

class ZoomStrategy: Strategy {

    var factor: Float = 1
    var increment: Float = 0.3

    func setup(arView: ARView, container: Entity & HasCollision) {
        factor = 1
    }

    func reset(arView: ARView, container: Entity & HasCollision) {

    }

    func handleScreenTouch(sender: UITapGestureRecognizer, arView: ARView, container: Entity & HasCollision) {

    }

    func handleButton(_ data: String, arView: ARView, container: Entity & HasCollision) {
        if data == "in" {
            factor += increment
        }
        if data == "out" {
            factor -= increment
        }
        container.transform.scale = [1, 1, 1] * factor

    }
}
