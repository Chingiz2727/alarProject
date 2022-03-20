import Foundation
import UIKit

public enum SnackbarAlignment {
    case horizontal
}

public final class SnackbarAction {

    public typealias Action = (SnackbarAction) -> ()

    public let title: String
    public let block: (Action)?
    public let titleColor: UIColor?

    public init(block: @escaping Action, title: String, titleColor: UIColor?) {
        self.block = block
        self.title = title
        self.titleColor = titleColor
    }

}

open class Snackbar: UIView {
    
    public var actions: [SnackbarAction] = [] {
        didSet {
            actionsUpdated()
        }
    }

    public var buttonsSpacing: CGFloat = 14.0 {
        didSet {
            setNeedsLayout()
        }
    }

    public var alignment: SnackbarAlignment = .horizontal {
        didSet {
            setNeedsLayout()
        }
    }

    public let titleLabel: UILabel = .init()

    public var titleOffset: UIOffset = .init(horizontal: 16.0, vertical: 14.0) {
        didSet {
            setNeedsLayout()
        }
    }

    public var cornerRadius: CGFloat = 8.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            applyShadow()
        }
    }

    public var shadow: DynamicShadow = .init(light: .dark32, dark: .dark16) {
        didSet {
            applyShadow()
        }
    }

    open override var bounds: CGRect {
        didSet {
            guard oldValue != bounds else {
                return
            }

            precalculateSize()
        }
    }

    open override var frame: CGRect {
        didSet {
            guard oldValue != bounds else {
                return
            }

            precalculateSize()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return expectedSize
    }

    // MARK: - Internal properties

    var appearanceTimer: Timer?

    // MARK: - Private properties

    private var expectedSize: CGSize = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    private var buttons: [UIButton] = []

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .black
        layer.cornerRadius = 8.0
        applyShadow()
        addSubview(titleLabel)

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        pan.require(toFail: tap)
        addGestureRecognizer(pan)
    }
    
    private func applyShadow() {
        if let shadow = shadow.resolved() {
            layer.applyShadow(shadow, cornerRadius: cornerRadius)
        }
        else {
            layer.removeShadow()
        }
    }

    // MARK: - Overrides

    open override func layoutSubviews() {
        super.layoutSubviews()

        applyShadow()

        var totalButtonsWidth: CGFloat = buttons.reduce(0.0, { $0 + $1.intrinsicContentSize.width })
        if buttons.count > 1 {
            totalButtonsWidth += CGFloat(buttons.count - 1) * buttonsSpacing
        }
        if alignment == .horizontal {
            let titleAdditionalRightPadding: CGFloat = buttons.isEmpty ? 0.0 : titleOffset.horizontal + totalButtonsWidth
            let titleAvailableWidth: CGFloat = bounds.width - titleOffset.horizontal * CGFloat(2.0) - titleAdditionalRightPadding
            let size = titleLabel.sizeThatFits(.init(width: titleAvailableWidth, height: CGFloat.greatestFiniteMagnitude))
            titleLabel.bounds.size = size
            titleLabel.frame.origin.x = titleOffset.horizontal
            titleLabel.frame.origin.y = titleOffset.vertical
            var buttonMaxX: CGFloat = bounds.width - titleOffset.horizontal
            for button in buttons.reversed() {
                button.sizeToFit()
                button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
                button.frame.origin.x = buttonMaxX - button.bounds.width
                buttonMaxX = button.frame.origin.x
                button.center.y = bounds.center.y
            }
        }
    }

    // MARK: - Public methods

    public func setTitle(_ title: String) {
        titleLabel.textColor = .white
        let typography = Typography(font: .systemFont(ofSize: 14), lineHeight: 24, lineSpacing: nil, letterSpacing: nil)
        titleLabel.attributedText = .init(string: title, typography: typography, lineBreakMode: .byWordWrapping)
        precalculateSize()
        setNeedsLayout()
    }

    // MARK: - Private methods

    private func actionsUpdated() {
        buttons.forEach { $0.removeFromSuperview() }

        for action in actions {
            let button = PVKButton(config: .tertiarySmall, frame: .zero)
            button.setTitle(action.title, for: .normal)
            button.setTitleColor(action.titleColor, for: .normal)
            addSubview(button)
            buttons.append(button)
        }

        precalculateSize()
        setNeedsLayout()
        layoutIfNeeded()
    }

    private func precalculateSize() {
        let size = calculateSize(width: bounds.width)
        print("button size \(size)")
        self.expectedSize = size
    }

    @objc private func swipeAction(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }

        let translation = sender.translation(in: superview)
        guard abs(translation.y) > 10.0 else {
            return
        }

        if appearanceTimer == nil {

            guard window != nil else {
                removeFromSuperview()
                return
            }
            let targetY: CGFloat = self.superview!.bounds.maxY + 40.0
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.0,
                           options: [UIView.AnimationOptions.curveEaseIn]) {
                self.frame.origin.y = targetY
            } completion: { [weak self] _ in
                self?.removeFromSuperview()
            }
        } else {
            appearanceTimer?.fire()
        }
    }

    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }

        if appearanceTimer == nil {

            guard window != nil else {
                removeFromSuperview()
                return
            }
            let targetY: CGFloat = self.superview!.bounds.maxY + 40.0
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.0,
                           options: [UIView.AnimationOptions.curveEaseIn]) {
                self.frame.origin.y = targetY
            } completion: { [weak self] _ in
                self?.removeFromSuperview()
            }
        } else {
            appearanceTimer?.fire()
        }
    }

    @objc private func buttonAction(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else {
            assertionFailure("Unexpected behavior. Button isn't in array.")
            return
        }

        appearanceTimer?.fire()
        actions[index].block?(actions[index])
    }

    func calculateSize(width: CGFloat) -> CGSize {
        var totalButtonsWidth: CGFloat = buttons.reduce(0.0, { $0 + $1.bounds.width })
        if buttons.count > 1 {
            totalButtonsWidth += CGFloat(buttons.count - 1) * buttonsSpacing
        }

        var labelContentHeight: CGFloat = 0.0

        if alignment == .horizontal {
            let titleAdditionalRightPadding: CGFloat = buttons.isEmpty ? 0.0 : titleOffset.horizontal + totalButtonsWidth
            let titleAvailableWidth: CGFloat = width - titleOffset.horizontal * CGFloat(2.0) - titleAdditionalRightPadding
            let size = titleLabel.sizeThatFits(.init(width: titleAvailableWidth, height: CGFloat.greatestFiniteMagnitude))
            labelContentHeight = size.height + titleOffset.horizontal * 2.0
        }

        return .init(width: width, height: labelContentHeight)
    }

}

public extension CGRect {

    var center: CGPoint {
        return CGPoint(x: origin.x + size.width/2.0, y: origin.y + size.height/2.0)
    }

}

public extension CGSize {

    init(value: CGFloat) {
        self = CGSize(width: value, height: value)
    }

}
