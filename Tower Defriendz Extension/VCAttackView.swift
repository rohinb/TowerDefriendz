//
//  VCAttackView.swift
//  Tower Defriendz
//
//  Created by Sahand Edrisian on 4/10/17.
//  Copyright © 2017 tutsplus. All rights reserved.
//

import UIKit
import Messages

extension TowerDefriendzViewController {

    @IBAction func increaseSoldierClicked(_ sender: Any) {
        if (armyBudget - 50) > 0 {
            soldierCounter += 1
            soldierCountLabel.text = soldierCounter.description
            armyBudget = 1000*(incomingAttack!.turnNumber! + 1) - soldierCounter*50 - eagleCounter*70
            armyCoinsLabel.text = "\(armyBudget) Coins"
        }
    }
    @IBAction func increaseEagleClicked(_ sender: Any) {
        if (armyBudget - 70) > 0 {
            eagleCounter += 1
            eagleCountLabel.text = eagleCounter.description
            armyBudget = 1000*(incomingAttack!.turnNumber! + 1) - soldierCounter*50 - eagleCounter*70
            armyCoinsLabel.text = "\(armyBudget) Coins"
        }
    }
}
