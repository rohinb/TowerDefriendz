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

    func createMessage(didWin: Bool, attackWave: String) {
        let conversation = activeConversation
        let session = conversation?.selectedMessage?.session ?? MSSession()

        let layout = MSMessageTemplateLayout()
        //layout.image = UIImage(named: "message-background.png")
        //layout.imageTitle = "iMessage Extension"
        layout.caption = "Defense \(didWin ? "succeded!" : "failed!")"
        layout.subcaption = "Tap to defend your base!"

        var components = URLComponents()
        let waveItem = URLQueryItem(name: "wave", value: attackWave)
        let turnItem = URLQueryItem(name: "turn", value: String(turnNumber+1))
        components.queryItems = [waveItem,turnItem]

        let message = MSMessage(session: session)
        message.layout = layout
        message.url = components.url
        message.summaryText = "Defense \(didWin ? "succeded!" : "failed!")"

        conversation?.insert(message)
    }

}
