//
//  GameStages.swift
//  Tower Defriendz
//
//  Created by Sahand Edrisian on 4/10/17.
//  Copyright © 2017 tutsplus. All rights reserved.
//

import UIKit

var screenCenter = CGPoint(x: UIScreen.main.bounds.width/2, y:UIScreen.main.bounds.height/2)

class MainButton : UIButton {

    var title = "" {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }

    var visible = false {
        didSet {
            self.isEnabled = visible
            self.animateAlpha(t: 0.3, a: visible ? 1 : 0)
        }
    }

    var location = CGPoint() {
        didSet {
            UIView.animate(withDuration: 0.3) { 
                self.center = self.location
            }
        }
    }

    var stage = GameStage.initial {
        didSet {

            switch stage {
            case .initial:
                title = ""
                location = screenCenter
                visible = false

            case .initialSoldierSelection:
                title = "ATTACK!"
                location = screenCenter
                visible = true
                break

            case .initialAttack:
                title = ""
                location = screenCenter
                visible = false
                break

            case .defend:
                title = "DEFEND!"
                location = screenCenter
                visible = true
                break

            case .game:
                title = ""
                location = screenCenter
                visible = false
                break

            case .soldierSelection:
                title = "ATTACK!"
                location = screenCenter
                visible = true
                break

            case .attack:
                title = ""
                location = screenCenter
                visible = false
                break

            case .waitingForOpponent:
                title = ""
                location = screenCenter
                visible = false
                break

            case .cannotGetAttack:
                title = ""
                location = screenCenter
                visible = false
                break

            }
        }
    }
}


