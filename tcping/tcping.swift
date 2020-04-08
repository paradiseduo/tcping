//
//  tcping.swift
//  tcping
//
//  Created by ParadiseDuo on 2020/3/26.
//  Copyright © 2020 ParadiseDuo. All rights reserved.
//

import Cocoa

class tcping: NSObject, GCDAsyncSocketDelegate {
    var socket:GCDAsyncSocket?
    var startTime = Date()
    var group: DispatchGroup
    var queue: DispatchQueue
    var speed = TimeInterval.infinity
    let io = ConsoleIO()
    var domain = ""
    var host = ""
    var port:UInt16 = 80
    
    init(group: DispatchGroup, queue: DispatchQueue) {
        self.group = group
        self.queue = queue
    }
    
    func connectSocket(domain: String, port: UInt16) {
        self.domain = domain
        self.port = port
        self.socket = GCDAsyncSocket(delegate: self, delegateQueue: self.queue)
        if !self.socket!.isConnected {
            self.group.enter()
            do {
                startTime = Date()
                try self.socket?.connect(toHost: domain, onPort: port, withTimeout: 1)
            } catch let error {
                io.writeMessage(error.localizedDescription, to: OutputType.error)
                self.group.leave()
            }
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        self.host = host
        self.speed = Date().timeIntervalSince(startTime) * 1000
        io.printResult(isFinish: false, detail: self)
        self.group.leave()
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        if let e = err {
            io.writeMessage(e.localizedDescription, to: OutputType.error)
            self.group.leave()
        }
    }
}

class Tcping {
    let consoleIO = ConsoleIO()
    func staticMode() {
        if CommandLine.argc < 3 {
            consoleIO.printUsage()
            return
        }
        if CommandLine.arguments.contains(where: { (s) -> Bool in
            return s=="-h" || s=="--help"
        }) {
            consoleIO.printUsage()
            return
        }
        var ip = ""
        var port = "65535"
        
        if CommandLine.argc == 3 {
            let a = CommandLine.arguments[1]
            let b = CommandLine.arguments[2]
            if a.count > b.count {
                ip = a
                port = b
            } else {
                ip = b
                port = a
            }
            if let p = UInt16(port) {
                Tcping.ping(domain: ip, port: p, count: 10)
            } else {
                consoleIO.printUsage()
            }
        } else {
            var countIndex = 0
            var countStringIndex = 0
            var argument = ""
            var count = ""
            for (i, item) in CommandLine.arguments.enumerated() {
                if item == "-c" || item == "--count" {
                    argument = item
                    countStringIndex = i
                    countIndex = countStringIndex+1
                    if countIndex >= CommandLine.arguments.count {
                        consoleIO.printUsage()
                        return
                    } else {
                        count = CommandLine.arguments[countIndex]
                    }
                } else {
                    if i != countIndex && i != countStringIndex {
                        if port.count >= item.count {
                            port = item
                        }
                        if ip.count <= item.count {
                            ip = item
                        }
                    }
                }
            }

            print(ip, port, argument, count)
            if argument == "-c" || argument == "--count" {
                if let p = UInt16(port) {
                    if let c = UInt(count), c <= 65535 {
                        Tcping.ping(domain: ip, port: p, count: c)
                    } else {
                        consoleIO.writeMessage("Count only a number, or out of range(1-65535)")
                    }
                } else {
                    consoleIO.writeMessage("Port only a number, or out of range(1-65535)")
                }
            } else {
                consoleIO.printUsage()
            }
        }
    }
    
    static func ping(domain: String, port:UInt16, count: UInt) {
        for _ in 1...count {
            let m = tcping(group: group, queue: queue)
            sockets.append(m)
            sleep(1)
            m.connectSocket(domain: domain, port: port)
        }
    }
}
