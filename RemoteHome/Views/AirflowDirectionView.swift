//
//  AirflowView.swift
//  RemoteHome
//
//  Created by John Forde on 28/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia


class AirflowDirectionView: UIView {

	
	let autoButton = UIButton()
	let swingButton = UIButton()
	var airflowButton = UIButton()
	var device: IoTDevice?
	var airflowButtonCounter = 0

	weak var delegate: AirflowCellDelegate?

	convenience init() {
		self.init(frame: CGRect.zero)
		setAllButtonsOff()
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv(
			autoButton.style(buttonStyle),
			swingButton.style(buttonStyle),
			airflowButton.style(directionButtonStyle)
		)
		backgroundColor = UIColor.backgroundColor
		layer.cornerRadius = 8

		airflowButton.addTarget(self, action: #selector(airflowDirectionButtonPressed(_:)), for: .touchUpInside)
		swingButton.addTarget(self, action: #selector(swingButtonPressed(_:)), for: .touchUpInside)
		autoButton.addTarget(self, action: #selector(autoButtonPressed(_:)), for: .touchUpInside)

		layout(8,
					 |-8-airflowButton-(>=8)-swingButton-8-autoButton-8-|,
					 8)
	}

	func setAirflowDirectionImageFor(buttonIndex index: Int) {
		setImage(on: airflowButton, imageName: "AirflowDirection\(index)")
	}

	@objc func airflowDirectionButtonPressed(_ sender: Any) {
		//delegate?.setFanMode(HvacFanMode(rawValue: buttonIndex)!)
		print("Airflow Button Button pressed.")
		setAllButtonsOff()
		airflowButtonCounter += 1
		if airflowButtonCounter > 5 { airflowButtonCounter = 1}
		setAirflowDirectionImageFor(buttonIndex: airflowButtonCounter)

		guard let device = device, let hvacVanneMode = HvacVanneMode(rawValue: airflowButtonCounter) else {return}
		device.hvacCommand.vanneMode = hvacVanneMode
		TempDataApi.shared.command(to: device)
	}

	@objc func autoButtonPressed(_ sender: Any) {
		print("Airflow Button Button pressed.")
		setAllButtonsOff()
		setImage(on: autoButton, imageName: "AutoButton")

		guard let device = device else {return}
		device.hvacCommand.vanneMode = .vanneAuto
		TempDataApi.shared.command(to: device)
	}

	@objc func swingButtonPressed(_ sender: Any) {
		print("Swing Button Button pressed.")
		setAllButtonsOff()
		setImage(on: swingButton, imageName: "AirflowDirectionSwing")

		guard let device = device else {return}
		device.hvacCommand.vanneMode = .vanneAutoMove
		TempDataApi.shared.command(to: device)
	}

//	func setAutoButton(on: Bool) {
//		setImage(on: autoButton, imageName: on ? "AutoButton" : "AutoButtonUnhighlighted")
//	}


	func setAllButtonsOff() {
		setImage(on: autoButton, imageName: "AutoButtonUnhighlighted")
		setImage(on: swingButton, imageName: "AirflowDirectionSwingUnhighlighted")
		setImage(on: airflowButton, imageName: "AirflowDirectionOff")
	}

	func setImage(on button: UIButton, imageName: String) {
		let image = UIImage(named: imageName)
		button.setImage(image, for: .normal)
	}

	private func buttonStyle(btn: UIButton) {
		btn.backgroundColor = UIColor.white
		btn.height(64)
		btn.width(64)
		btn.layer.cornerRadius = 8
	}

	private func directionButtonStyle(btn: UIButton) {
		btn.backgroundColor = UIColor.white
		btn.height(84)
		btn.width(84)
		btn.layer.cornerRadius = 8
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.backgroundColor = UIColor.controlColor
		lbl.textColor = UIColor.white
	}
}
