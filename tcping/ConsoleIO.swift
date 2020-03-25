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
    }
}
