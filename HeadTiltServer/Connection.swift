//
//  Connection.swift
//  HeadTiltServer
//
//  Created by Ricky Han on 11/9/21.
//

import Foundation
import Network

class Connection {

    let connection: NWConnection
    var angles: Angles?

    // outgoing connection
    init(endpoint: NWEndpoint) {
        print("PeerConnection outgoing endpoint: \(endpoint)")
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.keepaliveIdle = 2

        let parameters = NWParameters(tls: nil, tcp: tcpOptions)
        parameters.includePeerToPeer = true
        connection = NWConnection(to: endpoint, using: parameters)
        self.start()
    }

    // incoming connection
    init(connection: NWConnection, angles: Angles) {
        print("PeerConnection incoming connection: \(connection)")
        self.connection = connection
        self.angles = angles
        self.start()
    }

    func start() {
        connection.stateUpdateHandler = { newState in
            print("connection.stateUpdateHandler \(newState)")
            if case .ready = newState {
                self.receiveMessage()
            }
        }
        connection.start(queue: .main)
    }

    func send(_ message: String) {
        connection.send(content: message.data(using: .utf8), contentContext: .defaultMessage, isComplete: true, completion: .contentProcessed({ error in
            print("Connection send error: \(String(describing: error))")
        }))
    }

    func receiveMessage() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 100) { data, _, _, _ in
            if let data = data,
               let message = String(data: data, encoding: .utf8) {
                // print("Connection receiveMessage message: \(message)")
                let a = (message.split(separator: ";").first?.split(separator: ",").map({Double($0)!}))!
                if a.count == 3 {
                    self.angles?.update(angles: a)
                    print(self.angles!.debugDescription)
                }
            }
            self.receiveMessage()
        }
    }
}
