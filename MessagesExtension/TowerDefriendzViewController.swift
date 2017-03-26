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
    @IBOutlet weak var armyCoinsLabel: UILabel!
    
    var game : Game?
    var didWinGame = false
    var armyToUse = ""
    var enemyInts = [Int]()
    var turnNumber = 0
    var armyBudget = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defendButton.tag = 0
        defendButton.setTitle("DEFEND!", for: .normal)
        defendButton.isEnabled = true
        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { (_) in
            self.createMessage(didWin: true, attackWave: "1110010101010")
        }
    }
    
    override func willResignActive(with conversation: MSConversation) {
        defendButton.tag = 0
        statusLabel.animateAlpha(t: 0.3, a: 0)
        defendButton.setTitle("DEFEND!", for: .normal)
        gameViewInitiation()
    }
    
    
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        
        if let messageStr = conversation.selectedMessage?.url!.description {
            
            let waveStr = getKeyVal(str:getQueries(str: messageStr)[0]).1
            let turnStr = getKeyVal(str:getQueries(str: messageStr)[1]).1
            if waveStr.characters.count != 0 && turnStr.characters.count != 0 {
                enemyInts = getArray(str: waveStr)
                turnNumber = Int(turnStr)!
            }
        }
    }

    func getQueries(str: String) -> [String] {
        
        return str.components(separatedBy: "&")
        
    }
    
    func getKeyVal(str: String) -> (String,String) {
        let array = str.components(separatedBy: "=")
        return (array[0],array[1])
    }
    
    func getArray(str: String) -> [Int] {
		if str == "" { return [Int]() }
        return str.characters.map({ (char) -> Int in
            return Int(char.description)!
        })
    }
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        if let messageStr = conversation.selectedMessage?.url!.description {
            
            let waveStr = getKeyVal(str:getQueries(str: messageStr)[0]).1
            let turnStr = getKeyVal(str:getQueries(str: messageStr)[1]).1
            if waveStr.characters.count != 0 && turnStr.characters.count != 0 {
                enemyInts = getArray(str: waveStr)
                turnNumber = Int(turnStr)!
            }
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
            defendButton.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 + 10)
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
            createArmy()
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
        let waveItem = URLQueryItem(name: "wave", value: attackWave)
        let turnItem = URLQueryItem(name: "turn", value: String(turnNumber+1))
        components.queryItems = [waveItem,turnItem]
        
        let message = MSMessage(session: session)
        message.layout = layout
        message.url = components.url
        message.summaryText = "Attack \(didWin ? "succeded!" : "failed!")"
        
        conversation?.insert(message)
    }
    
    func gameViewInitiation() {
        if enemyInts.count != 0 {
            game = Game(frame: view.bounds)
            game?.delegate = self
            game?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            view.addSubview(game!)
            game?.start(enemyInts: enemyInts,turnNumber: turnNumber)
        } else {
            let alert = UIAlertController(title: "Bad attack wave (empty)", message: "Abort", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
        }
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
    
    @IBOutlet weak var soldierCountLabel: UILabel!
    @IBOutlet weak var eagleCountLabel: UILabel!
    
    @IBAction func increaseSoldierClicked(_ sender: Any) {
        if (armyBudget - 50) > 0 {
            soldierCounter += 1
            soldierCountLabel.text = soldierCounter.description
            armyBudget = 1000*(turnNumber+1) - soldierCounter*50 - eagleCounter*70
            armyCoinsLabel.text = "\(armyBudget) Coins"
        }
    }
    @IBAction func increaseEagleClicked(_ sender: Any) {
        if (armyBudget - 70) > 0 {
            eagleCounter += 1
            eagleCountLabel.text = eagleCounter.description
            armyBudget = 1000*(turnNumber+1) - soldierCounter*50 - eagleCounter*70
            armyCoinsLabel.text = "\(armyBudget) Coins"
        }
    }
    
    func createArmy() {
        for _ in 0..<soldierCounter {
            armyString += "1"
        }
		for _ in 0..<eagleCounter {
			armyString += "0"
		}
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

