//
//  Bullet.swift
//  asdfs
//
//  Created by HsHack on 3/25/17.
//  Copyright © 2017 HsHack. All rights reserved.
//

import Foundation
import UIKit

class Bullet: UIView {
    
    var damage : Int
    
    var velX: CGFloat
    var velY: CGFloat
    
    var updateTimer = Timer()
    
    init(locationX: Int, locationY: Int, vel: Double, direction: Double, damage: Int){
        self.velY = CGFloat(vel*sin(direction)) // unit circle is y opposite
        self.velX = CGFloat(vel*cos(direction))
        
        self.damage = damage
        
        super.init(frame: CGRect(x: locationX*Constants.scale + Constants.scale / 2, y: locationY*Constants.scale + Constants.scale / 2, width: 7, height: 7))
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (Timer) in
            self.update()
        })
        self.backgroundColor = UIColor.black
    }
    
    func update() {
        animateSmoothly(duration: updateTimer.timeInterval) {
            self.frame = CGRect(x: self.frame.origin.x + self.velX, y: self.frame.origin.y + self.velY, width: 7, height: 7)
        }
        // kill bullet if it is off the screen!
        if self.center.x > self.superview!.frame.width || self.center.x < 0
            || self.center.y > self.superview!.frame.height || self.center.y < 0 {
            self.die()
        }
        
        let posX = Int(self.center.x/CGFloat(Constants.scale))
        let posY = Int(self.center.y/CGFloat(Constants.scale))

        for enemy in enemyArray {

            if enemy.posX == posX && enemy.posY == posY {
                enemy.hurt(damage: self.damage)
                self.die() // if not piercing
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
