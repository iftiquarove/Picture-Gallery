//
//  Extensions.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import Foundation
import UIKit


//MARK: - UIView Extensions

extension UIView{
    func anchor (top : NSLayoutYAxisAnchor? = nil , left: NSLayoutXAxisAnchor?  = nil , bottom : NSLayoutYAxisAnchor?  = nil , right : NSLayoutXAxisAnchor?  = nil ,centerX : NSLayoutXAxisAnchor? = nil , centerY : NSLayoutYAxisAnchor? = nil, paddingTop : CGFloat = 0 , paddingLeft : CGFloat = 0 , paddingBottom : CGFloat = 0 , paddingRight : CGFloat = 0 ,xConstant : CGFloat = 0, yConstant : CGFloat = 0, width : CGFloat = 0 , height : CGFloat = 0 ){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top , constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left , constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom , constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right , constant: -paddingRight).isActive = true
        }
        
        if let centerX = centerX{
            self.centerXAnchor.constraint(equalTo: centerX, constant: xConstant).isActive = true
        }
        
        if let centerY = centerY{
            self.centerYAnchor.constraint(equalTo: centerY, constant: yConstant).isActive = true
        }
        
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setAspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
}

//MARK: - UIViewController Extensions
extension UIViewController{
    func showToast(message : String, font: UIFont = UIFont(name: RUBIK_MEDIUM, size: Utility.convertWidthMultiplier(constant: 15))!) {
        DispatchQueue.main.async {
            let toastLabel = UILabel()
            self.view.addSubview(toastLabel)
            toastLabel.font = font
            toastLabel.backgroundColor = UIColor(hexString: "#323D5D")
            toastLabel.text = message
            toastLabel.textAlignment = .center
            toastLabel.textColor = .white
            toastLabel.sizeToFit()
            
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            toastLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
            toastLabel.widthAnchor.constraint(equalToConstant: toastLabel.frame.width + 20).isActive = true
            toastLabel.heightAnchor.constraint(equalToConstant: toastLabel.frame.height + 20).isActive = true
            toastLabel.layer.cornerRadius = Utility.convertHeightMultiplier(constant: 12)
            toastLabel.clipsToBounds = true
            
            UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
}

//MARK: - UIImageView Extensions
let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String, placeHolder: Bool) {
        let url = URL(string: urlString)
        if url == nil {return}
        if placeHolder{
            self.image = #imageLiteral(resourceName: "placeholder")
        }
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.anchor(centerX: self.centerXAnchor , centerY: self.centerYAnchor ,width: 20, height: 20)
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
            }
            
        }).resume()
    }
}

//MARK: - UIColor Extensions
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


//MARK: - ************ UINavigationController related ************
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        self.navigationBar.isHidden = true
        self.navigationBar.barStyle = .black
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

//MARK: - ************ Constrainst related ************
extension NSLayoutConstraint {
     func setMultiplier(_ multiplier: CGFloat, of constraint: inout NSLayoutConstraint) {
        NSLayoutConstraint.deactivate([constraint])

         let newConstraint = NSLayoutConstraint(item: constraint.firstItem!, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: multiplier, constant: constraint.constant)

        newConstraint.priority = constraint.priority
        newConstraint.shouldBeArchived = constraint.shouldBeArchived
        newConstraint.identifier = constraint.identifier

        NSLayoutConstraint.activate([newConstraint])
        constraint = newConstraint
    }
}
