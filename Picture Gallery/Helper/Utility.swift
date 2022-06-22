//
//  Utility.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import Foundation
import SystemConfiguration
import UIKit

class Utility: NSObject{
    
    //MARK: - Height/Width related
    public class func convertHeightMultiplier(constant : CGFloat) -> CGFloat{
        let value = constant/896
        return value*UIScreen.main.bounds.height
    }
    
    public class func convertWidthMultiplier(constant : CGFloat) -> CGFloat{
        let value = constant/414
        return value*UIScreen.main.bounds.width
    }
    
    //MARK: - Netrork Check
    public class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    //MARK: - Alert Related
    public class func showAlert(_ VC: UIViewController, _ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default: print("default")
            case .cancel: print("cancel")
            case .destructive: print("destructive")
            default: break
            }}))
        DispatchQueue.main.async {
            VC.present(alert, animated: true, completion: nil)
        }
    }
}
