//
//  Panagram.swift
//  tcping
//
//  Created by Youssef on 2020/3/25.
//  Copyright © 2020 Youssef. All rights reserved.
//

import Foundation

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
            if let p = UInt(port) {
                tcping.start(ip, port: p, count: 10, stepInfo: { (detail) in
                    self.printResult(detail: detail)
                }) { (detail) in
                    self.printResult(isFinish: true, detail: detail)
                }
            } else {
                consoleIO.printUsage()
            }
        } else {
            let argument = CommandLine.arguments[1]
            ip = CommandLine.arguments[3]
            port = CommandLine.arguments[4]
            if argument == "-c" || argument == "--count" {
                if let p = UInt(port) {
                    if let c = UInt(CommandLine.arguments[2]) {
                        tcping.start(ip, port: p, count: c, stepInfo: { (detail) in
                            self.printResult(detail: detail)
                        }) { (detail) in
                            self.printResult(isFinish: true, detail: detail)
                        }
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
    
    func printResult(isFinish: Bool = false, detail: TcpingDetail) {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 3
        if detail.error != "" {
            if isFinish {
                self.consoleIO.writeMessage("\(detail.error)")
            }
        } else {
            if isFinish {
                self.consoleIO.writeMessage("Ping statistics \(detail.domain):\(detail.port)")
                self.consoleIO.writeMessage("    \(detail.count) probes sent.")
                self.consoleIO.writeMessage("    \(detail.count-detail.loss) successful, \(detail.loss) failed.")
                self.consoleIO.writeMessage("Approximate trip times:")
                self.consoleIO.writeMessage("    Minimum = \(nf.string(from: detail.min_time) ?? "")ms, Maximum = \(nf.string(from: detail.max_time) ?? "")ms, Average = \(nf.string(from: detail.avg_time) ?? "")ms")
            } else {
                if detail.ip == detail.domain {
                    self.consoleIO.writeMessage("\(detail.ip):\(detail.port) - Connected - \(nf.string(from: detail.speed) ?? "")ms")
                } else {
                    self.consoleIO.writeMessage("\(detail.domain):\(detail.port) has address: (\(detail.ip):\(detail.port)) - Connected - \(nf.string(from: detail.speed) ?? "")ms")
                }
            }
        }
    }
}
