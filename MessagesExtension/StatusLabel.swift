//
//  StatusLabel.swift
//  Tower Defriendz
//
//  Created by Sahand Edrisian on 4/10/17.
//  Copyright © 2017 tutsplus. All rights reserved.
//

import UIKit

class StatusLabel: UILabel {

    var title = "" {
        didSet {
            self.text = title
        }
    }

    var fontSize = StatusLabelFont.small {
        didSet {
            switch fontSize {
            case .small:
                font = font.withSize(19)
                break
            case .large:
                font = font.withSize(21)
                break
            }
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

            var labelCenter = screenCenter
            labelCenter.y -= 230

            switch stage {

            case .initial:
                title = "Expand app to attack!"
                location = labelCenter
                visible = true
                fontSize = .small
                break

            case .initialSoldierSelection:
                title = "Choose your army!"
                location = labelCenter
                visible = true
                fontSize = .large
                break

            case .initialAttack:
                title = "Send your attack!"
                location = labelCenter
                visible = true
                fontSize = .large
                break

            case .openingDefend:
                title = "Expand to defend your base"
                location = labelCenter
                visible = true
                fontSize = .small
                break

            case .defend:
                title = "They have attacked our base!"
                location = labelCenter
                visible = true
                fontSize = .large
                break

            case .game:
                title = ""
                location = labelCenter
                visible = false
                fontSize = .large
                break

            case .soldierSelection:
                title = "Choose your army!"
                location = labelCenter
                visible = true
                fontSize = .large
                break

            case .attack:
                title = "Attack sent!"
                location = labelCenter
                visible = true
                fontSize = .small
                break

            case .waitingForOpponent:
                title = "Waiting for oponent..."
                location = labelCenter
                visible = true
                fontSize = .small
                break

            case .cannotGetAttack:
                title = "Oops! There was a problem."
                location = labelCenter
                visible = true
                fontSize = .small
                break
                
            }
        }
    }


}


enum StatusLabelFont {
    case small
    case large
}
