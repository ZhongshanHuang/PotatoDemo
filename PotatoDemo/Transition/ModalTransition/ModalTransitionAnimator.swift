import UIKit

public protocol ModalTransitionAnimationConfig {
    var duration: TimeInterval { get }
    var auxAnimation: ((Bool) -> Void)? { get }
    var onCompletion: ((Bool) -> Void)? { get }
    func layout(presenting: Bool, modalView: UIView, in container: UIView)
    func animate(presenting: Bool, modalView: UIView, in container: UIView)
}

extension ModalTransitionAnimationConfig {
    var duration: TimeInterval { 0.3 }
    var auxAnimation: ((Bool) -> Void)? { nil }
    var onCompletion: ((Bool) -> Void)? { nil }
    func layout(presenting: Bool, modalView: UIView, in container: UIView) {
        if presenting {
            container.addSubview(modalView)
            modalView.transform = .identity.translatedBy(x: 0, y: modalView.bounds.height)
        }
    }
    
    func animate(presenting: Bool, modalView: UIView, in container: UIView) {
        if presenting {
            modalView.transform = .identity
        } else {
            modalView.transform = .identity.translatedBy(x: 0, y: modalView.bounds.height)
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
        let isPresenting = (toViewController.presentingViewController === fromViewController)
        
        let fromFrame = transitionContext.initialFrame(for: fromViewController)
        let toFrame = transitionContext.finalFrame(for: toViewController)
        print(fromFrame, toFrame)
//        fromView.frame = fromFrame
//        toView.frame = toFrame
        
        let modalView: UIView = isPresenting ? toViewController.view : fromViewController.view
        if isPresenting {
            modalView.transform = .identity
            modalView.frame = toFrame
        }
        config.layout(presenting: isPresenting, modalView: modalView, in: containerView)

        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear) {
            self.config.animate(presenting: isPresenting, modalView: modalView, in: containerView)
        } completion: { _ in
            let complete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(complete)
            if complete {
                self.config.onCompletion?(isPresenting)
            }
        }
    }
}
