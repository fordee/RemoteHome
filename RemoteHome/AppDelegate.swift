//
//  AppDelegate.swift
//  RemoteHome
//
//  Created by John Forde on 29/09/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

let userPoolID = "RemoteHomeUserPool"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	class func defaultUserPool() -> AWSCognitoIdentityUserPool {
		return AWSCognitoIdentityUserPool(forKey: userPoolID)
	}

	var loginViewController: LoginViewController?
//	var resetPasswordViewController: ResetPasswordViewController?
//	var multiFactorAuthenticationController: MultiFactorAuthenticationController?
	var navigationController: UINavigationController?

	var window: UIWindow?

	var cognitoConfig: CognitoConfig?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		let navigationBarAppearance = UINavigationBar.appearance()
		let barButtonItemAppearance = UIBarButtonItem.appearance()

		navigationBarAppearance.barTintColor = .backgroundColor
		navigationBarAppearance.tintColor = .white
		navigationBarAppearance.isTranslucent = false
		navigationBarAppearance.barStyle = .blackOpaque

		window = UIWindow(frame: UIScreen.main.bounds)

		AWSDDLog.sharedInstance.logLevel = .verbose
		AWSDDLog.add(AWSDDTTYLogger.sharedInstance)

		// Set up Cognito config
		cognitoConfig = CognitoConfig()
		setupCognitoUserPool()

		navigationController = UINavigationController(rootViewController: MenuViewController()) //SignUpViewController())
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.textColor, .font: UIFont.titleFont] // This is weirdly difficult to set a basic color
		barButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.textColor, .font: UIFont.backButtonFont], for: .normal)

		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
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
		NotificationCenter.default.post(name: .refreshDevices, object: nil, userInfo: nil)
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	func setupCognitoUserPool() {
		// we pull the needed values from the CognitoConfig object
		// this just pulls the values in from the plist
		let clientId:String = self.cognitoConfig!.getClientId()
		let poolId:String = self.cognitoConfig!.getPoolId()
		let clientSecret:String = self.cognitoConfig!.getClientSecret()
		let region:AWSRegionType = self.cognitoConfig!.getRegion()

		// we need to let Cognito know which region we plan to connect to
		let serviceConfiguration = AWSServiceConfiguration(region: region, credentialsProvider: nil)

		// we need to pass it the clientId and clientSecret from the app and the poolId for the user pool
		let cognitoConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: clientId, clientSecret: clientSecret, poolId: poolId)
		AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: cognitoConfiguration, forKey: userPoolID)
		let pool = AppDelegate.defaultUserPool()

		// we need to set the AppDelegate as the user pool's delegate, which will get called when events occur
		pool.delegate = self
	}


}

extension Notification.Name {
	static let refreshDevices = Notification.Name("refreshDevices")
}

extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {

	func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
		if (self.navigationController == nil) {
			self.navigationController = self.window?.rootViewController as? UINavigationController
		}

		if (self.loginViewController == nil) {
			self.loginViewController = LoginViewController()
		}

		DispatchQueue.main.async {
			if(self.loginViewController!.isViewLoaded || self.loginViewController!.view.window == nil) {
				self.navigationController?.present(self.loginViewController!, animated: true, completion: nil)
			}
		}

		return self.loginViewController!
	}
//
//	func startNewPasswordRequired() -> AWSCognitoIdentityNewPasswordRequired {
//		if (self.resetPasswordViewController == nil) {
//			self.resetPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordController") as? ResetPasswordViewController
//		}
//
//		DispatchQueue.main.async {
//			if(self.resetPasswordViewController!.isViewLoaded || self.resetPasswordViewController!.view.window == nil) {
//				self.navigationController?.present(self.resetPasswordViewController!, animated: true, completion: nil)
//			}
//		}
//
//		return self.resetPasswordViewController!
//	}
//
//	func startMultiFactorAuthentication() -> AWSCognitoIdentityMultiFactorAuthentication {
//		if (self.multiFactorAuthenticationController == nil) {
//			self.multiFactorAuthenticationController = self.storyboard?.instantiateViewController(withIdentifier: "MultiFactorAuthenticationController") as? MultiFactorAuthenticationController
//		}
//
//		DispatchQueue.main.async {
//			if(self.multiFactorAuthenticationController!.isViewLoaded || self.multiFactorAuthenticationController!.view.window == nil) {
//				self.navigationController?.present(self.multiFactorAuthenticationController!, animated: true, completion: nil)
//			}
//		}
//
//		return self.multiFactorAuthenticationController!
//	}
//
}



