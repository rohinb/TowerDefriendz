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
        if incomingAttack?.soldierArray!.count != 0 {
            gameView = GameView(frame: view.bounds)
            gameView?.delegate = self
            gameView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            view.addSubview(gameView!)
            gameView?.start(enemyInts: incomingAttack!.soldierArray! ,turnNumber: incomingAttack!.turnNumber!)
        } else {

            alert(withTitle: "Empty attack wave", withMessage: "abort")

        }
    }

    func gameDidEnd(didWin: Bool) {

        statusLabel.text = didWin ? "YOUR DEFENSE WON!" : "Your defense lost."
        statusLabel.animateAlpha(t: 0.3, a: 1)
        statusLabel.animateView(direction: .up, t: 0.3, pixels: 50)
        mainButton.setTitle("BUILD ARMY!", for: .normal)
        mainButton.animateAlpha(t: 0.3, a: 1)
        mainButton.tag = 1
        gameView?.animateAlpha(t: 0.3, a: 0)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (_) in
            self.gameView?.removeFromSuperview()
        }
        defenseSucceeded = didWin
    }

}
