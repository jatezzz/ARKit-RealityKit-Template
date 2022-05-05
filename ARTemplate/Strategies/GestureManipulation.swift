//
//  GestureStrategy.swift
//  ARTemplate
//
//  Created by John Trujillo on 5/5/22.
//

import Foundation
import RealityKit
import SwiftUI

class GestureStrategy: Strategy {

    var gesturesSaved: [UIGestureRecognizer] = []

    func setup(arView: ARView, container: Entity & HasCollision) {
        gesturesSaved = []
        arView.installGestures([.scale, .rotation], for: container).forEach {
            gesturesSaved.append($0)
        }

    }

    func reset(arView: ARView, container: Entity & HasCollision) {
        gesturesSaved.forEach {
            arView.removeGestureRecognizer($0)
        }
    }

    func handleScreenTouch(sender: UITapGestureRecognizer, arView: ARView, container: Entity & HasCollision) {

    }

    func handleButton(_ data: String, arView: ARView, container: Entity & HasCollision) {

    }
}
