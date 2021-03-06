//
//  AppDelegate.swift
//  SportShop
//
//  Created by Tejas on 1/25/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import Kinvey
import Material
import FBSDKCoreKit
import UIColor_Hex_Swift

extension UIStoryboard {
    class func viewController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var drawerController: AppNavigationDrawerController?
    
    lazy var leftViewController: LeftViewController = {
        return UIStoryboard.viewController(identifier: "LeftViewController") as! LeftViewController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        //UINavigationBar.appearance().barTintColor = UIColor.darkGray
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        //UINavigationBar.appearance().tintColor = UIColor("#652111")

        initializeKinvey()

//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//        
//        FBSDKProfile.enableUpdates(onAccessTokenChange: true)


        window = UIWindow(frame: Screen.bounds)
        let rootViewController = UIStoryboard.viewController(identifier: "DashboardController")
        drawerController = AppNavigationDrawerController(rootViewController: UINavigationController(rootViewController: rootViewController),
                                                         leftViewController: leftViewController)
        window!.rootViewController = drawerController
        window!.makeKeyAndVisible()
                
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handled
    }
    
    func initializeKinvey(){
        Kinvey.sharedClient.initialize(appKey: "kid_B1Vak6Ey-", appSecret: "aa9a2a42b7d741bba30bb94b599a5f0b", apiHostName: URL(string: "https://kvy-us2-baas.kinvey.com/")!
)
        Kinvey.sharedClient.logNetworkEnabled = true
        Kinvey.sharedClient.userType = HealthUser.self
    }
}

//extension Client {
//    func isNamedUser () -> Bool {
//        return activeUser != nil && activeUser?.username != "Guest"
//    }
//    
//    func realUserName() -> String? {
//        if let user = activeUser as? HealthUser {
//            return user.firstname
//        }
//        return activeUser?.username
//    }
//}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}

extension UIViewController {
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController?.toggleLeftView()
    }
    
}
