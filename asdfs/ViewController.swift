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

var enemyArray: [Enemy]? = [Enemy(posX: 4, posY: 0, type: "soldier"), Enemy(posX: 4, posY: 0, type: "bird")]
var towerArray: [Tower]? = [Tower]()
var bulletArray: [Bullet]? = [Bullet]()

class ViewController: UIViewController, TowerDelegate, UIGestureRecognizerDelegate {
	@IBOutlet weak var backgroundImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer()
		tap.delegate = self
		tap.addTarget(self, action: #selector(self.tapReceived(gestureRecognizer:)))
		view.addGestureRecognizer(tap)
        Constants.scale = Int(view.frame.width / CGFloat(10))
        
        for enemy in enemyArray! {
            view.addSubview(enemy)
        }
        for tower in towerArray! {
            tower.delegate = self
            view.addSubview(tower)
        }
        
    }
	
	func tapReceived(gestureRecognizer: UITapGestureRecognizer) {
		let point = gestureRecognizer.location(in: view)
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
			let tower = Tower(posX: posX, posY: posY)
			tower.delegate = self
			towerArray?.append(tower)
			view.addSubview(tower)
		}
	}
	
    func addedBullet(bullet: Bullet) {
        bulletArray?.append(bullet)
        view.addSubview(bullet)
    }
}

func contains(arr:[(Int, Int)], tuple:(Int,Int)) -> Bool {
	let (c1, c2) = tuple
	for (v1, v2) in arr { if v1 == c1 && v2 == c2 { return true } }
	return false
}
