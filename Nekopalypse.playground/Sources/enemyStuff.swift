import Foundation
import SpriteKit

public func spawnEnemiesGroup(groupTether: CGPoint, parentRoom: Room) {
    
    for _ in 1...8 {
        let enemySpawners = [
        JumpingEnemy.init(parentRoom:location:),
        Enemy.init(parentRoom:location:),
        SprintingStopShooter.init(parentRoom:location:),
        ]
        let initializer = enemySpawners[.random(in: 0 ..< enemySpawners.count)]
        let _ = initializer(parentRoom, CGPoint(x: CGFloat.random(in: (groupTether.x - 100)...(groupTether.x + 100)),
                                                y: CGFloat.random(in: (groupTether.y - 100)...(groupTether.y + 100))))
 
    }
}
public func spawnRedTutorialEnemyGroup(groupTether: CGPoint, parentRoom: Room) {
    
    for _ in 1...3 {
        let enemy = Enemy(parentRoom: parentRoom, location: CGPoint(x: CGFloat.random(in: (groupTether.x - 250)...(groupTether.x + 250)), y: CGFloat.random(in: (groupTether.y - 250)...(groupTether.y + 250))))
        enemy.constraints = [SKConstraint.positionX(SKRange(lowerLimit: groupTether.x - 460, upperLimit: groupTether.x + 460))]
    }
}
public func spawnBlueTutorialEnemyGroup(groupTether: CGPoint, parentRoom: Room) {
    for _ in 1...3 {
        let enemy = JumpingEnemy(parentRoom: parentRoom, location: CGPoint(x: CGFloat.random(in: (groupTether.x - 250)...(groupTether.x + 250)), y: CGFloat.random(in: (groupTether.y - 250)...(groupTether.y + 250))))
        enemy.constraints = [SKConstraint.positionX(SKRange(lowerLimit: groupTether.x - 460, upperLimit: groupTether.x + 460))]
    }
}
public func spawnGreenTutorialEnemyGroup(groupTether: CGPoint, parentRoom: Room) {
    for _ in 1...3 {
        let enemy = SprintingStopShooter(parentRoom: parentRoom, location: CGPoint(x: CGFloat.random(in: (groupTether.x - 250)...(groupTether.x + 250)), y: CGFloat.random(in: (groupTether.y - 250)...(groupTether.y + 250))))
        enemy.constraints = [SKConstraint.positionX(SKRange(lowerLimit: groupTether.x - 460, upperLimit: groupTether.x + 460))]
    }
}
