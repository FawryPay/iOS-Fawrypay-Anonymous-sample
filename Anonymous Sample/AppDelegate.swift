//
//  AppDelegate.swift
//  Anonymous Sample
//
//  Created by Sameh on 08/04/2025.
//

import UIKit
import IQKeyboardManagerSwift
import FawryPaySDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AnonymousFrameWorkHelper.sharedInstance.handleCheckoutURL(url: url)
        return true
    }
}

