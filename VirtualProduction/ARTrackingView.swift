//
//  ARTrackingView.swift
//  VirtualProduction
//
//  Created by blueken on 2025/07/16.
//

import SwiftUI
import ARKit

struct ARTrackingView: View {
    @StateObject private var model = ARTrackingModel()
    
    var body: some View {
        ZStack() {
            ARViewContainer(session: model.session)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("📍 位置")
                Text(String(format: "x: %.2f, y: %.2f, z: %.2f",
                            model.position.x, model.position.y, model.position.z))
                
                Text("🧭 向き（ラジアン）")
                Text(String(format: "pitch: %.2f, yaw: %.2f, roll: %.2f",
                            model.eulerAngles.x, model.eulerAngles.y, model.eulerAngles.z))
                
                Toggle(model.isSending ? "送信中" : "送信停止中", isOn: $model.isSending)
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(12)
            .foregroundColor(.white)
            .padding()
        }
        .onAppear {
            model.startTracking()
        }
        .onDisappear {
            model.pauseTracking()
        }
    }
}
