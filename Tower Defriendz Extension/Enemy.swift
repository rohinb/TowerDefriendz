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

fileprivate enum Direction {
	case L
	case R
	case U
	case D
	
}

// TODO: Balance with towers and price
enum EnemyType {
	case soldier
	case bird
	// if you add an enemy, you must add a case to ALL
	// the following switch statements and this array:

	static let type = [soldier, bird]
	init(name: String) {
		switch name.lowercased() {
		case "soldier" : self = .soldier
		case "bird" : self = .bird
		default:		self = .bird // don't let this happen
		}
	}
	
	var name : String {
		switch self {
		case .bird: return "Eagle"
		case .soldier: return "Soldier"
		}
	}
	
	var image : UIImage {
		switch self {
		case .bird: return #imageLiteral(resourceName: "Bird")
		case .soldier: return #imageLiteral(resourceName: "Soldier")
		}
	}
	
	var price : Int {
		switch self {
		case .bird: return 75
		case .soldier: return 50
		}
	}
	
	var initialHealth : Int {
		switch self {
		case .bird: return 300
		case .soldier: return 1800
		}
	}
	
	var moveInterval : Double {
		switch self {
		case .bird: return 0.5
		case .soldier: return 0.8
		}
	}
	
	fileprivate var path : [Direction] {
		switch self {
		case .soldier: return [.D, .D, .D, .D, .D, .D, .R, .R, .D, .D, .D, .D, .D, .L,
		                       .L, .L, .L, .D, .D, .D, .D, .R, .R, .R, .D, .D]
		case .bird: return [.D, .D, .D, .D, .D, .D, .D, .D, .D, .D,
		                    .D, .D, .D, .D, .D, .D, .D, .D, .D]
		}
	}
}

class Enemy: UIImageView {
	
	var posX: Int
	var posY: Int
	var delegate : EnemyDelegate?
	
	var pIndex: Int
	
	var updateTimer : Timer = Timer()
	var health : Int = 99
	var type : EnemyType
	
	init(posX: Int, posY: Int, type : EnemyType) {
		
		self.posX = posX
		self.posY = posY
		self.type = type
		self.pIndex = 0
		super.init(frame: CGRect(x: posX*Constants.scale, y: posY*Constants.scale, width: Constants.scale, height: Constants.scale))
		updateTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true, block: { (timer) in
			self.update()
		})
		health = type.initialHealth
		self.image = type.image.withRenderingMode(.alwaysOriginal)
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
		self.image = type.image.withRenderingMode(.alwaysTemplate)
		
		self.flashRed()
		if health <= 0{
			self.die()
		}
	}
	
	//TODO: Test when Sahand fixes imessage flow
	fileprivate func flashRed() {
		self.tintColor = UIColor.red
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
			self.tintColor = UIColor.clear
			self.image = self.type.image.withRenderingMode(.alwaysOriginal)
		})
	}
	
	
	fileprivate func update() {
		guard pIndex < type.path.count else {
			return
		}
		
		switch type.path[pIndex] {
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
