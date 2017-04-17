//
//  Bullet.swift
//  asdfs
//
//  Created by HsHack on 3/25/17.
//  Copyright © 2017 HsHack. All rights reserved.
//

import Foundation
import UIKit

class Bullet: UIImageView {
    
    var damage : Int
    
    var velX: CGFloat
    var velY: CGFloat
	var hitEnemies = [Enemy]()
    
    var updateTimer = Timer()
	var isPiercing = false
	var splashRadius = 0.0
    
    init(locationX: Int, locationY: Int, vel: Double, direction: Double, damage: Int, color: UIColor){
        self.velY = CGFloat(vel*sin(direction)) // unit circle is y opposite
        self.velX = CGFloat(vel*cos(direction))
        
        self.damage = damage
        
        super.init(frame: CGRect(x: locationX*Constants.scale + Constants.scale / 2 - 3, y: locationY*Constants.scale + Constants.scale / 2 - 3, width: 7, height: 7))
        self.layer.cornerRadius = 3.5
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (Timer) in
            self.update()
        })
        self.backgroundColor = color
    }
    
    func update() {
        animateSmoothly(duration: updateTimer.timeInterval) {
            self.frame = CGRect(x: self.frame.origin.x + self.velX, y: self.frame.origin.y + self.velY, width: 7, height: 7)
        }
        // kill bullet if it is off the screen!
		if superview == nil {
			self.die()
			return
		}
        if self.center.x > self.superview!.frame.width || self.center.x < 0
            || self.center.y > self.superview!.frame.height || self.center.y < 0 {
            self.die()
        }
		
		// FIXME: right now bullets are hitting enemies if they are in the same grid.
			//    They should be hitting when they actually make contact with the frame
        let posX = Int(self.center.x/CGFloat(Constants.scale))
        let posY = Int(self.center.y/CGFloat(Constants.scale))

		for enemy in enemyArray where isPiercing ? !hitEnemies.contains(enemy) : true {
            if enemy.posX == posX && enemy.posY == posY {
                enemy.hurt(damage: self.damage)
				hitEnemies.append(enemy)
				if !self.isPiercing {
					self.die()
					break
				}
            }
        }
    }
    
    func die() {
        self.removeFromSuperview()
        updateTimer.invalidate()
        if let index = bulletArray?.index(of: self) {
            bulletArray?.remove(at: index)
        }
		
		if splashRadius > 0.0 {
			for enemy in enemyArray {
				let dx = enemy.center.x - self.center.x
				let dy = enemy.center.y - self.center.y
				if pow(dx,2) + pow(dy,2) < CGFloat(pow(self.splashRadius,2)) {
					enemy.hurt(damage: self.damage / 2)
				}
			}
		}
    }
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

func animateSmoothly(duration: TimeInterval, animations: @escaping () -> Void) {
    UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: animations, completion: nil)
}
