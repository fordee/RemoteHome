//
//  ForgotPasswordViewController.swift
//  RemoteHome
//
//  Created by John Forde on 15/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

protocol ForgotPasswordViewControllerDelegate: class {
	func handleReset(confirmationCode: String, email: String, newPassword: String)
	func handleCancel()
}

class ForgotPasswordViewController: UIViewController {

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {
		super.init(nibName: nil, bundle: nil) // Dummy to allow initialization
		modalPresentationStyle = .custom
		//transitioningDelegate = self
	}

	let v = PopUpForgotPasswordView()

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		v.forgotPasswordView.delegate = self
	}

}

extension ForgotPasswordViewController: ForgotPasswordViewControllerDelegate {

	func handleReset(confirmationCode: String, email: String, newPassword: String) {
		let user = AppDelegate.defaultUserPool().getUser(email)
		user.confirmForgotPassword(confirmationCode, password: newPassword).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
			guard let strongSelf = self else { return nil }
			DispatchQueue.main.async {
				if let error = task.error as NSError? {
					strongSelf.v.forgotPasswordView.errorLabel.text = error.userInfo["message"] as? String
				} else {
					strongSelf.dismiss(animated: true)
				}
			}
			return nil
		}
	}

	func handleCancel() {
		dismiss(animated: true)
	}

}
