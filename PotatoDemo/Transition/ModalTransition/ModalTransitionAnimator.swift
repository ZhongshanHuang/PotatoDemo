import UIKit

public protocol ModalTransitionAnimationConfig {
    var duration: TimeInterval { get }
    var auxAnimation: ((Bool) -> Void)? { get }
    var onDismissed: (() -> Void)? { get }
    var onPresented: (() -> Void)? { get }
    func layout(presenting: Bool, modalView: UIView, in container: UIView)
    func animate(presenting: Bool, modalView: UIView, in container: UIView)
}

final class ModalTransitionAnimator: NSObject {
    private let config: any ModalTransitionAnimationConfig
    
    init(config: any ModalTransitionAnimationConfig) {
        self.config = config
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension ModalTransitionAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return config.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionAnimator(using: transitionContext).startAnimation()
    }
    
    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return transitionAnimator(using: transitionContext)
    }
    
    private func transitionAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
            return UIViewPropertyAnimator(duration: config.duration, dampingRatio: 0.8)
        }

        let containerView = transitionContext.containerView
        let isPresenting = !toViewController.isBeingDismissed

        let modalView: UIView = isPresenting ? toViewController.view : fromViewController.view
        config.layout(presenting: isPresenting, modalView: modalView, in: containerView)

        let duration = transitionDuration(using: transitionContext)
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.8)
        animator.isUserInteractionEnabled = true
         
        animator.addAnimations {
            self.config.animate(presenting: isPresenting, modalView: modalView, in: containerView)
        }

        animator.addCompletion { position in
            switch position {
            case .end:
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if isPresenting {
                    self.config.onPresented?()
                } else {
                    self.config.onDismissed?()
                }
            default:
                self.config.animate(presenting: !isPresenting, modalView: modalView, in: containerView)
                transitionContext.completeTransition(false)
            }
        }
        return animator
    }
}
