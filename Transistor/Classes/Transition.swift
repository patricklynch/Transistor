import UIKit

/// Defines an object that performs a transition animation between two view controllers
/// using configuration values provided in model`.
public protocol Transition {
    var animationDuration: TimeInterval { get }
    func performTransitionIn(_ model: TransitionModel, completion: @escaping (Bool)->())
    func performTransitionOut(_ model: TransitionModel, completion: @escaping (Bool)->())
}

/// Encapsulates configuration values and references to view controllers involved in the
/// tranisition.  Intended for use by conformers to `Transition` in order to perform
/// the transition animation.
public struct TransitionModel {
    let context: UIViewControllerContextTransitioning
    let transition: Transition
    let fromViewController: UIViewController
    let toViewController:UIViewController
    let presenting: Bool
    
    init(context: UIViewControllerContextTransitioning, transition: Transition) {
        self.context = context
        self.transition = transition
        guard let toViewController = context.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = context.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                abort()
        }
        
        self.toViewController = toViewController
        self.fromViewController = fromViewController
        
        let modal = toViewController.presentedViewController != nil || fromViewController.presentedViewController != nil
        if let fromNav = fromViewController.navigationController , !modal {
            presenting = fromNav.viewControllers.contains(fromViewController)
        } else {
            presenting = toViewController.presentedViewController != fromViewController
        }
    }
}
