//
//  GameHandler.swift
//  Tower Defriendz
//
//  Created by Sahand Edrisian on 4/13/17.
//  Copyright © 2017 fiveever. All rights reserved.
//

import UIKit
import Firebase

class GameHandler {

    var currentUserId = ""
    var remoteUserId = ""
    let ref = FIRDatabase.database().reference()
    var currentUser : GameUser?
    var gameId = ""

    init(withCurrentUserId: String, withRemoteUserId: String) {
        currentUserId = withCurrentUserId
        remoteUserId = withRemoteUserId
        gameId = "\(currentUserId)&\(remoteUserId)"
    }

    func createGame(completion: @escaping (_ success: Bool) -> ()) {
        gameExists() { (exists) in
            if exists {
                completion(false)
            } else {
                let gameDictionary : [String : Any] = [FirebaseGameOptions.turnNumber.rawValue : 0,
                                      FirebaseGameOptions.user1Id.rawValue : self.currentUserId,
                                      FirebaseGameOptions.user2Id.rawValue : self.remoteUserId,
                                      FirebaseGameOptions.user1Score.rawValue : 0,
                                      FirebaseGameOptions.user2Score.rawValue : 0]
                self.ref.child("Game").child(self.gameId).setValue(gameDictionary, withCompletionBlock: { (error, gameRef) in
                    if error != nil {
                        print("error creating game")
                    } else {
                        completion(true)
                    }
                })
            }
        }
    }

    func gameExists(completion: @escaping (_ success: Bool) -> ()) {
        ref.child("Game").child(self.remoteUserId).observe(.value, with: { (snap) in
            if snap.value == nil {
                completion(false)
            } else {
                completion(true)
            }
        })
    }

    func getGame(withGameId: String, completion: @escaping (Bool, Game?) -> ()) {

        ref.child("Game").child(withGameId).observe(.value, with: { (snap) in
            if snap.value == nil {
                let gameDictionary = snap.value as! [String : Any]
                let game = Game(gameid: withGameId, user1id: gameDictionary[FirebaseGameOptions.user1Id.rawValue] as! String, user2id: gameDictionary[FirebaseGameOptions.user2Id.rawValue] as! String, turnnumber: gameDictionary[FirebaseGameOptions.turnNumber.rawValue] as! Int, user1score: gameDictionary[FirebaseGameOptions.user1Score.rawValue] as! Int, user2score: gameDictionary[FirebaseGameOptions.user2Score.rawValue] as! Int)
                completion(true, game)
            } else {
                completion(false, nil)
            }
        })
    }

    func updateGame(game: Game) {
        let gameDictionary : [String : Any] = [FirebaseGameOptions.turnNumber.rawValue : game.turnNumber!,
                                               FirebaseGameOptions.user1Id.rawValue : game.user1Id!,
                                               FirebaseGameOptions.user2Id.rawValue : game.user2Id!,
                                               FirebaseGameOptions.user1Score.rawValue : game.user1Score!,
                                               FirebaseGameOptions.user2Score.rawValue : game.user2Score!]
        ref.child("Game").child(game.gameId!).setValue(gameDictionary) { (error, gameRef) in
            if error != nil {
                print("error updating game")
            } else {
            }
        }
    }

    func attackFinished(inGameId: String, withWinner: GameUser) {
        getGame(withGameId: inGameId) { (success, game) in
            if success {
                if game?.user1Id! == withWinner.uid {
                    game?.user1Score! += 1
                } else {
                    game?.user2Score! += 1
                }
                self.updateGame(game: game!)
            }
        }
    }

    func createAttack(withSoldierArray: [Int], completion: @escaping (_ success: Bool) -> ()) {
        let attackDictionary : [String: Any] = [FirebaseGameOptions.gameId.rawValue : gameId,
                                                FirebaseGameOptions.attackerId.rawValue : self.currentUserId,
                                                FirebaseGameOptions.defenderId.rawValue : self.remoteUserId,
                                                FirebaseGameOptions.soldierArray.rawValue : withSoldierArray]
        ref.child("Attack").child(self.remoteUserId).child(currentUser!.uid).setValue(attackDictionary) { (error, attackRef) in
            if error != nil {
                print("error creating attack")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    func getLatestAttack(inGameId: String, completion: @escaping ( _ success: Bool, _ attack: Attack?) -> ()) {

        let users = getUsersFromGameId(gameId: inGameId)
        ref.child("Attack").child(users.0).child(users.1).observe(.value, with: { (snap) in
            if let attackDictionary = snap.value as? [String : Any] {
                let attack = Attack(gameid: inGameId, atackerid: attackDictionary[FirebaseGameOptions.attackerId.rawValue] as! String, defenderid: attackDictionary[FirebaseGameOptions.defenderId.rawValue] as! String, turnnumber: attackDictionary[FirebaseGameOptions.turnNumber.rawValue] as! Int, soldierarray: attackDictionary[FirebaseGameOptions.soldierArray.rawValue] as! [Int])
                completion(true, attack)
            } else {
                completion(false, nil)
            }
        })
    }

    func getUsersFromGameId(gameId: String) -> (String, String){
        let components = gameId.components(separatedBy: "&")
        return (components.first!,components.last!)
    }

}

enum FirebaseGameOptions : String {
    case gameId = "gameId"
    case attackerId = "attackerId"
    case defenderId = "defenderId"
    case soldierArray = "soldierArray"
    case user1Id = "user1Id"
    case user2Id = "user2Id"
    case turnNumber = "turnNumber"
    case user1Score = "user1Score"
    case user2Score = "user2Score"
}


class GameUser {
    var uid : String

    init(withId : String) {
        uid = withId
    }
}


class Attack {

    var gameId : String?
    var attackerId : String?
    var defenderId : String?
    var turnNumber : Int?
    var soldierArray : [Int]?

    init(gameid: String, atackerid: String, defenderid: String, turnnumber: Int, soldierarray: [Int]) {
        gameId = gameid
        attackerId = atackerid
        defenderId = defenderid
        turnNumber = turnnumber
        soldierArray = soldierarray
    }
}

class Game {

    var gameId : String?
    var user1Id : String?
    var user2Id : String?
    var turnNumber : Int?
    var user1Score : Int?
    var user2Score : Int?

    init(gameid: String, user1id: String, user2id: String, turnnumber: Int, user1score: Int, user2score: Int) {
        gameId = gameid
        user1Id = user1id
        user2Id = user2id
        turnNumber = turnnumber
        user1Score = user1score
        user2Score = user2score
    }
}





