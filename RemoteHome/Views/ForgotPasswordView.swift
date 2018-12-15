//
//  ForgotPasswordView.swift
//  RemoteHome
//
//  Created by John Forde on 15/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia
import AWSCognitoIdentityProvider

class ForgotPasswordView: UIView, ValidatesVerificationCode, ValidatesEmail, ValidatesPassword {

	let cancelButton = UIButton()
	let confirmationCodeLabel = UILabel()
	let confirmationCodeField = UITextField()
	let emailLabel = UILabel()
	let emailField = UITextField()
	let password1Label = UILabel()
	let password1Field = UITextField()
	let password2Label = UILabel()
	let password2Field = UITextField()


	let newPasswordButton = UIButton()
	let errorLabel = UILabel()

	weak var delegate: ForgotPasswordViewControllerDelegate?

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv([cancelButton.style(cancelButtonStyle),
				confirmationCodeLabel.style(labelStyle),
				confirmationCodeField.style(textFieldStyle),
				emailLabel.style(labelStyle),
				emailField.style(emailFieldStyle),
				newPasswordButton.style(buttonStyle),
				errorLabel.style(errorLabelStyle),
				password1Label.style(labelStyle),
				password1Field.style(passwordFieldStyle),
				password2Label.style(labelStyle),
				password2Field.style(passwordFieldStyle),
			])

		backgroundColor = UIColor.backgroundColor
		confirmationCodeLabel.text = "Confirmation Code"
		emailLabel.text = "Email"
		password1Label.text = "New Password"
		password2Label.text = "Confirm"
		newPasswordButton.setTitle("Change Password", for: .normal)
		newPasswordButton.addTarget(self, action: #selector(newPasswordButtonPressed(_:)), for: .touchUpInside)
		password2Field.returnKeyType = .done
		confirmationCodeField.becomeFirstResponder()
		errorLabel.numberOfLines = 0 // multiline

		layout(8,
					 |-20-errorLabel-(>=8)-cancelButton-|,
					 8,
					 |-20-emailLabel-(>=10)-emailField-8-|,
					 8,
					 |-20-confirmationCodeLabel-(>=10)-confirmationCodeField-8-|,
					 8,
					 |-20-password1Label-(>=10)-password1Field-8-|,
					 8,
					 |-20-password2Label-(>=10)-password2Field-8-|,
					 8,
					 |-40-newPasswordButton-40-|,
					 (>=8))
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.textColor = UIColor.white
		lbl.numberOfLines = 0
		lbl.font = .cellFont
	}

	private func errorLabelStyle(lbl: UILabel) {
		labelStyle(lbl: lbl)
		lbl.textColor = .red
	}

	private func passwordFieldStyle(txt: UITextField) {
		textFieldStyle(txt: txt)
		txt.isSecureTextEntry = true
		txt.autocapitalizationType = .none
		txt.autocorrectionType = .no
		txt.keyboardType = .alphabet
	}

	private func textFieldStyle(txt: UITextField) {
		txt.borderStyle = .roundedRect
		txt.textColor = UIColor.white
		txt.backgroundColor = UIColor.controlColor
		txt.keyboardType = .numberPad
		txt.keyboardAppearance = .dark
		txt.returnKeyType = .next
		txt.height(44)
		txt.width(200)
		txt.font = .detailFont
		txt.delegate = self
	}

	private func emailFieldStyle(txt: UITextField) {
		textFieldStyle(txt: txt)
		txt.autocapitalizationType = .none
		txt.autocorrectionType = .no
		txt.keyboardType = .emailAddress
	}

	private func buttonStyle(btn: UIButton) {
		btn.backgroundColor = UIColor.controlColor
		btn.tintColor = UIColor.white
		btn.height(44)
		//btn.width(80)
		btn.layer.cornerRadius = 8
	}

	private func cancelButtonStyle(btn: UIButton) {
		btn.setTitleColor(.white, for: .normal)
		btn.height(20)
		btn.setTitle("X", for: .normal)
		btn.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
	}

	@objc func newPasswordButtonPressed(_ sender: Any) {
		print("Verify Button Pressed.")
		if let (confirmationCode, email, newPassword) = validateFields() {
			delegate?.handleReset(confirmationCode: confirmationCode, email: email, newPassword: newPassword)
		}
	}

	@objc func cancelButtonPressed(_ sender: Any) {
		print("Cancel Button Pressed.")
		errorLabel.text = ""
		delegate?.handleCancel()
	}

	private func validateFields() -> (String, String, String)? {

		guard let confirmationCode = confirmationCodeField.text?.trimmingCharacters(in: .whitespaces) else {return nil}
		guard let email = emailField.text?.trimmingCharacters(in: .whitespaces) else {return nil}
		guard let password1 = password1Field.text?.trimmingCharacters(in: .whitespaces) else {return nil}

		guard isEmailValid(email) else {
			errorLabel.text = "Please enter a valid email."
			return nil
		}

		guard isVerificationCodeValid(confirmationCode) else {
			errorLabel.text = "Please enter a valid verification code."
			return nil
		}

		guard isPasswordValid(password1) else {
			errorLabel.text = "Please enter a valid password."
			return nil
		}

		if password1Field.text != password2Field.text {
			errorLabel.text = "Passwords do not match."
			return nil
		}

		return (confirmationCode, email, password1)
	}

}

extension ForgotPasswordView: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()

		switch textField {
		case emailField:
			confirmationCodeField.becomeFirstResponder()
		case confirmationCodeField:
			password1Field.becomeFirstResponder()
		case password1Field:
			password2Field.becomeFirstResponder()
		case password2Field:
			if let (confirmationCode, email, newPassword) = validateFields() {
				delegate?.handleReset(confirmationCode: confirmationCode, email: email, newPassword: newPassword)
			}
		default:
			fatalError("Text Field Delegate Error. Doesn't handle: \(textField.self)")
		}
		return true
	}
}
