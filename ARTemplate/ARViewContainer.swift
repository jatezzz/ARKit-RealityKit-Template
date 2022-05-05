//
//  ARViewContainer.swift
//  ARTemplate
//
//  Created by John Trujillo on 4/5/22.
//

import RealityKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {

    func makeUIView(context: Context) -> ARView {
        return DataModel.shared.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

}
