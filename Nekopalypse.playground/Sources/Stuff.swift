import SpriteKit
import AVFoundation


func +(_ lhs: CGVector, _ rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

func -(_ lhs: CGVector, _ rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}

func *(_ lhs: CGVector, _ rhs: CGFloat) -> CGVector {
    return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
}
public func pythagorean(dx: CGFloat, dy: CGFloat) -> CGFloat{
    let hypoteneuse = sqrt(pow(dx, 2) + pow(dy, 2))
    return hypoteneuse
}
/*-------------------------------------------------------------------------------------------------------------------------------*/
func findDistanceAndAngleBetween(from: SKNode, to: SKNode) -> (angle: CGFloat, distance: CGFloat) {
    let angle = atan2(to.position.y - from.position.y, to.position.x - from.position.x)
    let distance = sqrt(pow(from.position.x - to.position.x, 2) + pow(from.position.y - to.position.y, 2))
    return(angle, distance)
}
/*-------------------------------------------------------------------------------------------------------------------------------*/

struct PhysicsCategory {
    static let all                     : UInt32 = UInt32.max
    static let playerTear              : UInt32 =      0b1 // 1
    static let enemyTear               : UInt32 =     0b10 // 2
    static let player                  : UInt32 =    0b100 // 4
    static let enemy                   : UInt32 =   0b1000 // 8
    static let destroyableObstacle     : UInt32 =  0b10000 // 16
    static let permanentObstacle       : UInt32 = 0b100000 // 32
    
    static let entity                  : UInt32 = PhysicsCategory.player | PhysicsCategory.enemy
    static let tear                    : UInt32 = PhysicsCategory.playerTear | PhysicsCategory.enemyTear
    static let obstacle                : UInt32 = PhysicsCategory.permanentObstacle | PhysicsCategory.destroyableObstacle
}

typealias CentiBlocks = CGFloat
typealias CBPerSecond = CGFloat

func turnIntoVector(maxMovementSpeed: CGFloat, movementSpeedRatio: CGFloat = 1, movementAngle: CGFloat) -> CGVector {
    return CGVector(dx: maxMovementSpeed * movementSpeedRatio * cos(movementAngle), dy: maxMovementSpeed * movementSpeedRatio * sin(movementAngle))
    
}
/* ----------------------------------- player ----------------------------------- */
/*-------------------------------------------------------------------------------------------------------------------------------*/

public class Player: SKNode {
    var health : Int
    var movementSpeed : CBPerSecond
    var shotSpeed : CBPerSecond
    var shotDelay : TimeInterval
    var shotDelayMinimum : TimeInterval = 50
    var range : TimeInterval
    var damage : Int
    var movementAngle : CGFloat
    var relativeMovementSpeed : CGFloat
    var shootingAngle : CGFloat
    var relativeShootingSpeed : CGFloat
    var killCount : Int
    
    var sheild = SKShapeNode(circleOfRadius: 40)
    var invulnerable : Bool
    
    let node = SKSpriteNode(imageNamed: "neko-head.png")//SKShapeNode(circleOfRadius: 40)
    
    var isShootingAvailable = true
    
    var shootingSounds : [SKAction]
    var damageSounds   : [SKAction]
    var deathSounds    : [SKAction]
    
    let positionLabel = SKLabelNode()
    let tail = SKSpriteNode(imageNamed: "neko-tail.png")
    
    //let killCounter = SKLabelNode()
    
    init(health:            Int      = 9,
         movementSpeed: CBPerSecond  = 400,
         shotSpeed:     CBPerSecond  = 600,
         shotDelay:     TimeInterval = 0.2,
         range:         TimeInterval = 1.2,
         damage:            Int      = 40) {
        
        self.health = health
        self.movementSpeed = movementSpeed
        self.shotSpeed = shotSpeed
        self.shotDelay = shotDelay
        self.range = range
        self.damage = damage
        self.movementAngle = 0
        self.relativeMovementSpeed = 0
        self.shootingAngle = 0
        self.relativeShootingSpeed = 0
        self.killCount = 0
        
        self.invulnerable = false
        
        self.shootingSounds = [/*
            AudioActions.playerShootSoundRa,
            AudioActions.playerShootSoundRi,
            AudioActions.playerShootSoundRo*/
            AudioActions.playerShoot1,
            AudioActions.playerShoot2,
            AudioActions.playerShoot3,
            AudioActions.playerShoot4,
            AudioActions.playerShoot5,
            AudioActions.playerShoot6,
            AudioActions.playerShoot7,
            AudioActions.playerShoot8,
            AudioActions.playerShoot9
        ]
        self.damageSounds = [
            AudioActions.damageSound1,
            AudioActions.damageSound2,
        ]
        self.deathSounds = [
            AudioActions.catDeath1
        ]
    
        super.init()
        //self.node = node
        self.addChild(self.node)
        self.node.scale(to: CGSize(width: 100, height: 100))
        //self.node.fillColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        self.node.zPosition = 100
            // physics body stuff
        self.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.enemyTear | PhysicsCategory.obstacle
        self.physicsBody?.collisionBitMask = PhysicsCategory.enemy | PhysicsCategory.enemyTear | PhysicsCategory.obstacle
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.mass = 5
        self.physicsBody?.velocity = CGVector.zero
        
        self.physicsBody?.allowsRotation = false
        
        self.addChild(self.tail)
        self.tail.setScale(0.2)
        self.tail.zPosition = 99
        self.tail.position = CGPoint(x: -40, y: 0)
        
        self.tail.run(.repeatForever(.sequence([
            .rotate(toAngle: .pi / 3, duration: 0.6, shortestUnitArc: true),
            .rotate(toAngle: -1 * .pi/3, duration: 0.6, shortestUnitArc: true)
            ])))

        
        //self.addChild(self.positionLabel)
        self.positionLabel.zPosition = 120
        rippleEffect(center: self.position, owner: self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func takeDamage(damageTaken: Int = 1){
        if self.invulnerable {
            return
        }
        let parentRoom = self.scene as! Room
        parentRoom.performScreenShake()
        self.invulnerable = true
        self.node.alpha = 0.5
        self.tail.alpha = 0.5
        self.health -= damageTaken
        playSound(self.damageSounds[Int.random(in: 0 ..< self.damageSounds.count)], from: self)
        self.run(.sequence([
            .wait(forDuration: 1),
            .run{
                self.invulnerable = false
                self.node.alpha = 1
                self.tail.alpha = 1
            }
            ]))
        //shield animation
        self.run(.sequence([
            
            ]))
        if self.health <= 0 {
            playSound(AudioActions.catDeath1, from: self.parent as! Room)
            if self.scene is Tutorial {
                displayTutorial()
                return
            } else {
                displayDeathScreen(self.killCount)
                self.removeFromParent()
            }
            
        }
    }
    func heal(healthPickedUp: Int = 1){
        self.health += healthPickedUp
    }
    func update() {
        if self.shootingAngle == 0 {
            if self.movementAngle != 0 {
                self.run(.rotate(toAngle: self.movementAngle, duration: 0.1, shortestUnitArc: true))
            }
        } else {
            self.run(.rotate(toAngle: self.shootingAngle, duration: 0.1, shortestUnitArc: true))
        }
        self.physicsBody?.velocity = turnIntoVector(maxMovementSpeed: self.movementSpeed, movementSpeedRatio: self.relativeMovementSpeed, movementAngle: self.movementAngle)
        
        if self.shootingAngle != 0 && self.relativeShootingSpeed != 0 && self.isShootingAvailable {
            defer {
                self.isShootingAvailable = false
                self.run(.sequence([
                    .wait(forDuration: self.shotDelay),
                    .run {
                        self.isShootingAvailable = true
                    }
                    ]))
            }
            var _ = Projectile(maxMovementSpeed: self.shotSpeed,
                               movementSpeedRatio: 1,
                               movementAngle: self.shootingAngle,
                               range: self.range,
                               damage: self.damage,
                               nodeType: PhysicsCategory.playerTear,
                               parentRoom: self.scene as! Room,
                               position: self.position,
                               shooterMovementVector: self.physicsBody!.velocity)
            playSound(self.shootingSounds[Int.random(in: 0 ..< self.shootingSounds.count)], from: self)
        }
        
        self.positionLabel.text = "(x: \(Int(self.position.x)), y: \(Int(self.position.y))"    }
    
}

public var thePlayer = Player()
/* ----------------------------------- Projectiles ----------------------------------- */
/*-------------------------------------------------------------------------------------------------------------------------------*/
public class Projectile: SKNode {
    var movementSpeed : CBPerSecond
    var damage : Int
    
    let node = SKShapeNode(circleOfRadius: 10)
    let popSounds : [SKAction]
    
    init(maxMovementSpeed: CBPerSecond = 600,
         movementSpeedRatio: CGFloat = 1,
         movementAngle: CGFloat,
         range: TimeInterval = 1.2,
         damage: Int = 20,
         nodeType: UInt32,
         parentRoom: Room,
         position: CGPoint,
         shooterMovementVector: CGVector = CGVector.zero) {
        self.movementSpeed = maxMovementSpeed * movementSpeedRatio
        self.damage = damage
        self.popSounds = [
            AudioActions.pop1,
            AudioActions.pop2,
            AudioActions.pop3,
            AudioActions.pop4,
            AudioActions.pop5,
            AudioActions.pop6,
            AudioActions.pop7,
            AudioActions.pop8,
            AudioActions.pop9,
            AudioActions.pop10,
            AudioActions.pop11,
        ]
        super.init()
        self.addChild(self.node)
        parentRoom.addChild(self)
        self.position = position
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.categoryBitMask = nodeType
        if self.physicsBody?.categoryBitMask == PhysicsCategory.playerTear {
            self.node.fillColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
            self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.obstacle
        } else if self.physicsBody?.categoryBitMask == PhysicsCategory.enemyTear {
            self.node.fillColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            self.node.alpha = 0.5
            self.node.strokeColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
            self.node.glowWidth = 5
            self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.obstacle
        }
        self.physicsBody?.collisionBitMask = 0
        
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.run(.sequence([
            .move(by:turnIntoVector(maxMovementSpeed: self.movementSpeed, movementSpeedRatio: CGFloat(range), movementAngle: movementAngle) + shooterMovementVector, duration: range),
            .removeFromParent()
            ]))
    }
    func selfDestruct() {
        playSound(self.popSounds[Int.random(in: 0 ..< self.popSounds.count)], from: self.scene!)
        self.removeFromParent()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*-------------------------------------------------------------------------------------------------------------------------------*/


public class HintArrow: SKNode {
    let trackedEnemy : Enemy
    let parentRoom   : Room
    
    var node = SKSpriteNode(imageNamed: "arrow")
    init(
        trackedEnemy: Enemy,
        parentRoom: Room
        ) {
        self.trackedEnemy = trackedEnemy
        self.parentRoom = parentRoom
        super.init()
        self.parentRoom.container.addChild(self)
        self.addChild(self.node)
        self.node.run(.scale(to: 0.8, duration: 0))
        
        self.node.constraints = [SKConstraint.orient(to: self.trackedEnemy, offset: SKRange(value: 0, variance: 0))]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        // This runs every 0.1 second
        
        let halfFrameWidth = self.parentRoom.view!.frame.width / 2
        let halfFrameHeight = self.parentRoom.view!.frame.height / 2
        let distanceBetweenTrackedEnemyAndCameraX = trackedEnemy.position.x - self.parentRoom.container.position.x
        let distanceBetweenTrackedEnemyAndCameraY = trackedEnemy.position.y - self.parentRoom.container.position.y
        
        let absoluteDistX = abs(distanceBetweenTrackedEnemyAndCameraX)
        let absoluteDistY = abs(distanceBetweenTrackedEnemyAndCameraY)
        if absoluteDistX < halfFrameWidth && absoluteDistY < halfFrameHeight {
            self.node.isHidden = true
        } else {
            self.node.isHidden = false
        }
        
        let newX: CGFloat
        let newY: CGFloat
        
        if absoluteDistX < halfFrameWidth  - 10 {
            newX = distanceBetweenTrackedEnemyAndCameraX
        } else if distanceBetweenTrackedEnemyAndCameraX > 0 {
            newX = halfFrameWidth - 10
        } else {
            newX = -1 * halfFrameWidth + 10
        }
        
        if absoluteDistY < halfFrameHeight - 10 {
            newY = distanceBetweenTrackedEnemyAndCameraY
        } else if distanceBetweenTrackedEnemyAndCameraY > 0 {
            newY = halfFrameHeight - 10
        } else {
            newY = -1 * halfFrameHeight + 10
        }
        
        self.run(.move(to: CGPoint(x: newX, y: newY), duration: 0.1))
    }
}


/*-------------------------------------------------------------------------------------------------------------------------------*/
/*
func rippleEffect(parentRoom: Room, center: CGPoint) {
    let circle = SKShapeNode(circleOfRadius: 40)
    circle.position = center
    circle.glowWidth = 5
    circle.zPosition = 0
    circle.alpha = 0.05
    parentRoom.addChild(circle)
    circle.run(.sequence([
        .scale(to: 1, duration: 0),
        .scale(to: 4, duration: 1),
        .run {
            circle.removeFromParent()
        }
        ]))
    circle.run(.fadeOut(withDuration: 1))
}*/
func rippleEffect(center: CGPoint, owner: SKNode) {
    let circle = SKShapeNode(circleOfRadius: 40)
    let velocity: CGFloat
    
    if owner.physicsBody?.velocity != CGVector.zero{
        velocity = pythagorean(dx: owner.physicsBody!.velocity.dx, dy: owner.physicsBody!.velocity.dy)
    } else {
        velocity = 0
    }
    var waitDuration: TimeInterval = (velocity == 0) ? 0.1: Double(1 / velocity) * 40
    if waitDuration > 0.7 {
        waitDuration = 0.7
    }
    
    if velocity != 0 {
        if let parentRoom = owner.scene {
            circle.position = center
            circle.glowWidth = 5
            circle.zPosition = 0
            circle.alpha = 0.05
            parentRoom.addChild(circle)
            circle.run(.sequence([
                .scale(to: 1, duration: 0),
                .scale(to: 4, duration: 1),
                .run {
                    circle.removeFromParent()
                }
                ]))
            circle.run(.fadeOut(withDuration: 1))
        }
    }
    
    owner.run(.sequence([
        .wait(forDuration: waitDuration),
        .run{
            rippleEffect(center: owner.position, owner: owner)
        }
    ]))
}
/* ----------------------------------- Rooms ----------------------------------- */
public class Room : SKScene, SKPhysicsContactDelegate {
    
    let movementJoystickBase = SKShapeNode(circleOfRadius: 60)
    let movementJoystickKnob = SKShapeNode(circleOfRadius: 30)
    
    let shootingJoystickBase = SKShapeNode(circleOfRadius: 60)
    let shootingJoystickKnob = SKShapeNode(circleOfRadius: 30)
    
    var movementJoystickTouch: UITouch?
    var shootingJoystickTouch: UITouch?
    
    let killCounter = SKLabelNode()
    let playerHealthBar = SKLabelNode()
    
    let cameraNode = SKCameraNode()
    var playerKills : Int
    
    var musicPlayerAlt: AVAudioPlayer?
    
    
    let container = SKNode()

    public override init(size: CGSize) {
        self.playerKills = 0
        super.init(size: size)
        scaleMode = .aspectFill
        physicsWorld.gravity = .zero
        cameraNode.addChild(movementJoystickBase)
        cameraNode.addChild(shootingJoystickBase)
        movementJoystickBase.zPosition = 1000
        movementJoystickKnob.zPosition = 1001
        shootingJoystickBase.zPosition = 1000
        shootingJoystickKnob.zPosition = 1001
        
        movementJoystickKnob.fillColor = #colorLiteral(red: 0.239215686917305, green: 0.6745098233222961, blue: 0.9686274528503418, alpha: 1.0)
        shootingJoystickKnob.fillColor = #colorLiteral(red: 0.9372549057006836, green: 0.3490196168422699, blue: 0.1921568661928177, alpha: 1.0)
        movementJoystickBase.addChild(movementJoystickKnob)
        shootingJoystickBase.addChild(shootingJoystickKnob)
        
        movementJoystickBase.alpha = 0
        shootingJoystickBase.alpha = 0
        /*
        let testCircle = SKShapeNode(circleOfRadius: 80)
        testCircle.position = CGPoint.zero
        testCircle.physicsBody = SKPhysicsBody(circleOfRadius: 80)
        testCircle.physicsBody?.isDynamic = false
        testCircle.physicsBody?.categoryBitMask = PhysicsCategory.permanentObstacle
        addChild(testCircle)
        
        let testSquare = SKShapeNode(rect: CGRect(x: -15, y: -15, width: 30, height: 30))
        testSquare.position = CGPoint(x: 100, y: 100)
        testSquare.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
        testSquare.physicsBody?.isDynamic = false
        testSquare.physicsBody?.categoryBitMask = PhysicsCategory.permanentObstacle
        addChild(testSquare)
        */
        
        self.addChild(container)
        
        initialStuff()
        camera = cameraNode
        container.addChild(cameraNode)
        
        
        camera!.addChild(self.killCounter)
        self.killCounter.zPosition = 1000000
        
        self.listener = cameraNode
        self.physicsWorld.contactDelegate = self
        
        do {
            if let musicURL = Bundle.main.url(forResource: "ambientSound", withExtension: "mp3") {
                musicPlayerAlt = try AVAudioPlayer(contentsOf: musicURL)
                musicPlayerAlt?.numberOfLoops = -1
                musicPlayerAlt?.volume = 0.1
            } else {
                print("music not found")
            }
            
        } catch {
            print("failed to load background noise")
        }
        self.musicPlayerAlt?.currentTime = 0
        self.musicPlayerAlt?.play()
        self.camera!.addChild(self.playerHealthBar)
        self.playerHealthBar.zPosition = 9999
        self.playerHealthBar.fontColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        /*
        for _ in 1...20 {
            let _ = JumpingEnemy(parentRoom: self, position: CGPoint(x: CGFloat.random(in: -1000...1000), y: CGFloat.random(in: -1000...1000)))
        }
        for _ in 1...20 {
            let _ = Enemy(parentRoom: self, position: CGPoint(x: CGFloat.random(in: -1000...1000), y: CGFloat.random(in: -1000...1000)))
        }
        for _ in 1...20 {
            let _ = SprintingStopShooter(parentRoom: self, position: CGPoint(x: CGFloat.random(in: -1000...1000), y: CGFloat.random(in: -1000...1000)))
        }*/
        
    }
    func initialStuff() {
        
        let floor = SKShapeNode(rectOf: CGSize(width: 4000, height: 4000))
        floor.position = CGPoint.zero
        floor.zPosition = -10000
        floor.fillColor = #colorLiteral(red: 0.171858855, green: 0.2281698986, blue: 0.2974896891, alpha: 1)
        addChild(floor)
        
        
        let wallLeft = SKNode()
        wallLeft.position = CGPoint.zero
        wallLeft.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -2000, y: -2000), to: CGPoint(x: -2000, y: 2000))
        wallLeft.physicsBody?.isDynamic = false
        addChild(wallLeft)
        
        let wallRight = SKNode()
        wallRight.position = CGPoint.zero
        wallRight.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 2000, y: -2000), to: CGPoint(x: 2000, y: 2000))
        wallRight.physicsBody?.isDynamic = false
        addChild(wallRight)
        
        let wallTop = SKNode()
        wallTop.position = CGPoint.zero
        wallTop.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -2000, y: 2000), to: CGPoint(x: 2000, y: 2000))
        wallTop.physicsBody?.isDynamic = false
        addChild(wallTop)
        
        let wallBottom = SKNode()
        wallBottom.position = CGPoint.zero
        wallBottom.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -2000, y: -2000), to: CGPoint(x: 2000, y: -2000))
        wallBottom.physicsBody?.isDynamic = false
        addChild(wallBottom)
        
        for _ in 1...4 {
            var x = CGFloat.random(in: -800...800)
            var y = CGFloat.random(in: -800...800)
            if x > 0 {
                x += 200
            } else { x -= 200 }
            if y > 0 {
                y += 200
            } else { y -= 200 }
            spawnEnemiesGroup(groupTether: CGPoint(x: x, y: y), parentRoom: self)
        }
        self.run(.repeatForever(.sequence([
            .wait(forDuration: 30),
            .run {
                var x = CGFloat.random(in: -800...800)
                var y = CGFloat.random(in: -800...800)
                if x > 0 {
                    x += 200
                } else { x -= 200 }
                if y > 0 {
                    y += 200
                } else { y -= 200 }
                spawnEnemiesGroup(groupTether: CGPoint(x: x, y: y), parentRoom: self)
            }
            ])))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == PhysicsCategory.playerTear {
            switch secondBody.categoryBitMask {
            case PhysicsCategory.enemy:
                if let secBody = secondBody.node as? Enemy, let firBody = firstBody.node as? Projectile {
                    secBody.takeDamage(damageTaken: firBody.damage)
                }
                break
            case PhysicsCategory.destroyableObstacle:
                // do something
                break
            default:
                break
            }
        } else if firstBody.categoryBitMask == PhysicsCategory.enemyTear {
            switch secondBody.categoryBitMask {
            case PhysicsCategory.player:
                if let secBody = secondBody.node as? Player, let firBody = firstBody.node as? Projectile {
                    secBody.takeDamage(damageTaken: firBody.damage)
                }
                
                break
            case PhysicsCategory.destroyableObstacle:
                // do something
                break
            default:
                break
            }
        } else if firstBody.categoryBitMask == PhysicsCategory.player {
            switch secondBody.categoryBitMask {
            case PhysicsCategory.enemy:
                if let secBody = secondBody.node as? Enemy, let firBody = firstBody.node as? Player, secBody.dealsContactDamage {
                    firBody.takeDamage(damageTaken: secBody.damage)
                }
                break
            default:
                break
            }
        }
        if let projectile = firstBody.node as? Projectile {
            projectile.selfDestruct()
        }
    }
    func performScreenShake() {
        var shakeSequence = [SKAction]()
        for _ in 1...4 {
            shakeSequence.append(.moveBy(x: CGFloat(arc4random() % 30) - 15, y: CGFloat(arc4random() % 30) - 15, duration: 0.05))
        }
        shakeSequence.append(.move(to: CGPoint(x: 0, y: 0), duration: 0.05))
        self.camera?.run(.sequence(shakeSequence))
    }
    public override func update(_ currentTime: TimeInterval) {
        self.playerHealthBar.position = CGPoint(x: 0, y: -60 + self.view!.frame.height / 2 )
        if thePlayer.invulnerable {
            self.playerHealthBar.fontColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            self.playerHealthBar.fontColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        self.playerHealthBar.text = ""
        for _ in 1 ... thePlayer.health {
            self.playerHealthBar.text! += "♥︎"
        }
        for _ in thePlayer.health ..< 9 {
            self.playerHealthBar.text! += "♡"
        }
        self.playerKills = thePlayer.killCount
        thePlayer.update()
        self.container.position = thePlayer.position
        self.killCounter.position = CGPoint(x: 0, y: -1 * self.view!.frame.height / 2 + 30 )
        self.killCounter.text = "Kills: \(self.playerKills)"

        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: cameraNode)
            if position.x < 0 {
                if movementJoystickTouch == nil {
                    movementJoystickTouch = touch
                    movementJoystickBase.removeAllActions()
                    movementJoystickBase.alpha = 1
                    movementJoystickBase.position = position
                    movementJoystickKnob.position = CGPoint.zero                }
            } else {
                if shootingJoystickTouch == nil {
                    shootingJoystickTouch = touch 
                    shootingJoystickBase.removeAllActions()
                    shootingJoystickBase.alpha = 1
                    shootingJoystickBase.position = position
                    shootingJoystickKnob.position = CGPoint.zero
                }

            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        typealias Angle = CGFloat
        typealias Magnitude = CGFloat
        func updateJoystick(base: SKNode, knob: SKNode, touch: UITouch) -> (Angle, Magnitude) {
            let position = touch.location(in: base)
            let angle = atan2(position.y, position.x)
            let distance = sqrt(pow(position.x, 2) + pow(position.y, 2))
            let maxDistance = base.frame.size.width * 0.4
            if (distance < maxDistance) {
                knob.position = position
                return (angle, distance / maxDistance)
            } else {
                knob.position.x = maxDistance * cos(angle)
                knob.position.y = maxDistance * sin(angle)
                return (angle, 1)
            }
        }
        
        for touch in touches {
            if touch === movementJoystickTouch {
                let (angle, magnitude) = updateJoystick(base: movementJoystickBase, knob: movementJoystickKnob, touch: touch)
                thePlayer.movementAngle = angle
                thePlayer.relativeMovementSpeed = magnitude
            } else if touch === shootingJoystickTouch {
                let (angle, magnitude) = updateJoystick(base: shootingJoystickBase, knob: shootingJoystickKnob, touch: touch)
                thePlayer.shootingAngle = angle
                thePlayer.relativeShootingSpeed = magnitude
            }
        }
    }
    
    func endTouches(_ touches: Set<UITouch>) {
        for touch in touches {
            if touch === movementJoystickTouch {
                movementJoystickTouch = nil
                movementJoystickBase.run(.fadeOut(withDuration: 0.3))
                thePlayer.movementAngle = 0
                thePlayer.relativeMovementSpeed = 0
            } else if touch === shootingJoystickTouch {
                shootingJoystickTouch = nil
                shootingJoystickBase.run(.fadeOut(withDuration: 0.3))
                thePlayer.shootingAngle = 0
                thePlayer.relativeShootingSpeed = 0
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTouches(touches)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTouches(touches)
    }
}

public func displayGame() {
    thePlayer = Player()
    skView.isMultipleTouchEnabled = true
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.showsDrawCount = true
    let firstRoom = Room(size: CGSize(width: 1000, height: 1000))
    changeRoom(to: firstRoom, showUpAt: CGPoint.zero, skView: skView)
    
}
/*-------------------------------------------------------------------------------------------------------------------------------*/
public func changeRoom(to newRoom: Room, showUpAt spawnLocation: CGPoint = .zero, skView: SKView) {
    thePlayer.removeFromParent()
    thePlayer.position = spawnLocation
    newRoom.addChild(thePlayer)
    skView.presentScene(newRoom)
}
