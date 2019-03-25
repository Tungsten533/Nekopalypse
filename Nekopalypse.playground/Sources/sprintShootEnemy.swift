import Foundation
import SpriteKit

public class SprintingStopShooter: JumpingEnemy {
    
    override init(health: Int = 70,
                  movementSpeed: CBPerSecond = 0,
                  shotSpeed: CBPerSecond = 400,
                  shotDelayMin: TimeInterval = 0,
                  shotDelayMax: TimeInterval = 0,
                  parentRoom: Room,
                  range: TimeInterval = 1.2,
                  damage: Int = 1,
                  position: CGPoint,
                  aggroRange: CGFloat = 500,
                  jumpDelayMin: TimeInterval = 4,
                  jumpDelayMax: TimeInterval = 6,
                  jumpDistanceMin: CGFloat = 40,
                  jumpDistanceMax: CGFloat = 100,
                  jumpTime: TimeInterval = 0.5) {
        super.init(health: health, parentRoom: parentRoom, position: position)
        self.node.fillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    }
    convenience init(parentRoom: Room, location: CGPoint) {
        self.init(parentRoom: parentRoom, position: location)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func jumpTowardsPlayer() {
        
        guard self.isJumpingAvailable else { return }
        
        self.isJumpingAvailable = false
        self.physicsBody?.velocity = turnIntoVector(maxMovementSpeed: CGFloat.random(in: self.jumpDistanceMin...self.jumpDistanceMax) / CGFloat(self.jumpTime), movementAngle: self.angleFromPlayer)
        
        if self.targetFound {
            self.run(.sequence([
                .wait(forDuration: self.jumpTime),
                .repeat(.sequence([
                    .run {
                        // Shooting the projectile
                        self.physicsBody?.velocity = CGVector.zero
                        var _ = Projectile(maxMovementSpeed: self.shotSpeed,
                                           movementSpeedRatio: 1,
                                           movementAngle: self.angleFromPlayer,
                                           range: self.range,
                                           damage: self.damage,
                                           nodeType: PhysicsCategory.enemyTear,
                                           parentRoom: self.scene as! Room,
                                           position: self.position,
                                           shooterMovementVector: self.physicsBody!.velocity)
                        
                        playSound(self.shootingSounds[Int.random(in: 0 ..< self.shootingSounds.count)], from: self)
                    },
                    .wait(forDuration: 0.2),
                    ]), count: 4),
                .wait(forDuration: Double.random(in: self.jumpDelayMin...self.jumpDelayMax)),
                .run {
                    self.isJumpingAvailable = true
                }
                ]))
        } else {
            self.physicsBody?.velocity = turnIntoVector(maxMovementSpeed: CGFloat.random(in: self.jumpDistanceMin...jumpDistanceMax) / CGFloat(self.jumpTime), movementAngle: CGFloat.random(in: 0 ... 2 * CGFloat.pi))
            self.run(.sequence([
                .wait(forDuration: self.jumpTime),
                .run {
                    self.physicsBody?.velocity = CGVector.zero
                },
                .wait(forDuration: Double.random(in: self.jumpDelayMin...self.jumpDelayMax)),
                .run {
                    self.isJumpingAvailable = true
                }
                ]))
        }
    }
}
