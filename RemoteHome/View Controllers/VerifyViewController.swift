//
//  VerifyViewController.swift
//  RemoteHome
//
//  Created by John Forde on 24/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

protocol VerifyViewControllerDelegate: class {
	func handleVerifyPressed()
}

class VerifyViewController: UIViewController {

	var codeDeliveryDetails: AWSCognitoIdentityProviderCodeDeliveryDetailsType?
	var user: AWSCognitoIdentityUser?

	let v = VerifyView()

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Verify Code"
		v.delegate = self
		populateCodeDeliveryDetails()
	}

	func populateCodeDeliveryDetails() {
		let isEmail = (codeDeliveryDetails?.deliveryMedium == AWSCognitoIdentityProviderDeliveryMediumType.email)
		v.verificationCodeButton.setTitle(isEmail ? "Verify Email Address" : "Verify Phone Number", for: .normal)
		let medium = isEmail ? "your email address" : "your phone number"
		let destination = codeDeliveryDetails!.destination!
		v.titleLabel.text = "Please enter the code that was sent to \(medium) at \(destination)"
	}
	
}

extension VerifyViewController: VerifyViewControllerDelegate {
	func handleVerifyPressed() {
		print("delegate handleVerifyPressed fired.")
		self.user?.confirmSignUp(v.verificationCodeField.text!)
			.continueWith(block: { (response) -> Any? in
				if response.error != nil {
					self.resetConfirmation(message: (response.error! as NSError).userInfo["message"] as? String)
				} else {
					DispatchQueue.main.async {
						// Return to Login View Controller - this should be handled a bit differently, but added in this manner for simplicity
						self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
					}
				}
				return nil
			})
	}

	private func resetConfirmation(message: String? = "") {
		DispatchQueue.main.async {
			self.v.verificationCodeField.text = ""
			self.v.errorLabel.text = "Error: \(message!)"
		}
	}
}
