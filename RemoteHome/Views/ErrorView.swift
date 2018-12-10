//
//  ErrorView.swift
//  RemoteHome
//
//  Created by John Forde on 9/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class ErrorView: UIView {
	var errorHeaderLabel = UILabel()
	var errorMessageLabel = UILabel()
	var okButton = UIButton()

	weak var delegate: ErrorViewControllerDelegate?

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv(
			errorHeaderLabel.style(errorHeaderLabelStyle),
			errorMessageLabel.style(errorMessageLabelStyle),
			okButton.style(okButtonStyle)
		)

		errorHeaderLabel.centerVertically()
		layout(
			8,
			|-errorHeaderLabel-|,
			10,
			|-errorMessageLabel-|,
			10,
			|-okButton-|,
			8
		)


	}

	private func errorHeaderLabelStyle(lbl: UILabel) {
		labelStyle(lbl: lbl)
		lbl.height(80)
		lbl.text = "Error"
	}

	private func errorMessageLabelStyle(lbl: UILabel) {
		labelStyle(lbl: lbl)
		lbl.font = .detailFont
		lbl.numberOfLines = 0 // multiline
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.textColor = .white
		lbl.font = .cellFont
	}

	private func okButtonStyle(btn: UIButton) {
		btn.backgroundColor = UIColor.white
		btn.setTitleColor(.black, for: .normal)
		btn.height(44)
		btn.setTitle("Ok", for: .normal)
		btn.addTarget(self, action: #selector(okButtonPressed(_:)), for: .touchUpInside)
		//btn.width(>=44)
		btn.layer.cornerRadius = 8
	}

	@objc func okButtonPressed(_ sender: Any) {
		print("OK pressed")
		delegate?.handleOkButton()
	}
}
