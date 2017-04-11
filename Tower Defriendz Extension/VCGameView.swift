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
        if enemyInts.count != 0 {
            game = Game(frame: view.bounds)
            game?.delegate = self
            game?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            view.addSubview(game!)
            game?.start(enemyInts: enemyInts,turnNumber: turnNumber)
        } else {
            let alert = UIAlertController(title: "Bad attack wave (empty)", message: "Abort", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)

        }
    }

    func gameDidEnd(didWin: Bool) {

        statusLabel.text = didWin ? "YOUR DEFENSE WON!" : "Your defense lost."
        statusLabel.animateAlpha(t: 0.3, a: 1)
        statusLabel.animateView(direction: .up, t: 0.3, pixels: 50)
        mainButton.setTitle("BUILD ARMY!", for: .normal)
        mainButton.animateAlpha(t: 0.3, a: 1)
        mainButton.tag = 1
        game?.animateAlpha(t: 0.3, a: 0)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (_) in
            self.game?.removeFromSuperview()
        }
        didWinGame = didWin
    }

}
