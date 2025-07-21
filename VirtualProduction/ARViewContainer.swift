//
//  ARViewContainer.swift
//  VirtualProduction
//
//  Created by blueken on 2025/07/16.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    let session: ARSession

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session = session
        arView.automaticallyConfigureSession = false
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Do nothing
    }
}
