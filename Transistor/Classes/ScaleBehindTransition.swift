import UIKit

public class ScaleBehindTransition: Transition {
    
    enum Direction {
        case top, right, bottom, left
    }
    
    let direction: Direction
    public let animationDuration: TimeInterval = 0.75
    let scale: CGFloat = 1.2
    let fromAlpha: CGFloat = 0.4
    
    init(direction: Direction) {
        self.direction = direction
    }
    
    func createScreen(frame: CGRect) -> UIView {
        let screen = UIView(frame: frame)
        screen.backgroundColor = UIColor.lightGray
        return screen
    }
    
    private var inverstionScale: CGFloat {
        return 1.0 / scale
    }
    
    private func destinationTransform(with viewController: UIViewController) -> CGAffineTransform {
        let translationX: CGFloat
        let translationY: CGFloat
        switch direction {
        case .bottom:
            translationX = 0.0
            translationY = viewController.view.bounds.height
        case .right:
            translationX = viewController.view.bounds.width
            translationY = 0.0
        case .top:
            translationX = 0.0
            translationY = -viewController.view.bounds.height
        case .left:
            translationX = -viewController.view.bounds.width
            translationY = 0.0
        }
        return CGAffineTransform(translationX: translationX, y: translationY)
    }
    
    public func performTransitionIn(_ model: TransitionModel, completion: @escaping (Bool)->()) {
        
        let screen = createScreen(frame: model.fromViewController.view.frame)
        model.context.containerView.addSubview(screen)
        model.context.containerView.sendSubview(toBack: screen)
        
        model.toViewController.view.transform = destinationTransform(with: model.toViewController)
        
        model.fromViewController.view.layer.shadowColor = UIColor.black.cgColor
        model.fromViewController.view.layer.shadowOpacity = 0.3
        model.fromViewController.view.layer.shadowRadius = 12.0
        model.fromViewController.view.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.1,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.9,
            options: [],
            animations: {
                model.toViewController.view.transform = CGAffineTransform.identity
            },
            completion: { finished in
                model.fromViewController.view.transform = CGAffineTransform.identity
                screen.removeFromSuperview()
                completion(finished)
            }
        )
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.9,
            options: [],
            animations: {
                model.fromViewController.view.alpha = self.fromAlpha
                model.fromViewController.view.transform = CGAffineTransform.identity
                    .scaledBy(x: self.inverstionScale, y: self.inverstionScale)
            },
            completion: nil
        )
    }
    
    public func performTransitionOut(_ model: TransitionModel, completion: @escaping (Bool)->()) {
        
        let screen = createScreen(frame: model.toViewController.view.frame)
        model.context.containerView.addSubview(screen)
        model.context.containerView.sendSubview(toBack: screen)
        
        model.toViewController.view.alpha = fromAlpha
        model.toViewController.view.transform = CGAffineTransform.identity
            .scaledBy(x: self.inverstionScale, y: self.inverstionScale)
        
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.9,
            options: [],
            animations: {
                model.fromViewController.view.transform = self.destinationTransform(with: model.fromViewController)
            },
            completion: { finished in
                model.fromViewController.view.transform = CGAffineTransform.identity
                screen.removeFromSuperview()
                completion(finished)
            }
        )
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.2,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.9,
            options: [],
            animations: {
                model.toViewController.view.alpha = 1.0
                model.toViewController.view.transform = CGAffineTransform.identity
            },
            completion: nil
        )
    }
}
