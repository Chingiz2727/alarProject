import Foundation
import UIKit

public enum SnackbarAnchor {

    public enum Spacing {
        case value(CGFloat)
        case plain
        case below(CGFloat)
        var value: CGFloat {
            switch self {
            case .plain:
                return LayoutConstants.Spacing.p24
            case .value(let value):
                return value
            case .below(let value):
                return value + LayoutConstants.Spacing.p24
            }
        }
    }

    case top(spacing: Spacing)
    case bottom(spacing: Spacing)

    var spacing: Spacing {
        switch self {
        case .bottom(let spacing), .top(let spacing):
            return spacing
        }
    }

}

public enum SnackbarSource {
    case fromBottom
    case fromTop
}

public extension Snackbar {

    struct AnimationOptions {
        public var targetAnchor: SnackbarAnchor
        public var source: SnackbarSource
        public var lifetimeDuration: TimeInterval
        public var animationDuration: TimeInterval
        public var animateAlpha: Bool

        public init(
            targetAnchor: SnackbarAnchor,
            source: SnackbarSource,
            animationDuration: TimeInterval = 0.4,
            lifetimeDuration: TimeInterval = 2.0,
            animateAlpha: Bool = true
        ) {
            self.targetAnchor = targetAnchor
            self.source = source
            self.animationDuration = animationDuration
            self.lifetimeDuration = lifetimeDuration
            self.animateAlpha = animateAlpha
        }
    }

    static func showAttached(
        to view: UIView,
        in container: UIView,
        title: String,
        backgroundColor: UIColor? = nil,
        actions: [SnackbarAction],
        options: AnimationOptions
    ) {
        
        guard view.window != nil else {
            assertionFailure("Trying to add snackbar to not active view hierarchy.")
            return
        }
        let snackbar = Snackbar()
        snackbar.setTitle(title)
        snackbar.actions = actions
        snackbar.backgroundColor = backgroundColor
        let horizontalPadding: CGFloat = 20.0
        let width = container.bounds.width - horizontalPadding * CGFloat(2.0)
        let height = snackbar.calculateSize(width: width).height
        snackbar.bounds.size = .init(width: width, height: height)

        switch options.source {
        case .fromBottom:
            snackbar.frame.origin.x = horizontalPadding
            snackbar.frame.origin.y = container.bounds.maxY + 40.0
        case .fromTop:
            snackbar.frame.origin.x = horizontalPadding
            snackbar.frame.origin.y = container.bounds.minY + 40.0
        }

        let viewFrame = view.convert(view.bounds, to: container)
        let targetY: CGFloat
        
        switch options.targetAnchor {
        case .top(let spacing):
            targetY = viewFrame.origin.y - spacing.value - height
        case .bottom(let spacing):
            targetY = viewFrame.maxX - spacing.value - height
        }

        if options.animateAlpha {
            snackbar.alpha = 0.0
        }
        container.addSubview(snackbar)
        
        UIView.animate(withDuration: options.animationDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.5,
                       options: [UIView.AnimationOptions.curveEaseInOut]) {
            if options.animateAlpha {
                snackbar.alpha = 1.0
            }
            snackbar.frame.origin.y = targetY
        } completion: { completed in
            if completed {
                initDismissTimer(in: snackbar, options: options)
            }
        }

    }

    private static func initDismissTimer(in snackbar: Snackbar, options: AnimationOptions) {
        snackbar.appearanceTimer = Timer.scheduledTimer(
            withTimeInterval: options.lifetimeDuration,
            repeats: false,
            block: { [weak snackbar] timer in
                guard let snackbar = snackbar, let window = snackbar.window else {
                    return
                }
                timer.invalidate()
                _dismiss(snackbar, window: window, options: options)
            })
    }

    private static func _dismiss(
        _ snackbar: Snackbar,
        window: UIWindow,
        options: AnimationOptions
    ) {

        let targetY: CGFloat
        switch options.source {
        case .fromBottom:
            targetY = snackbar.superview!.bounds.maxY + 40.0
        case .fromTop:
            targetY = snackbar.superview!.bounds.minY + 40.0
        }

        UIView.animate(withDuration: options.animationDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.0,
                       options: [UIView.AnimationOptions.curveEaseIn]) {
            if options.animateAlpha {
                snackbar.alpha = 0.0
            }
            snackbar.frame.origin.y = targetY
        } completion: { _ in
            snackbar.removeFromSuperview()
        }
    }

}
