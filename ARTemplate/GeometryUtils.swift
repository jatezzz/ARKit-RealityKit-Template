//
//  GeometricUtils.swift
//  ARTemplate
//
//  Created by John Trujillo on 5/5/22.
//

import Foundation

import ARKit
import RealityKit

class GeometryUtils {
    static func calculateDistance(first: SIMD3<Float>, second: SIMD3<Float>) -> Float {
        var distance: Float = sqrt(
                pow(second.x - first.x, 2) +
                        pow(second.y - first.y, 2) +
                        pow(second.z - first.z, 2)
        )

        distance *= 100 // convert in cm
        return abs(distance)
    }

    static func calculateDistance(firstNode: Entity, secondNode: Entity) -> Float {
        return calculateDistance(first: firstNode.position, second: secondNode.position)
    }

    static func createCircle(fromRaycastResult result: ARRaycastResult) -> AnchorEntity {

        let circle = createSphere()
        let planeAnchor = AnchorEntity()
        planeAnchor.addChild(circle)

        return planeAnchor
    }

    static func createBox(color: UIColor = .blue) -> ModelEntity {
        let box = MeshResource.generateBox(size: 0.08) // Generate mesh
        let boxMaterial = SimpleMaterial(color: color, isMetallic: true)
        let boxEntity = ModelEntity(mesh: box, materials: [boxMaterial])
        return boxEntity
    }

    static func createSphere(color: UIColor = .blue) -> ModelEntity {
        let box = MeshResource.generateSphere(radius: 0.005) // Generate mesh
        let boxMaterial = SimpleMaterial(color: color, isMetallic: true)
        let boxEntity = ModelEntity(mesh: box, materials: [boxMaterial])
        return boxEntity
    }

    static func createText(text: String, color: UIColor = .blue) -> ModelEntity {
        let box = MeshResource.generateText(text, extrusionDepth: 0.05, font: .systemFont(ofSize: 0.2), containerFrame: CGRect(), alignment: .left, lineBreakMode: .byWordWrapping) // Generate mesh
        let boxMaterial = SimpleMaterial(color: color, isMetallic: true)
        let boxEntity = ModelEntity(mesh: box, materials: [boxMaterial])
        boxEntity.generateCollisionShapes(recursive: true)
        return boxEntity
    }

    static func placeBox(box: ModelEntity, at position: SIMD3<Float>) -> AnchorEntity {
        let boxAnchor = AnchorEntity(world: position)
        boxAnchor.addChild(box)
        return boxAnchor
    }

}
