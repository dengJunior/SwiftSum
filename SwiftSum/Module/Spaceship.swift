//
//  Spaceship.swift
//  SpriteWalkthrouch
//
//  Created by sihuan on 2016/6/23.
//  Copyright © 2016年 huan. All rights reserved.
//

import SpriteKit
import AVFoundation

extension Spaceship: SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
        self.runAction(self.explosionSound)
        let secondNode = contact.bodyA.node
        secondNode?.removeFromParent()
        
        // MARK: - ## 给精灵着色
        vitalityReduced()
    }
    
    func vitalityReduced() {
        vitality -= 1
        //你可以使用color属性以及 colorBlendFactor 属性给贴图着色。colorBlendFactor属性默认为0.0，意味着贴图使用时未作任何改变。当你增加这个属性的值，贴图越多的颜色被渲染颜色取代。例如，当你游戏中的怪物造成火箭的损坏，你希望红给角色染上红色。
        spaceship?.colorBlendFactor = CGFloat(vitality) / 10
    }
}

class Spaceship: SKScene {
    var contentCreated = false
    
    var spaceship: SKSpriteNode?
    lazy var explosionSound: SKAction = {
        return SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
    }()
    var vitality = 10
    //didMoveToView:方法是场景在视图中展示时被调用
    override func didMoveToView(view: SKView) {
        if !contentCreated {
            contentCreated = true
            createSceneContents()
        }
    }
    
    func createSceneContents() {
        //SKColor并不是一个类，它是一个宏，对应IOS的UIColor以及OS X的NSColor。定义这个宏是为了更好的创建跨平台的代码。
        backgroundColor = SKColor.blackColor()
        scaleMode = .AspectFit
        
        //创建飞船
        let spaceship = newSpaceship()
        spaceship.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 150.0)
        addChild(spaceship)
        self.spaceship = spaceship
        
        
        let makeRoks = SKAction.sequence([
            SKAction.performSelector(#selector(addRock), onTarget: self),
            SKAction.waitForDuration(0.5, withRange: 0.2)
            ])
        runAction(SKAction.repeatActionForever(makeRoks))
        
        //两个physics body碰撞时，物理世界physicsWorld就会自动调用代码中的method。
        physicsWorld.contactDelegate = self
    }
    
    func newSpaceship() -> SKSpriteNode {
//        let hull = SKSpriteNode(color: SKColor.grayColor(), size: CGSize(width: 64, height: 32))
        //默认精灵的大小和贴图的大小相同，一个SKTexture对象会被创建到精灵中。
        let hull = SKSpriteNode(imageNamed: "spaceship")
        
        /**
         精灵框架大小的属性是由三个属性决定的：
         
         1. 基本大小 - 精灵的size属性保存精灵的基本大小（未经过缩放的大小）。
         2. xScale和yScale - 基本大小可以由精灵继承自SKNode的xScale以及yScale属性进行缩放。 
         
         <mark>精灵父节点的缩放也可以用于缩放精灵。这可以改变精灵的有效大小而不用改变其实际框架的值。
         */
        
        
        hull.physicsBody = SKPhysicsBody(circleOfRadius: hull.size.width * 0.3)
        //设置飞船不会被重力所影响。因此它像以前一样运行。然而，让刚体时静态的也意味着飞船的速率不会被碰撞影响。
        hull.physicsBody?.dynamic = false
        hull.physicsBody?.allowsRotation = true
        //启用精确冲突检测(usesPreciseCollisionDetection)：默认情况下，除非确实有必要，Sprite Kit 并不会启用精确的冲突检测，因为这样更快。但是不启用精确的冲突检测会有一个副作用，如果一个物体移动的非常快(比如一个子弹)，它可能会直接穿过其他物体。如果这种情况确实发生了，你就应该尝试启用更精确的冲突检测了。
        hull.physicsBody?.usesPreciseCollisionDetection = true
        hull.physicsBody?.contactTestBitMask = 2
        hull.physicsBody?.categoryBitMask = 1
        
        let light1 = newLight()
        light1.position = CGPoint(x: -28, y: 6)
        hull.addChild(light1)
        
        let light2 = newLight()
        light1.position = CGPoint(x: 28, y: 6)
        hull.addChild(light2)
        
        let hover = SKAction.sequence([
            SKAction.waitForDuration(1),
            SKAction.moveByX(100, y: 50, duration: 1),
            SKAction.waitForDuration(1),
            SKAction.moveByX(-100, y: -50, duration: 1)
            ])
        hull.runAction(SKAction.repeatActionForever(hover))
        
        return hull
    }
    
    func newLight() -> SKSpriteNode {
        let light = SKSpriteNode(color: SKColor.yellowColor(), size: CGSize(width: 8, height: 8))
        let blink = SKAction.sequence([
            SKAction.fadeOutWithDuration(0.25),
            SKAction.fadeInWithDuration(0.25)
            ])
        let blinkForever = SKAction.repeatActionForever(blink)
        light.runAction(blinkForever)
        return light
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    func addRock() {
        let rock = SKSpriteNode(color: UIColor.brownColor(), size: CGSize(width: 8, height: 8))
        rock.position = CGPoint(x: random(min: 0, max: size.width), y: size.height - 50)
        rock.name = "rock"
        rock.physicsBody = SKPhysicsBody(rectangleOfSize: rock.size)
        rock.physicsBody?.usesPreciseCollisionDetection = true
        rock.physicsBody?.allowsRotation = false
        rock.physicsBody?.contactTestBitMask = 1
        rock.physicsBody?.categoryBitMask = 2
        //设置 collisionBitMask后，当接触到敌人时，两者会互相弹开；如果不想要这种效果，将值设为0。
//        rock.physicsBody?.collisionBitMask = 0
        addChild(rock)
    }
    
    //场景每次处理一帧时，它都要运行动作并模拟物理效果。
    override func didSimulatePhysics() {
        /**
         如果你让这段程序运行一段时间，帧率就会开始下降，即使结点数量仍然很少。
         
         这是因为结点代码只显示可见的结点，然而，当石块落到场景屏幕以下后，它们仍然在场景中存在，这也意味着物理引擎仍然作用于这些石块上。
         因为有这么多的石块需要处理，因此帧率就降下来了。
         */
        enumerateChildNodesWithName("rock") { (rock, _) in
            if rock.position.y < 0 {
                rock.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesBegan")
        if let touch = touches.first {
            spaceship?.position = touch.locationInView(view!)
        }
    }
}


























