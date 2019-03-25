import Foundation
import SpriteKit

class DeathScreen : TitleScreen {
    let restartButton = Button(x: -350, y: -230, width: 700, height: 160, text: "Restart", task: displayGame)
    let titleScreenButton = Button(x: -350, y: -450, width: 700, height: 160, text: "Main Menu", task: displayTitleScreen)
    var finalKillCount = 0
    
    let deathMessage = SKLabelNode()
    
    override init() {
        super.init()
        
        playSound(AudioActions.catDeath1, from: self)
    }
    
    override func initialStuff() {
        self.buttons = [
            restartButton,
            titleScreenButton
        ]
        
        self.addChild(self.deathMessage)
        self.deathMessage.position = CGPoint(x: 0, y: 100)
        self.deathMessage.setScale(0.4)
        self.deathMessage.fontSize = self.scene!.frame.height / 4
        self.deathMessage.fontName = "Avenir-Black"
        deathMessage.text = "Final kill count: \(self.finalKillCount)"

        
        
        scaleMode = .aspectFit
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.addChild(self.restartButton)
        self.addChild(self.titleScreenButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public func displayDeathScreen(_ killCount: Int) {
    let deathScreen = DeathScreen()
    deathScreen.deathMessage.text = " Final kill Count: \(killCount)"
    skView.presentScene(deathScreen)
}

