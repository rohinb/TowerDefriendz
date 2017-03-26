//
//  Enemy.swift
//  asdfs
//
//  Created by HsHack on 3/25/17.
//  Copyright © 2017 HsHack. All rights reserved.
//

import Foundation
import UIKit

let startPathPoint = (4, 0)
let pathPoints =	[startPathPoint,
                	 (4, 1),
                	 (4, 2),
                	 (4, 3),
                	 (4, 4),
                	 (4, 5),
                	 (4, 6),
                	 (4, 7),
                	 (5, 7),
                	 (5, 6),
                	 (6, 6),
                	 (6, 7),
                	 (6, 8),
                	  (6, 9),
                	  (6, 10),
                	  (6, 11),
                	  (5, 11),
                	  (4, 11),
                	  (3, 11),
                	  (2, 11),
                	  (2, 12),
                	  (2, 13),
                	  (2, 14),
                	  (2, 15),
                	  (3, 15),
                	  (4, 15),
                	  (5, 15),
                	  (5, 16),
                	  (5, 17),
                	  (3, 14),
                	  (4, 14),
                	  (5, 14)]
class Enemy: UIImageView {
	
	var posX: Int
	var posY: Int
	var delegate : EnemyDelegate?
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
	var type = ""
	var initialHealth = 10
	
	init(posX: Int, posY: Int, type : String) {
		
		self.posX = posX
		self.posY = posY
		self.type = type
		self.pIndex = 0
		super.init(frame: CGRect(x: posX*Constants.scale, y: posY*Constants.scale, width: Constants.scale, height: Constants.scale))
		switch type {
		case "soldier":
			updateTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true, block: { (timer) in
				self.update()
			})
			self.path = [.D, .D, .D, .D, .D, .D, .R, .R, .D, .D, .D, .D, .D, .L, .L, .L, .L, .D, .D, .D, .D, .R, .R, .R, .D, .D]
			health = 1800
            self.image = UIImage(named: "Soldier")!.withRenderingMode(.alwaysOriginal)
		case "bird":
			updateTimer = Timer.scheduledTimer(withTimeInterval: 0.50, repeats: true, block: { (timer) in
				self.update()
			})
			self.path = [.D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D, .D]
			health = 300
            self.image = UIImage(named: "Bird")!.withRenderingMode(.alwaysOriginal)
		default:
			updateTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
				self.update()
			})
			health = 999
            self.image = UIImage(named: "Soldier")!.withRenderingMode(.alwaysOriginal)
		}
		initialHealth = health
	}
	
	func die() {
		if let index = enemyArray.index(of: self) {
			enemyArray.remove(at: index)
		}
		updateTimer.invalidate()
		UIView.animate(withDuration: 0.3, animations: {
			self.alpha = 0.0
		}) { (success) in
			self.removeFromSuperview()
		}
		if enemyArray.count <= 0 {
			self.delegate?.allEnemiesDead()
		}
	}
	
	func hurt(damage: Int) {
		health -= damage
		self.image = UIImage(named: type == "soldier" ? "Soldier" : "Bird")!.withRenderingMode(.alwaysTemplate)
		UIView.animate(withDuration: 0.13, animations: {
			self.tintColor = UIColor.red
		}, completion: { (success) in
			self.tintColor = UIColor.clear
			self.image = UIImage(named: self.type == "soldier" ? "Soldier" : "Bird")!.withRenderingMode(.alwaysOriginal)
		})
		
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
		
		if self.center.y >= self.superview!.frame.height {
			self.delegate?.enemyReachedEnd()
			self.die()
		}
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

protocol EnemyDelegate {
	func enemyReachedEnd()
	func allEnemiesDead()
}
