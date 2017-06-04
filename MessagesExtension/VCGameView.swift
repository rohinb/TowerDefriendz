//
//  VCGameView.swift
//  Tower Defriendz
//
//  Created by Sahand Edrisian on 4/10/17.
//  Copyright © 2017 tutsplus. All rights reserved.
//

import UIKit
import Messages

extension TowerDefriendzViewController {

    func gameViewInitiation(isReplay: Bool) {
        if (!isReplay || incomingMessage?.replay.count == 0) && incomingMessage?.soldierArray.count != 0 {
            if isReplay {
                progressGameStage()
                return
            }
            gameView = GameView(frame: view.bounds)
            gameView?.delegate = self
            gameView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            view.addSubview(gameView!)
            gameView?.start(enemyInts: incomingMessage!.soldierArray ,turnNumber: incomingMessage!.turnNumber, replay: nil)
        } else if isReplay && incomingMessage?.replay.count != 0 && incomingMessage?.previousSoldierArray.count != 0 {
            gameView = GameView(frame: view.bounds)
            gameView?.delegate = self
            gameView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            view.addSubview(gameView!)
            gameView?.start(enemyInts: incomingMessage!.previousSoldierArray ,turnNumber: incomingMessage!.turnNumber, replay: incomingMessage?.replay)
        } else {
            progressGameStage()
        }
    }

    func gameDidEnd(didWin: Bool, replay: [String: [String: String]]?) {

        gameView?.animateAlpha(t: 0.3, a: 0)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (_) in
            self.gameView?.removeFromSuperview()
        }
        defenseSucceeded = didWin
        self.replay = replay
        progressGameStage()
    }

}
