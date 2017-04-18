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

    func gameViewInitiation() {
        if incomingMessage?.soldierArray.count != 0 {
            gameView = GameView(frame: view.bounds)
            gameView?.delegate = self
            gameView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            view.addSubview(gameView!)
            gameView?.start(enemyInts: incomingMessage!.soldierArray ,turnNumber: incomingMessage!.turnNumber)
        } else {
            alert(withTitle: "Empty attack wave", withMessage: "abort")
        }
    }

    func gameDidEnd(didWin: Bool) {

        progressGameStage()
        gameView?.animateAlpha(t: 0.3, a: 0)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (_) in
            self.gameView?.removeFromSuperview()
        }
        defenseSucceeded = didWin
    }

}
