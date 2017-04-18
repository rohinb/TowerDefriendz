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

    func showSoldierSelection() {
        soldierAdditionView.animateAlpha(t: 0.3, a: 1)
        soldierAdditionView.animateView(direction: .up, t: 0.3, pixels: 70)
    }

    func hideSoldierSelection() {
        soldierAdditionView.animateAlpha(t: 0.3, a: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return soldierTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SoldierTableView.dequeueReusableCell(withIdentifier: "cell") as! SoldierSelectionCell
        cell.VC = self
        cell.soldierType = soldierTypes[indexPath.row]
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

import GMStepper

class SoldierSelectionCell: UITableViewCell {

    var soldierType : EnemyType? {
        didSet {
            soldierLabel.text = soldierType?.name
        }
    }
    @IBOutlet weak var soldierLabel: UILabel!
    @IBOutlet weak var stepper: GMStepper!
    var VC : TowerDefriendzViewController?

    @IBAction func stepperChanged(_ sender: Any) {
        if (VC!.armyBudget - soldierType!.price) > 0 {
            VC?.pendingMessage?.soldierArray.append(soldierType!.rawValue)
            VC?.armyBudget -= soldierType!.price
        }
    }

    override func awakeFromNib() { }
}









