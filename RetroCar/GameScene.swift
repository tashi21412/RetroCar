//
//  GameScene.swift
//  RetroCar
//
//  Created by iD Student on 8/17/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
   let hero = SKSpriteNode(imageNamed: "car")
    let side1 = SKSpriteNode()
    let side2 = SKSpriteNode()
    
    let heroSpeed: CGFloat  = 95.0
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.gray
        let xCoord: CGFloat = 125.0
        let yCoord = size.height * 0.2
        
        hero.size.height = 250
        hero.size.width = 130
        
        hero.position = CGPoint(x: xCoord, y: yCoord)
        
        addChild(hero)
    
        side1.size.height = size.height
        side1.size.width = 50
        
        side1.position = CGPoint (x: 0 + side1.size.width/2, y: side1.size.height/2)
        side1.color = SKColor.green
        addChild(side1)
        
        side2.size.height = size.height
        side2.size.width = 50
        
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
        
    }
    func swipedRight(sender: UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        if (hero.position.x + heroSpeed >= size.width - side2.size.width) {
            
            actionMove = SKAction.move(to: CGPoint(x: size.width - hero.size.width , y: hero.position.y), duration: 0.3)
            print(size.width - side2.size.width)
            print(hero.position.x + heroSpeed)
        }
            
        else {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x + 164 , y: hero.position.y), duration: 0.3)
            print(size.width - side2.size.width)
            print(hero.position.x + heroSpeed)
        }
        
        hero.run(actionMove)
    }
    
    func swipedLeft(sender: UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        if (hero.position.x - heroSpeed <= side1.size.width) {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.size.width , y: hero.position.y), duration: 0.3)
           
        }
        else {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x - 164, y: hero.position.y), duration: 0.3)
           
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
        
        
        enemyCar.size.height = 250
        enemyCar.size.width = 130
        
        
        let anotherRoll = Int (arc4random_uniform(2))
        var xPosition: CGFloat = 0
        
        
        switch anotherRoll {
            
        case 0 :
            xPosition = 125.0
            
            enemyCar.position = CGPoint (x : xPosition , y : size.height)
            break;
            
        case 1 :
            xPosition = 289.0
            enemyCar.position = CGPoint (x: xPosition , y : size.height)
            break;
            
        default:
            print ()
            break;
        }
        
        addChild(enemyCar)
        
        
        var moveEnemyCar: SKAction
        moveEnemyCar = SKAction.move (to: CGPoint (x: xPosition, y: -enemyCar.position.y), duration: (3.0))
        enemyCar.run(SKAction.sequence([moveEnemyCar,SKAction.removeFromParent()]))
    }
    
    
    
    func addLines() {
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addWhiteLines), SKAction.wait(forDuration: 1.0)])), withKey:"addEnemies")
        
        
    }
    
    func addCars(){
        run (SKAction.repeatForever(SKAction.sequence([SKAction.run(addEnemyCar), SKAction.wait(forDuration: 3.0)])), withKey:"addEnemyCars")
    
    }
    
    func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
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
