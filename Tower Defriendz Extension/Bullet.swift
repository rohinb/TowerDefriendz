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
        
        let posX = Int(self.center.x/CGFloat(Constants.scale))
        let posY = Int(self.center.y/CGFloat(Constants.scale))

		for enemy in enemyArray where isPiercing ? !hitEnemies.contains(enemy) : true {
            if enemy.posX == posX && enemy.posY == posY {
                enemy.hurt(damage: self.damage)
				hitEnemies.append(enemy)
				if !self.isPiercing {
					self.die()
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

func animateSmoothly(duration: TimeInterval, animations: @escaping () -> Void) {
    UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: animations, completion: nil)
}
