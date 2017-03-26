//
//  Tower.swift
//  asdfs
//
//  Created by HsHack on 3/25/17.
//  Copyright © 2017 HsHack. All rights reserved.
//

import Foundation
import UIKit

class Tower:UIView {
    
    var radius : CGFloat = 10000
    
    var posX: Int
    var posY: Int
    
    
    var delegate : TowerDelegate?
    
    var shootTimer = Timer()
    
    init(posX: Int, posY: Int) {
        self.posX = posX
        self.posY = posY
        
        super.init(frame: CGRect(x: posX*Constants.scale, y: posY*Constants.scale, width: Constants.scale, height: Constants.scale))
        self.backgroundColor = UIColor.brown
        // not true rate of fire because has to find enemy in order to shoot
        shootTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (_) in
            self.shoot()
        })
    }
    
    deinit {
        shootTimer.invalidate()
    }
    
    func shoot() {
        // we want to traverse (for loop) array of enemies and find first one that is within radius
        // then transform/rotate to face it and instantly shoot (with that direction's vel)
        for enemy in enemyArray! {
            let dx = enemy.center.x - self.center.x
            let dy = enemy.center.y - self.center.y
            if pow(dx,2) + pow(dy,2) < pow(radius,2) {
                let direction = dx < 0 ? atan(dy/dx) + 3.14 : atan(dy/dx)
                UIView.animate(withDuration: shootTimer.timeInterval, delay: 0.0, options: .curveLinear, animations: {
                    self.transform = CGAffineTransform(rotationAngle: direction)
                }, completion: { (success) in
                    if success {
                        let bullet = Bullet(locationX: self.posX, locationY: self.posY, vel: 8, direction: Double(direction))
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
