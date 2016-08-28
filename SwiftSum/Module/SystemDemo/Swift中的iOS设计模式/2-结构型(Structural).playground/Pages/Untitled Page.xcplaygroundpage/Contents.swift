//: Playground - noun: a place where people can play

import Cocoa

/**
 Adapter 适配器模式
 
 The adapter pattern is used to provide a link between two otherwise incompatible types by wrapping the "adaptee" with a class that supports the interface required by the client.
 
 适配器模式是用来提供在两个不兼容的类型之间的联系,通过包装“adaptee”类,支持客户端所需的接口。
 */
protocol OlderDeathStarSuperLaserAiming {
    var angleV: NSNumber {get}
    var angleH: NSNumber {get}
}

//Adaptee
struct DeathStarSuperlaserTarget {
    let angleHorizontal: Double
    let angleVertical: Double
    
    init(angleHorizontal:Double, angleVertical:Double) {
        self.angleHorizontal = angleHorizontal
        self.angleVertical = angleVertical
    }
}

//Adapter
struct OldDeathStarSuperlaserTarget: OlderDeathStarSuperLaserAiming {
    private let target: DeathStarSuperlaserTarget
    var angleV: NSNumber {
        return NSNumber(double: target.angleVertical)
    }
    
    var angleH: NSNumber {
        return NSNumber(double: target.angleHorizontal)
    }
    init(_ target: DeathStarSuperlaserTarget) {
        self.target = target
    }
}

//Usage
let target = DeathStarSuperlaserTarget(angleHorizontal: 14.0, angleVertical: 12.0)
let oldFormat = OldDeathStarSuperlaserTarget(target)
oldFormat.angleV
















