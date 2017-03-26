//
//  Enemy.swift
//  asdfs
//
//  Created by HsHack on 3/25/17.
//  Copyright © 2017 HsHack. All rights reserved.
//

import Foundation
import UIKit

class Enemy: UIView {
    
    var posX: Int
    var posY: Int
    
    enum Direction {
        case L
        case R
        case U
        case D
        
    }
    var path = [Direction]()
    var pIndex: Int
    
    var updateTimer : Timer = Timer()
    var health : Int = 99
    
    init(posX: Int, posY: Int, type : String) {
        
        self.posX = posX
        self.posY = posY
        
        self.pIndex = 0
        super.init(frame: CGRect(x: posX*Constants.scale, y: posY*Constants.scale, width: Constants.scale, height: Constants.scale))
        switch type {
        case "soldier":
            updateTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { (timer) in
                self.update()
            })
            self.path = [.D, .D, .D, .D, .D, .D, .R, .R, .D, .D, .D, .D, .D, .L, .L, .L, .L, .D, .D, .D, .D, .R, .R, .R, .D, .D]
            health = 50
            self.backgroundColor = UIColor.white
        case "bird":
            updateTimer = Timer.scheduledTimer(withTimeInterval: 0.30, repeats: true, block: { (timer) in
                self.update()
            })
            self.path = [.D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D]
            health = 20
            self.backgroundColor = UIColor.blue
        default:
            updateTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
                self.update()
            })
            health = 999
            self.backgroundColor = UIColor.red
        }
    }
    
    func die() {
        if let index = enemyArray?.index(of: self) {
            enemyArray?.remove(at: index)
        }
        updateTimer.invalidate()
        self.removeFromSuperview()
    }

    func hurt(damage: Int) {
        health -= damage
        if health <= 0{
            self.die()
        }
    }
    

    func update() {
        guard pIndex < path.count else {
            return
        }
        
        switch path[pIndex] {
        case Direction.R:
            self.posX += 1
        case Direction.L:
            self.posX -= 1
        case Direction.U:
            self.posY -= 1
        case Direction.D:
            self.posY += 1
        }
        
        animateSmoothly(duration: updateTimer.timeInterval) { 
            self.frame = CGRect(x: self.posX*Constants.scale, y: self.posY*Constants.scale, width: Constants.scale, height: Constants.scale)
        }
        pIndex += 1
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
