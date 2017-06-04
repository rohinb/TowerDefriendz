//
//  GameHandler.swift
//  Tower Defriendz
//
//  Created by Sahand Edrisian on 4/13/17.
//  Copyright © 2017 fiveever. All rights reserved.
//

import UIKit

class Message {

    var dictionary : [String : Any]?
	var messageString : String? {
		didSet {
		//	print(messageString)
		}
	}
    var fromUUID : String = "" {
        didSet {
            updateMessageStringFromProperties()
        }
    }
    var soldierArray : [Int] = [0] {
        didSet {
            updateMessageStringFromProperties()
        }
    }
    var turnNumber : Int = 0 {
        didSet {
            updateMessageStringFromProperties()
        }
    }
    var fromScore : Int = 0 {
        didSet {
            updateMessageStringFromProperties()
        }
    }
    var toScore : Int = 0 {
        didSet {
            updateMessageStringFromProperties()
        }
    }
    var replay : [String: [String: String]] = [String: [String: String]]() {
        didSet {
            updateMessageStringFromProperties()
        }
    }
    var previousSoldierArray : [Int] = [0] {
        didSet {
            updateMessageStringFromProperties()
        }
    }

    init(str: String) {
        messageString = str
        updatePropertiesFromMessageString()
    }
    func updatePropertiesFromMessageString() {
		if let dic = deserialize(text: messageString!) {
			fromUUID = dic[MessageOptions.fromUUID.rawValue] as! String
			soldierArray = dic[MessageOptions.soldierArray.rawValue] as! [Int]
			turnNumber = dic[MessageOptions.turnNumber.rawValue] as! Int
			fromScore = dic[MessageOptions.fromScore.rawValue] as! Int
			toScore = dic[MessageOptions.toScore.rawValue] as! Int
            if let rply = dic[MessageOptions.replay.rawValue] as? [String: [String: String]] {
                if let _ = rply["-1"] {
                    replay = [String: [String: String]]()
                } else {
                    replay = rply
                }
            }
			previousSoldierArray = dic[MessageOptions.previousSoldierArray.rawValue] as? [Int] ?? [Int]()
		}
    }

    init(dic: Dictionary<String, Any>) {
        dictionary = dic
		messageString = serialize(dic: dictionary)
		updatePropertiesFromMessageString()
    }

    func updateMessageStringFromProperties() {
        dictionary = [MessageOptions.fromUUID.rawValue : fromUUID,
                      MessageOptions.soldierArray.rawValue : soldierArray.count > 0 ? soldierArray : [-1],
                      MessageOptions.turnNumber.rawValue : turnNumber,
                      MessageOptions.fromScore.rawValue : fromScore,
                      MessageOptions.toScore.rawValue : toScore,
                      MessageOptions.replay.rawValue : replay.keys.count > 0 ? replay : ["-1"  : ["name" : "normal" , "x" : "8", "y" : "7"]],
                      MessageOptions.previousSoldierArray.rawValue : previousSoldierArray.count > 0 ? previousSoldierArray : [-1]]
        messageString = serialize(dic: dictionary)
    }

    func deserialize(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
				print("bad text: ", text)
            }
        }
        return nil
    }

	func serialize(dic: [String: Any]?) -> String {
		var res = dic!.description
		res.remove(at: res.startIndex)
		res.insert("{", at: res.startIndex)
		res = res.substring(to: res.index(before: res.endIndex))
		res.append("}")
		
		if let range = res.localizedStandardRange(of: "replay") {
			res = res.replacingOccurrences(of: "[", with: "{", options: .caseInsensitive, range: range.upperBound..<res.endIndex)
			res = res.replacingOccurrences(of: "]", with: "}", options: .caseInsensitive, range: range.upperBound..<res.endIndex)
		}

		return res
	}


}

enum MessageOptions : String {
    case fromUUID = "fromUUID"
    case soldierArray = "soldierArray"
    case turnNumber = "turnNumber"
    case fromScore = "fromScore"
    case toScore = "toScore"
    case replay = "replay"
    case previousSoldierArray = "previousSoldierArray"
}




