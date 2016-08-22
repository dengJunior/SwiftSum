//: [Previous](@previous)

import UIKit

//1. 抽象产品Human负责定义产品的共性
enum HumanSex {
    case male, female
}
protocol Human {
    var sex: HumanSex { get }
    var skinColor: UIColor { get }
    func talk()
}

//2. 具体的产品BlackHuman，YellowHuman，WhiteHuman
class BlackHuman: Human {
    var skinColor: UIColor = UIColor.blueColor()
    func talk() {
        print("黑人说话")
    }
    
    var sex: HumanSex
    init(sex: HumanSex) {
        self.sex = sex
    }
}

class YellowHuman: Human {
    var skinColor: UIColor = UIColor.yellowColor()
    func talk() {
        print("黄色人种说话")
    }
    var sex: HumanSex
    init(sex: HumanSex) {
        self.sex = sex
    }
}

class WhiteHuman: Human {
    var skinColor: UIColor = UIColor.whiteColor()
    func talk() {
        print("白色人种说话")
    }
    var sex: HumanSex
    init(sex: HumanSex) {
        self.sex = sex
    }
}

//4. AbstractHumanFactory为抽象创建类，也就是抽象工厂
protocol AbstractHumanFactory {
    static func makeBlack() -> Human
    static func makeYellow() -> Human
    static func makeWhite() -> Human
}

//4.1 具体如何创建产品类是由具体的实现工厂FemaleFactory和MaleFactory完成
enum FemaleFactory: AbstractHumanFactory {
    static let sex: HumanSex = .female
    static func makeBlack() -> Human {
        return BlackHuman(sex: sex)
    }
    static func makeYellow() -> Human {
        return YellowHuman(sex: sex)
    }
    static func makeWhite() -> Human {
        return WhiteHuman(sex: sex)
    }
}
enum MaleFactory: AbstractHumanFactory {
    static let sex: HumanSex = .male
    static func makeBlack() -> Human {
        return BlackHuman(sex: sex)
    }
    static func makeYellow() -> Human {
        return YellowHuman(sex: sex)
    }
    static func makeWhite() -> Human {
        return WhiteHuman(sex: sex)
    }
}

// Usage

FemaleFactory.makeBlack().sex
MaleFactory.makeYellow().sex

//: [Next](@next)
