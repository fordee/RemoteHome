//
//  AirflowView.swift
//  RemoteHome
//
//  Created by John Forde on 31/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//


import UIKit
import Stevia

class AirflowView: UIView {

	let airflowLabel = UILabel()
	let airflowDirectionView = AirflowDirectionView()

	var device: IoTDevice? {
		didSet(value) {
			airflowDirectionView.device = device
		}
	}

	required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}

	override init(frame: CGRect) {
		super.init(frame: frame)
		//airflowDirectionView.delegate = self

		airflowLabel.text = "Airflow Direction"
		// TODO: add target for swing button

		sv(
			airflowLabel.style(labelStyle),
			airflowDirectionView
		)

		// Here we layout the cell.
		layout(
			8,
			|-8-airflowLabel-(>=8)-|,
			4,
			|-8-airflowDirectionView-8-|,
			>=8
		)

		// Configure visual elements
		backgroundColor = UIColor.controlColor
		layer.cornerRadius = 8
	}



	private func setImage(on button: UIButton, imageName: String) {
		let image = UIImage(named: imageName)
		button.contentMode = .scaleAspectFill
		button.setImage(image, for: .normal)
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		//lbl.backgroundColor = UIColor.controlColor
		lbl.textColor = UIColor.white
		lbl.font = .cellFont
	}

	@objc func autoButtonPressed(_ sender: Any) {
		print("Auto Button Auto pressed.")
	}
}


