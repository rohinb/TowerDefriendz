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

    static let shared = GameHandler()
    let ref = FIRDatabase.database().reference()
    var currentUser : FIRUser?

    init() {

        signupAnon { (success) in
            if success {

            } else {

            }
        }

    }

    func signupAnon(completion: @escaping (_ success: Bool) -> ()) {
        guard let user = FIRAuth.auth()?.currentUser else {
            FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
                if error != nil {
                    print("error signing up")
                    completion(false)
                } else {
                    completion(true)
                }
            })
            return
        }
        currentUser = user
    }

    func createGame(withUser: FIRUser, completion: @escaping (_ success: Bool) -> ()) {

        gameExists(withUser: withUser) { (exists) in
            if exists {
                completion(false)
            } else {
                let gameDictionary : [FirebaseGameOptions : Any] = [.turnNumber : 0,
                                      .user1 : self.currentUser!.uid,
                                      .user2 : withUser.uid]
                let gameId = "\(String(describing: self.currentUser?.uid))-\(withUser.uid)"
                self.ref.child("Game").child(gameId).setValue(gameDictionary, withCompletionBlock: { (error, gameRef) in
                    if error != nil {
                        print("error creating game")
                    } else {
                        completion(true)
                    }
                })
            }
        }

    }

    func gameExists(withUser: FIRUser, completion: @escaping (_ success: Bool) -> ()) {
        let gameId = "\(String(describing: currentUser?.uid))-\(withUser.uid)"
        ref.child("Game").child(gameId).observe(.value, with: { (snap) in
            if snap.value == nil {
                completion(false)
            } else {
                completion(true)
            }
        })
    }

    func createAttack(toUser: FIRUser, withSoldierArray: [Int], completion: @escaping (_ success: Bool) -> ()) {
        let gameId = "\(String(describing: currentUser?.uid))-\(toUser.uid)"
        let attackDictionary : [FirebaseGameOptions: Any] = [.gameId : gameId,
                                                .attackerId : currentUser!.uid,
                                                .defenderId : toUser.uid,
                                                .soldierArray : withSoldierArray]
        ref.child("Attack").child(toUser.uid).child(currentUser!.uid).setValue(attackDictionary) { (error, attackRef) in
            if error != nil {
                print("error creating attack")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    func getLatestAttack(inGameId: String, completion: @escaping ( _ success: Bool, _ attackerId: String?, _ defenderId: String?, _ turnNumber: Int?, _ soldierArray: [Int]? ) -> ()) {

        let users = getUsersFromGameId(gameId: inGameId)
        ref.child("Attack").child(users.0).child(users.1).observe(.value, with: { (snap) in
            if let attackDictionary = snap.value as? [FirebaseGameOptions : Any] {
                completion(true, attackDictionary[.attackerId] as? String, attackDictionary[.defenderId] as? String, attackDictionary[.turnNumber] as? Int, attackDictionary[.soldierArray] as? [Int])
            } else {
                completion(false, nil, nil, nil, nil)
            }
        })
    }

    func getUsersFromGameId(gameId: String) -> (String, String){
        let components = gameId.components(separatedBy: "-")
        return (components.first!,components.last!)
    }

}

enum FirebaseGameOptions {
    case gameId
    case attackerId
    case defenderId
    case soldierArray
    case user1
    case user2
    case turnNumber
}

