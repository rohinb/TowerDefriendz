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
        retrieveAttack(fromConversation: conversation)
    }

    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        retrieveAttack(fromConversation: conversation)
    }

    func retrieveAttack(fromConversation: MSConversation) {
        if let messageStr = fromConversation.selectedMessage?.url!.description {
            let queries = getQueries(str: messageStr)
            let gameId = queries[0]
            gameHandler.getLatestAttack(inGameId: gameId, completion: { (success, attack) in
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








    func createMessage(didWin: Bool, attackWave: String) {
        let conversation = activeConversation
        let session = conversation?.selectedMessage?.session ?? MSSession()

        let layout = MSMessageTemplateLayout()
        //layout.image = UIImage(named: "message-background.png")
        //layout.imageTitle = "iMessage Extension"
        layout.caption = "Defense \(didWin ? "succeded!" : "failed!")"
        layout.subcaption = "Tap to defend your base!"

        var components = URLComponents()
        let waveItem = URLQueryItem(name: "gameId", value: attackWave)
        components.queryItems = [waveItem]

        let message = MSMessage(session: session)
        message.layout = layout
        message.url = components.url
        message.summaryText = "Defense \(didWin ? "succeded!" : "failed!")"

        conversation?.insert(message)
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
