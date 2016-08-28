//: [Previous](@previous)

import Foundation

/**
 玩网络游戏过程的一个抽象
 */

//定义一个接口GamePlayerType，是所有喜爱网络游戏的玩家
protocol GamePlayerType {
    func login()//登录
    func killBoss()//杀怪
    func upgrade()//升级
}

class GamePlayer: GamePlayerType {
    var name = ""
    init(name: String) {
        self.name = name
    }
    func login() {
        print(name+" 登录了")
    }
    func killBoss() {
        print(name+" 打怪")
    }
    func upgrade() {
        print(name+" 升级了")
    }
}

let player = GamePlayer(name: "zhangsan")
player.login()
player.killBoss()
player.upgrade()
/**
 运行结果也是我们想要的，记录我这段时间的网游生涯。
 心理学家告诉我们，人类对于苦难的记忆比对喜悦的记忆要深刻，
 但是人类对于喜悦是“趋利”性的，每个人都想Happy，都不想让苦难靠近，要想获得幸福，
 苦难也是再所难免的，我们的网游生涯也是如此，游戏打时间长了，
 腰酸背痛、眼涩干枯、手臂酸麻，等等，也就是网络成瘾综合症都出来了
 
 那怎么办呢？我们想玩游戏，但又不想碰触到游戏中的烦恼？如何解决呢？
 有办法，现在游戏代练的公司非常多，我把自己的账号交给代练人员，由他们去帮我升级，去打怪
 */

//定义代理
class GamePlayerProxy: GamePlayerType {
    var player: GamePlayerType? = nil
    init(player: GamePlayerType) {
        self.player = player
    }
    
    func login() {
        player?.login()
    }
    func killBoss() {
        player?.killBoss()
    }
    func upgrade() {
        player?.upgrade()
    }
}
let playerProxy = GamePlayerProxy(player: player)
playerProxy.login()
playerProxy.killBoss()
playerProxy.upgrade()
//运行结果也完全相同,但是你有没有发觉，你的游戏已经在升级，有人在帮你干活了,这就是代理模式。

// MARK: - 普通代理
class GamePlayer2: GamePlayerType {
    var name = ""
    
    // 在构造函数中，传递进来一个IGamePlayer对象，检查谁能创建真实的角色，当然还可以有其他的限制，比如类名必须为Proxy类等等，读者可以根据实际情况进行扩展。
    init?(gamePlayer: GamePlayerType? = nil, name: String) {
        if gamePlayer == nil {
            return nil
        }
        self.name = name
    }
    func login() {
        print(name+" 登录了")
    }
    func killBoss() {
        print(name+" 打怪")
    }
    func upgrade() {
        print(name+" 升级了")
    }
}

class GamePlayerProxy2: GamePlayerType {
    var player: GamePlayerType? = nil
    /*
     传递进来一个代理者名称，即可进行代理，在这种改造下，系统更加简洁了，
     调用者只知道代理存在就可以，不用知道代理了谁。
     */
    init(name: String) {
        self.player = GamePlayer2(gamePlayer: self, name: name)
    }
    
    func login() {
        player?.login()
    }
    func killBoss() {
        player?.killBoss()
    }
    func upgrade() {
        player?.upgrade()
    }
}

/*
 运行结果完全相同。在该模式下，调用者只知代理而不用知道真实的角色是谁，屏蔽了真实角色的变更对高层模块的影响，真实的主题角色爱怎么修改就怎么修改，对高层次的模块没有任何的影响，只要你实现了接口所对应的方法，该模式非常适合对扩展性要求较高的场合。当然，在实际的项目中，一般都是通过约定来禁止new一个真实的角色，也是一个非常好的方案。
 
 注意 普通代理模式的约束问题，尽量通过团队内的编程规范类约束，因为每一个主题类是可被重用的和可维护的，使用技术约束的方式对系统维护是一种非常不利的因素。
 */


// MARK: - 强制代理
protocol GamePlayerType3 {
    //仅仅增加了一个getProxy方法，指定要访问自己必须通过哪个代理
    func getProxy() -> GamePlayerType3
    func login()//登录
    func killBoss()//杀怪
    func upgrade()//升级
}

//强制代理的真实角色
class GamePlayer3: GamePlayerType3 {
    var name = ""
    
    var proxy: GamePlayerType3?
    //校验是否是代理访问,
    var isProxying: Bool {
        return proxy != nil
    }
    
    init(name: String) {
        self.name = name
    }
    
    func getProxy() -> GamePlayerType3 {
        proxy = GamePlayerProxy3(player: self)
        return proxy!
    }
    
    //是指定的代理则允许访问，否则不允许访问。
    func login() {
        if isProxying {
            print(name+" 登录了")
        } else {
            print("请使用指定的代理访问")
        }
    }
    func killBoss() {
        if isProxying {
            print(name+" 打怪")
        } else {
            print("请使用指定的代理访问")
        }
    }
    func upgrade() {
        if isProxying {
            print(name+" 升级了")
        } else {
            print("请使用指定的代理访问")
        }
    }
}

class GamePlayerProxy3: GamePlayerType3 {
    weak var player: GamePlayer3?
    
    init(player: GamePlayer3) {
        self.player = player
    }
    
    //代理的代理暂时还没有,就是自己
    func getProxy() -> GamePlayerType3 {
        return self
    }
    
    func login() {
        player?.login()
    }
    func killBoss() {
        player?.killBoss()
    }
    func upgrade() {
        player?.upgrade()
    }
}

let player3 = GamePlayer3(name: "zhangsan")
player3.login()
player3.killBoss()
player3.upgrade()
//请使用指定的代理访问
//请使用指定的代理访问
//请使用指定的代理访问

//正确用法,必须先获得指定的代理
let proxy3 = player3.getProxy()
proxy3.login()
proxy3.killBoss()
proxy3.upgrade()

/*
 OK，可以正常访问代理了。
 强制代理的概念就是要从真实角色查找到代理角色，不允许直接访问真实角色，
 高层模块只要调用getProxy就可以访问真实角色的所有方法，
 它根本就不需要产生一个代理出来，代理的管理已经由真实角色自己完成。
 */

/*
 代理是有个性的
 
 一个类可以实现多个接口，完成不同任务的整合，那也就是说代理类不仅仅可以实现主题接口，也可以实现其他接口完成不同的任务，而且代理的目的是在目标对象方法的基础上作增强，这种增强的本质通常就是对目标对象的方法进行拦截和过滤，例如游戏代理是需要收费的，升一级需要5元钱，这个计算功能就是代理类的个性，它应该在代理的接口中定义
 */
//增加了一个Proxy接口，其作用是计算代理的费用
protocol Proxy {
    //计算费用
    func count()
}

//实现了Proxy接口，同时在upgrade方法中调用该方法，完成费用结算
class GamePlayerProxy4: GamePlayerType3, Proxy {
    weak var player: GamePlayer3?
    
    init(player: GamePlayer3) {
        self.player = player
    }
    
    //代理的代理暂时还没有,就是自己
    func getProxy() -> GamePlayerType3 {
        return self
    }
    
    func count() {
        print("升级费用150")
    }
    
    func login() {
        player?.login()
    }
    func killBoss() {
        player?.killBoss()
    }
    func upgrade() {
        player?.upgrade()
        count()
    }
    
}
/*
 好了，代理公司也赚钱了，我的游戏也升级了，皆大欢喜。
 代理类不仅仅是都可以有自己的运算方法，通常的情况下代理的职责并不一定单一，它可以组合其他的真实角色，也可以实现自己的职责，比如计算费用。代理类可以为真实角色预处理消息、过滤消息、消息转发、事后处理消息等功能，当然一个代理类，可以代理多个真实角色，并且真实角色之间可以有耦合关系，读者可以自行扩展一下。
 */

// MARK: - 动态代理
/*
 本章节的核心部分就在动态代理上，现在有一个非常流行的名称叫做：面向横切面编程，也就是AOP（Aspect Oriented Programming），其核心就是采用了动态代理机制，既然这么重要，我们就来看看动态代理是如何实现的，还是以打游戏为例
 
 增加了一个InvocationHanlder接口和GamePlayIH类，作用就是产生一个对象的代理对象，其中InvocationHanlder是JDK提供的动态代理接口，对被代理类的方法进行代理。我们来看程序，接口保持不变，实现类也没有变化
 */

class GamePlayIH {
    //被代理者
    var cls: AnyClass? = nil
    
    //被代理的实例
    var obj: AnyObject? = nil
    
    //我要代理谁
    init(obj: AnyObject) {
        self.obj = obj
    }
    
    /*
     其中invoke方法是接口InvocationHandler定义必须实现的，它完成对真实方法的调用。
     我们来详细讲解一下InvocationHanlder接口，动态代理是根据被代理的接口生成所有的方法，也就是说给定一个接口，
     动态代理会宣称“我已经实现该接口下的所有方法了”，那各位读者想想看，动态代理怎么才能实现被代理接口中的方法呢？
     默认情况下所有的方法返回值都是空的，是的，代理已经实现它了，但是没有任何的逻辑含义，那怎么办？
     好办，通过InvocationHandler接口，所有方法都由该Handler来进行处理，即所有被代理的方法都由InvocationHandler接管实际的处理任务。
     */
    func invoke(proxy: AnyObject, method: Method, args: [AnyObject]) {
        
    }
}





//: [Next](@next)
