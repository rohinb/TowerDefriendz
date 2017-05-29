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
        for cell in SoldierTableView.visibleCells as! [SoldierSelectionCell]{
            cell.stepper.value = 0
        }
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
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

import GMStepper

class SoldierSelectionCell: UITableViewCell, GMStepperDelegate {

    var soldierType : EnemyType? {
        didSet {
            soldierLabel.text = soldierType!.name
        }
    }
    @IBOutlet weak var soldierLabel: UILabel!
    @IBOutlet weak var stepper: GMStepper! {
        didSet {
            stepper.delegate = self
        }
    }
    var VC : TowerDefriendzViewController?
    let stepperValue = 0

    func valueIncreased() -> Bool {
        if (VC!.armyBudget - soldierType!.price) >= 0 {
            VC?.pendingMessage?.soldierArray.append(soldierType!.rawValue)
            VC?.armyBudget -= soldierType!.price
            stepper.maximumValue = floor(Double(VC!.armyBudget / soldierType!.price)) + stepper.value
        } else {
            return false
        }
        return true
    }

    func valueDecreased() -> Bool {
        if stepper.value != 0 && VC!.pendingMessage!.soldierArray.count > 1 {
            VC?.pendingMessage?.soldierArray.remove(at: VC!.pendingMessage!.soldierArray.index(of: soldierType!.rawValue)!)
            VC?.armyBudget += soldierType!.price
            stepper.maximumValue = floor(Double(VC!.armyBudget / soldierType!.price)) + stepper.value
        }
        return true
    }

    override func awakeFromNib() { }
}






