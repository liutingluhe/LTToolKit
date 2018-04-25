//
//  ViewStyleConfigurable.swift
//  ViewStyleProtocolDemo
//
//  Created by luhe liu on 2018/4/12.
//  Copyright © 2018年 luhe liu. All rights reserved.
//

import UIKit

// MARK: - 视图可配置协议
public protocol ViewStyleConfigurable: class {
    associatedtype ViewStyle
    var viewStyle: ViewStyle? { get set }
    func updateStyle(_ viewStyle: ViewStyle)
}

/// 为实现该协议的类添加一个伪存储属性（利用 objc 的关联方法实现），用来保存样式配置表
fileprivate var viewStyleKey: String = "viewStyleKey"
public extension ViewStyleConfigurable {
    
    public var viewStyle: ViewStyle? {
        get {
            return objc_getAssociatedObject(self, &viewStyleKey) as? ViewStyle
        }
        set {
            objc_setAssociatedObject(self, &viewStyleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let style = newValue {
                self.updateStyle(style)
            }
        }
    }
}

// MARK: - 以下是一些常用配置项
/// View 配置项
public class ViewConfiguration {
    
    public lazy var backgroundColor: UIColor? = UIColor.clear
    public lazy var borderWidth: CGFloat = 0
    public lazy var borderColor: UIColor? = UIColor.clear
    public lazy var cornerRadius: CGFloat = 0
    public lazy var clipsToBounds: Bool = false
    public lazy var contentMode: UIViewContentMode = .scaleToFill
    public lazy var padding: UIEdgeInsets = .zero
    public lazy var size: CGSize = .zero
    public init() {}
}

/// Label 配置项
public class LabelConfiguration: ViewConfiguration {
    public lazy var numberOfLines: Int = 1
    public lazy var textColor: UIColor? = UIColor.black
    public lazy var textBackgroundColor: UIColor? = UIColor.clear
    public lazy var font: UIFont? = UIFont.systemFont(ofSize: 14)
    public lazy var textAlignment: NSTextAlignment = .left
    public lazy var lineBreakMode: NSLineBreakMode = .byTruncatingTail
    public lazy var lineSpacing: CGFloat = 0
    public lazy var characterSpacing: CGFloat = 0
    
    // 属性表，用于属性字符串使用
    public var attributes: [String: Any]? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = self.lineSpacing
        paragraphStyle.lineBreakMode = self.lineBreakMode
        paragraphStyle.alignment = self.textAlignment
        var attributes: [String: Any] = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSKernAttributeName: self.characterSpacing
        ]
        if let font = self.font {
            attributes[NSFontAttributeName] = font
        }
        if let textColor = self.textColor {
            attributes[NSForegroundColorAttributeName] = textColor
        }
        if let textBackgroundColor = self.textBackgroundColor {
            attributes[NSBackgroundColorAttributeName] = textBackgroundColor
        }
        return attributes
    }
}

/// Button 配置项
public class ButtonConfiguration: ViewConfiguration {
    
    public class StateStyle<T> {
        public var normal: T?
        public var highlighted: T?
        public var selected: T?
        public var disabled: T?
    }
    
    public lazy var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    public lazy var titleColor = StateStyle<UIColor>()
    public lazy var image = StateStyle<UIImage>()
    public lazy var title = StateStyle<String>()
    public lazy var backgroundImage = StateStyle<UIImage>()
    public lazy var contentEdgeInsets: UIEdgeInsets = .zero
    public lazy var imageEdgeInsets: UIEdgeInsets = .zero
    public lazy var titleEdgeInsets: UIEdgeInsets = .zero
}

/// ImageView 配置项
public class ImageConfiguration: ViewConfiguration {
    public var image: UIImage?
}
