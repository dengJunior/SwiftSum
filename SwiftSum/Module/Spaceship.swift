//
//  Spaceship.swift
//  SpriteWalkthrouch
//
//  Created by sihuan on 2016/6/23.
//  Copyright © 2016年 huan. All rights reserved.
//

import SpriteKit

class Spaceship: SKScene {
    var contentCreated = false
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
        let makeRoks = SKAction.sequence([
            SKAction.performSelector(#selector(addRock), onTarget: self),
            SKAction.waitForDuration(0.5, withRange: 0.2)
            ])
        runAction(SKAction.repeatActionForever(makeRoks))
    }
    
    func newSpaceship() -> SKSpriteNode {
        let hull = SKSpriteNode(color: SKColor.grayColor(), size: CGSize(width: 64, height: 32))
        //设置飞船不会被重力所影响。因此它像以前一样运行。然而，让刚体时静态的也意味着飞船的速率不会被碰撞影响。
        hull.physicsBody?.dynamic = true
        //启用精确冲突检测(usesPreciseCollisionDetection)：默认情况下，除非确实有必要，Sprite Kit 并不会启用精确的冲突检测，因为这样更快。但是不启用精确的冲突检测会有一个副作用，如果一个物体移动的非常快(比如一个子弹)，它可能会直接穿过其他物体。如果这种情况确实发生了，你就应该尝试启用更精确的冲突检测了。
        hull.physicsBody?.usesPreciseCollisionDetection = true
        
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
    }
}


























