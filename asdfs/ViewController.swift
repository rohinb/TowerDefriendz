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

var enemyArray: [Enemy]? = [Enemy(posX: 1, posY: 1, type: "soldier"), Enemy(posX: 2, posY: 3, type: "bird")]
var towerArray: [Tower]? = [Tower(posX: 7, posY: 3), Tower(posX: 9, posY: 3)]
var bulletArray: [Bullet]? = [Bullet]()

class ViewController: UIViewController, TowerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Constants.scale = Int(view.frame.width / CGFloat(10))
        
        for enemy in enemyArray! {
            view.addSubview(enemy)
        }
        for tower in towerArray! {
            tower.delegate = self
            view.addSubview(tower)
        }
        
    }
    
    func addedBullet(bullet: Bullet) {
        bulletArray?.append(bullet)
        view.addSubview(bullet)
    }
}

