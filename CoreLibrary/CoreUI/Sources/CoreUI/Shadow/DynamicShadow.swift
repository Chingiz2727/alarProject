import UIKit

public struct DynamicShadow: Equatable {

    public var currentShadow: Shadow? {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .light {
                return light
            }
            else {
                return dark
            }
        } else {
            return light
        }
    }

    public let light: Shadow?
    public let dark: Shadow?

    public init(light: Shadow?, dark: Shadow?) {
        self.light = light
        self.dark = dark
    }

    public func resolved() -> Shadow? {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                return dark
            }
            else {
                return light
            }
        } else {
            return light
        }
    }

}

public struct Shadow: Equatable {

    public let color: UIColor
    public let alpha: CGFloat
    public let xOffset: CGFloat
    public let yOffset: CGFloat
    public let blur: CGFloat
    public let spread: CGFloat

    public static var primaryShadow: Shadow {
        return Shadow(color: .black,
                      alpha: 0.1,
                      xOffset: 0.0,
                      yOffset: 2.0,
                      blur: 8.0,
                      spread: 0.0)
    }

    public static var terciaryShadow: Shadow {
        return Shadow(color: .black,
                      alpha: 0.1,
                      xOffset: 0.0,
                      yOffset: 10.0,
                      blur: 20.0,
                      spread: 0.0)
    }

    public static var light4: Shadow {
        return Shadow(color: UIColor.black,
                      alpha: 0.16,
                      xOffset: 0,
                      yOffset: 1.0,
                      blur: 8.0,
                      spread: 0)
    }

    public static var dark4: Shadow {
        return Shadow(color: UIColor.black,
                      alpha: 1.0,
                      xOffset: 0.0,
                      yOffset: 1.0,
                      blur: 8.0,
                      spread: 0.0)
    }

    public static var light8: Shadow {
        return Shadow(color: UIColor.black,
                      alpha: 0.16,
                      xOffset: 0,
                      yOffset: 4.0,
                      blur: 8.0,
                      spread: 0)
    }

    public static var dark8: Shadow {
        return Shadow(color: UIColor.black,
                      alpha: 1.0,
                      xOffset: 0,
                      yOffset: 4.0,
                      blur: 8.0,
                      spread: 0)
    }

    public static var light16: Shadow {
        return Shadow(color: UIColor.black,
                      alpha: 0.16,
                      xOffset: 0,
                      yOffset: 8.0,
                      blur: 16.0,
                      spread: 0)
    }

    public static var dark16: Shadow {
        return Shadow(color: UIColor.black,
                      alpha: 1.0,
                      xOffset: 0,
                      yOffset: 8.0,
                      blur: 16.0,
                      spread: 0)
    }

    public static var light32: Shadow {
        return Shadow(color: UIColor.black,
                      alpha: 0.16,
                      xOffset: 0,
                      yOffset: 16.0,
                      blur: 32.0,
                      spread: 0)
    }

    public static var dark32: Shadow {
        return Shadow(color: UIColor.black,
                      alpha: 1.0,
                      xOffset: 0,
                      yOffset: 16.0,
                      blur: 32.0,
                      spread: 0)
    }

    public static var light64: Shadow {
        return Shadow(color: UIColor.black,
                      alpha: 0.16,
                      xOffset: 0,
                      yOffset: 32.0,
                      blur: 64.0,
                      spread: 0)
    }

    public static var dark64: Shadow {
        return Shadow(color: UIColor.black,
                      alpha: 1.0,
                      xOffset: 0,
                      yOffset: 32.0,
                      blur: 64.0,
                      spread: 0)
    }

}

extension CALayer {

    public func applyShadow(_ shadow: Shadow,
                            cornerRadius: CGFloat) {
        applyFigmaShadow(color: shadow.color,
                         alpha: shadow.alpha,
                         x: shadow.xOffset,
                         y: shadow.yOffset,
                         blur: shadow.blur,
                         spread: shadow.spread,
                         cornerRadius: cornerRadius)
    }

    public func applyShadow(_ shadow: Shadow) {
        applyFigmaShadow(color: shadow.color,
                         alpha: shadow.alpha,
                         x: shadow.xOffset,
                         y: shadow.yOffset,
                         blur: shadow.blur,
                         spread: shadow.spread,
                         cornerRadius: self.cornerRadius)
    }

    public func removeShadow() {
        shadowColor = nil
        shadowOpacity = 0
        shadowOffset = .zero
        shadowRadius = 0
        shadowPath = nil
    }

}

extension CALayer {

    public func applyFigmaShadow(color: UIColor,
                                 alpha: CGFloat = 0.0,
                                 x: CGFloat = 0.0,
                                 y: CGFloat = 0.0,
                                 blur: CGFloat = 0.0,
                                 spread: CGFloat = 0.0,
                                 cornerRadius: CGFloat) {

        if #available(iOS 13.0, *) {
            shadowColor = color.resolvedColor(with: UITraitCollection.current).cgColor
        } else {
            shadowColor = color.cgColor
        }
        shadowOpacity = Float(alpha)
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0

        if spread == 0 {
            shadowPath = nil
        }
        else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
    }

}
