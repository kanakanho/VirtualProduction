//
//  WebSocketClient.swift
//  spatial-painting
//
//  Created by blueken on 2025/03/20.
//

// original → https://github.com/kanakanho/sensing-handtracking-websocket/blob/main/sensing-handtracking-websocket/WebSocketClient.swift

import Foundation
import ARKit

class WebSocketClient:NSObject, ObservableObject  {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var isConnected: Bool = false
    
    func connect() {
        let url = URL(string: "wss://in-camera-vfx-ws.kajilab.dev/wss")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        webSocketTask?.send(URLSessionWebSocketTask.Message.string("new")) { error in
            if let error = error {
                print(error)
            }
        }
        isConnected = true
        print("WebSocket connected")
    }
    
    func disConnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
        print("WebSocket disconnected")
    }
    
    func send(_ message: String) {
        let msg = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(msg) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func send(_ data: Data) {
        let msg = URLSessionWebSocketTask.Message.data(data)
        webSocketTask?.send(msg) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("WebSocket disconnected")
    }
}
