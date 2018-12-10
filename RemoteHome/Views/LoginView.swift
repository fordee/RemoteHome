//
//  LoginView.swift
//  RemoteHome
//
//  Created by John Forde on 24/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class LoginView: UIView {

	let cancelButton = UIButton()
	let emailAddressLabel = UILabel()
	let emailAddressField = UITextField()

	let passwordLabel = UILabel()
	let passwordField = UITextField()

	let errorLabel = UILabel()

	let loginButton = UIButton()
	let signUpButton = UIButton()
	let forgotPasswordButton = UIButton()
//	let verifyButton = UIButton()

	weak var delegate: LoginViewControllerDelegate?

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv([cancelButton.style(cancelButtonStyle),
			  emailAddressLabel.style(labelStyle),
				emailAddressField.style(emailFieldStyle),
				passwordLabel.style(labelStyle),
				passwordField.style(passwordFieldStyle),
				errorLabel.style(errorLabelStyle),
				loginButton.style(buttonStyle),
				signUpButton.style(buttonStyle),
				forgotPasswordButton.style(buttonStyle),
//				verifyButton.style(buttonStyle)
			])

		backgroundColor = UIColor.backgroundColor
		emailAddressLabel.text = "Email:"
		passwordLabel.text = "Password:"
		errorLabel.text = ""
		errorLabel.numberOfLines = 0
		loginButton.text("Login")
		loginButton.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
		signUpButton.text("Sign Up")
		signUpButton.addTarget(self, action: #selector(signUpButtonPressed(_:)), for: .touchUpInside)
		forgotPasswordButton.text("Forgot Password")
		forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonPressed(_:)), for: .touchUpInside)
//		verifyButton.text("Verify Email")
//		verifyButton.addTarget(self, action: #selector(verifyButtonPressed(_:)), for: .touchUpInside)
//		verifyButton.isHidden = true
		passwordField.returnKeyType = .done
		emailAddressField.becomeFirstResponder()

		equal(sizes: [signUpButton, forgotPasswordButton])

		layout(4,
					 |-errorLabel-(>=8)-cancelButton-|,
					 4,
					 |-8-emailAddressLabel-(>=8)-emailAddressField-8-|,
					 8,
					 |-8-passwordLabel-(>=8)-passwordField-8-|,
					 16,
					 |-8-loginButton-8-|,
					 8,
					 |-8-signUpButton-8-forgotPasswordButton-8-|,
					 //4,
				//	 |-8-verifyButton-8-|,
					 (>=4))
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.textColor = UIColor.white
		lbl.font = .cellFont
	}

	private func errorLabelStyle(lbl: UILabel) {
		labelStyle(lbl: lbl)
		lbl.height(32)
		lbl.textColor = .red
	}

	private func textFieldStyle(txt: UITextField) {
		txt.borderStyle = .roundedRect
		txt.textColor = UIColor.white
		txt.backgroundColor = UIColor.controlColor
		txt.keyboardAppearance = .dark
		txt.returnKeyType = .next
		txt.height(44)
		txt.width(240)
		txt.font = .detailFont
		txt.delegate = self
	}

	private func emailFieldStyle(txt: UITextField) {
		textFieldStyle(txt: txt)
		txt.autocapitalizationType = .none
		txt.autocorrectionType = .no
		txt.keyboardType = .emailAddress
	}

	private func passwordFieldStyle(txt: UITextField) {
		textFieldStyle(txt: txt)
		txt.isSecureTextEntry = true
		txt.autocapitalizationType = .none
		txt.autocorrectionType = .no
		txt.keyboardType = .alphabet
	}

	private func buttonStyle(btn: UIButton) {
		btn.backgroundColor = UIColor.controlColor
		btn.tintColor = UIColor.white
		btn.height(44)
		//btn.width(>=44)
		btn.layer.cornerRadius = 8
	}

	private func cancelButtonStyle(btn: UIButton) {
		btn.setTitleColor(.white, for: .normal)
		btn.height(20)
		btn.setTitle("X", for: .normal)
		btn.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
	}

	@objc func cancelButtonPressed(_ sender: Any) {
		print("Cancel Button Pressed.")
		errorLabel.text = ""
		delegate?.handleCancel()
	}

	@objc func loginButtonPressed(_ sender: Any) {
		print("Login Button Pressed.")
		if let loginInfo = validateFields() {
			errorLabel.text = ""
			delegate?.handleLogin(loginInfo: loginInfo)
		}
	}

	@objc func signUpButtonPressed(_ sender: Any) {
		print("Sign Up Button Pressed.")
		errorLabel.text = ""
		delegate?.handleSignUp()
	}

	@objc func forgotPasswordButtonPressed(_ sender: Any) {
		print("Forgot Password Button Pressed.")
		if let emailAddress = emailAddressField.text, emailAddress.count > 3 {
			errorLabel.text("")
			delegate?.handleForgotPassword(email: emailAddress)
		} else {
			print("Email Address is invalid")
			errorLabel.text("Please enter a valid email address and press Forgot Password.")
		}
	}

	@objc func verifyButtonPressed(_ sender: Any) {
		if let emailAddress = emailAddressField.text, emailAddress.count > 3 {
			delegate?.handleVerify(email: emailAddress)
		}
	}


	private func validateFields() -> LoginInfo? {

		guard let email = emailAddressField.text?.trimmingCharacters(in: .whitespaces) else {return nil}
		guard let password = passwordField.text?.trimmingCharacters(in: .whitespaces) else {return nil}

		let loginInfo = LoginInfo(email: email, password: password)

		return loginInfo
	}

}

extension LoginView: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()

		switch textField {
		case emailAddressField:
			passwordField.becomeFirstResponder()
		case passwordField:
			if let loginInfo = validateFields() {
				errorLabel.text = ""
				delegate?.handleLogin(loginInfo: loginInfo)
			}
		default:
			fatalError("Text Field Delegate Error. Doesn't handle: \(textField.self)")
		}
		return true
	}
}

