import UIKit

public protocol ModalTransitionAnimationConfig {
    var duration: TimeInterval { get }
    var auxAnimation: ((Bool) -> Void)? { get }
    var onCompletion: ((Bool) -> Void)? { get }
    func layout(presenting: Bool, fromView: UIView, toView: UIView, in container: UIView)
    func animate(presenting: Bool, fromView: UIView, toView: UIView, in container: UIView)
}

extension ModalTransitionAnimationConfig {
    var duration: TimeInterval { 0.3 }
    var auxAnimation: ((Bool) -> Void)? { nil }
    var onCompletion: ((Bool) -> Void)? { nil }
    func layout(presenting: Bool, fromView: UIView, toView: UIView, in container: UIView) {
        if presenting {
            toView.transform = .identity.translatedBy(x: 0, y: toView.bounds.height)
        }
    }
    
    func animate(presenting: Bool, fromView: UIView, toView: UIView, in container: UIView) {
        if presenting {
            toView.transform = .identity
        } else {
            fromView.transform = .identity.translatedBy(x: 0, y: fromView.bounds.height)
        }
    }
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
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }

        let containerView = transitionContext.containerView
        let fromView: UIView = fromViewController.view
        let toView: UIView = toViewController.view
        
        let isPresenting = toViewController.presentingViewController === fromViewController
        if isPresenting {
            let proposedFrame = transitionContext.finalFrame(for: toViewController)
            toView.transform = .identity
            toView.frame = proposedFrame
            containerView.addSubview(toView)
        } else {
            if fromViewController.modalPresentationStyle == .fullScreen {
                containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            }
        }
        
        config.layout(presenting: isPresenting, fromView: fromView, toView: toView, in: containerView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear) {
            self.config.animate(presenting: isPresenting, fromView: fromView, toView: toView, in: containerView)
        } completion: { _ in
            let complete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(complete)
            if complete {
                self.config.onCompletion?(isPresenting)
            }
        }
    }
}
