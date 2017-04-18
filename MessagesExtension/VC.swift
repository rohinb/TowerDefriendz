//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Sahand Edrisian
//  Copyright © 2017 Sahand Edrisian. All rights reserved.
//

import UIKit
import Messages


class TowerDefriendzViewController: MSMessagesAppViewController, GameDelegate, UITableViewDelegate, UITableViewDataSource {

    var incomingMessage : Message? = nil
    var pendingMessage : Message? = nil
    var currentUDID : String?

    var gameStage = GameStage.initial {
        didSet {
            handleGameStages()
        }
    }
    var stages : [GameStage] = [.initial, .initialAttack, .defend, .game, .soldierSelection, .attack]
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

        updateLocation()
    }

    func updateLocation() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            screenCenter = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
            self.mainButton.location = screenCenter
            self.statusLabel.location = screenCenter
            if [GameStage.soldierSelection, GameStage.initialSoldierSelection].contains(self.gameStage) {
                self.statusLabel.location.y -= 210
            } else {
                self.statusLabel.location.y -= 70
            }
        }
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .expanded {
            if [GameStage.initial].contains(gameStage) {
                screenCenter = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                progressGameStage()
            }
        } else {

        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        screenCenter = CGPoint(x: size.width/2, y: size.height/2)
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
            let dic : [String : Any] = [MessageOptions.fromUUID.rawValue : currentUDID!,
                        MessageOptions.soldierArray.rawValue : [Int](),
                        MessageOptions.turnNumber.rawValue : 0,
                        MessageOptions.fromScore.rawValue : 0,
                        MessageOptions.toScore.rawValue : 0]

            pendingMessage = Message(dic: dic)
            showSoldierSelection()
            break

        case .initialAttack:
            createInitialAttackMessage(withMessage: pendingMessage!)
            hideSoldierSelection()
            requestPresentationStyle(.compact)
            break

        case .defend:
            break

        case .game:
            gameViewInitiation()
            break

        case .soldierSelection:
            let dic : [String : Any] = [MessageOptions.fromUUID.rawValue : currentUDID!,
                                        MessageOptions.soldierArray.rawValue : [Int](),
                                        MessageOptions.turnNumber.rawValue : incomingMessage!.turnNumber + 1,
                                        MessageOptions.fromScore.rawValue : incomingMessage!.toScore,
                                        MessageOptions.toScore.rawValue : incomingMessage!.fromScore]
            
            pendingMessage = Message(dic: dic)
            showSoldierSelection()
            break

        case .attack:

            self.createAttackMessage(withMessage: pendingMessage!, defenseDidWin: self.defenseSucceeded)
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



