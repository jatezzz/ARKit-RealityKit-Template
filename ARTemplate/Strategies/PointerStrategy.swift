//
//  Pointer.swift
//  ARTemplate
//
//  Created by John Trujillo on 5/5/22.
//

import Foundation
import RealityKit
import ARKit

class PointerStrategy: Strategy {

    private var pointerPoints: [Entity] = []

    func setup(arView: ARView, container: Entity & HasCollision) {

    }

    func reset(arView: ARView, container: Entity & HasCollision) {
        for circle in pointerPoints {
            circle.removeFromParent()
        }
        pointerPoints.removeAll()
    }

    func handleScreenTouch(sender: UITapGestureRecognizer, arView: ARView, container: Entity & HasCollision) {
        let location = sender.location(in: arView)
        if let result = raycastResult(fromLocation: location, arView: arView) {
            addTemporalCircle(raycastResult: result, container: container)
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

    private func addTemporalCircle(raycastResult: CollisionCastHit, container: Entity & HasCollision) {
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

}
