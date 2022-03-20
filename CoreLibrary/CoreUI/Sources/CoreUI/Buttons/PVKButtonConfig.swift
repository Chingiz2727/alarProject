import UIKit

// MARK: - LayoutConstants

extension LayoutConstants {
    enum PVKButton {
        static var defaultCornerRadius: CGFloat {
            return 8.0
        }

        static var largePadding: UIEdgeInsets {
            return .init(top: 12.0, left: 32.0, bottom: 12.0, right: 32.0)
        }
        static var mediumPadding: UIEdgeInsets {
            return .init(top: 8.0, left: 24.0, bottom: 8.0, right: 24.0)
        }
        static var smallPadding: UIEdgeInsets {
            return .init(top: 4.0, left: 16.0, bottom: 4.0, right: 16.0)
        }
    }
}

// MARK: - PVKButton constants

extension PVKButton {

    enum Constants {
        enum Color {
            enum Border {
                static var secondary: UIColor {
                    return .black
                }
            }

            enum Title {
                static var primary: UIColor {
                    return .white
                }

                static var secondaryNormal: UIColor {
                    return .black
                }
                static var secondarySelected: UIColor {
                    return .white
                }
                static var secondaryDisabled: UIColor {
                    return .black
                }

                static var tertiaryNormal: UIColor {
                    return .black
                }
                static var tertiarySelected: UIColor {
                    return .white
                }
                static var tertiaryDisabled: UIColor {
                    return .black
                }
            }

            enum Background {
                static var primaryNormal: UIColor {
                    return UIColor.black
                }
                static var primarySelected: UIColor {
                    return UIColor.black
                }
                static var primaryDisabled: UIColor {
                    return UIColor.black
                }

                static var secondaryNormal: UIColor {
                    return UIColor.clear
                }
                static var secondarySelected: UIColor {
                    return UIColor.black
                }
                static var secondaryDisabled: UIColor {
                    return UIColor.clear
                }

                static var tertiaryNormal: UIColor {
                    return UIColor.clear
                }
                static var tertiarySelected: UIColor {
                    return UIColor.black
                }
                static var tertiaryDisabled: UIColor {
                    return UIColor.clear
                }
            }
        }
    }
}

// MARK: - PVKButtonConfig constants

extension PVKButtonConfig.Priority {
    typealias Border = PVKButton.Constants.Color.Border

    func border(for state: UIControl.State) -> UIColor? {
        switch (self, state) {
        case (.primary, _):
            return nil

        case (.secondary, _):
            return Border.secondary

        case (.tertiary, _):
            return nil
        }
    }
}

extension PVKButtonConfig.Priority {

    typealias Title = PVKButton.Constants.Color.Title

    func titleColor(for state: UIControl.State) -> UIColor {
        switch (self, state) {
        case (.primary, _):
            return Title.primary

        case (.secondary, .disabled):
            return Title.secondaryDisabled
        case (.secondary, .highlighted):
            return Title.secondarySelected
        case (.secondary, _):
            return Title.secondaryNormal

        case (.tertiary, .disabled):
            return Title.tertiaryDisabled
        case (.tertiary, .highlighted):
            return Title.tertiarySelected
        case (.tertiary, _):
            return Title.tertiaryNormal
        }
    }
}

extension PVKButtonConfig.Priority {

    typealias Background = PVKButton.Constants.Color.Background

    func backgroundColor(for state: UIControl.State) -> UIColor {
        switch (self, state) {
        case (.primary, .disabled):
            return Background.primaryDisabled
        case (.primary, .highlighted):
            return Background.primarySelected
        case (.primary, _):
            return Background.primaryNormal

        case (.secondary, .disabled):
            return Background.secondaryDisabled
        case (.secondary, .highlighted):
            return Background.secondarySelected
        case (.secondary, _):
            return Background.secondaryNormal

        case (.tertiary, .disabled):
            return Background.tertiaryDisabled
        case (.tertiary, .highlighted):
            return Background.tertiarySelected
        case (.tertiary, _):
            return Background.tertiaryNormal
        }
    }

}

extension PVKButtonConfig.Size {

    var contentInsets: UIEdgeInsets {
        switch self {
        case .large:
            return LayoutConstants.PVKButton.largePadding

        case .medium:
            return LayoutConstants.PVKButton.mediumPadding

        case .small:
            return LayoutConstants.PVKButton.smallPadding
        }
    }

}

extension PVKButtonConfig.Size {

    var height: CGFloat {
        switch self {
        case .large:
            return 48.0
        case .medium:
            return 40.0
        case .small:
            return 32.0
        }
    }

}

// MARK: - PVKButtonConfig

extension PVKButtonConfig {

    static var `default`: PVKButtonConfig {
        return PVKButtonConfig(priority: .primary, size: .large, cornerRadius: LayoutConstants.PVKButton.defaultCornerRadius)
    }

    public static var primaryLarge: PVKButtonConfig {
        return PVKButtonConfig(priority: .primary, size: .large, cornerRadius: LayoutConstants.PVKButton.defaultCornerRadius)
    }

    public static var secondaryLarge: PVKButtonConfig {
        return PVKButtonConfig(priority: .secondary, size: .large, cornerRadius: LayoutConstants.PVKButton.defaultCornerRadius)
    }

    public static var tertiaryLarge: PVKButtonConfig {
        return PVKButtonConfig(priority: .tertiary, size: .large, cornerRadius: LayoutConstants.PVKButton.defaultCornerRadius)
    }

    public static var primaryMedium: PVKButtonConfig {
        return PVKButtonConfig(priority: .primary, size: .medium, cornerRadius: LayoutConstants.PVKButton.defaultCornerRadius)
    }

    public static var secondaryMedium: PVKButtonConfig {
        return PVKButtonConfig(priority: .secondary, size: .medium, cornerRadius: LayoutConstants.PVKButton.defaultCornerRadius)
    }

    public static var tertiaryMedium: PVKButtonConfig {
        return PVKButtonConfig(priority: .tertiary, size: .medium, cornerRadius: LayoutConstants.PVKButton.defaultCornerRadius)
    }

    public static var primarySmall: PVKButtonConfig {
        return PVKButtonConfig(priority: .primary, size: .small, cornerRadius: LayoutConstants.PVKButton.defaultCornerRadius)
    }

    public static var secondarySmall: PVKButtonConfig {
        return PVKButtonConfig(priority: .secondary, size: .small, cornerRadius: LayoutConstants.PVKButton.defaultCornerRadius)
    }

    public static var tertiarySmall: PVKButtonConfig {
        return PVKButtonConfig(priority: .tertiary, size: .small, cornerRadius: LayoutConstants.PVKButton.defaultCornerRadius)
    }
}

enum LayoutConstants {

    /// Namespace
    enum Spacing {
        static var p2: CGFloat { return 2.0 }
        static var p4: CGFloat { return 4.0 }
        static var p8: CGFloat { return 8.0 }
        static var p12: CGFloat { return 12.0 }
        static var p16: CGFloat { return 16.0 }
        static var p24: CGFloat { return 24.0 }
        static var p32: CGFloat { return 32.0 }
        static var p48: CGFloat { return 48.0 }
        static var p56: CGFloat { return 56.0 }
        static var p64: CGFloat { return 64.0 }
        static var p96: CGFloat { return 96.0 }
        static var p128: CGFloat { return 128.0 }
        static var p160: CGFloat { return 160.0 }
    }

}
