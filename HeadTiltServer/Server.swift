
import Foundation
import Network

let server = try? Server()

class Server {

    let listener: NWListener

    var connections: [Connection] = []

    init() throws {
        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.enableKeepalive = true
        tcpOptions.keepaliveIdle = 2

        let parameters = NWParameters(tls: nil, tcp: tcpOptions)
        parameters.includePeerToPeer = true
        listener = try NWListener(using: parameters)
        
        listener.service = NWListener.Service(name: "server", type: "_myitem._tcp")
    }

    func start(angles: Angles) {
        listener.stateUpdateHandler = { newState in
            print("listener.stateUpdateHandler \(newState)")
        }
        listener.newConnectionHandler = { [weak self] newConnection in
            print("listener.newConnectionHandler \(newConnection)")
            let connection = Connection(connection: newConnection, angles: angles)
            self?.connections += [connection]
        }
        listener.start(queue: .main)
    }

    func send() {
        connections.forEach {
            $0.send("super message from the server! \(Int(Date().timeIntervalSince1970))")
        }
    }
}
