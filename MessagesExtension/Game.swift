//
//  ViewController.swift
//  asdfs
//
//  Created by HsHack on 3/25/17.
//  Copyright © 2017 HsHack. All rights reserved.
//

import UIKit

struct Constants {
    static var scale = 30
}

protocol GameDelegate {
    
    func gameDidEnd(didWin: Bool)
    
}

var enemyArray = [Enemy]()
var towerArray: [Tower]? = [Tower(posX: 7, posY: 3), Tower(posX: 9, posY: 3)]
var bulletArray: [Bullet]? = [Bullet]()
let imageView = UIImageView(image: #imageLiteral(resourceName: "path"))

class Game: UIView, TowerDelegate {

    var delegate : GameDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = self.bounds
        self.addSubview(imageView)
        
        Constants.scale = Int(self.frame.width / CGFloat(10))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func start(enemyInts: [Int]) {
        for int in enemyInts {
            let enemy = Enemy(posX: 4, posY: 0, type: int == 1 ? "soldier" : "bird")
            self.addSubview(enemy)
            enemyArray.append(enemy)
        }
        for tower in towerArray! {
            tower.delegate = self
            self.addSubview(tower)
        }
    }
    
    func didEnd(didWin: Bool) {
        delegate?.gameDidEnd(didWin: didWin)
    }
    
    func addedBullet(bullet: Bullet) {
        bulletArray?.append(bullet)
        self.addSubview(bullet)
    }
}

