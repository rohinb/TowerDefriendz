import UIKit
import SpriteKit

struct Constants {
    static var scale = 30
}

protocol GameDelegate {

    func gameDidEnd(didWin: Bool, replay: [String: [String: String]])
}

var enemyArray = [Enemy]()
var towerArray: [Tower]? = [Tower]()
var bulletArray: [Bullet]? = [Bullet]()
let imageView = UIImageView(image: #imageLiteral(resourceName: "path"))

class GameView: UIView, TowerDelegate, UIGestureRecognizerDelegate, EnemyDelegate {

    var delegate : GameDelegate?
    var lives = 3
    var isRunning = true
    var defenderBudget = 0
    var hearts = [UIImageView]()
    let towerTypes = ["normal", "ranged", "deadly"]
    var selectedTowerType : TowerType?
    var currentConfirmPosition : (Int, Int)?
    var currentConfirmTower : Tower?
    var currentConfirmCircle : UIView?
    var budgetLabel : UILabel?

    var stage = GameStage.game {
        didSet {
            switch stage {
            case .game:
                self.animateAlpha(t: 0.3, a: 1)
                break

            default:
                self.removeFromSuperview()
                break
            }
        }
    }

    // TODO: pass these in n out of iMessage

    var isReplay = false
    var recordingTimer = Timer()
    var recordingTicks = 0
    var recordingPlacements = [String: [String: String]]()
    var replayTimer = Timer()
    var replayTicks = 0
    var replayPlacements : [String: [String: String]] = [   // ticks are in tenths of a second
        "34"  : ["name" : "normal" , "x" : "8", "y" : "7"],
        "24"  : ["name" : "ranged" , "x" : "7", "y" : "9"],
        "14"  : ["name" : "deadly" , "x" : "6", "y" : "10"],
        "54"  : ["name" : "ranged" , "x" : "5", "y" : "8"],
        "86"  : ["name" : "normal" , "x" : "4", "y" : "7"],
        "73"  : ["name" : "deadly" , "x" : "3", "y" : "6"],
        "1"   : ["name" : "normal" , "x" : "2", "y" : "5"],
        "104" : ["name" : "normal" , "x" : "1", "y" : "4"]]


    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.frame = self.bounds
        self.addSubview(imageView)

        let tap = UITapGestureRecognizer()
        tap.isEnabled = !isReplay
        tap.delegate = self
        tap.addTarget(self, action: #selector(self.tapReceived(gestureRecognizer:)))
        addGestureRecognizer(tap)

        Constants.scale = Int(self.frame.width / CGFloat(10))

        for (index, towerType) in towerTypes.enumerated() {
            let button = UIButton(frame: CGRect(x: 10, y: 200 + index * 50, width: Constants.scale * 375/255, height: Constants.scale))
            button.backgroundColor = UIColor.white
            button.setTitle("towerType", for: UIControlState())
            button.setImage(UIImage(named: towerType), for: UIControlState())
            button.tag = index
            button.addTarget(self, action: #selector(self.setSelectedTowerType(sender:)), for: .touchUpInside)
            self.insertSubview(button, aboveSubview: imageView)
        }

        for live in 0..<lives {
            let imageView = UIImageView(frame: CGRect(x: 10 + live * 25, y: 100, width: 20, height: 20))
            imageView.image = UIImage(named: "heart")
            imageView.contentMode = .scaleToFill
            hearts.insert(imageView, at: 0)
            self.insertSubview(imageView, aboveSubview: imageView)
        }

        budgetLabel = UILabel(frame: CGRect(x: self.frame.width - 50, y: 100, width: 50, height: 30))
        budgetLabel?.text = ""
        budgetLabel?.isHidden = isReplay
        budgetLabel?.textColor = UIColor.yellow
        self.addSubview(budgetLabel!)

        let coin = UIImageView(frame: CGRect(x: budgetLabel!.frame.origin.x - 20, y: budgetLabel!.frame.origin.y, width: 10, height: 10))
        coin.image = #imageLiteral(resourceName: "coin")
        coin.isHidden = isReplay
        coin.center.y = budgetLabel!.center.y
        self.addSubview(coin)

        if isReplay {
            replayTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                self.replayTicks += 1
                if let item = self.replayPlacements[self.replayTicks.description] {
                    let tower = Tower(posX: Int(item["x"]!)!, posY: Int(item["y"]!)!, type: TowerType(name: item["name"]!))
                    self.addSubview(tower)
                    tower.delegate = self
                    towerArray?.append(tower)
                    tower.startShooting()
                }
            })
        } else {
            recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                self.recordingTicks += 1 //these ticks will be used every time the user places a tower
            })
        }
    }

    @IBAction func setSelectedTowerType(sender: UIButton) {
        for view in sender.superview!.subviews {
            if let button = view as? UIButton {
                button.layer.borderWidth = 0.0
            }
        }
        selectedTowerType = TowerType.types[sender.tag]
        sender.layer.borderWidth = 2.0
        sender.layer.borderColor = UIColor.blue.cgColor

    }

    func tapReceived(gestureRecognizer: UITapGestureRecognizer) {
        guard selectedTowerType != nil else { return }

        let point = gestureRecognizer.location(in: self)
        let posX = Int(point.x) / Constants.scale
        let posY = Int(point.y) / Constants.scale

        var occupied = false
        for tower in towerArray! {
            if tower.posX == posX && tower.posY == posY {
                occupied = true
            }
        }

        if !contains(arr: pathPoints, tuple: (posX, posY)) && !occupied {
            currentConfirmCircle?.removeFromSuperview()
            currentConfirmCircle = nil
            if currentConfirmTower != nil && abs(currentConfirmPosition!.0) - posX < 2 && abs(currentConfirmPosition!.1 - posY) < 2  { //enlarge tap radius for the tower in question
                confirmTower(posX: posX, posY: posY, tower: currentConfirmTower!)
                return
            } else {
                currentConfirmPosition = nil
                currentConfirmTower?.removeFromSuperview()
                currentConfirmTower = nil
            }
            showTowerRadius(posX: posX, posY: posY)
        }
    }

    func showTowerRadius(posX: Int, posY : Int) {
        guard selectedTowerType != nil else { return }
        let tower = Tower(posX: posX, posY: posY, type: selectedTowerType!)
        addSubview(tower)
        tower.alpha = 0.3

        let circleView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: selectedTowerType!.radius, height: selectedTowerType!.radius))
        circleView.center = tower.center
        let color = defenderBudget - tower.type.price >= 0 ? UIColor(hex: 0x00A6ED): UIColor(hex: 0xF6511D)
        circleView.backgroundColor = color.withAlphaComponent(0.25)
        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.layer.borderColor = color.withAlphaComponent(0.75).cgColor
        circleView.layer.borderWidth = 2.0
        addSubview(circleView)

        currentConfirmCircle = circleView
        currentConfirmPosition = (posX, posY)
        currentConfirmTower = tower
    }

    func confirmTower(posX: Int, posY : Int, tower: Tower) { // TODO: Make clickable radius bigger
        if defenderBudget - tower.type.price >= 0 {
            recordingPlacements[recordingTicks.description] = ["name" : tower.type.name, "x" : posX.description, "y" : posY.description]

            tower.alpha = 1.0
            tower.delegate = self
            towerArray?.append(tower)
            tower.startShooting()
            currentConfirmTower = nil

            self.defenderBudget -= tower.type.price
            budgetLabel?.text = "\(defenderBudget)"
        } else {
            currentConfirmPosition = nil
            currentConfirmTower?.removeFromSuperview()
            currentConfirmTower = nil
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func start(enemyInts: [Int], turnNumber: Int, replay: [String: [String: Any]]?) {
        isReplay = replay != nil
        var count = 0
        defenderBudget = (turnNumber+1) * 1000
        budgetLabel?.text = "\(defenderBudget)"
        for (index, int) in enemyInts.enumerated() {
            Timer.scheduledTimer(withTimeInterval: ((index > enemyInts.count / 2 && turnNumber > 2) ? 0.25 : 0.5) * Double(count), repeats: false) {_ in
                let enemy = int == 1 ? Enemy(posX: 4, posY: 0, type: .soldier) : Enemy(posX: Int(arc4random_uniform(9))+1, posY: 0, type: .bird)
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
        if !isRunning { return }
        print("recording placements at end of game: ", recordingPlacements)
        
        //      ----------------------------- TO FIX ------------------
        delegate?.gameDidEnd(didWin: didWin, replay: recordingPlacements)
        isRunning = false
        
        //kill everything
        for bullet in bulletArray! {
            bullet.die()
        }
        
        for enemy in enemyArray {
            enemy.die()
        }
        
        for i in towerArray! {
            i.removeFromSuperview()
        }
        towerArray = [Tower]()
    }
    
    func addedBullet(bullet: Bullet) {
        bulletArray?.append(bullet)
        self.insertSubview(bullet, aboveSubview: imageView)
    }
    
    func enemyReachedEnd() {
        lives -= 1
        if let heart = hearts.first {
            heart.removeFromSuperview()
            hearts.remove(at:0)
        }
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
