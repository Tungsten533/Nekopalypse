import Foundation
import SpriteKit
/*-------------------------------------------------------------------------------------------------------------------------------*/
public class Enemy: SKNode {
    var health        : Int
    var movementSpeed : CBPerSecond
    var shotSpeed     : CBPerSecond
    var shotDelayMin  : TimeInterval
    var shotDelayMax  : TimeInterval
    var range         : TimeInterval
    var damage        : Int
    var movementAngle : CGFloat
    var shootingAngle : CGFloat
    var aggroRange    : CGFloat
    
    var targetFound : Bool
    var isJumpingAvailable : Bool
    
    let node = SKShapeNode(circleOfRadius: 40)
    let healthBar = SKLabelNode()
    
    var isShootingAvailable = true
    var angleFromPlayer : CGFloat
    var distanceFromPlayer : CGFloat
    
    let positionLabel = SKLabelNode()
    
    var hintArrow: HintArrow!
    let shootingSounds : [SKAction]
    
    let deathSounds: [SKAction]
    var initialized: Bool
    var dealsContactDamage : Bool
    
    init(health:            Int      = 100,
         movementSpeed: CBPerSecond  = 200,
         shotSpeed:     CBPerSecond  = 350,
         shotDelayMin:  TimeInterval = 1.2,
         shotDelayMax:  TimeInterval = 2.5,
         parentRoom:        Room,
         range:         TimeInterval = 1.2,
         damage:            Int      = 1,
         aggroRange:      CGFloat    = 350,
         position:        CGPoint) {
        
        self.health = health
        self.movementSpeed = movementSpeed
        self.shotSpeed = shotSpeed
        self.shotDelayMin = shotDelayMin
        self.shotDelayMax = shotDelayMax
        self.range = range
        self.damage = damage
        self.movementAngle = 0
        self.shootingAngle = 0
        self.angleFromPlayer = 0
        self.distanceFromPlayer = 0
        self.aggroRange = aggroRange
        self.shootingSounds = [
            AudioActions.enemyShoot1,
            AudioActions.enemyShoot2,
            AudioActions.enemyShoot3,
            AudioActions.enemyShoot4,
            AudioActions.enemyShoot5,
            AudioActions.enemyShoot6,
            AudioActions.enemyShoot7,
            AudioActions.enemyShoot8,
            AudioActions.enemyShoot9,
            AudioActions.enemyShoot10
        ]
        self.deathSounds = [
            AudioActions.squish1,
            AudioActions.squish2,
            AudioActions.squish3,
            AudioActions.squish4,
            AudioActions.squish5,
            AudioActions.squish6,
            AudioActions.squish7,
            AudioActions.squish8,
            AudioActions.squish9,
            AudioActions.squish10,
            AudioActions.squish11
        ]
        self.targetFound = false
        self.isJumpingAvailable = true
        self.initialized = false
        self.dealsContactDamage = true
        super.init()
        
        self.node.run(.sequence([
            .scale(to: 0, duration: 0),
            .scale(to: 1, duration: 2),
            .wait(forDuration: 0.5),
            .run {
                self.initialized = true
            }
        ]))
        self.addChild(self.healthBar)
        
        parentRoom.addChild(self)
        self.addChild(self.node)
        self.node.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        self.node.strokeColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
        self.node.glowWidth = 10
        self.node.alpha = 0.5
        self.position = position
        self.node.zPosition = 100
        // physics body stuff
        self.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.playerTear | PhysicsCategory.obstacle
        self.physicsBody?.collisionBitMask = PhysicsCategory.entity | PhysicsCategory.playerTear | PhysicsCategory.obstacle
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.physicsBody?.mass = 10
        self.physicsBody?.linearDamping = 0.3
        self.hintArrow = HintArrow(trackedEnemy: self, parentRoom: self.scene as! Room)
        self.run(.repeatForever(.sequence([
                .wait(forDuration: 0.1),
                .run {
                    guard self.initialized else {
                        return
                    }
                    self.update()
                    self.hintArrow.update()
                }
        ])))
        rippleEffect(center: self.position, owner: self)
        
    }
    convenience init(parentRoom: Room, location: CGPoint) {
        self.init(parentRoom: parentRoom, position: location)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func takeDamage(damageTaken: Int) {
        playSound(self.deathSounds[Int.random(in: 0 ..< self.deathSounds.count)], from: self.scene!)
        self.health -= damageTaken
        if self.health <= 0 {
            self.removeFromParent()
            self.hintArrow.removeFromParent()
            thePlayer.killCount += 1
        }
    }
    func shootAtPlayer() {
        if self.isShootingAvailable {
            defer {
                self.isShootingAvailable = false
                self.run(.sequence([
                    .wait(forDuration: Double.random(in: self.shotDelayMin...self.shotDelayMax)),
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
                               nodeType: PhysicsCategory.enemyTear,
                               parentRoom: self.scene as! Room,
                               position: self.position,
                               shooterMovementVector: self.physicsBody!.velocity)
            playSound(self.shootingSounds[Int.random(in: 0 ..< self.shootingSounds.count)], from: self)
        }
    }
    
    
    
    func findThePlayer() {
        (self.angleFromPlayer, self.distanceFromPlayer) = findDistanceAndAngleBetween(from: self, to: thePlayer)
    }
    
    func moveConstantlyTowardsPlayer() {
        self.physicsBody?.velocity = turnIntoVector(maxMovementSpeed: self.movementSpeed, movementAngle: angleFromPlayer)
    }
    
    func update() {
        self.healthBar.text = "\(self.health)"
        self.findThePlayer()
        self.targetFound = false
        self.dealsContactDamage = false
        
        
        if distanceFromPlayer < self.aggroRange {
            self.targetFound = true
            self.shootingAngle = angleFromPlayer
            moveConstantlyTowardsPlayer()
        }
        if self.targetFound {
            self.shootAtPlayer()
        }
        
        
    }
}
