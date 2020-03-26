//
//  ConsoleIO.swift
//  tcping
//
//  Created by Youssef on 2020/3/25.
//  Copyright © 2020 Youssef. All rights reserved.
//

import Foundation

enum OutputType {
  case error
  case standard
}

class ConsoleIO {
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
            case .standard:
                print("\(message)")
            case .error:
                fputs("Error: \(message)\n", stderr)
        }
    }
    
    func printUsage() {
        writeMessage("""
        tcping is a ping over tcp connection.

        Examples:
            1. ping over tcp with custom port 10 times
               > tcping www.baidu.com 80
            2. ping over tcp with custom port 5 times
               > tcping -c 5 www.baidu.com 443

        USAGE: tcping [--count <count>] <ip> <port>

        ARGUMENTS:
          <ip>                    The IP or Domain to tcping.
          <port>                  The port to tcping.

        OPTIONS:
          -c, --count <count>     The number of times to repeat 'tcping'. Default value is 10, Max value is 65535
          -h, --help              Show help information.
        """)
        NotificationCenter.default.post(name: NSNotification.Name("stop"), object: nil)
    }
    
    func printResult(isFinish: Bool = false, detail: tcping, count: UInt = 1, lossCount: UInt = 0, min: NSNumber = 0.0, max: NSNumber = 0.0, avge: NSNumber = 0.0) {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 3

        if isFinish {
            self.writeMessage("Ping statistics \(detail.host):\(detail.port)")
            self.writeMessage("    \(count) probes sent.")
            self.writeMessage("    \(count-lossCount) successful, \(lossCount) failed.")
            self.writeMessage("Approximate trip times:")
            self.writeMessage("    Minimum = \(nf.string(from: min) ?? "")ms, Maximum = \(nf.string(from: max) ?? "")ms, Average = \(nf.string(from: avge) ?? "")ms")
        } else {
            if detail.host == detail.domain {
                self.writeMessage("\(detail.host):\(detail.port) - Connected - \(nf.string(from: NSNumber(value: detail.speed)) ?? "")ms")
            } else {
                self.writeMessage("\(detail.domain):\(detail.port) has address: (\(detail.host):\(detail.port)) - Connected - \(nf.string(from: NSNumber(value: detail.speed)) ?? "")ms")
            }
        }
    }
}
