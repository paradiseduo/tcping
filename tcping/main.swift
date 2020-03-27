//
//  main.swift
//  tcping
//
//  Created by YouShaoduo on 2020/3/26.
//  Copyright © 2020 YouShaoduo. All rights reserved.
//

import Foundation

var running = true

var sockets = [tcping]()
let group = DispatchGroup()
let queue = DispatchQueue(label: "tcping")

Tcping().staticMode()

group.notify(queue: DispatchQueue.main) {
    let successArr = sockets.filter { (p) -> Bool in
        return p.speed != TimeInterval.infinity
    }
    let max = successArr.max { (a, b) -> Bool in
        return a.speed < b.speed
    }?.speed
    let min = successArr.min { (a, b) -> Bool in
        return a.speed < b.speed
    }?.speed
    if successArr.count == 0 {
        ConsoleIO().printResult(isFinish: true, detail: sockets[0], count: UInt(sockets.count), lossCount: UInt(sockets.count), min: NSNumber(value: Double.infinity), max: NSNumber(value: Double.infinity), avge: NSNumber(value: Double.infinity))
    } else {
        let avge = successArr.reduce(0.0) { (result: Double, p: tcping) -> Double in return result+p.speed}/Double(successArr.count)
        ConsoleIO().printResult(isFinish: true, detail: sockets[0], count: UInt(sockets.count), lossCount: UInt(sockets.count-successArr.count), min: NSNumber(value: min!), max: NSNumber(value: max!), avge: NSNumber(value: avge))
    }
    NotificationCenter.default.post(name: NSNotification.Name("stop"), object: nil)
}


NotificationCenter.default.addObserver(forName: NSNotification.Name("stop"), object: nil, queue: OperationQueue.main) { (noti) in
    running = false
}

let runLoop = RunLoop.current
let distantFuture = Date.distantFuture
while running == true && runLoop.run(mode: RunLoop.Mode.default, before: distantFuture) {
    
}
