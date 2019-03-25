import Foundation
import SpriteKit

func clickedIn(touch: UITouch, button: Button) -> Bool {
    let touchSpot = touch.location(in: button.scene!)
    if (button.left < touchSpot.x) && (touchSpot.x < button.right) && (button.top > touchSpot.y) && (touchSpot.y > button.bottom) {
        return true
    } else {
        return false
    }
}

public class Button : SKNode {
    var clicked : Bool
    var center : CGPoint
    
    let x : CGFloat
    let y : CGFloat
    let width : CGFloat
    let height : CGFloat
    let left : CGFloat
    let right : CGFloat
    let top : CGFloat
    let bottom : CGFloat
    
    let node : SKShapeNode
    var myTouch : UITouch?
    
    let task : () -> Void
    
    let label = SKLabelNode()
    
    public init(x: CGFloat,
         y: CGFloat,
         width: CGFloat,
         height: CGFloat,
         text: String,
         task: @escaping () -> ()
        ){
        self.center = CGPoint(x: x, y: y)
        self.clicked = false
        self.x = x + width / 2
        self.y = y + height / 2
        self.width = width
        self.height = height
        self.left = x
        self.right = x + width
        self.top = y + height
        self.bottom = y
        self.node = SKShapeNode(rect: CGRect(x: x, y: y, width: width, height: height), cornerRadius: 100)
        self.node.glowWidth = 10
        self.myTouch = nil
        self.task = task
        super.init()
        self.label.text = "\(text)"
        self.addChild(self.node)
        //self.node.fillColor = #colorLiteral(red: 0.171858855, green: 0.2281698986, blue: 0.2974896891, alpha: 1)
        self.node.alpha = 1
        
        self.label.text = text
        self.label.fontSize = height * 3 / 4
        self.label.verticalAlignmentMode = .center
        self.label.fontName = "Avenir-Black"
        self.label.position = CGPoint(x: self.x, y: self.y)
        self.addChild(self.label)
    }
    public func checkIfClicked(touch: UITouch) {
        self.clicked = false
        self.clicked = clickedIn(touch: touch, button: self)
        if self.clicked {
            self.myTouch = touch
            self.flip()
        }
    }
    public func checkIfMovedOff() {
        if let _ = self.myTouch {
            self.clicked = clickedIn(touch: self.myTouch!, button: self)
            self.flip()
        } else {
            self.clicked = false
            self.flip()
        }
    }
    public func checkIfReleasedWhileOn() -> Bool {
        let endedWhileOn = self.clicked
        self.clicked = false
        return endedWhileOn
        
    }
    public func activate() {
        self.task()
    }
    public func flip() {
        if self.clicked {
            self.node.alpha = 0.5
            
        } else {
            self.node.alpha = 1
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class TitleScreen : SKScene {
    let playButton = Button(x: -275, y: -230, width: 550, height: 160, text: "Play", task: displayGame)
    let tutorialButton = Button(x: -275, y: -450, width: 550, height: 160, text: "Tutorial", task: displayTutorial)
    //let settingsButton = Button(x: 20, y: -500, width: 480, height: 230, text: "Settings", task: displaySettings)
    
    var buttons : [Button]
    
    let title = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "title.png")))
    
    let cameraNode = SKCameraNode()
    override init() {
        
        
        self.buttons = [
            playButton,
            tutorialButton
            //settingsButton
        ]
        super.init(size: CGSize(width: 1100, height: 1100))
        
        camera = cameraNode
        addChild(cameraNode)
        
        
        self.camera?.position = CGPoint(x: 0, y: 0)
        /*
         self.playButton.position = CGPoint(x: 0, y: -13.5)
         self.tutorialButton.position = CGPoint(x: -26, y: -38.5)
         self.settingsButton.position = CGPoint(x: 26, y: -38.5)
         */
        scaleMode = .aspectFit
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //self.addChild(self.settingsButton)
        initialStuff()
        
    }
    func initialStuff() {
        
        self.addChild(self.title)
        self.title.position = CGPoint(x: 0, y: 100)
        self.title.setScale(0.5)
        
        self.addChild(self.playButton)
        self.addChild(self.tutorialButton)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //let position = touch.location(in: cameraNode)
            for button in self.buttons {
                button.checkIfClicked(touch: touch)
            }
            
        }
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for _ in touches {
            for button in buttons {
                button.checkIfMovedOff()
            }
        }
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            for button in buttons {
                button.myTouch = nil
                if button.checkIfReleasedWhileOn() {
                    button.activate()
                }
            }
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            for button in buttons {
                button.myTouch = nil
                button.clicked = false
            }
        }
    }
    
}


public let skView = SKView()
public var titleScreen = TitleScreen()

public func displayTitleScreen() {
    titleScreen = TitleScreen()
    skView.presentScene(titleScreen)
}


/*
public class TitleScreen: SKScene {
    
    public override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
    
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //click a button
        for(touch of touches) {
            
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //change button pressed when moved onto another button
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //activate button if began and end on same touch
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //forget everything
    }
}
public class Button: SKNode {
    let box : SKShapeNode
    
    let x: CGFloat
    let y: CGFloat
    let height: CGFloat
    let width: CGFloat
    
    init(x: CGFloat,
         y: CGFloat,
         height: CGFloat,
         width: CGFloat) {
        self.box = SKShapeNode(rectOf: CGSize(width: width, height: height), cornerRadius: height / 3)
        super.init()
    }
}
*/
