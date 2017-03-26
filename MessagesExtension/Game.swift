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
var towerArray: [Tower]? = [Tower]()
var bulletArray: [Bullet]? = [Bullet]()
let imageView = UIImageView(image: #imageLiteral(resourceName: "path"))

class Game: UIView, TowerDelegate, UIGestureRecognizerDelegate, EnemyDelegate {

    var delegate : GameDelegate?
	var lives = 3
	var isRunning = true
    var defenderBudget = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = self.bounds
        self.addSubview(imageView)
		
		let tap = UITapGestureRecognizer()
		tap.delegate = self
		tap.addTarget(self, action: #selector(self.tapReceived(gestureRecognizer:)))
		addGestureRecognizer(tap)
        
        Constants.scale = Int(self.frame.width / CGFloat(10))
        
    }
	
	func tapReceived(gestureRecognizer: UITapGestureRecognizer) {
		let point = gestureRecognizer.location(in: self)
		let posX = Int(point.x) / Constants.scale
		let posY = Int(point.y) / Constants.scale
		print("(\(posX), \(posY)), ")
		let tuple = (posX, posY)
		var occupied = false
		for tower in towerArray! {
			if tower.posX == posX && tower.posY == posY {
				occupied = true
			}
		}
		if !contains(arr: pathPoints, tuple: tuple) && !occupied {
			//add tower there
            let tower = Tower(posX: posX, posY: posY, type: "ranged")
			tower.delegate = self
			towerArray?.append(tower)
			addSubview(tower)
            
            //lower budget (different price depending on what tower type
            self.defenderBudget -= 1000
		}
	}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func start(enemyInts: [Int], turnNumber: Int) {
		var count = 0
        defenderBudget = turnNumber * 1000
        for int in enemyInts {
			Timer.scheduledTimer(withTimeInterval: 1.5 * Double(count), repeats: false) {_ in
                let enemy = int == 1 ? Enemy(posX: 4, posY: 0, type: "soldier") : Enemy(posX: Int(arc4random_uniform(11)), posY: 0, type: "bird")
				enemy.delegate = self
				self.addSubview(enemy)
				enemyArray.append(enemy)
			}
			count += 1
        }
        for tower in towerArray! {
            tower.delegate = self
            self.addSubview(tower)
        }
    }
    
    func didEnd(didWin: Bool) {
		isRunning = false
        delegate?.gameDidEnd(didWin: didWin)
    }
    
    func addedBullet(bullet: Bullet) {
        bulletArray?.append(bullet)
        self.insertSubview(bullet, aboveSubview: imageView)
    }
	
	func enemyReachedEnd() {
		lives -= 1
		if lives <= 0 {
			didEnd(didWin: false)
		}
	}
	
	func allEnemiesDead() {
		didEnd(didWin: true)
	}
}


func contains(arr:[(Int, Int)], tuple:(Int,Int)) -> Bool {
	let (c1, c2) = tuple
	for (v1, v2) in arr { if v1 == c1 && v2 == c2 { return true } }
	return false
}

