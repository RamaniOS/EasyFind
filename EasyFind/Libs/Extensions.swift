//
//  Extensions.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-18.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit

/*
 Extension for UITextField
 */
extension UITextField {
    
    var hasText: Bool {
        return text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
    
    func setLeftPading(_ size: CGFloat) {
        leftViewMode = .always
        let leftPadView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: bounds.size.height))
        leftPadView.backgroundColor = .clear
        leftView = leftPadView
    }
    
    func addLeftImage(_ image: UIImage) {
        let margin: CGFloat = 10
        leftViewMode = .always
        var width: CGFloat = 30
        width += margin
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: bounds.size.height))
        let imageView = UIImageView(frame: CGRect(x: margin, y: 0, width: width-margin, height: bounds.size.height))
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.image = image
        view.addSubview(imageView)
        leftView = view
    }
    
    func addBorder(radius: CGFloat, width: CGFloat, color: CGColor){
        layer.cornerRadius = radius;
        layer.borderWidth = width;
        layer.borderColor = color
    }
}

/*
Extension for UIAlertController
*/
extension UIAlertController {
    class func showAlert(_ title: String, _ message: String, in viewController: UIViewController) {
        let alertView = self.init(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alertView, animated: true, completion: nil)
    }
}

/*
Extension for UIStoryboard
*/
extension UIStoryboard {
    static var main: UIStoryboard {
        let storyboardName = (Bundle.main.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String)!
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
}

/*
Extension for UIView
*/
extension UIView {
    
    func actionBlock(_ closure: @escaping() -> ()) {
        let sleeve = ClosureSleeve(closure)
        let recognizer = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func addShadow(color: CGColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

/*
Extension for UIScreen
*/
extension UIScreen {
    
    class var mainBounds: CGRect {
        return main.bounds
    }
    
    class var mainSize: CGSize {
        return mainBounds.size
    }
}

public class ClosureSleeve {
    
    let closure: ()->()
    
    init(_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}
