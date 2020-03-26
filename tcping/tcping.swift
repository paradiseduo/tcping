//
//  tcping.swift
//  tcping
//
//  Created by YouShaoduo on 2020/3/26.
//  Copyright © 2020 YouShaoduo. All rights reserved.
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
                io.writeMessage("\(error)", to: OutputType.error)
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
            io.writeMessage("\(e)")
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
        var ip = ""
        var port = ""
        
        if CommandLine.argc == 3 {
            ip = CommandLine.arguments[1]
            port = CommandLine.arguments[2]
            if let p = UInt16(port) {
                Tcping.ping(domain: ip, port: p, count: 10)
            } else {
                consoleIO.printUsage()
            }
        } else {
            let argument = CommandLine.arguments[1]
            ip = CommandLine.arguments[3]
            port = CommandLine.arguments[4]
            if argument == "-c" || argument == "--count" {
                if let p = UInt16(port) {
                    if let c = UInt(CommandLine.arguments[2]) {
                        Tcping.ping(domain: ip, port: p, count: c)
                    } else {
                        consoleIO.writeMessage("Count only a number")
                    }
                } else {
                    consoleIO.writeMessage("Port only a number")
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
