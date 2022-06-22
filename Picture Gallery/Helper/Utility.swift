//
//  Utility.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import Foundation
import SystemConfiguration
import UIKit

class Utlity: NSObject{
    
    //MARK: - Height/Width related
    public class func convertHeightMultiplier(constant : CGFloat) -> CGFloat{
        let value = constant/896
        return value*UIScreen.main.bounds.height
    }
    
    public class func convertWidthMultiplier(constant : CGFloat) -> CGFloat{
        let value = constant/414
        return value*UIScreen.main.bounds.width
    }
}
