//
//  SignUpViewController.swift
//  RemoteHome
//
//  Created by John Forde on 24/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

protocol SignUpViewControllerDelegate: class {
	func handleSignUp(userInfo: UserSignUpInfo)
	func handleCancel()
}

class SignUpViewController: UIViewController {

	var user: AWSCognitoIdentityUser?
	var codeDeliveryDetails: AWSCognitoIdentityProviderCodeDeliveryDetailsType?

	let v = PopUpSignUpView()

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {
		super.init(nibName: nil, bundle: nil) // Dummy to allow initialization
		modalPresentationStyle = .custom
		//transitioningDelegate = self
	}

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		v.signUpView.delegate = self

		navigationItem.title = "Sign Up"
  }

}

extension SignUpViewController: SignUpViewControllerDelegate {
	func handleSignUp(userInfo: UserSignUpInfo) {
		print(userInfo)
		let userPool = AppDelegate.defaultUserPool()
		let emailAttribute = AWSCognitoIdentityUserAttributeType(name: "email", value: userInfo.email)
		let firstNameAttribute = AWSCognitoIdentityUserAttributeType(name: "given_name", value: userInfo.firstName)
		let lastNameAttribute = AWSCognitoIdentityUserAttributeType(name: "family_name", value: userInfo.lastName)
		let attributes:[AWSCognitoIdentityUserAttributeType] = [emailAttribute, firstNameAttribute, lastNameAttribute]
		userPool.signUp(userInfo.email, password: userInfo.password1, userAttributes: attributes, validationData: nil)
			.continueWith { (response) -> Any? in
				if response.error != nil {
					// Error in the Signup Process
					let alert = UIAlertController(title: "Error", message: (response.error! as NSError).userInfo["message"] as? String, preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
					self.present(alert, animated: true, completion: nil)
				} else {
					self.user = response.result!.user
					// Does user need confirmation?
					if (response.result?.userConfirmed?.intValue != AWSCognitoIdentityUserStatus.confirmed.rawValue) {
						// User needs confirmation, so we need to proceed to the verify view controller
						DispatchQueue.main.async {
							self.codeDeliveryDetails = response.result?.codeDeliveryDetails
							let verifyVC = VerifyViewController()
							verifyVC.codeDeliveryDetails = self.codeDeliveryDetails
							verifyVC.user = self.user

							print("Verify")
							self.present(verifyVC, animated: true)
						}
					} else {
						// User signed up but does not need confirmation.  This should rarely happen (if ever).
						DispatchQueue.main.async {
							self.presentingViewController?.dismiss(animated: true, completion: nil)
						}
					}
				}
				return nil
		}
	}

	func handleCancel() {
		dismiss(animated: true)
	}

}
