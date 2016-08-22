//: [Previous](@previous)

import UIKit

/**
 通过女娲造人看设计模式
 
 女娲造人过程程涉及三个对象：女娲、八卦炉、三种不同肤色的人，
 
 1. 女娲可以使用场景类Client来表示，
 2. 八卦炉类似于一个工厂，负责制造生产产品（即人类）
 3. 三种不同肤色的人，他们都是同一个接口下的不同实现类，都是人嘛，只是肤色、语言不同，对于八卦炉来说都是它生产出的产品。
 */

//1. 抽象产品Human负责定义产品的共性
//接口Human是对人类的总称，有肤色，可以说话
protocol Human {
    var skinColor: UIColor { get }
    func talk()
}

//2. 具体的产品BlackHuman，YellowHuman，WhiteHuman
class BlackHuman: Human {
    var skinColor: UIColor = UIColor.blueColor()
    func talk() {
        print("黑人说话")
    }
}

class YellowHuman: Human {
    var skinColor: UIColor = UIColor.yellowColor()
    func talk() {
        print("黄色人种说话")
    }
}

class WhiteHuman: Human {
    var skinColor: UIColor = UIColor.whiteColor()
    func talk() {
        print("白色人种说话")
    }
}


//3. 要创建产品需要的参数
enum HumanType {
    case black, yellow, white
}

//4. AbstractHumanFactory为抽象创建类，也就是抽象工厂
protocol AbstractHumanFactory {
    static func make(type: HumanType) -> Human?
}

//4.1 具体如何创建产品类是由具体的实现工厂HumanFactory完成
enum HumanFactory: AbstractHumanFactory {
    static func make(type: HumanType) -> Human? {
        switch type {
        case .black:
            return BlackHuman()
        case .yellow:
            return YellowHuman()
        case .white:
            return WhiteHuman()
        }
    }
}

// Usage

HumanFactory.make(.black)?.skinColor
HumanFactory.make(.white)?.talk()
HumanFactory.make(.yellow)?.skinColor


/**
 所以使用工厂方法模式需要4个条件
 
 1. 抽象产品接口Product负责定义产品的共性
 2. 具体的实现Product接口的产品类
 3. 要创建某个产品需要的参数
 4. 抽象工厂，提供实现工厂来根据不同的参数生产出不同的产品
 
 工厂方法模式的优点
 
 1. 首先，良好的封装性，代码结构清晰。一个对象创建是有条件约束的，如一个调用者需要一个具体的产品对象，只要知道这个产品的类名（或约束字符串）就可以了，不用知道创建对象的艰辛过程，减少模块间的耦合。
 2. 其次，工厂方法模式的扩展性非常优秀。在增加产品类的情况下，只要适当地修改具体的工厂类或扩展一个工厂类，就可以完成“拥抱变化”。
 3. 再次，屏蔽产品类。这一特点非常重要，产品类的实现如何变化，调用者都不需要关心，它只需要关心产品的接口，只要接口保持不表，系统中的上层模块就不要发生变化，因为产品类的实例化工作是由工厂类负责，一个产品对象具体由哪一个产品生成是由工厂类决定的。
 - 在数据库开发中，大家应该能够深刻体会到工厂方法模式的好处：如果使用JDBC连接数据库，数据库从MySql切换到Oracle，需要改动地方就是切换一下驱动名称（前提条件是SQL语句是标准语句），其他的都不需要修改，这是工厂方法模式灵活性的一个直接案例。
 4. 最后，工厂方法模式是典型的解耦框架。高层模块只需要知道产品的抽象类，其他的实现类都不用关心
 - 符合迪米特原则，我不需要的就不要去交流；
 - 也符合依赖倒转原则，只依赖产品类的抽象；
 - 当然也符合里氏替换原则，使用产品子类替换产品父类，没问题！
 
 工厂方法模式的使用场景
 
 1. 首先，工厂方法模式是new一个对象的替代品，所以在所有需要生成对象的地方都可以使用，但是需要慎重地考虑是否要需要增加一个工厂类进行管理，增加代码的复杂度。
 2. 其次，需要灵活的、可扩展的框架时，可以考虑采用工厂方法模式。万物皆对象，那万物也就皆产品类
 - 例如需要设计一个连接邮件服务器的框架，有三种网络协议可供选择：POP3、IMAP、HTTP
 - 我们就可以把这三种连接方法作为产品类，定义一个接口如IConnectMail，
 - 然后定义对邮件的操作方法，三个具体的产品类（也就是连接方式）进行不同的实现
 - 再定义一个工厂方法，按照不同的传入条件，选择不同的连接方式。
 - 如此设计，可以做到完美的扩展，如某些邮件服务器提供了WebService接口，很好，我们只要增加一个产品类就可以了。
 3. 再次，工厂方法模式可以用在异构项目中，
 - 例如通过WebService与一个非Java的项目交互，虽然WebService号称是可以做到异构系统的同构化，但是在实际的开发中，还是会碰到很多问题，如类型问题、WSDL文件的支持问题，等等，从WSDL中产生的对象都认为是一个产品，然后由一个具体的工厂类进行管理，减少与外围系统的耦合。
 4. 最后，可以使用在测试驱动开发的框架下
 - 例如，测试一个类A，就需要把与类A有关联关系的类B也同时产生出来
 - 我们可以使用工厂方法模式把类B虚拟出来，避免类A与类B的耦合。
 - 目前由于JMock和EasyMock的诞生，该使用场景已经弱化了，读者可以在遇到此种情况时直接考虑使用JMock或EasyMock。
*/

//: [Next](@next)
