import UIKit

public typealias AuxAnimation = (closure: () -> Void, relativeDelay: Double)

public protocol NavigationTransitionAnimationConfig {
    var duration: TimeInterval { get }
    var auxAnimations: (Bool) -> [AuxAnimation] { get }
    
    func layout(presenting: Bool, fromView: UIView, toView: UIView, in container: UIView)
    func animations(presenting: Bool, fromView: UIView, toView: UIView, in container: UIView)
}

final class NavigationTransitionAnimator: NSObject {
    
    private let config: NavigationTransitionAnimationConfig
    
    public init(config: NavigationTransitionAnimationConfig) {
        self.config = config
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension NavigationTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        config.duration
    }
    
    public func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        let fromView = fromViewController.view!
        let toView = toViewController.view!

        var isPush = false
        if let toIndex = toViewController.navigationController?.viewControllers.firstIndex(of: toViewController),
            let fromIndex = fromViewController.navigationController?.viewControllers.firstIndex(of: fromViewController) {
            isPush = toIndex > fromIndex
        }
        
        let fromFrame = transitionContext.initialFrame(for: fromViewController)
        let toFrame = transitionContext.finalFrame(for: toViewController)
        
        fromView.frame = fromFrame
        toView.frame = toFrame
        
        config.layout(presenting: isPush, fromView: fromView,
                                  toView: toView, in: containerView)
        
        let duration = transitionDuration(using: transitionContext)
        let auxAnimations = config.auxAnimations(isPush)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.config.animations(presenting: isPush,fromView: fromView,
                                                   toView: toView, in: containerView)
            })
            
            for animation in auxAnimations {
                let relativeDuration = duration - animation.relativeDelay * duration
                UIView.addKeyframe(withRelativeStartTime: animation.relativeDelay,
                                   relativeDuration: relativeDuration,
                                   animations: animation.closure)
            }
        }) { finished in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
    
//    public func interruptibleAnimator(using transitionContext: any UIViewControllerContextTransitioning) -> any UIViewImplicitlyAnimating {
//        
//    }
//
//    public func animationEnded(_ transitionCompleted: Bool) {
//        
//    }
    
}
