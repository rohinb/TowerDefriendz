//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Sahand Edrisian
//  Copyright © 2017 Sahand Edrisian. All rights reserved.
//

import UIKit
import Messages


class TowerDefriendzViewController: MSMessagesAppViewController, GameDelegate {

    var gameHandler : GameHandler?
    var incomingAttack : Attack?
    var pendingAttack : Attack?
    var gameStage = GameStage.initial
    var stages : [GameStage] = [.initial, .defend, .game, .soldierSelection, .attack]
    var gameView : GameView?
    var defenseSucceeded = false


    @IBOutlet weak var statusLabel: StatusLabel!
    @IBOutlet weak var mainButton: MainButton!

    var armyBudget = 500
    var soldierCounter = 0
    var eagleCounter = 0
    var soldierArray : [Int]?

    @IBOutlet weak var soldierAdditionView: UIView!
    @IBOutlet weak var armyCoinsLabel: UILabel!
    @IBOutlet weak var soldierCountLabel: UILabel!
    @IBOutlet weak var eagleCountLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func willResignActive(with conversation: MSConversation) {

    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .expanded {
            mainButton.isEnabled = true
            mainButton.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        } else {
            statusLabel.animateAlpha(t: 0.3, a: 0)
            mainButton.isEnabled = false
            mainButton.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 + 10)
        }
    }

    func progressGameStage() {

        stages.removeFirst()
        gameStage = stages.first!

        switch gameStage {

        case .initial:
            pendingAttack = Attack(gameid: gameHandler!.gameId, atackerid: gameHandler!.currentUserId, defenderid: gameHandler!.remoteUserId, turnnumber: 0, soldierarray: soldierArray!)
            createInitialAttackMessage(withAttack: pendingAttack!)
            break

        case .defend:
            break

        case .game:
            break

        case .soldierSelection:
            break

        case .attack:

            gameHandler?.getGame(withGameId: gameHandler!.gameId, completion: { (success, game) in
                if success {
                    self.pendingAttack = Attack(gameid: self.gameHandler!.gameId, atackerid: self.gameHandler!.currentUserId, defenderid: self.gameHandler!.remoteUserId, turnnumber: game!.turnNumber!, soldierarray: self.soldierArray!)
                    self.createAttackMessage(withAttack: self.pendingAttack!, defenseDidWin: self.defenseSucceeded)
                }
            })


            break

        }
    }

    @IBAction func mainButtonClicked(_ sender: MainButton) {
        progressGameStage()
    }

    func alert(withTitle: String, withMessage: String) {
        let alert = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }


    /* @IBAction func mainButtonClicked(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            // Defend clicked
            statusLabel.animateAlpha(t: 0.3, a: 0)
            mainButton.animateAlpha(t: 0.3, a: 0)
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
    }*/
    



}



