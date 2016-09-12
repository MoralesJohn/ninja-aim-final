//
//  GameScene.swift
//  Circle_test
//
//  Created by Jennifer Zeller on 9/9/16.
//  Copyright (c) 2016 Alex. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    let manager = CMMotionManager()
    var crosshair = SKSpriteNode()
    let timer = CountdownLabel()
    var resetButton = SKLabelNode(fontNamed:"Score")
    var score  = 0
    var scoreLabel = SKLabelNode(fontNamed:"Score")
    var gameOn = true

    
    func drawTarget(){
        
        let x_position = CGFloat(arc4random_uniform(UInt32(frame.size.width-100)+50))
        let y_position = CGFloat(arc4random_uniform(UInt32(frame.size.height-100)+50))
        
        let OuterRing = SKShapeNode(circleOfRadius: 100 ) // Size of Circle
        OuterRing.name = "outerring";
        OuterRing.position = CGPointMake(x_position, y_position)  //Middle of Screen
        OuterRing.zPosition = -1.0
        OuterRing.strokeColor = SKColor.blackColor()
        OuterRing.glowWidth = 1.0
        OuterRing.fillColor = SKColor.whiteColor()
        self.addChild(OuterRing)
        
        let OuterRing2 = SKShapeNode(circleOfRadius: 80 ) // Size of Circle
        OuterRing2.name = "outerring2";
        OuterRing2.position = CGPointMake(x_position, y_position)  //Middle of Screen
        OuterRing2.zPosition = -1.0
        OuterRing2.strokeColor = SKColor.whiteColor()
        OuterRing2.glowWidth = 1.0
        OuterRing2.fillColor = SKColor.blackColor()
        self.addChild(OuterRing2)
        
        let MiddleRing = SKShapeNode(circleOfRadius: 60 ) // Size of Circle
        MiddleRing.name = "middlering";
        MiddleRing.position = CGPointMake(x_position, y_position)  //Middle of Screen
        MiddleRing.zPosition = -1.0
        MiddleRing.strokeColor = SKColor.blackColor()
        MiddleRing.glowWidth = 1.0
        MiddleRing.fillColor = SKColor.blueColor()
        self.addChild(MiddleRing)
        
        let InnerRing = SKShapeNode(circleOfRadius: 40 ) // Size of Circle
        InnerRing.name = "innerring";
        InnerRing.position = CGPointMake(x_position, y_position)  //Middle of Screen
        InnerRing.zPosition = -1.0
        InnerRing.strokeColor = SKColor.blackColor()
        InnerRing.glowWidth = 1.0
        InnerRing.fillColor = SKColor.redColor()
        self.addChild(InnerRing)
        
        let BullsEye = SKShapeNode(circleOfRadius: 20 ) // Size of Circle
        BullsEye.name = "bullseye";
        BullsEye.position = CGPointMake(x_position, y_position)  //Middle of Screen
        BullsEye.zPosition = -1.0
        BullsEye.strokeColor = SKColor.blackColor()
        BullsEye.glowWidth = 1.0
        BullsEye.fillColor = SKColor.yellowColor()
        self.addChild(BullsEye)
        
    }
    
    func destroyTarget(){
        childNodeWithName("outerring")!.removeFromParent()
        childNodeWithName("outerring2")!.removeFromParent()
        childNodeWithName("middlering")!.removeFromParent()
        childNodeWithName("innerring")!.removeFromParent()
        childNodeWithName("bullseye")!.removeFromParent()
    }

    
    override func didMoveToView(view: SKView) {
        
        resetButton = SKLabelNode(fontNamed:"Score")
        resetButton.text = "Touch Screen for New Game"
        resetButton.fontSize = 75
        resetButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        addChild(resetButton)
        resetButton.hidden = true
        
        /* Setup your scene here */
                scoreLabel.text = "Score: \(score)"
                scoreLabel.fontSize = 45
                scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height-100)
                self.addChild(scoreLabel)

        resetButton.name = "reset";

    
        
        
        
        scene?.backgroundColor = SKColor.blackColor()
        
        drawTarget()
        
        // manager.startGyroUpdates()
        manager.deviceMotionUpdateInterval=0.1
        manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()){
            (data,error) in
            
            self.physicsWorld.gravity = CGVectorMake(CGFloat((data?.attitude.roll)!*8),CGFloat(((data?.attitude.pitch)! - 0.8) * (-8)))
            //print(self.crosshair.position)
        }
        // physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        crosshair = SKSpriteNode(imageNamed: "crosshairs.png")
        crosshair.name = "crosshair";
        crosshair.position = CGPointMake(frame.midX, frame.midY)
        crosshair.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        crosshair.physicsBody?.dynamic = true
        crosshair.physicsBody?.allowsRotation = false
        
        // crosshair.physicsBody!.affectedByGravity = false
        self.addChild(crosshair)
        
        timer.position = CGPointMake(40, 20)
        timer.fontSize = 45
        addChild(timer)
        timer.startWithDuration(30)

//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!"
//        myLabel.fontSize = 45
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        
//        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            
            if timer.hasFinished() == true{
                print("timer finished and touch screen")
                score = 0
                scoreLabel.text = "Score: \(score)"
                print("start timer")
                timer.startWithDuration(30)
                print("add crosshair")
                // addChild(crosshair)
                print("remove reset button")
                childNodeWithName("reset")!.hidden = true
                // remove target
                destroyTarget()
                // redraw target
                drawTarget()
                gameOn = true
                
            } else {
            
        //  let location = touch.locationInNode(self)
            let location = childNodeWithName("bullseye")!.position
            let distanceFromTarget = sqrt(Double(pow(Double(crosshair.position.x - location.x),2)+pow(Double(crosshair.position.y - location.y),2)))
            
            if  distanceFromTarget<21  {
                // add to score
                score = score + 100
                scoreLabel.text = "Score: \(score)"
                
                // remove target
                destroyTarget()
                
                // redraw target
                drawTarget()
            } else if distanceFromTarget>20 && distanceFromTarget<41{
                // add to score
                score = score + 50
                scoreLabel.text = "Score: \(score)"
                
                // remove target
                destroyTarget()
                
                // redraw target
                drawTarget()
            } else if distanceFromTarget>40 && distanceFromTarget<61{
                // add to score
                score = score + 40
                scoreLabel.text = "Score: \(score)"
                
                // remove target
                destroyTarget()
                
                // redraw target
                drawTarget()
            }  else if distanceFromTarget>60 && distanceFromTarget<81{
                // add to score
                score = score + 30
                scoreLabel.text = "Score: \(score)"
                
                // remove target
                destroyTarget()
                
                // redraw target
                drawTarget()
            }  else if distanceFromTarget>80 && distanceFromTarget<101{
                // add to score
                score = score + 20
                scoreLabel.text = "Score: \(score)"
                
                // remove target
                destroyTarget()
                
                // redraw target
                drawTarget()
            } else{
                // do nothing if miss
            }
            
            
            
            runAction(SKAction.playSoundFileNamed("174436__drminky__laser-gun-ice-beam.caf", waitForCompletion: false))
            }
        }
    }
    
    func endGame() {
        if gameOn{
            // childNodeWithName("crosshair")!.removeFromParent()
            resetButton.hidden = false
            gameOn = false
        }
        
        
        // childNodeWithName("crosshair")!.removeFromParent()
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        timer.update()
        if timer.hasFinished() {
            endGame()
        }
    }
}
