//
//  HeadTiltServerApp.swift
//  HeadTiltServer
//
//  Created by Ricky Han on 11/9/21.
//

import SwiftUI
import Network

class Angles: ObservableObject, CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(roll),\(pitch),\(yaw)"
    }
    
    @Published var roll: Double = 0.0
    @Published var pitch: Double = 0.0
    @Published var yaw: Double = 0.0
    
    func update(angles: [Double]) {
        self.roll = angles[0]
        self.pitch = angles[1]
        self.yaw = angles[2]
    }
    
    func update(angles: Angles) {
        self.roll = angles.roll
        self.pitch = angles.pitch
        self.yaw = angles.yaw
    }
}

@main
struct HeadTiltServerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.angles)
        }
    }
    var angles = Angles()
    
    init() {
        server?.start(angles: self.angles)
    }
}
