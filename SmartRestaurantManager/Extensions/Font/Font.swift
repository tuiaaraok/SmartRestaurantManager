//
//  Font.swift
//  Graffity
//
//  Created by Karen Khachatryan on 25.11.24.
//

import UIKit

extension UIFont {
    
    static func light(size: CFloat) -> UIFont? {
        return UIFont(name: "SFProText-Light", size: CGFloat(size))
    }
    
    static func regular(size: CFloat) -> UIFont? {
        return UIFont(name: "SFProText-Regular", size: CGFloat(size))
    }
    
    static func medium(size: CFloat) -> UIFont? {
        return UIFont(name: "SFProText-Medium", size: CGFloat(size))
    }
    
    static func semibold(size: CFloat) -> UIFont? {
        return UIFont(name: "SFProText-Semibold", size: CGFloat(size))
    }
    
    static func bold(size: CFloat) -> UIFont? {
        return UIFont(name: "SFProText-Bold", size: CGFloat(size))
    }
}
