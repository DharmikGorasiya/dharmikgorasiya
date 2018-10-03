//
//  extention.swift
//  GlobalDemoProject
//
//  Created by Dharmik Gorasiya on 14/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit


@IBDesignable
public extension UIView
{
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// Sets the color of the border
    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return UIColor.clear }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    // Drop Shadow to UIView
    func dropShadow(shadowWidth: Int, shadowHeight: Int, color: UIColor = UIColor.black, opacity: Float = 0.5) {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        self.layer.shadowRadius = 2
    }
}

extension UIView {
    
    // Add Border to View..
    func setBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = Constant.Color.TextFieldBorder.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.cornerRadius = 3.5
    }
    
    // Set Corner Radius
    func setCornerRadius(_ radius: CGFloat = 3.5) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}

extension UIImageView {
    // Set Web Image
    func setImageFromURL(_ urlString: String,_ placeholder: UIImage) {
        self.sd_setImage(with: URL(string: urlString), placeholderImage: placeholder)
    }
}

// MARK:- Set Extension
extension UIApplication {
    
    // Get Current View
    @available(iOS 10.0, *)
    class func topViewController(base: UIViewController? = kRootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

// MARK:- Custome TextField Padding  Class
class MyTextField : UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "",
                                                        attributes:[NSAttributedStringKey.foregroundColor: Constant.Color.TextFieldPlaceholder])
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}


// MARK:- String Extension
extension String {
    // Check String is valid email
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    // encode emoji's message
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    // decode emoji's message
    func decode() -> String? {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}


