import SpriteKit

public struct AudioNodes {
    /*
    public static let damageSound1 = "damageSound1.mp3" //{ return SKAudioNode(fileNamed: "damageSound1.mp3") }
    public static let damageSound2 = "damageSound2.mp3" //{ return SKAudioNode(fileNamed: "damageSound2.mp3") }
    */
    public static let playerIdleSound1 = { return SKAudioNode(fileNamed: "playerIdleSound1.mp3") }
    public static let randomMoan1 = { return SKAudioNode(fileNamed: "randomMoan1.mp3") }
    
    public static let rawr1 = { return SKAudioNode(fileNamed: "rawr1.mp3") }
    public static let rawr2 = { return SKAudioNode(fileNamed: "rawr2.mp3") }
    /*
    public static let playerShootSoundRa = "playerShootSoundRa.mp3" //{ return SKAudioNode(fileNamed: "playerShootSoundRa.mp3") }
    public static let playerShootSoundRi = "playerShootSoundRi.mp3" //{ return SKAudioNode(fileNamed: "playerShootSoundRi.mp3") }
    public static let playerShootSoundRo = "playerShootSoundRo.mp3" //{ return SKAudioNode(fileNamed: "playerShootSoundRo.mp3") }
    */
    public static let pop1 = { return SKAudioNode(fileNamed: "pop1.mp3") }
    public static let pop2 = { return SKAudioNode(fileNamed: "pop2.mp3") }
    public static let pop3 = { return SKAudioNode(fileNamed: "pop3.mp3") }
    public static let pop4 = { return SKAudioNode(fileNamed: "pop4.mp3") }
    public static let pop5 = { return SKAudioNode(fileNamed: "pop5.mp3") }
    public static let pop6 = { return SKAudioNode(fileNamed: "pop6.mp3") }
    public static let pop7 = { return SKAudioNode(fileNamed: "pop7.mp3") }
    public static let pop8 = { return SKAudioNode(fileNamed: "pop8.mp3") }
    public static let pop9 = { return SKAudioNode(fileNamed: "pop9.mp3") }
    public static let pop10 = { return SKAudioNode(fileNamed: "pop10.mp3") }
    public static let pop11 = { return SKAudioNode(fileNamed: "pop11.mp3") }
}

public struct AudioActions {
    public static func makeSound(fileName: String) -> SKAction {
        return SKAction.playSoundFileNamed(fileName, waitForCompletion: false)
    }
    
    public static let damageSound1 = makeSound(fileName: "damageSound1.mp3")
    public static let damageSound2 = makeSound(fileName: "damageSound2.mp3")
    /*
    public static let playerShootSoundRa = makeSound(fileName: "playerShootSoundRa.mp3")
    public static let playerShootSoundRi = makeSound(fileName: "playerShootSoundRi.mp3")
    public static let playerShootSoundRo = makeSound(fileName: "playerShootSoundRo.mp3")
    */
    public static let pop1 = makeSound(fileName: "pop1.mp3")
    public static let pop2 = makeSound(fileName: "pop2.mp3")
    public static let pop3 = makeSound(fileName: "pop3.mp3")
    public static let pop4 = makeSound(fileName: "pop4.mp3")
    public static let pop5 = makeSound(fileName: "pop5.mp3")
    public static let pop6 = makeSound(fileName: "pop6.mp3")
    public static let pop7 = makeSound(fileName: "pop7.mp3")
    public static let pop8 = makeSound(fileName: "pop8.mp3")
    public static let pop9 = makeSound(fileName: "pop9.mp3")
    public static let pop10 = makeSound(fileName: "pop10.mp3")
    public static let pop11 = makeSound(fileName: "pop11.mp3")
    
    public static let squish1 = makeSound(fileName: "squish1.mp3")
    public static let squish2 = makeSound(fileName: "squish2.mp3")
    public static let squish3 = makeSound(fileName: "squish3.mp3")
    public static let squish4 = makeSound(fileName: "squish4.mp3")
    public static let squish5 = makeSound(fileName: "squish5.mp3")
    public static let squish6 = makeSound(fileName: "squish6.mp3")
    public static let squish7 = makeSound(fileName: "squish7.mp3")
    public static let squish8 = makeSound(fileName: "squish8.mp3")
    public static let squish9 = makeSound(fileName: "squish9.mp3")
    public static let squish10 = makeSound(fileName: "squish10.mp3")
    public static let squish11 = makeSound(fileName: "squish11.mp3")
    
    public static let playerShoot1 = makeSound(fileName: "playerShoot1.mp3")
    public static let playerShoot2 = makeSound(fileName: "playerShoot2.mp3")
    public static let playerShoot3 = makeSound(fileName: "playerShoot3.mp3")
    public static let playerShoot4 = makeSound(fileName: "playerShoot4.mp3")
    public static let playerShoot5 = makeSound(fileName: "playerShoot5.mp3")
    public static let playerShoot6 = makeSound(fileName: "playerShoot6.mp3")
    public static let playerShoot7 = makeSound(fileName: "playerShoot7.mp3")
    public static let playerShoot8 = makeSound(fileName: "playerShoot8.mp3")
    public static let playerShoot9 = makeSound(fileName: "playerShoot9.mp3")
    
    public static let enemyShoot1 = makeSound(fileName: "enemyShoot1.mp3")
    public static let enemyShoot2 = makeSound(fileName: "enemyShoot2.mp3")
    public static let enemyShoot3 = makeSound(fileName: "enemyShoot3.mp3")
    public static let enemyShoot4 = makeSound(fileName: "enemyShoot4.mp3")
    public static let enemyShoot5 = makeSound(fileName: "enemyShoot5.mp3")
    public static let enemyShoot6 = makeSound(fileName: "enemyShoot6.mp3")
    public static let enemyShoot7 = makeSound(fileName: "enemyShoot7.mp3")
    public static let enemyShoot8 = makeSound(fileName: "enemyShoot8.mp3")
    public static let enemyShoot9 = makeSound(fileName: "enemyShoot9.mp3")
    public static let enemyShoot10 = makeSound(fileName: "enemyShoot10.mp3")
    
    public static let catDeath1 = makeSound(fileName: "catDeath1.mp3")
    
    public static let ambientNoise = { return SKAction.playSoundFileNamed("ambientSound.mp3" , waitForCompletion: true) }
}

public func playSound(_ action: SKAction, from parentNode: SKNode) {
    // Easy way
    parentNode.run(action)
}
/*
public func playSound(audioNode: () -> SKAudioNode, from parentNode: SKNode) {
    // Recommended way
    let audioCopy = audioNode()
    audioCopy.autoplayLooped = false
    
    parentNode.addChild(audioCopy)
    audioCopy.run(.sequence([
        .play(),
        .wait(forDuration: 10),
        .removeFromParent()
        ]))
}*/
public func playAmbientNoise(_ action: SKAction, from parentNode: SKNode) {
    // Easy way
    parentNode.run(action)
}
