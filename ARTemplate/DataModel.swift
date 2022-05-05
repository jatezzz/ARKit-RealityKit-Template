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

enum AppState: Equatable {
    case zoom
    case gesture
    case grab
    case pointer
    case measure

    var title: String {
        switch self {
        case .zoom:
            return "Manipulate the object with the buttons"
        case .grab:
            return "Tap the screen to save and restore object's position"
        case .pointer:
            return "Tap the screen to add circles"
        case .measure:
            return "Tap two points to see the distance"
        default:
            return "Manipulate the object thought gestures"
        }
    }

    var strategy: Strategy {
        switch self {
        case .zoom:
            return ZoomStrategy()
        case .grab:
            return GrabStrategy()
        case .pointer:
            return PointerStrategy()
        case .measure:
            return MeasureStrategy()
        default:
            return GestureStrategy()
        }
    }
}

final class DataModel: ObservableObject {

    static var shared = DataModel()

    @Published var arView: ARView!

    var container: Entity & HasCollision

    @Published var context: CustomContext = CustomContext()

    @Published var appState = AppState.gesture {
        didSet {
            print(" === \(appState) ===")
            context.update(strategy: appState.strategy, arView: arView, container: container)
        }
    }

    init() {

        arView = ARView(frame: .zero)

        guard let boxAnchor = try? Experience.loadBox() else {
            container = ModelEntity()
            return
        }

        boxAnchor.generateCollisionShapes(recursive: true)
        // First you have to set physic enabled on Reality Composer
        container = (boxAnchor.steelBox as? Entity & HasCollision)!
        arView.scene.addAnchor(boxAnchor)
        arView.debugOptions = [.showPhysics]

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnARView))
        arView.addGestureRecognizer(tapGesture)
        appState = .gesture
    }

    @objc func tapOnARView(sender: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        context.handleScreenTouch(sender: sender, arView: arView, container: container)
    }
    func zoomIn() {
        context.handleButton("in", arView: arView, container: container)
    }

    func zoomOut() {
        context.handleButton("out", arView: arView, container: container)
    }

    func setZoomStrategy() {
        appState = .zoom
    }

    func setGrabStrategy() {
        appState = .grab
    }

    func setPointerStrategy() {
        appState = .pointer
    }

    func setMeasureStrategy() {
        appState = .measure
    }

    func setGestureStrategy() {
        appState = .gesture
    }

}

extension Entity {
    /// Billboards the entity to the targetPosition which should be provided in world space.
    func billboard(targetPosition: SIMD3<Float>) {
        look(at: targetPosition, from: position(relativeTo: nil), relativeTo: nil)
    }
}
