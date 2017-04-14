//
//  TowerDefriendzMessageHandling.swift
//  Tower Defriendz
//
//  Created by Sahand Edrisian on 4/10/17.
//  Copyright © 2017 tutsplus. All rights reserved.
//

import UIKit
import Messages

extension TowerDefriendzViewController {


    override func willBecomeActive(with conversation: MSConversation) {
        let currentUserId = conversation.localParticipantIdentifier.uuidString
        let remoteUserId = conversation.remoteParticipantIdentifiers.first!.uuidString
        gameHandler = GameHandler(withCurrentUserId: currentUserId, withRemoteUserId: remoteUserId)
        retrieveAttack(fromConversation: conversation)
    }

    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        retrieveAttack(fromConversation: conversation)
    }

    func retrieveAttack(fromConversation: MSConversation) {
        if let messageStr = fromConversation.selectedMessage?.url!.description {
            let queries = getQueries(str: messageStr)
            let gameId = queries[0]
            gameHandler?.getLatestAttack(inGameId: gameId, completion: { (success, attack) in
                if success {
                    self.incomingAttack = attack!
                    self.mainButton.visible = true
                } else {
                    self.alert(withTitle: "Cannot retrieve attack.", withMessage: "abort")
                    self.mainButton.visible = false
                }
            })
        }
    }

    func createAttackMessage(withAttack: Attack, defenseDidWin: Bool) {
        gameHandler?.getGame(withGameId: withAttack.gameId!) { (success, game) in
            if success {
                var yourScore = 0
                var opponentScore = 0
                if game?.user1Id == self.gameHandler?.currentUser?.uid {
                    yourScore = game!.user1Score!
                    opponentScore = game!.user2Score!
                } else {
                    yourScore = game!.user2Score!
                    opponentScore = game!.user1Score!
                }
                let caption = "Defense \(defenseDidWin ? "succeded!" : "failed!")"
                let subcaption = "Tap to defend your base! You are \((yourScore > opponentScore) ? "in the lead" : "losing")!"
                self.sendMessage(withCaption: caption, withSubcaption: subcaption, withQueries: ["gameId" : self.gameHandler!.gameId])
            }
        }
    }

    func createInitialAttackMessage(withAttack: Attack) {
        gameHandler?.createGame(completion: { (success) in
            if success {
                let caption = "PREPARE FOR WAR!"
                let subcaption = "Tap to defend your base!"
                self.sendMessage(withCaption: caption, withSubcaption: subcaption, withQueries: ["gameId" : self.gameHandler!.gameId])
            }
        })
    }

    func sendMessage(withCaption: String, withSubcaption: String, withQueries : [String : String]) {
        let conversation = activeConversation
        let session = conversation?.selectedMessage?.session ?? MSSession()
        let layout = MSMessageTemplateLayout()
        layout.caption = withCaption
        layout.subcaption = withSubcaption
        //layout.image = UIImage(named: "message-background.png")
        //layout.imageTitle = "iMessage Extension"
        var components = URLComponents()
        for query in withQueries {
            let queryItem = URLQueryItem(name: query.key, value: query.value)
            components.queryItems?.append(queryItem)
        }
        let message = MSMessage(session: session)
        message.layout = layout
        message.url = components.url
        message.summaryText = withCaption
        conversation?.insert(message)
    }

    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        self.gameHandler?.createAttack(withSoldierArray: pendingAttack!.soldierArray!, completion: { (success) in
            if success {
                print("Attack created successfully")
            } else {
                print("Error creating attack")
            }
        })
    }



    ///////////////////////////////////////////////////////

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

    ///////////////////////////////////////////////////////

}
