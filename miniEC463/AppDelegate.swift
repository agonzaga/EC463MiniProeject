//
//  AppDelegate.swift
//  miniEC463
//
//  Created by Shivani Singh on 9/12/18.
//  Copyright © 2018 Shivani Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseStorage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID        
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    public func sign( _ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if let err = error{
            print("Google login failed - ", err)
            return
        }
        print("Google login successful", user)
        
        guard let tokenID = user.authentication.idToken else { return }
        guard let tokenAccess = user.authentication.accessToken else { return }
        let cred = GoogleAuthProvider.credential(withIDToken: tokenID, accessToken: tokenAccess)
        //Auth.auth().signIn(with: cred, completion: { (user, error) in
        Auth.auth().signIn(with: cred, completion: { (user, error) in
            if let err = error {
                print("Firebase Google Login Failed - ", err)
                return
            }
            guard let uID = user?.uid else { return }
            print("Firebase Google Login Successful", uID )
            return
        })
        
    }
    //func application( app: UIApplication, open url: URL, options:
    func application( _ app: UIApplication, open url: URL, options:
        [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool{
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                          annotation: options[UIApplicationOpenURLOptionsKey.annotation])
       
        return true
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


}

