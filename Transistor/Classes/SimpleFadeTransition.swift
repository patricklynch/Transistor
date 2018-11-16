import UIKit

extension UIView {
    
    func snapShotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

public class SimpleFadeTransition: Transition {
    public let animationDuration: TimeInterval = 0.6
    
    public func performTransitionIn(_ model: TransitionModel, completion: @escaping (Bool)->()) {
        model.toViewController.view.alpha = 0.0
        model.fromViewController.view.alpha = 1.0
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.2,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                model.toViewController.view.alpha = 1.0
            },
            completion: { finished in
                completion(finished)
            }
        )
    }
    
    public func performTransitionOut(_ model: TransitionModel, completion: @escaping (Bool)->()) {
        model.toViewController.view.alpha = 1.0
        model.fromViewController.view.alpha = 1.0
        
        let delay = 0.2
        UIView.animate(
            withDuration: animationDuration - delay,
            delay: delay,
            options: [],
            animations: {
                model.fromViewController.view.alpha = 0.0
            },
            completion: { finished in
                completion(finished)
            }
        )
    }
}

