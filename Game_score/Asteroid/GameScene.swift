//
//  GameScene.swift
//  Asteroid
//
//  Created by Rosh Sugathan Thaivalappil on 9/24/19.
//  Copyright © 2019 Rosh Sugathan Thaivalappil. All rights reserved.
//

import SpriteKit
import GameplayKit
class GameScene: SKScene {
    
    var attacktime:Timer!
    var freeze:SKSpriteNode!
    var time:SKSpriteNode!
    var player:SKSpriteNode!
    var hammer:SKSpriteNode!
    var bulletnode:SKSpriteNode!
    var firenode:SKSpriteNode!
    var lightnode:SKSpriteNode!
    var kill:SKSpriteNode!
    var totalVillians = ["Villian","Villian2"]
    var villian:SKSpriteNode!
    var field:SKEmitterNode!
    var count:intmax_t = 0
    var scoreL:SKLabelNode!
    var score:Int = 0
    {
        didSet{
            scoreL.text = "Score \(score)"
        }
    }
    
    let villianidentity:UInt32 = 0x1 << 1
    let bulletidentity:UInt32 = 0x1 << 0
    
    
    func freezebutton()
    {
        freeze = SKSpriteNode(imageNamed: "freeze")
        freeze.name = "freeze"
        freeze.position = CGPoint(x: -(self.frame.width/2 - freeze.size.width), y: -(self.frame.height/2 - freeze.size.height*3))
        addChild(freeze)
    }
    
    func killbutton()
    {
        kill = SKSpriteNode(imageNamed: "kill")
        kill.name = "kill"
        kill.position = CGPoint(x: (self.frame.width/2 - freeze.size.width), y: -(self.frame.height/2 - freeze.size.height*3))
        addChild(kill)
    }
    
    func timereverse()
    {
        time = SKSpriteNode(imageNamed: "time")
        time.name = "time"
        time.position = CGPoint(x: -(self.frame.width/2 - freeze.size.width*1.5), y: -(self.frame.height/2 - freeze.size.height*1.5))
        addChild(time)
    }
    
    func hammerbutton()
    {
        hammer = SKSpriteNode(imageNamed: "hammer")
        hammer.name = "hammer"
        hammer.position = CGPoint(x: (self.frame.width/2 - freeze.size.width*2), y: -(self.frame.height/2 - freeze.size.height*2))
        addChild(hammer)
    }
    
    @objc func addVillian()
    {
        if(count == 0)
        {
            count = 1
        }
        else{
            count = 0
        }
        
        villian = SKSpriteNode(imageNamed: totalVillians[count])
        let rand = GKRandomDistribution(lowestValue: Int(-self.frame.width/2 + villian.size.width), highestValue:Int(self.frame.width/2 - villian.size.width))
        let position = CGFloat(rand.nextInt())
        villian.position = CGPoint(x: position, y: self.frame.size.height + villian.size.height)
        villian.physicsBody = SKPhysicsBody(rectangleOf :villian.size)
        villian.physicsBody?.isDynamic = true
        villian.physicsBody?.categoryBitMask = villianidentity
        villian.physicsBody?.contactTestBitMask = bulletidentity
        villian.physicsBody?.collisionBitMask = 0
        self.addChild(villian)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.40)
        
    }

    override func didMove(to view: SKView) {
        field = SKEmitterNode(fileNamed: "MyParticle")
        field.position = CGPoint(x: 0, y: self.frame.size.height)
        self.addChild(field)
        field.zPosition =  -1
        player = SKSpriteNode(imageNamed: "Player")
        player.position = CGPoint(x: 0, y: -(self.frame.size.height/2 - player.size.height))
        self.addChild(player)
        attacktime = Timer.scheduledTimer(timeInterval: 0.75, target: self,selector: #selector(addVillian), userInfo: nil, repeats: true)
        scoreL = SKLabelNode(text: "Score: 0")
        scoreL.position = CGPoint(x:100, y: self.frame.size.height-70)
        scoreL.fontSize = 40
        scoreL.fontColor = UIColor.white
        score = 0
        freezebutton()
        hammerbutton()
        killbutton()
        timereverse()
    }
    
    func fire()
    {
        firenode = SKSpriteNode(imageNamed: "fire")
        firenode.position = player.position
        firenode.position.y = player.position.y + 2
        
        firenode.physicsBody = SKPhysicsBody(rectangleOf: firenode.size)
        firenode.physicsBody?.isDynamic = true
        
        firenode.physicsBody?.categoryBitMask = bulletidentity
        firenode.physicsBody?.contactTestBitMask = villianidentity
        firenode.physicsBody?.collisionBitMask = 0
        firenode.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(firenode)
        
        let anim:TimeInterval = 0.3
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x,y: self.frame.size.height + 10),duration:anim))
        actionArray.append(SKAction.removeFromParent())
        firenode.run(SKAction.sequence(actionArray))
    }
    func light()
    {
        lightnode = SKSpriteNode(imageNamed: "light")
        lightnode.position = player.position
        lightnode.position.y = player.position.y + 2
        
        lightnode.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        lightnode.physicsBody?.isDynamic = true
        self.addChild(lightnode)
        
        let anim:TimeInterval = 1
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x,y: self.frame.size.height + 10),duration:anim))
        actionArray.append(SKAction.removeFromParent())
        lightnode.run(SKAction.sequence(actionArray))
    }
    
    func bullet()
    {
        bulletnode = SKSpriteNode(imageNamed: "Bullet")
        bulletnode.position = player.position
        bulletnode.position.y = bulletnode.position.y + 2
        
        bulletnode.physicsBody = SKPhysicsBody(circleOfRadius: bulletnode.size.width/2)
        bulletnode.physicsBody?.isDynamic = true
        self.addChild(bulletnode)
        
        let anim:TimeInterval = 0.3
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x,y: self.frame.size.height + 10),duration:anim))
        actionArray.append(SKAction.removeFromParent())
        bulletnode.run(SKAction.sequence(actionArray))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in:self)
            if freeze.contains(location) {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: +0.40)
            }
            else if time.contains(location) {
                    self.physicsWorld.gravity = CGVector(dx: 0, dy: +10)
            }
            else if kill.contains(location) {
                villian.removeFromParent()
                fire()
            }
            else if hammer.contains(location) {
                villian.removeFromParent()
                light()
            }
            else{
                bullet()
            }
    }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        var identity1:SKPhysicsBody
        var identity2:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            identity1 = contact.bodyA
            identity2 = contact.bodyB
        }
        else
        {
            identity1 = contact.bodyB
            identity2 = contact.bodyA
        }
        
        if(identity1.categoryBitMask & bulletidentity) != 0 && (identity2.categoryBitMask & villianidentity) != 0
        {
            collidefunction(bulletc: identity1.node as! SKSpriteNode, villianc: identity2.node as! SKSpriteNode)
        }
    }
    
    func collidefunction(bulletc:SKSpriteNode, villianc:SKSpriteNode)
    {
        let fire = SKEmitterNode(fileNamed: "Fire")!
        fire.position = villian.position
        self.addChild(fire)
        bulletc.removeFromParent()
        villianc.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2))
        {
            fire.removeFromParent()
        }
        
    }
    override func update(_ currentTime: TimeInterval) {
    }
}
