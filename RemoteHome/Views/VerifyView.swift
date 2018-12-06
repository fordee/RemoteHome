//
//  VerifyView.swift
//  RemoteHome
//
//  Created by John Forde on 24/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia
import AWSCognitoIdentityProvider

class VerifyView: UIView {

	let titleLabel = UILabel()
	let verificationCodeLabel = UILabel()
	let verificationCodeField = UITextField()
	let verificationCodeButton = UIButton()
	let errorLabel = UILabel()

	weak var delegate: VerifyViewControllerDelegate?

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv([titleLabel.style(labelStyle),
				verificationCodeLabel.style(labelStyle),
				verificationCodeField.style(textFieldStyle),
				verificationCodeButton.style(buttonStyle),
				errorLabel.style(errorLabelStyle)
			])

		backgroundColor = UIColor.backgroundColor
		titleLabel.numberOfLines = 0 // multiline
		verificationCodeLabel.text = "Verify Code"
		verificationCodeButton.addTarget(self, action: #selector(verifyButtonPressed(_:)), for: .touchUpInside)
		verificationCodeField.returnKeyType = .done
		verificationCodeField.becomeFirstResponder()
		errorLabel.numberOfLines = 0 // multiline

		layout(44,
					 |-20-titleLabel-20-|,
					 8,
					 |-20-verificationCodeLabel-(>=10)-verificationCodeField-8-|,
					 8,
					 |-40-verificationCodeButton-40-|,
					 8,
					 |-20-errorLabel-20-|,
					 (>=8))
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.textColor = UIColor.white
		lbl.font = .cellFont
	}

	private func errorLabelStyle(lbl: UILabel) {
		labelStyle(lbl: lbl)
		lbl.textColor = .red
	}

	private func textFieldStyle(txt: UITextField) {
		txt.borderStyle = .roundedRect
		txt.textColor = UIColor.white
		txt.backgroundColor = UIColor.controlColor
		txt.keyboardType = .numberPad
		txt.keyboardAppearance = .dark
		txt.returnKeyType = .next
		txt.height(44)
		txt.width(240)
		txt.font = .detailFont
		//txt.delegate = self
	}

	private func buttonStyle(btn: UIButton) {
		btn.backgroundColor = UIColor.controlColor
		btn.tintColor = UIColor.white
		btn.height(44)
		//btn.width(80)
		btn.layer.cornerRadius = 8
	}

	@objc func verifyButtonPressed(_ sender: Any) {
		print("Verify Button Pressed.")
		delegate?.handleVerifyPressed()
	}

}
