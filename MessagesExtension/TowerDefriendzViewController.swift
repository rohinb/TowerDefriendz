//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Davis Allie on 17/07/16.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import UIKit
import Messages

class TowerDefriendzViewController: MSMessagesAppViewController, GameDelegate {
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var defendButton: UIButton!
    @IBOutlet weak var soldierAdditionView: UIView!
    
    var game : Game?
    var didWinGame = false
    var armyToUse = ""
    var enemyInts = [Int]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defendButton.tag = 0
        defendButton.setTitle("DEFEND!", for: .normal)
        
        /*if presentationStyle == .compact {
            defendButton.isEnabled = false
        } else {
            defendButton.isEnabled = true

        }*/
        
        defendButton.isEnabled = true

        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { (_) in
            self.createMessage(didWin: true, attackWave: "1-1-1-0-0")
        }

    }

    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        
        if let messageStr = conversation.selectedMessage?.url!.description {
        
            let waveStr = messageStr.substring(from: messageStr.characters.index(after: messageStr.characters.index(of: "=")!))
            enemyInts = waveStr.components(separatedBy: "-").map({ (str) -> Int in
                return Int(str)!
            })
            
        }
        
        // SEND INFO TO GAME ENGINE!!!!!!
        
    }
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        if let messageStr = conversation.selectedMessage?.url!.description {
            
            let waveStr = messageStr.substring(from: messageStr.characters.index(after: messageStr.characters.index(of: "=")!))
            enemyInts = waveStr.components(separatedBy: "-").map({ (str) -> Int in
                return Int(str)!
            })
            
        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
        if presentationStyle == .expanded {
            defendButton.isEnabled = true
            defendButton.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        } else {
            statusLabel.animateAlpha(t: 0.3, a: 0)
            defendButton.isEnabled = false
            defendButton.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        }
    }

    @IBAction func defendButtonClicked(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            // Defend clicked
            statusLabel.animateAlpha(t: 0.3, a: 0)
            defendButton.animateAlpha(t: 0.3, a: 0)
            sender.setTitle("BUILD ARMY!", for: .normal)
            gameViewInitiation()
            
        } else if sender.tag == 1 {
            
            // Build army clicked
            statusLabel.animateView(direction: .up, t: 0.3, pixels: 70)
            statusLabel.animateAlpha(t: 0.3, a: 0)
            statusLabel.text = "CHOOSE YOUR ARMY!"
            soldierAdditionView.animateAlpha(t: 0.3, a: 1)
            soldierAdditionView.animateView(direction: .up, t: 0.3, pixels: 70)
            sender.tag = 2
            sender.setTitle("ATTACK!", for: .normal)
            
        } else if sender.tag == 2 {
            
            // Attack clicked
            soldierAdditionView.animateAlpha(t: 0.3, a: 0)
            requestPresentationStyle(.compact)
            statusLabel.text = "SEND THE MESSAGE!"
            statusLabel.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.width/2)
            createMessage(didWin: didWinGame, attackWave: armyString)
            
        }
    }
    
    func createMessage(didWin: Bool, attackWave: String) {
        let conversation = activeConversation
        let session = conversation?.selectedMessage?.session ?? MSSession()
        
        let layout = MSMessageTemplateLayout()
        //layout.image = UIImage(named: "message-background.png")
        //layout.imageTitle = "iMessage Extension"
        layout.caption = "Attack \(didWin ? "succeded!" : "failed!")"
        layout.subcaption = "Tap to defend your base!"
        
        var components = URLComponents()
        let queryItem = URLQueryItem(name: "wave", value: attackWave)
        components.queryItems = [queryItem]
        
        let message = MSMessage(session: session)
        message.layout = layout
        message.url = components.url
        message.summaryText = "Attack \(didWin ? "succeded!" : "failed!")"
        
        conversation?.insert(message)
    }
    
    func gameViewInitiation() {
        game = Game(frame: view.bounds)
        game?.delegate = self
        game?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(game!)
        game?.start(enemyInts: enemyInts)
    }
    
    func gameDidEnd(didWin: Bool) {
        
        statusLabel.text = didWin ? "YOUR DEFENSE WON!" : "Your defense lost."
        statusLabel.animateAlpha(t: 0.3, a: 1)
        statusLabel.animateView(direction: .up, t: 0.3, pixels: 50)
        defendButton.setTitle("BUILD ARMY!", for: .normal)
        defendButton.animateAlpha(t: 0.3, a: 1)
        defendButton.tag = 1
        game?.animateAlpha(t: 0.3, a: 0)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (_) in
            self.game?.removeFromSuperview()
        }
        didWinGame = didWin
    }
    
    var soldierCounter = 0
    var eagleCounter = 0
    var armyString = ""
    
    @IBAction func increaseSoldierClicked(_ sender: Any) {
        soldierCounter += 1
    }
    @IBAction func increaseEagleClicked(_ sender: Any) {
        eagleCounter += 1
    }
    
    func createArmy() {
        for _ in 0...soldierCounter {
            armyString += "1-"
        }
        for _ in 0...eagleCounter {
            armyString += "0-"
        }
        armyString.remove(at: armyString.startIndex)
    }
    
}



extension UIView {
    
    func animateAlpha(t: Double, a: Double) {
        UIView.animate(withDuration: t) { 
            self.alpha = CGFloat(a)
        }
    }
    
    func animateView(direction: UIViewAnimationDirection, t: Double, pixels: Double) {
        UIView.animate(withDuration: t) {
            switch direction {
                case .up:
                    self.frame.origin.y -= CGFloat(pixels)
                case .down:
                    self.frame.origin.y += CGFloat(pixels)
                case .right:
                    self.frame.origin.x += CGFloat(pixels)
                case .left:
                    self.frame.origin.x -= CGFloat(pixels)
            }
        }
    }
    
    enum UIViewAnimationDirection {
        case up
        case down
        case left
        case right
    }
    
}

