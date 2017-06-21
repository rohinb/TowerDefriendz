//
//  Bullet.swift
//  asdfs
//
//  Created by HsHack on 3/25/17.
//  Copyright © 2017 HsHack. All rights reserved.
//

import Foundation
//import UIKit
import SpriteKit

class Bullet: SKSpriteNode {
    
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
        
        super.init(texture: SKTexture(image: #imageLiteral(resourceName: "bullet")), color: UIColor.clear, size: CGSize(width: 7, height: 7))
        //x: original x + 0.5width; y: screen height - original y - 0.5height
        let halfConstantsScale = Constants.scale / 2
        let positionXBullet = CGFloat(locationX*Constants.scale + halfConstantsScale) + 0.5
        let positionYBullet = (self.parent?.frame.height)! - CGFloat(locationY*Constants.scale + halfConstantsScale) - 7.5
        super.position = CGPoint(x: positionXBullet, y: positionYBullet)
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (Timer) in
            self.update()
        })
    }
    
    func update() {
        animateSmoothly(duration: updateTimer.timeInterval) {
            self.size = CGSize(width: 7, height: 7)
            self.position = CGPoint(x: self.frame.origin.x + self.velX + 3.5, y: (self.parent?.frame.height)! - self.frame.origin.y - self.velY - 3.5)
            
        }
        // kill bullet if it is off the screen!
		if self.parent == nil {
			self.die()
			return
		}
        if self.position.x > self.parent!.frame.width || self.position.x < 0
            || self.position.y > self.parent!.frame.height || self.position.y < 0 {
            self.die()
        }
		
		// FIXME: right now bullets are hitting enemies if they are in the same grid.
			//    They should be hitting when they actually make contact with the frame
        let posX = Int(self.position.x/CGFloat(Constants.scale))
        let posY = Int(self.position.y/CGFloat(Constants.scale))

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
        self.removeFromParent()
        updateTimer.invalidate()
        if let index = bulletArray?.index(of: self) {
            bulletArray?.remove(at: index)
        }
		
		if splashRadius > 0.0 {
			for enemy in enemyArray {
				let dx = enemy.position.x - self.position.x
				let dy = enemy.position.y - self.position.y
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
