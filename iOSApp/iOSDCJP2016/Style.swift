//
//  Style.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/9/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit


extension UIColor {
    static func darkPrimaryTextColor() -> UIColor {
        return UIColor(red: 0.01, green: 0.14, blue: 0.31, alpha: 1.0)
    }

    static func primaryTextColor() -> UIColor {
        return UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.0)
    }

    static func secondaryTextColor() -> UIColor {
        return UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 0.5)
    }

    static func accentColor() -> UIColor {
        return UIColor(red: 0.0, green: 0.68, blue: 0.79, alpha: 1.0)
    }

    static func secondaryAccentColor() -> UIColor {
        return UIColor(red: 0.89, green: 0.16, blue: 0.54, alpha: 1.0)
    }
    
    static func twitterColor() -> UIColor {
        return UIColor(red: 0.0, green: 0.67, blue: 0.93, alpha: 1.0)
    }
    
    static func colorForRoom(room: Session.Room) -> UIColor {
        switch room {
        case .A:
            return UIColor.accentColor()
        case .B:
            return  UIColor.secondaryAccentColor()
        }
    }
}


class AttributedStringBuilder {
    enum Weight {
        case Thin
        case Regular
        case Bold
        
        var fontWeight: CGFloat {
            get {
                switch self {
                case .Thin:
                    return UIFontWeightThin
                case .Regular:
                    return UIFontWeightRegular
                case .Bold:
                    return UIFontWeightBold
                }
            }
        }
    }

    let size: CGFloat
    var color: UIColor
    var textAlignment: NSTextAlignment
    var weight: Weight
    
    init(size: CGFloat, color: UIColor, textAlignment: NSTextAlignment, weight: Weight) {
        self.size = size
        self.color = color
        self.textAlignment = textAlignment
        self.weight = weight
    }
    
    func build() -> [String: AnyObject] {
        let style = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        style.alignment = textAlignment
        
        return [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: UIFont.systemFontOfSize(size, weight: weight.fontWeight),
            NSParagraphStyleAttributeName: style,
        ]
    }
}


enum TextStyle {
    case Title
    case Body
    case Small
    
    var builder: AttributedStringBuilder {
        // http://www.modularscale.com/?14&px&1.333&web&text
        let baseSize: CGFloat = 14
        let scale: CGFloat = 1.333
        switch self {
        case .Title:
            return AttributedStringBuilder(size: baseSize * scale, color: UIColor.primaryTextColor(),
                                           textAlignment: .Left, weight: .Thin)
        case .Body:
            return AttributedStringBuilder(size: 14, color: UIColor.primaryTextColor(),
                                           textAlignment: .Left, weight: .Regular)
        case .Small:
            return AttributedStringBuilder(size: baseSize * (1 / scale), color: UIColor.secondaryTextColor(),
                                           textAlignment: .Left, weight: .Regular)
        }
    }
}


extension NSAttributedString {
    convenience init(string: String, style: TextStyle) {
        let attrs = style.builder.build()
        self.init(string: string, attributes: attrs)
    }

    convenience init(string: String, style: TextStyle, tweak: ((inout builder: AttributedStringBuilder) -> Void)) {
        var builder = style.builder
        tweak(builder: &builder)
        let attrs = builder.build()
        self.init(string: string, attributes: attrs)
    }
}

protocol DefaultLineHeight: NSLayoutManagerDelegate {
}

extension DefaultLineHeight {
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 12
    }
}

let iconImageRadius: CGFloat = 36
