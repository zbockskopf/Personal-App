//
//  AppDelegate.swift
//  Personal Budget
//
//  Created by Zach Bockskopf on 10/15/17.
//  Copyright © 2017 Zach Bockskopf. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
//add GIDSignInDelegate back in
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate  {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let defaults = UserDefaults.standard
        let defaultValue = ["currentMonth" : ""]
        defaults.register(defaults: defaultValue)
        
        return true
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
    -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let err = error {
            print("Failed to log into Google: ", error)
            return
        }
        print("Logged into google", user)

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { (authUser, error) in
            if let err = error {
                print("Failed to create a firebase user with google account: ", err)
                return
            }

            let ref = Database.database().reference()
            guard let uid = authUser?.uid else { return }
            let userReference = ref.child("Users").child(uid)
            let values = ["name": user.profile.name, "email" : user.profile.email]
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err as Any)
                    return
                }

                //print("Saved user into firebase")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainMenuController = storyboard.instantiateViewController(withIdentifier: "mainMenuTabBar")
                self.window!.rootViewController = mainMenuController
                self.window!.makeKeyAndVisible()
            })
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }


}

