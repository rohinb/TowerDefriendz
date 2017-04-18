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

        currentUDID = conversation.localParticipantIdentifier.uuidString

        if conversation.selectedMessage == nil {
            self.stages = [.initial, .initialSoldierSelection, .initialAttack]
            self.gameStage = .initial
        } else {
            incomingMessage = Message(str: conversation.selectedMessage!.url!.absoluteString.removingPercentEncoding!)
//            if incomingMessage?.fromUUID != currentUDID {
                self.stages = [.defend, .game, .soldierSelection, .attack]
                self.gameStage = .defend
//            } else {
//                self.stages = [.waitingForOpponent]
//                self.gameStage = .waitingForOpponent
//            }
        }
    }

    override func didSelect(_ message: MSMessage, conversation: MSConversation) {

        incomingMessage = Message(str: message.url!.absoluteString.removingPercentEncoding!)
//        if incomingMessage?.fromUUID != currentUDID {
            self.stages = [.defend, .game, .soldierSelection, .attack]
            self.gameStage = .defend
//        } else {
//            self.stages = [.waitingForOpponent]
//            self.gameStage = .waitingForOpponent
//        }
    }

    func createAttackMessage(withMessage: Message, defenseDidWin: Bool) {

        if defenseDidWin {
            withMessage.fromScore += 1
        } else {
            withMessage.toScore += 1
        }

        let caption = "Defense \(defenseDidWin ? "succeded!" : "failed!")"
        let subcaption = "You are \((withMessage.fromScore > withMessage.toScore) ? "in the lead" : "losing")!"
        self.sendMessage(withCaption: caption, withSubcaption: subcaption)
    }

    func createInitialAttackMessage(withMessage: Message) {
        let caption = "PREPARE FOR WAR!"
        let subcaption = "Tap to defend your base!"
        self.sendMessage(withCaption: caption, withSubcaption: subcaption)
    }

    func sendMessage(withCaption: String, withSubcaption: String) {
        let conversation = activeConversation
        let session = conversation?.selectedMessage?.session ?? MSSession()
        let layout = MSMessageTemplateLayout()
        layout.caption = withCaption
        layout.subcaption = withSubcaption
        //layout.image = UIImage(named: "message-background.png")
        //layout.imageTitle = "iMessage Extension"
        let message = MSMessage(session: session)
        message.layout = layout
        let str = pendingMessage!.messageString!
        if let correctedstr = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let url = URL(string: correctedstr)
            message.url = url
            message.summaryText = withCaption
            conversation?.insert(message)
        }
    }

    override func didReceive(_ message: MSMessage, conversation: MSConversation) {

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
