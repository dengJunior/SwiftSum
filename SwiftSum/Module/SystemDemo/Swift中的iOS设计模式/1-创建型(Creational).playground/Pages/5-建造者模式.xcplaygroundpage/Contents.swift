//: [Previous](@previous)

import Foundation

/**
 需求：
 牛叉公司很满意我们做的车的模型，签订了一个合同，把奔驰、宝马的车辆模型都交给我们公司制作了，
 不过这次额外增加了一个需求：汽车的启动、停止、喇叭声音、引擎声音都由客户自己控制，他想什么顺序就什么顺序
 
 首先我们分析一下需求，奔驰、宝马都是一个产品，他们有共有的属性，
 牛叉公司关心的是单个模型的运行过程：
 奔驰模型A是先有引擎声音，然后再响喇叭；
 奔驰模型B是先启动起来，然后再有引擎声音，这才是牛叉公司要关心的
 */
enum CarSequence {
    case start, stop, alarm, engineBoom
}

protocol Car {
    //这个参数是各个基本方法执行的顺序
    var sequence: [CarSequence] { get set }
    
    func start()    //模型是启动开始跑了
    func stop()     //能发动，那还要能停下来，那才是真本事
    func alarm()    //喇叭会出声音，是滴滴叫，还是哔哔叫
    func engineBoom()//引擎会轰隆隆地响，不响那是假的
    
    func run()      //模型应该会跑
}

extension Car {
    func run() {
        //循环一遍，谁在前，就先执行谁
        for seq in sequence {
            switch seq {
            case .start:
                start()
            case .stop:
                stop()
            case .alarm:
                alarm()
            case .engineBoom:
                engineBoom()
            }
        }
    }
}

class Benz: Car {
    var sequence: [CarSequence]
    
    init(sequence: [CarSequence]) {
        self.sequence = sequence
    }
    
    func start() {
        print("奔驰车跑起来了")
    }
    func stop() {
        print("奔驰车停下来了")
    }
    func alarm() {
        print("奔驰车喇叭响了")
    }
    func engineBoom() {
        print("奔驰车引擎响了")
    }
}

class BMW: Car {
    var sequence: [CarSequence]
    
    init(sequence: [CarSequence]) {
        self.sequence = sequence
    }
    
    func start() {
        print("宝马车跑起来了")
    }
    func stop() {
        print("宝马车停下来了")
    }
    func alarm() {
        print("宝马车喇叭响了")
    }
    func engineBoom() {
        print("宝马车引擎响了")
    }
}

// MARK: - 汽车组装者
protocol CarBuildable {
    func setSequence(sequence: [CarSequence])
    func make() -> Car
}

class BenzBuilder: CarBuildable {
    private var sequence: [CarSequence] = []
    
    func setSequence(sequence: [CarSequence]) {
        self.sequence = sequence
    }
    func make() -> Car {
        return Benz(sequence: sequence)
    }
}

class BMWBuilder: CarBuildable {
    private var sequence: [CarSequence] = []
    
    func setSequence(sequence: [CarSequence]) {
        self.sequence = sequence
    }
    func make() -> Car {
        return BMW(sequence: sequence)
    }
}

//Usage

/*
 * 客户告诉牛叉公司，我要这样一个模型，然后牛叉公司就告诉我老大
 * 说要这样一个模型，这样一个顺序，然后我就来制造
 */
var sequece = [CarSequence]()
sequece.append(.engineBoom)//客户要求，run的时候时候先发动引擎
sequece.append(.start)
sequece.append(.stop)

//要一个奔驰车
let benzBuilder = BenzBuilder()
//把顺序给这个builder类，制造出这样一个车出来
benzBuilder.setSequence(sequece)

//制造出一个奔驰车
let benz = benzBuilder.make()
//奔驰车跑一下看看
benz.run()

//那如果我再想要个同样顺序的宝马车呢？很简单，再次修改一下场景类
let bmwBuilder = BMWBuilder()
bmwBuilder.setSequence(sequece)
let bmw = bmwBuilder.make()
bmw.run()

/**
 同样运行顺序的宝马车也生产出来了，而且代码很简单。
 
 我们在做项目时，经常会有一个共识：需求是无底洞，是无理性的，不可能你告诉它不增加需求就不增加，
 这四个过程（start、stop、alarm、engineBoom）按照排列组合有很多种，牛叉公司可以随意组合，它要什么顺序的车模我就必须生成什么顺序的车模，客户可是上帝！
 
 那我们不可能预知他们要什么顺序的模型呀，怎么办？
 封装一下，找一个导演，指挥各个事件的先后顺序，然后为每种顺序指定一个代码，你说一种我们立刻就给你生产处理
 如下，有makeBenzA， makeBenzB， makeBMWC。。。
 */

class CarDirector {
    var sequence: [CarSequence] = []
    let benzBuilder = BenzBuilder()
    let bmwBuilder = BMWBuilder()
    
    //A类型的奔驰车模型，先start,然后stop,其他什么引擎了，喇叭一概没有
    func makeBenzA() -> Benz? {
        sequence.removeAll()
        sequence.append(.start)
        sequence.append(.stop)
        benzBuilder.setSequence(sequence)
        return benzBuilder.make() as? Benz
    }
    
    //B型号的奔驰车模型，是先发动引擎，然后启动，然后停止，没有喇叭
    func makeBenzB() -> Benz? {
        sequence.removeAll()
        sequence.append(.engineBoom)
        sequence.append(.start)
        sequence.append(.stop)
        benzBuilder.setSequence(sequence)
        return benzBuilder.make() as? Benz
    }
    
    //C型号的宝马车是先按下喇叭（炫耀嘛），然后启动，然后停止
    func makeBMWC() -> BMW? {
        sequence.removeAll()
        sequence.append(.alarm)
        sequence.append(.start)
        sequence.append(.stop)
        bmwBuilder.setSequence(sequence)
        return bmwBuilder.make() as? BMW
    }
    
    //...
}

//有了这样一个导演类后，我们的场景类就更容易处理了，牛叉公司要A类型的奔驰车10辆，B类型的奔驰车100辆，C类型的宝马车1000辆，非常容易处理
let carDirector = CarDirector()

//10辆A类型的奔驰车
for _ in 0 ..< 10 {
    carDirector.makeBenzA()?.run()
}
//100辆B类型的奔驰车
for _ in 0 ..< 100 {
    carDirector.makeBenzB()?.run()
}
//1000辆C类型的宝马车
for _ in 0 ..< 1000 {
    carDirector.makeBMWC()?.run()
}

//清晰，简单吧,这就是建造者模式。


/**
 ## 建造者模式的应用
 
 ### 建造者模式的优点
 
 1. 封装性
 - 使用建造者模式可以使客户端不必知道产品内部组成的细节，如例子中我们就不需要关心每一个具体的模型内部是如何实现的，产生的对象类型就是Car。
 2. 建造者独立，容易扩展
 - BenzBuilder和BMWBuilder是相互独立的，对系统的扩展非常有利。
 3. 便于控制细节风险
 - 由于具体的建造者是独立的，因此可以对建造过程逐步细化，而不对其他的模块产生任何影响。
 
 ### 建造者模式的使用场景
 
 相同的方法，不同的执行顺序，产生不同的事件结果时，可以采用建造者模式
 
 多个部件或零件,都可以装配到一个对象中，但是产生的运行结果又不相同时，则可以使用该模式。
 
 产品类非常复杂，或者产品类中的调用顺序不同产生了不同的效能，这个时候使用建造者模式是非常合适。
 
 在对象创建过程中会使用到系统中的一些其它对象，这些对象在产品对象的创建过程中不易得到时，也可以采用建造者模式封装该对象的创建过程。该种场景，只能是一个补偿方法，因为一个对象不容易获得，而在设计阶段竟然没有发觉，而要通过创建者模式柔化创建过程，本身已经违反设计最初目标。
 
 ### 建造者模式的注意事项
 
 建造者模式关注的是的零件类型和装配工艺（顺序），这是它与工厂方法模式最大不同的地方，虽然同为创建类模式，但是注重点不同。
 
 ### 建造者模式的扩展
 
 已经不用扩展了，因为我们在汽车模型制造的例子中已经对建造者模式进行了扩展，引入了模板方法模式
 
 可能大家会比较疑惑，为什么在其他介绍设计模式的书籍上创建者模式并不是这样说的，读者请注意，建造者模式中还有一个角色没有说明，就是零件，建造者怎么去建造一个对象？
 
 是零件的组装，组装顺序不同对象效能也不同，这才是建造者模式要表达的核心意义，而怎么才能更好的达到这种效果呢？引入模板方法模式是一个非常简单而有效的办法。
 
 大家看到这里估计就开始犯嘀咕了，这个建造者模式和工厂模式非常相似呀，Yes，是的，是非常相似，但是记住一点你就可以游刃有余的使用了：
 
 - 建造者模式最主要功能是基本方法的调用顺序安排，也就是这些基本方法已经实现了，通俗的说就是零件的装配，顺序不同产生的对象也不同；
 - 而工厂方法则重点是创建，创建零件时它的主要职责，你要什么对象我创造一个对象出来，组装顺序则不是他关心的。
 */

/*
 ## 建造者模式的定义
 
 建造者模式(Builder Pattern)也叫做生成器模式，其定义如下：
 
 Separate the construction of a complex object from its representation so that the same construction process can create different representations.
 将一个复杂对象的构建与它的表示分离，使得同样的构建过程可以创建不同的表示。
 
 在建造者模式中，有如下四个角色：
 
 1. Product 产品类
 - 通常是实现了模板方法模式，也就是有模板方法和基本方法，
 2. Builder 抽象建造者
 - 规范产品的组建，一般是由子类实现。
 3. ConcreteBuilder 具体建造者
 - 实现抽象类定义的所有方法，并且返回一个组件好的对象。
 4. Director 导演
 - 负责安排已有模块的顺序，然后告诉Builder开始建造。
 - 导演类就是起到封装的作用，避免高层模块深入到建造者内部的实现类。当然，在建造者模式比较庞大时，导演类可以有多个。
 */



//: [Next](@next)




















