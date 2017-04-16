//
//  Tower.swift
//  asdfs
//
//  Created by HsHack on 3/25/17.
//  Copyright © 2017 HsHack. All rights reserved.
//

import Foundation
import UIKit


// TODO: Balance towers for price; right now .normal is overpowered
enum TowerType {
	case normal
	case ranged
	case deadly
	// if you add a tower, you must add a case to ALL
	// the following switch statements
	static let types = [normal, ranged, deadly]
	
	init(name: String) {
		switch name.lowercased() {
		case "normal" : self = .normal
		case "deadly" : self = .deadly
		case "ranged" : self = .ranged
		default:		self = .normal // don't let this happen
		}
	}
	
	var name : String {
		switch self {
		case .normal: return "Normal"
		case .ranged: return "Ranged"
		case .deadly: return "Deadly"
		}
	}
	
	var image : UIImage {
		switch self {
		case .normal: return #imageLiteral(resourceName: "normal")
		case .ranged: return #imageLiteral(resourceName: "ranged")
		case .deadly: return #imageLiteral(resourceName: "deadly")
		}
	}
	
	var price : Int {
		switch self {
		case .normal: return 100
		case .ranged: return 200
		case .deadly: return 300
		}
	}
	
	var damage : Int {
		switch self {
		case .normal: return 20
		case .ranged: return 50
		case .deadly: return 100
		}
	}
	
	var radius : CGFloat {
		switch self {
		case .normal: return CGFloat(4 * Constants.scale)
		case .ranged: return CGFloat(10 * Constants.scale)
		case .deadly: return CGFloat(3 * Constants.scale)
		}
	}
	
	var bulletSpeed : Double {
		switch self {
		case .normal: return 13.0
		case .ranged: return 9.0
		case .deadly: return 6.0
		}
	}
	
	var firingInterval : Double {
		switch self {
		case .normal: return 0.3
		case .ranged: return 0.5
		case .deadly: return 0.8
		}
	}
}

class Tower:UIImageView {
	
	var type : TowerType
    var posX: Int
    var posY: Int
    var delegate : TowerDelegate?
    var shootTimer = Timer()
	let TOWER_ROTATION_INTERVAL = 0.3 // keeping this constant for all towers
    
    init(posX: Int, posY: Int, type: TowerType) {
        self.posX = posX
        self.posY = posY
        self.type = type
		
        super.init(frame: CGRect(x: posX * Constants.scale,
                                 y: posY * Constants.scale,
                                 width: Constants.scale * 375 / 255, //FIXME: Get rid of these magic numbers
                                 height: Constants.scale))
		
		self.shootTimer = Timer.scheduledTimer(withTimeInterval: self.type.firingInterval, repeats: true, block: { (_) in
			self.shoot(speed: self.type.bulletSpeed, color: UIColor.blue)
		})
		self.image = type.image
	}
    
    
    deinit {
        shootTimer.invalidate()
    }
    
    func shoot(speed: Double , color: UIColor) {
        // we want to traverse (for loop) array of enemies and find first one that is within radius
        // then transform/rotate to face it and instantly shoot (with that direction's vel)
        for enemy in enemyArray {
            let dx = enemy.center.x - self.center.x
            let dy = enemy.center.y - self.center.y
            if pow(dx,2) + pow(dy,2) < pow(type.radius,2) {
                let direction = dx < 0 ? atan(dy/dx) + 3.14159265535 : atan(dy/dx)
                UIView.animate(withDuration: self.TOWER_ROTATION_INTERVAL, delay: 0.0, options: .curveLinear, animations: {
                    self.transform = CGAffineTransform(rotationAngle: direction)
                }, completion: { (success) in
                    if success {
                        let bullet = Bullet(locationX: self.posX, locationY: self.posY, vel: speed, direction: Double(direction), damage : self.type.damage, color : color)
                        self.delegate?.addedBullet(bullet: bullet)
                    }
                })
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol TowerDelegate {
    func addedBullet(bullet: Bullet)
}
