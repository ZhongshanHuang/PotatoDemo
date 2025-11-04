import UIKit

public class NavigationTransitionDelegate: NSObject {
    private var animationConfigs = [UINavigationController.Operation: any NavigationTransitionAnimationConfig]()
    private let interactiveController = TransitionInteractiveController()
    
    public func addPanGesture(to viewController: UIViewController, with panType: PanGestureType, beginWhen: @escaping (() -> Bool) = { true }) {
        interactiveController.addPanGesture(to: viewController.view, with: panType)
        interactiveController.navigationAction = {
            viewController.navigationController?.popViewController(animated: true)
        }
        interactiveController.shouldBeginTransition = beginWhen
    }
    
    public func set(animatorConfig: any NavigationTransitionAnimationConfig, for operation: UINavigationController.Operation) {
        animationConfigs[operation] = animatorConfig
    }

    public func removeAnimatorConfig(for operation: UINavigationController.Operation) {
        animationConfigs[operation] = nil
    }
    
}

// MARK: - UINavigationControllerDelegate
extension NavigationTransitionDelegate: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let config = animationConfigs[operation] else { return nil }
        return NavigationTransitionAnimator(config: config)
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactiveController.interactionInProgress ? interactiveController : nil
    }
}
