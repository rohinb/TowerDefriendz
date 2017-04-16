//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Sahand Edrisian
//  Copyright © 2017 Sahand Edrisian. All rights reserved.
//

import UIKit
import Messages
import Firebase


class TowerDefriendzViewController: MSMessagesAppViewController, GameDelegate {

    var gameHandler : GameHandler?
    var incomingAttack : Attack?
    var pendingAttack : Attack?
    var gameStage = GameStage.initial {
        didSet {
            handleGameStages()
        }
    }
    var stages : [GameStage] = [.initial, .initialAttack, .openingDefend, .defend, .game, .soldierSelection, .attack]
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

        FIRApp.configure()
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .expanded {
            if [GameStage.initial, GameStage.defend].contains(gameStage) {
                progressGameStage()
            }
        } else {

        }
    }

    func progressGameStage() {
        stages.removeFirst()
        gameStage = stages.first!
    }

    func handleGameStages() {
        mainButton.stage = gameStage
        statusLabel.stage = gameStage
        switch gameStage {

        case .initial:
            break

        case .initialSoldierSelection:
            pendingAttack = Attack(gameid: gameHandler!.gameId, atackerid: gameHandler!.currentUserId, defenderid: gameHandler!.remoteUserId, turnnumber: 0, soldierarray: [Int]())
            showSoldierSelection()
            break

        case .initialAttack:
            createInitialAttackMessage(withAttack: pendingAttack!)
            hideSoldierSelection()
            requestPresentationStyle(.compact)
            break

        case .openingDefend:
            break

        case .defend:
            break

        case .game:
            gameViewInitiation()
            break

        case .soldierSelection:
            pendingAttack = Attack(gameid: gameHandler!.gameId, atackerid: gameHandler!.currentUserId, defenderid: gameHandler!.remoteUserId, turnnumber: 0, soldierarray: [Int]())
            showSoldierSelection()
            break

        case .attack:
            gameHandler?.getGame(withGameId: gameHandler!.gameId, completion: { (success, game) in
                if success {
                    self.pendingAttack = Attack(gameid: self.gameHandler!.gameId, atackerid: self.gameHandler!.currentUserId, defenderid: self.gameHandler!.remoteUserId, turnnumber: game!.turnNumber!, soldierarray: self.pendingAttack!.soldierArray!)
                    self.createAttackMessage(withAttack: self.pendingAttack!, defenseDidWin: self.defenseSucceeded)
                }
            })
            hideSoldierSelection()
            requestPresentationStyle(.compact)
            break

        case .waitingForOpponent:
            break

        case .cannotGetAttack:
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
    
}



