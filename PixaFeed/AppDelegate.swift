//
//  AppDelegate.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    var loginCoordinator: LoginCoordinator?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navController = UINavigationController()
        loginCoordinator = LoginCoordinator(navigationController: navController)
        loginCoordinator?.start()
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }
}

