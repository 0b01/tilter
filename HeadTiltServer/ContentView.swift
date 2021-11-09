//
//  ContentView.swift
//  HeadTiltServer
//
//  Created by Ricky Han on 11/9/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var angles: Angles

    @State var leftAngle = Angles()
    @State var rightAngle = Angles()
    var angle: Double {
        angles.pitch // TODO: interpolate based on left and right
    }
    
    var body: some View {
        VStack(){
            Text("Hello, world! \(angles.debugDescription)")
                .padding()
//                .rotationEffect(Angle(radians: angle))
                .rotation3DEffect(.radians(angle), axis: (x: 0.0, y: 0.0, z: 1.0))
                    .border(Color.gray)
            HStack(){
                Button("Left", action: left)
                Button("Right", action: right)
            }
        }
    }
    
    func left() {
        leftAngle.update(angles: angles)
    }
    func right() {
        leftAngle.update(angles: angles)
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environmentObject(Angles())
//    }
//}
