import UIKit

open class TransitionInteractiveController: UIPercentDrivenInteractiveTransition {

    // MARK: - Private
    private weak var panGestureContainer: UIView?
    private var gestureRecognizer: UIPanGestureRecognizer?
    private var shouldCompleteTransition = false
    
    private enum InteractionConstants {
        static let velocityForComplete: CGFloat = 100.0
        static let velocityForCancel: CGFloat = -5.0
    }
    
    // MARK: - Public
    
    /// enables/disables the entire interactor.
    open var isEnabled = true {
        didSet { gestureRecognizer?.isEnabled = isEnabled }
    }
    open var interactionInProgress = false
    open var completeOnPercentage: CGFloat = 0.5
    open var navigationAction: (() -> Void) = {
        fatalError("Missing navigationAction (ex: navigation.dismiss) on TransitionInteractiveController")
    }
    open var shouldBeginTransition: () -> Bool = { return true }
    
    deinit {
        if let gestureRecognizer = gestureRecognizer {
            panGestureContainer?.removeGestureRecognizer(gestureRecognizer)
        }
    }
    
    /// Sets the viewController to be the one in charge of handling the swipe transition.
    ///
    /// - Parameter viewController: `UIViewController` in charge of the the transition.
    open func addPanGesture(to view: UIView, with panType: PanGestureType) {
        if let gestureRecognizer = gestureRecognizer {
            panGestureContainer?.removeGestureRecognizer(gestureRecognizer)
        }
        self.panGestureContainer = view
        gestureRecognizer = TransitionPanGestureFactory.create(with: panType)
        gestureRecognizer?.addTarget(self, action: #selector(handle(_:)))
        gestureRecognizer?.delegate = self
        gestureRecognizer?.isEnabled = isEnabled
        self.panGestureContainer?.addGestureRecognizer(gestureRecognizer!)
    }
    
    /// Handles the swiping with progress
    ///
    /// - Parameter recognizer: `UIPanGestureRecognizer` in the current tab controller's view.
    @objc
    open func handle(_ recognizer: UIGestureRecognizer) {
        guard let panGesture = recognizer as? TransitionPanGestureProtocol else { return }
        let panVelocity = panGesture.completionSpeed()
        let panned = panGesture.percentComplete()
        switch recognizer.state {
        case .began:
            if panVelocity > 0 && shouldBeginTransition() {
                interactionInProgress = true
                navigationAction()
            }
        case .changed:
            if interactionInProgress {
                let fraction = min(max(panned, 0.0), 0.99)
                update(fraction)
            }
        case .ended, .cancelled:
            if interactionInProgress {
                interactionInProgress = false
                // TODO: - Support completion speed.
                shouldCompleteTransition = (panned > completeOnPercentage || panVelocity > InteractionConstants.velocityForComplete) &&
                    panVelocity > InteractionConstants.velocityForCancel
                shouldCompleteTransition ? finish() : cancel()
            }
        default:
            break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension TransitionInteractiveController: UIGestureRecognizerDelegate {
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = otherGestureRecognizer.view as? UIScrollView {
            return scrollView.contentOffset.y <= 0
        }
        return true
    }
}
