import UIKit

extension UIView {

    func animateAlpha(t: Double, a: Double) {
        UIView.animate(withDuration: t) {
            self.alpha = CGFloat(a)
        }
    }

    func animateView(direction: UIViewAnimationDirection, t: Double, pixels: Double) {
        UIView.animate(withDuration: t) {
            switch direction {
            case .up:
                self.frame.origin.y -= CGFloat(pixels)
            case .down:
                self.frame.origin.y += CGFloat(pixels)
            case .right:
                self.frame.origin.x += CGFloat(pixels)
            case .left:
                self.frame.origin.x -= CGFloat(pixels)
            }
        }
    }

    enum UIViewAnimationDirection {
        case up
        case down
        case left
        case right
    }

}
