//
//  RecordTranslation.swift
//  ARTemplate
//
//  Created by John Trujillo on 5/5/22.
//

import Foundation
import RealityKit
import ARKit

class RecordStrategy: Strategy {

    var customBool = false
    var savedTransform: Transform?

    func setup(arView: ARView, container: Entity & HasCollision) {
    }

    func reset(arView: ARView, container: Entity & HasCollision) {
    }

    func handleScreenTouch(sender: UITapGestureRecognizer, arView: ARView, container: Entity & HasCollision) {
        if customBool, let savedTransform = savedTransform {
            container.transform.translation = container.transform.translation - (savedTransform.translation - arView.cameraTransform.translation)
        }
        savedTransform = arView.cameraTransform
        customBool = !customBool
    }

    func handleButton(_ data: String, arView: ARView, container: Entity & HasCollision) {

    }
}
