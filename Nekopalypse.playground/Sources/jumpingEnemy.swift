import Foundation
import SpriteKit

public class JumpingEnemy : Enemy {
    var jumpDelayMin : TimeInterval
    var jumpDelayMax : TimeInterval
    var jumpDistanceMin : CGFloat
    var jumpDistanceMax : CGFloat
    var jumpTime : TimeInterval
    init(health: Int = 200,
         movementSpeed: CBPerSecond = 0,
         shotSpeed: CBPerSecond = 0,
         shotDelayMin: TimeInterval = 0,
         shotDelayMax: TimeInterval = 0,
         parentRoom: Room,
         range: TimeInterval = 0,
         damage: Int = 1,
         position: CGPoint,
         aggroRange: CGFloat = 500,
         jumpDelayMin: TimeInterval = 0.8,
         jumpDelayMax: TimeInterval = 1.6,
         jumpDistanceMin: CGFloat = 100,
         jumpDistanceMax: CGFloat = 300,
         jumpTime: TimeInterval = 0.5) {
        self.jumpDelayMin = jumpDelayMin
        self.jumpDelayMax = jumpDelayMax
        self.jumpDistanceMin = jumpDistanceMin
        self.jumpDistanceMax = jumpDistanceMax
        self.jumpTime = jumpTime
        super.init(health: health, parentRoom: parentRoom, aggroRange: aggroRange, position: position)
        self.node.fillColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    }
    convenience init(parentRoom: Room, location: CGPoint) {
        self.init(parentRoom: parentRoom, position: location)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func jumpTowardsPlayer() {
        if self.isJumpingAvailable {
            defer {
                self.isJumpingAvailable = false
                self.run(.sequence([
                    .wait(forDuration: Double.random(in: self.jumpDelayMin...self.jumpDelayMax)),
                    .run {
                        self.isJumpingAvailable = true
                    }
                    ]))
            }
            if self.targetFound {
                self.physicsBody?.velocity = turnIntoVector(maxMovementSpeed: CGFloat.random(in: self.jumpDistanceMin...jumpDistanceMax) / CGFloat(self.jumpTime), movementAngle: self.angleFromPlayer)
            } else {
                self.physicsBody?.velocity = turnIntoVector(maxMovementSpeed: CGFloat.random(in: self.jumpDistanceMin...jumpDistanceMax) / CGFloat(self.jumpTime), movementAngle: CGFloat.random(in: 0 ... 2 * CGFloat.pi))
            }
            self.run(.sequence([
                .wait(forDuration: self.jumpTime),
                .run {
                    self.physicsBody?.velocity = CGVector.zero
                }
                ]))
            /*
             self.run(.move(by:turnIntoVector(maxMovementSpeed: CGFloat.random(in: self.jumpDistanceMin...self.jumpDistanceMax), movementAngle: self.angleFromPlayer), duration: self.jumpTime))*/
            
            //self.physicsBody!.velocity = turnIntoVector(maxMovementSpeed: CGFloat.random(in: self.jumpDistanceMin...self.jumpDistanceMax), movementSpeedRatio: 1, movementAngle: self.angleFromPlayer)
        }
    }
    override func update() {
        self.healthBar.text = "\(self.health)"
        self.findThePlayer()
        self.targetFound = false
        if self.distanceFromPlayer <= self.aggroRange {
            self.targetFound = true
        }
        self.jumpTowardsPlayer()
    }
}

