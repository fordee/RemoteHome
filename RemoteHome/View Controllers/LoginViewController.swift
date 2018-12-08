//
//  LoginViewController.swift
//  RemoteHome
//
//  Created by John Forde on 24/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

protocol LoginViewControllerDelegate: class {
	func handleLogin(loginInfo: LoginInfo)
	func handleSignUp()
	func handleForgotPassword(email: String)
	func handleVerify(email: String)
}

class LoginViewController: UIViewController {

	var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?

	let v = LoginView()

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		v.delegate = self
	}

}

extension LoginViewController: LoginViewControllerDelegate {
	func handleSignUp() {
		present(SignUpViewController(), animated: true, completion:  nil)
	}

	func handleLogin(loginInfo: LoginInfo) {
		print(loginInfo)
		let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: loginInfo.email, password: loginInfo.password )
		passwordAuthenticationCompletion?.set(result: authDetails)
	}

	func handleForgotPassword(email: String) {
		print("\(email) forgot their password.")
	}

	func handleVerify(email: String) {
		DispatchQueue.main.async {
			//self.codeDeliveryDetails = response.result?.codeDeliveryDetails
			let verifyVC = VerifyViewController()
			//verifyVC.codeDeliveryDetails = self.codeDeliveryDetails
			//verifyVC.user = self.user
			let userPool = AppDelegate.defaultUserPool()
			let user = userPool.getUser(email)
			let cdd = try? AWSCognitoIdentityProviderCodeDeliveryDetailsType(dictionary: ["attributeName": "email", "deliveryMedium": "2", "destination": email], error: {}())
			verifyVC.codeDeliveryDetails = cdd
			verifyVC.user = user
			let details = user.getDetails()
			print("Verify. User: \(details)")
			self.present(verifyVC, animated: true)
		}
	}
}

extension LoginViewController: AWSCognitoIdentityPasswordAuthentication {

	public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
		self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
		DispatchQueue.main.async {
			if (self.v.emailAddressField.text == nil) {
				self.v.emailAddressField.text = authenticationInput.lastKnownUsername
			}
		}
	}

	public func didCompleteStepWithError(_ error: Error?) {
		DispatchQueue.main.async {
			if let error = error {
				let message = (error as NSError).userInfo["message"] as? String ?? ""
				self.v.errorLabel.text = "Cannot Login. \(message)"
//				if message == "User is not confirmed." {
//					self.v.verifyButton.isHidden = false
//				}
			} else {
				self.dismiss(animated: true, completion: {
					self.v.emailAddressField.text = nil
					self.v.passwordField.text = nil
				})
			}
		}
	}



}
