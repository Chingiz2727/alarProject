import Foundation
import UIKit

public struct Typography: Equatable {
    public let font: UIFont
    public var lineHeight: CGFloat?
    public let letterSpacing: CGFloat?
    public let lineSpacing: CGFloat?

    public init(font: UIFont,
                lineHeight: CGFloat? = nil,
                lineSpacing: CGFloat? = nil,
                letterSpacing: CGFloat? = nil) {
        self.font = font
        self.lineSpacing = lineSpacing
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
    }

}

public extension Typography {

    public var asAttributes: [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [.font: font]

        let paragraph = NSMutableParagraphStyle()
        if let lineHeight = lineHeight {
            paragraph.minimumLineHeight = lineHeight
        }

        if let lineSpacing = lineSpacing {
            paragraph.lineSpacing = lineSpacing
        }

        attributes[.paragraphStyle] = paragraph

        if let letterSpacing = letterSpacing {
            attributes[.kern] = letterSpacing
        }

        return attributes
    }

}

public extension NSAttributedString {

    convenience init(string: String?, typography: Typography,
                     alignment: NSTextAlignment = .natural,
                     lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
        var attributes = typography.asAttributes

        let paragraph = (attributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        paragraph.alignment = alignment
        paragraph.lineBreakMode = lineBreakMode
        
        attributes[.paragraphStyle] = paragraph

        self.init(string: string ?? "", attributes: attributes)
    }

}
