import UIKit

/// Picker VisualKit Button
open class PVKButton: UIButton {

    public typealias Config = PVKButtonConfig

    public var config: Config = .default {
        didSet {
            guard oldValue != config else {
                return
            }
            configure(config)
            setNeedsDisplay()
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            updateBackground()
        }
    }

    open override var isEnabled: Bool {
        didSet {
            updateBackground()
        }
    }

    open override var intrinsicContentSize: CGSize {
        let height: CGFloat = config.size.height
        return CGSize(width: super.intrinsicContentSize.width, height: height)
    }

    public convenience init(config: Config, frame: CGRect) {
        self.init(type: .custom)
        self.config = config
        self.frame = frame
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                layer.borderColor = config.priority.border(for: .normal)?.cgColor
            }
        }
    }

    open override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {

        if #available(iOS 13.0, *) {
            super.setAttributedTitle(title, for: state)
        } else {
            let highlightedColor = config.priority.titleColor(for: .highlighted)
            let disabledColor = config.priority.titleColor(for: .disabled)
            let normalColor = config.priority.titleColor(for: .normal)
            if let title = title {
                let highlightedMutableString = NSMutableAttributedString(attributedString: title)
                let disabledMutableString = NSMutableAttributedString(attributedString: title)
                let normalMutableString = NSMutableAttributedString(attributedString: title)
                let range = NSMakeRange(0, highlightedMutableString.length)
                
                highlightedMutableString.addAttribute(.foregroundColor, value: highlightedColor, range: range)
                disabledMutableString.addAttribute(.foregroundColor, value: disabledColor, range: range)
                normalMutableString.addAttribute(.foregroundColor, value: normalColor, range: range)

                super.setAttributedTitle(normalMutableString, for: .normal)
                super.setAttributedTitle(highlightedMutableString, for: .highlighted)
                super.setAttributedTitle(disabledMutableString, for: .disabled)
            }
        }
    }

    private func setup() {
        configure(config)
    }

    private func configure(_ config: Config) {
        updateBackground()
//        setTitleColor(config.priority.titleColor(for: .highlighted), for: .highlighted)
//        setTitleColor(config.priority.titleColor(for: .disabled), for: .disabled)
//        setTitleColor(config.priority.titleColor(for: .normal), for: .normal)
        setTitleColor(.white, for: .normal)
        contentEdgeInsets = config.size.contentInsets
        layer.cornerRadius = config.cornerRadius

        if let borderColor = config.priority.border(for: .normal) {
            layer.borderWidth = 1
            layer.borderColor = borderColor.cgColor
        }
        else if layer.borderWidth != 0 {
            layer.borderWidth = 0
        }

        invalidateIntrinsicContentSize()
    }

    private func updateBackground() {
        if !isEnabled {
            backgroundColor = config.priority.backgroundColor(for: .disabled)
        }
        else {
            if isHighlighted {
                backgroundColor = config.priority.backgroundColor(for: .highlighted)
            }
            else {
                backgroundColor = config.priority.backgroundColor(for: .normal)
            }
        }
    }

}

public struct PVKButtonConfig: Equatable {

    public enum Priority: Equatable {
        case primary, secondary, tertiary
    }

    public enum Size: Equatable {
        case large, medium, small
    }

    public let priority: Priority
    public let size: Size
    public let cornerRadius: CGFloat

    public init(priority: Priority, size: Size, cornerRadius: CGFloat) {
        self.priority = priority
        self.size = size
        self.cornerRadius = cornerRadius
    }

}
