//
//  ARTrackingModel.swift
//  VirtualProduction
//
//  Created by blueken on 2025/07/16.
//

import Foundation
import ARKit
import Combine

struct SendPositionAndRotation: Codable {
    let position: SIMD3<Float>
    let rotation: SIMD3<Float>
}

class ARTrackingModel: NSObject, ObservableObject, ARSessionDelegate {
    let session = ARSession()
    let webSocketClient = WebSocketClient()
    
    @Published var position: SIMD3<Float> = .zero
    @Published var eulerAngles: SIMD3<Float> = .zero
    
    override init() {
        super.init()
        session.delegate = self
    }
    
    func startTracking() {
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravity
        session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }

    func pauseTracking() {
        session.pause()
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let transform = frame.camera.transform
        let translation = SIMD3<Float>(transform.columns.3.x,
                                       transform.columns.3.y,
                                       transform.columns.3.z)
        let rotation = frame.camera.eulerAngles

        DispatchQueue.main.async {
            self.position = translation
            self.eulerAngles = rotation
            
            let data = SendPositionAndRotation(position: translation, rotation: rotation)
            do {
                let jsonData = try JSONEncoder().encode(data)
                self.webSocketClient.send(jsonData)
            } catch {
                print("Failed to encode data: \(error)")
            }
        }
    }
}
