import UIKit

public enum CustomFont: String, CaseIterable {
    case notoSansBold = "NotoSans-Bold"
    case notoSansBoldItalic = "NotoSans-BoldItalic"
    case notoSansItalic = "NotoSans-Italic"
    case notoSansRegular = "NotoSans-Regular"
}

public extension UIFont {
    static let registerFonts: () = {
        CustomFont.allCases
            .map { $0.rawValue + ".ttf" }
            .forEach { registerFont(fontName: $0) }
    }()

    private static func registerFont(fontName: String) {
        guard let pathForResourceString = Bundle.framework.path(forResource: fontName, ofType: nil),
            let fontData = NSData(contentsOfFile: pathForResourceString),
            let dataProvider = CGDataProvider(data: fontData),
            let fontRef = CGFont(dataProvider) else {
            preconditionFailure("Failed to load fonts (step 1): \(fontName)")
        }
        var errorRef: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) {
            preconditionFailure("Failed to load fonts (step 2): \(fontName)")
        }
    }
}

extension UIFont {
    static func notoSansBold(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: CustomFont.notoSansBold.rawValue, size: size) else {
            preconditionFailure("Missing font: \(CustomFont.notoSansBold.rawValue)")
        }
        return font
    }

    static func notoSansBoldItalic(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: CustomFont.notoSansBoldItalic.rawValue, size: size) else {
            preconditionFailure("Missing font: \(CustomFont.notoSansBoldItalic.rawValue)")
        }
        return font
    }

    static func notoSansItalic(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: CustomFont.notoSansItalic.rawValue, size: size) else {
            preconditionFailure("Missing font: \(CustomFont.notoSansItalic.rawValue)")
        }
        return font
    }

    private static let notoSansRegular: String = {
        var rawValue = CustomFont.notoSansRegular.rawValue
        return rawValue
    }()

    static func notoSansRegular(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: notoSansRegular, size: size) else {
            preconditionFailure("Missing font: \(notoSansRegular)")
        }
        return font
    }
}
