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
    
    var velX: CGFloat
    var velY: CGFloat
    
    var updateTimer = Timer()
    
    init(locationX: Int, locationY: Int, vel: Double, direction: Double){
        self.velY = CGFloat(-vel*sin(direction)) // unit circle is y opposi
        self.velX = CGFloat(-vel*cos(direction))
        
        super.init(frame: CGRect(x: locationX*Constants.scale + Constants.scale / 2, y: locationY*Constants.scale + Constants.scale / 2, width: 4, height: 4))
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { (Timer) in
            self.update()
        })
        self.backgroundColor = UIColor.black
    }
    
    func update() {
        animateSmoothly(duration: updateTimer.timeInterval) { 
            self.frame = CGRect(x: self.frame.origin.x + self.velX, y: self.frame.origin.y + self.velY, width: 4, height: 4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

func animateSmoothly(duration: TimeInterval, animations: @escaping () -> Void) {
    UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: animations, completion: nil)
}
