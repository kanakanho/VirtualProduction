//
//  ARTrackingModel.swift
//  VirtualProduction
//
//  Created by blueken on 2025/07/16.
//

import Foundation
import ARKit
import Combine
import simd

struct Euler: Codable {
    let x: Float
    let y: Float
    let z: Float
}

struct SendPositionAndRotation: Codable {
    let position: Euler
    let rotation: Euler
}

class ARTrackingModel: NSObject, ObservableObject, ARSessionDelegate {
    let session = ARSession()
    let webSocketClient = WebSocketClient()
    
    @Published var position: SIMD3<Float> = .zero
    @Published var eulerAngles: SIMD3<Float> = .zero
    
    @Published var isSending: Bool = false {
        didSet {
            if isSending {
                webSocketClient.connect()
            } else {
                webSocketClient.disconnect()
            }
        }
    }
    
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

        if !isSending {
            return
        }
        DispatchQueue.main.async {
            self.position = translation
            self.eulerAngles = rotation
            
            let data = SendPositionAndRotation(position: Euler(x: translation.x, y: translation.y, z: translation.z), rotation: Euler(x: rotation.x, y: rotation.y, z: rotation.z))
            do {
                let jsonData = try JSONEncoder().encode(data)
                let jsonDataString = String(data: jsonData, encoding: .utf8) ?? ""
                self.webSocketClient.send(jsonDataString)
            } catch {
                print("Failed to encode data: \(error)")
            }
        }
        
//        DispatchQueue.main.async {
//            do {
//                let jsonData = try JSONEncoder().encode(frame.camera.transform.inverse)
//                let jsonDataString = String(data: jsonData, encoding: .utf8) ?? ""
//                self.webSocketClient.send(jsonDataString)
//            } catch {
//                print("Failed to encode data: \(error)")
//            }
//        }
    }
}
