import UIKit

/// Implementaiton of `UIViewControllerAnimatedTransitioning` designed as a reusable template
/// for many types of custom transitions that conform to `Transition`.
class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let transition: Transition
    
    init(transition: Transition) {
        self.transition = transition
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transition.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let model = TransitionModel(
            context: transitionContext,
            transition: transition
        )
        
        if model.presenting {
            model.toViewController.view.frame = model.fromViewController.view.frame
            
            transitionContext.containerView.addSubview(model.fromViewController.view)
            transitionContext.containerView.addSubview(model.toViewController.view)
            
            transition.performTransitionIn(model) { completed in
                transitionContext.completeTransition( !transitionContext.transitionWasCancelled )
            }
            
        } else {
            model.fromViewController.view.frame = model.toViewController.view.frame
            
            transitionContext.containerView.addSubview(model.toViewController.view)
            transitionContext.containerView.addSubview(model.fromViewController.view)
            
            transition.performTransitionOut(model) { completed in
                transitionContext.completeTransition( !transitionContext.transitionWasCancelled )
                
                // HACK: But fixes the issue... (http://stackoverflow.com/questions/24338700/from-view-controller-disappears-using-uiviewcontrollercontexttransitioning)
                UIApplication.shared.keyWindow!.addSubview(model.toViewController.view)
            }
        }
    }
}

/// Implemention of `UIViewControllerTransitioningDelegate` using a provided `Transition` required
/// to perform a custom transition between two view controllers.  Conformanced to
/// `UINavigationControllerDelegate` is also included to support custom transitions for both
/// present and push transition styles.
class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    let animator: TransitionAnimator
    
    init(transition: Transition) {
        self.animator = TransitionAnimator(transition: transition)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}
