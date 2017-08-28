//
//  GameScene.swift
//  RetroCar
//
//  Created by iD Student on 8/17/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import SpriteKit
import GameplayKit


struct BodyType {
    
    static let None: UInt32 = 0
    static let EnemyCar: UInt32 = 1
    static let Bullet: UInt32 = 2
    static let Hero: UInt32 = 4
}

class GameScene: SKScene,SKPhysicsContactDelegate {
    
   let hero = SKSpriteNode(imageNamed: "car")
    let side1 = SKSpriteNode()
    let side2 = SKSpriteNode()
    var score: Int = 0
    
    let heroSound = SKAction.playSoundFileNamed("CarSound.mp3", waitForCompletion: false)
    let crashSound = SKAction.playSoundFileNamed("crashSound.mp3", waitForCompletion: false)
    let carPassBy = SKAction.playSoundFileNamed("carPassBy.mp3", waitForCompletion: false)
    
    let heroSpeed: CGFloat  = 95.0
    
    let gameScore = SKLabelNode(fontNamed: "ChalkDuster")
    
    
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.gray
       
        
        hero.size.height = size.height * 1/4
        hero.size.width = size.width * 1/4
        
        let xCoord: CGFloat = size.width * 1/6 + hero.size.width * 0.7
        let yCoord = size.height * 0.2
        
        hero.position = CGPoint(x: xCoord, y: yCoord)
        hero.zPosition = 1
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: hero.size)
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.categoryBitMask = BodyType.Hero
        hero.physicsBody?.contactTestBitMask = BodyType.EnemyCar
        hero.physicsBody?.collisionBitMask = 0
        hero.physicsBody?.usesPreciseCollisionDetection = true
        addChild(hero)
        
        gameScore.text = "Game Over"
        
        gameScore.fontColor = UIColor.white
        
        gameScore.fontSize = 40
        gameScore.zPosition = 3
        gameScore.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.92)
        addChild(gameScore)
    
        side1.size.height = size.height
        side1.size.width = 1/6 * size.width
        
        side1.position = CGPoint (x: 0 + side1.size.width/2, y: side1.size.height/2)
        side1.color = SKColor.green
        addChild(side1)
        
        side2.size.height = size.height
        side2.size.width = 1/6 * size.width
        
        side2.position = CGPoint (x: size.width - side1.size.width/2, y: side1.size.height/2)
        side2.color = SKColor.green
        addChild(side2)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        addLines()
        addCars()
        playHeroSound()
        
        physicsWorld.gravity = CGVector(dx:0,dy:0)
        physicsWorld.contactDelegate = self
        
    }
    func swipedRight(sender: UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        if (hero.position.x + heroSpeed >= size.width - side2.size.width) {
            
            actionMove = SKAction.move(to: CGPoint(x: size.width - hero.size.width , y: hero.position.y), duration: 0.2)
            
        }
            
        else {
            
            actionMove = SKAction.move(to: CGPoint(x: size.width / 2 + hero.size.width * 2/3 , y: hero.position.y), duration: 0.2)
            
        }
        
        hero.run(actionMove)
    }
    
    func swipedLeft(sender: UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        if (hero.position.x - heroSpeed <= side1.size.width) {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.size.width , y: hero.position.y), duration: 0.2)
           
        }
        else {
            
            actionMove = SKAction.move(to: CGPoint(x: size.width * 1/6 + hero.size.width * 0.7, y: hero.position.y), duration: 0.2)
           
        }
        
        hero.run(actionMove)
    }
    
    
    
    func addWhiteLines(){
        
        let line  = SKSpriteNode()
        line.size.height = 50
        line.size.width = 15
        
        line.position = CGPoint (x: size.width/2 - 4, y: size.height)
        line.color = SKColor.white
        addChild(line)

        var moveMeteor: SKAction
        moveMeteor = SKAction.move (to: CGPoint (x: size.width/2, y: -line.position.y), duration: (3.0))
        line.run(SKAction.sequence([moveMeteor,SKAction.removeFromParent()]))
    }
    
    func addEnemyCar(){
        let diceRoll = Int(arc4random_uniform(3))
        let enemyCar : SKSpriteNode
        
        switch diceRoll {
            
            case 0 :
                enemyCar = SKSpriteNode(imageNamed: "redcar")
                break;
        
            case 1 :
                enemyCar = SKSpriteNode(imageNamed: "whitecar")
                break;
            
            default:
                enemyCar = SKSpriteNode(imageNamed: "yellowcar")
                break;
        }
        
        
        enemyCar.size.height = size.height * 1/4
        enemyCar.size.width = size.width * 1/4
        
        
        let anotherRoll = Int (arc4random_uniform(2))
        var xPosition: CGFloat = 0
        
        
        switch anotherRoll {
            
        case 0 :
            xPosition = size.width * 1/6 + hero.size.width * 0.7
            
            enemyCar.position = CGPoint (x : xPosition , y : size.height)
            break;
            
        case 1 :
            xPosition = size.width / 2 + hero.size.width * 2/3
            enemyCar.position = CGPoint (x: xPosition , y : size.height)
            break;
            
        default:
            print ()
            break;
        }
        
        
        enemyCar.physicsBody = SKPhysicsBody(rectangleOf: enemyCar.size)
        enemyCar.physicsBody?.isDynamic = true
        enemyCar.physicsBody?.categoryBitMask = BodyType.EnemyCar
        enemyCar.physicsBody?.contactTestBitMask = BodyType.Hero
        enemyCar.physicsBody?.collisionBitMask = 0
        enemyCar.physicsBody?.usesPreciseCollisionDetection = true
        addChild(enemyCar)
        
        score = score + 1
        gameScore.text = String(score)
        
        var moveEnemyCar: SKAction
        moveEnemyCar = SKAction.move (to: CGPoint (x: xPosition, y: -enemyCar.position.y), duration: (3.0))
        enemyCar.run(SKAction.sequence([moveEnemyCar,SKAction.removeFromParent()]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        
        let contactA = bodyA.categoryBitMask
        let contactB = bodyB.categoryBitMask
        
        switch contactA {
            
        case BodyType.EnemyCar:
            
            
            
            switch contactB {
                
                
                
                case BodyType.EnemyCar:
                
                break
                
    
                case BodyType.Hero:
                
                    if let bodyBNode = contact.bodyB.node as? SKSpriteNode {
                        
                        heroHitOtherCar(enemyCar: bodyBNode)
                      
                        
                    }
                    
                    
                
                
                
            default:
                
                break
                
            }
            
            
            
            case BodyType.Hero:
            
            
            
                switch contactB {
                
                
                
                case BodyType.EnemyCar:
                
                    
                    if let bodyBNode = contact.bodyB.node as? SKSpriteNode {
                        
                        heroHitOtherCar(enemyCar: bodyBNode)
                        
                    }
                    
                    
      
                
                case BodyType.Hero:
                
                    break
                
                
                
            default:
                
                break
                
            }
            
            
            
            
        default:
            
            break
            
        }
        
        
    
    }
    
    func addLines() {
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addWhiteLines), SKAction.wait(forDuration: 1.0)])), withKey:"addEnemies")
        
        
    }
    
    func addCars(){
        run (SKAction.repeatForever(SKAction.sequence([SKAction.run(addEnemyCar),carPassBy, SKAction.wait(forDuration: 3.0)])), withKey:"addEnemyCars")
    
    }
    
    func playHeroSound(){
        run (SKAction.repeatForever(SKAction.sequence([heroSound, SKAction.wait(forDuration: 5.0)])), withKey:"heroSound")
        
    }
    func heroHitOtherCar (enemyCar: SKSpriteNode){
        
        //enemyCar.removeFromParent()
        
        removeAction(forKey: "addEnemyCars")
        removeAction(forKey: "heroSound")
        run(crashSound)
        
        let explosion = SKSpriteNode (imageNamed: "explosion")
        
        explosion.size.height = 300.0
        explosion.size.width = 300.0
        
        explosion.position = CGPoint (x: hero.position.x, y: hero.position.y + (hero.size.height/2) )
        explosion.zPosition = 2
        addChild(explosion)
        
        
        hero.isPaused = true
        enemyCar.isPaused = true
        // Label Code
        let gameOverLabel = SKLabelNode(fontNamed: "ChalkDuster")
        
        gameOverLabel.text = "Game Over"
        
        gameOverLabel.fontColor = UIColor.white
        
        gameOverLabel.fontSize = 40
        gameOverLabel.zPosition = 3
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.83)
        
        addChild(gameOverLabel)
        
      
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
      
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    
}
