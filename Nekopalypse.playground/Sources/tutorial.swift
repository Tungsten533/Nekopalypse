import Foundation
import SpriteKit
import AVFoundation

class Tutorial : Room {
    public override init(size: CGSize = CGSize(width: 1000, height: 1000)) {
        
        super.init(size: size)
 
    }
    override func initialStuff() {
        
        let leftMainMenuText = SKLabelNode()
        leftMainMenuText.position = CGPoint(x: -460, y: 90)
        leftMainMenuText.text = "↓ Kill for main menu"
        leftMainMenuText.zPosition = 0
        leftMainMenuText.verticalAlignmentMode = .center
        leftMainMenuText.horizontalAlignmentMode = .left
        leftMainMenuText.fontName = "Avenir-Black"
        self.addChild(leftMainMenuText)
        
        let rightMainMenuText = SKLabelNode()
        rightMainMenuText.position = CGPoint(x: 3260, y: 90)
        rightMainMenuText.text = "Kill for main menu ↓"
        rightMainMenuText.zPosition = 0
        rightMainMenuText.verticalAlignmentMode = .center
        rightMainMenuText.horizontalAlignmentMode = .right
        rightMainMenuText.fontName = "Avenir-Black"
        self.addChild(rightMainMenuText)
        
        let redEnemyDescription = SKLabelNode()
        redEnemyDescription.position = CGPoint(x: 500, y: 0)
        redEnemyDescription.text = "Red slimes move towards you and shoot at you"
        redEnemyDescription.zPosition = 0
        redEnemyDescription.verticalAlignmentMode = .center
        redEnemyDescription.horizontalAlignmentMode = .center
        redEnemyDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        redEnemyDescription.numberOfLines = 2
        redEnemyDescription.preferredMaxLayoutWidth = 500
        redEnemyDescription.fontName = "Avenir-Black"
        self.addChild(redEnemyDescription)
        
        let blueEnemyDescription = SKLabelNode()
        blueEnemyDescription.position = CGPoint(x: 1500, y: 0)
        blueEnemyDescription.text = "Blue slimes jump towards you and hurt to the touch"
        blueEnemyDescription.zPosition = 0
        blueEnemyDescription.verticalAlignmentMode = .center
        blueEnemyDescription.horizontalAlignmentMode = .center
        blueEnemyDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        blueEnemyDescription.numberOfLines = 2
        blueEnemyDescription.preferredMaxLayoutWidth = 500
        blueEnemyDescription.fontName = "Avenir-Black"
        self.addChild(blueEnemyDescription)
        
        let greenEnemyDescription = SKLabelNode()
        greenEnemyDescription.position = CGPoint(x: 2500, y: 0)
        greenEnemyDescription.text = "Green slimes jump towards you then shoot at you in bursts and hurt to the touch"
        greenEnemyDescription.zPosition = 0
        greenEnemyDescription.verticalAlignmentMode = .center
        greenEnemyDescription.horizontalAlignmentMode = .center
        greenEnemyDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        greenEnemyDescription.numberOfLines = 2
        greenEnemyDescription.preferredMaxLayoutWidth = 500
        greenEnemyDescription.fontName = "Avenir-Black"
        self.addChild(greenEnemyDescription)
        
        let healthBarDescription = SKLabelNode()
        healthBarDescription.position = CGPoint(x: 0, y: self.frame.height / 4 - 60)
        healthBarDescription.text = "↑ Health Bar ↑"
        healthBarDescription.zPosition = 2000
        healthBarDescription.verticalAlignmentMode = .center
        healthBarDescription.horizontalAlignmentMode = .center
        healthBarDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        healthBarDescription.numberOfLines = 2
        healthBarDescription.preferredMaxLayoutWidth = 500
        healthBarDescription.fontName = "Avenir-Black"
        cameraNode.addChild(healthBarDescription)
        
        let killCounterDescription = SKLabelNode()
        killCounterDescription.position = CGPoint(x: 0, y: -1 * self.frame.height / 4 + 60)
        killCounterDescription.text = "↓ Slime Kill Counter ↓"
        killCounterDescription.zPosition = 2000
        killCounterDescription.verticalAlignmentMode = .center
        killCounterDescription.horizontalAlignmentMode = .center
        killCounterDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        killCounterDescription.numberOfLines = 2
        killCounterDescription.preferredMaxLayoutWidth = 500
        killCounterDescription.fontName = "Avenir-Black"
        cameraNode.addChild(killCounterDescription)
        
        let movementJoystickDescription = SKLabelNode()
        movementJoystickDescription.position = CGPoint(x: -1 * self.frame.width / 4 + 20, y: 0)
        movementJoystickDescription.fontColor = #colorLiteral(red: 0.239215686917305, green: 0.6745098233222961, blue: 0.9686274528503418, alpha: 1.0)
        movementJoystickDescription.text = "The joystick on this side is for moving"
        movementJoystickDescription.zPosition = 2000
        movementJoystickDescription.verticalAlignmentMode = .center
        movementJoystickDescription.horizontalAlignmentMode = .center
        movementJoystickDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        movementJoystickDescription.numberOfLines = 2
        movementJoystickDescription.preferredMaxLayoutWidth = 250
        movementJoystickDescription.fontName = "Avenir-Black"
        cameraNode.addChild(movementJoystickDescription)
        
        let shootingJoystickDescription = SKLabelNode()
        shootingJoystickDescription.position = CGPoint(x: self.frame.width / 4 - 20, y: 0)
        shootingJoystickDescription.fontColor =  #colorLiteral(red: 0.9372549057006836, green: 0.3490196168422699, blue: 0.1921568661928177, alpha: 1.0) 
        shootingJoystickDescription.text = "The joystick on this side is for shooting"
        shootingJoystickDescription.zPosition = 2000
        shootingJoystickDescription.verticalAlignmentMode = .center
        shootingJoystickDescription.horizontalAlignmentMode = .center
        shootingJoystickDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        shootingJoystickDescription.numberOfLines = 2
        shootingJoystickDescription.preferredMaxLayoutWidth = 250
        shootingJoystickDescription.fontName = "Avenir-Black"
        cameraNode.addChild(shootingJoystickDescription)
        
        let floor = SKShapeNode(rectOf: CGSize(width: 4000, height: 500))
        floor.position = CGPoint(x: 1500, y: 0)
        floor.zPosition = -10000
        floor.fillColor = #colorLiteral(red: 0.171858855, green: 0.2281698986, blue: 0.2974896891, alpha: 1)
        addChild(floor)
        
        let wallLeft = SKNode()
        wallLeft.position = CGPoint.zero
        wallLeft.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -500, y: -250), to: CGPoint(x: -500, y: 250))
        wallLeft.physicsBody?.isDynamic = false
        addChild(wallLeft)
        
        let wallRight = SKNode()
        wallRight.position = CGPoint.zero
        wallRight.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 3500, y: -250), to: CGPoint(x: 3500, y: 250))
        wallRight.physicsBody?.isDynamic = false
        addChild(wallRight)
        
        let wallTop = SKNode()
        wallTop.position = CGPoint.zero
        wallTop.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -500, y: 250), to: CGPoint(x: 3500, y: 250))
        wallTop.physicsBody?.isDynamic = false
        addChild(wallTop)
        
        let wallBottom = SKNode()
        wallBottom.position = CGPoint.zero
        wallBottom.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -500, y: -250), to: CGPoint(x: 3500, y: -250))
        wallBottom.physicsBody?.isDynamic = false
        addChild(wallBottom)
        
        let redFloor = SKShapeNode(rectOf: CGSize(width: 1000, height: 500))
        redFloor.position = CGPoint(x: 500, y: 0)
        redFloor.zPosition = 1
        redFloor.fillColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.5)
        redFloor.alpha = 0.25
        addChild(redFloor)
        
        let blueFloor = SKShapeNode(rectOf: CGSize(width: 1000, height: 500))
        blueFloor.position = CGPoint(x: 1500, y: 0)
        blueFloor.zPosition = 1
        blueFloor.fillColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 0.4955586473)
        blueFloor.alpha = 0.25
        addChild(blueFloor)
        
        let greenFloor = SKShapeNode(rectOf: CGSize(width: 1000, height: 500))
        greenFloor.position = CGPoint(x: 2500, y: 0)
        greenFloor.zPosition = 1
        greenFloor.fillColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 0.5)
        greenFloor.alpha = 0.25
        addChild(greenFloor)
        
        let _ = TitleScreenEnemy(parentRoom: self, position: CGPoint(x: -450, y: 0))
        
        let _ = TitleScreenEnemy(parentRoom: self, position: CGPoint(x: 3250, y: 0))
        
        spawnRedTutorialEnemyGroup(groupTether: CGPoint(x: 500, y: 0), parentRoom: self)
        
        spawnBlueTutorialEnemyGroup(groupTether: CGPoint(x: 1500, y: 0), parentRoom: self)
        
        spawnGreenTutorialEnemyGroup(groupTether: CGPoint(x: 2500, y: 0), parentRoom: self)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TitleScreenEnemy : Enemy {
    override init(
                  health:            Int      = 100,
                  movementSpeed: CBPerSecond  = 0,
                  shotSpeed:     CBPerSecond  = 0,
                  shotDelayMin:  TimeInterval = 0,
                  shotDelayMax:  TimeInterval = 0,
                  parentRoom:        Room,
                  range:         TimeInterval = 0,
                  damage:            Int      = 0,
                  aggroRange:      CGFloat    = 0,
                  position:        CGPoint) {
        
        super.init(health: 100,
                   movementSpeed: 0,
                   shotSpeed: 0,
                   shotDelayMin: 0,
                   shotDelayMax: 0,
                   parentRoom: parentRoom,
                   range: 0,
                   damage: 0,
                   aggroRange: 0,
                   position: position)
        self.dealsContactDamage = false
        self.node.fillColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        self.node.strokeColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
        self.physicsBody?.isDynamic = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func takeDamage(damageTaken: Int) {
        playSound(self.deathSounds[Int.random(in: 0 ..< self.deathSounds.count)], from: self.scene!)
        self.health -= damageTaken
        if self.health <= 0 {
            displayTitleScreen()
        }
    }
}

func displayTutorial() {
    thePlayer = Player()
    let tutorial = Tutorial()
    skView.presentScene(tutorial)
    changeRoom(to: tutorial, showUpAt: CGPoint(x: -250, y: 0), skView: skView)
}
