//
//  FanView.swift
//  RemoteHome
//
//  Created by John Forde on 27/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia


class FanView: UIView {

	let fanLabel = UILabel()
	var fanButtons: [UIButton] = []
	var device: IoTDevice?

	weak var delegate: FanCellDelegate?

	convenience init() {
		self.init(frame: CGRect.zero)
		for index in 0..<5 {
			let button = UIButton()
			button.tag = index
			fanButtons.append(button)
		}
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv(
			fanLabel.style(labelStyle),
			fanButtons[0].style(fanButtonStyle),
			fanButtons[1].style(fanButtonStyle),
			fanButtons[2].style(fanButtonStyle),
			fanButtons[3].style(fanButtonStyle),
			fanButtons[4].style(fanButtonStyle)
		)
		setControlImages()
		backgroundColor = UIColor.controlColor
		layer.cornerRadius = 8
		fanLabel.text = "Fan Speed"

		layout(4,
					 |-fanLabel-(>=4)-|,
					 4,
					 |-fanButtons[0]-2-fanButtons[1]-2-fanButtons[2]-2-fanButtons[3]-2-fanButtons[4]-(>=4)-|,
					 8)
	}

	func setAllFanButtonsOff() {
		for i in 0..<fanButtons.count {
			setImage(on: fanButtons[i], imageName: "FanSpeed\(i + 1)ButtonUnhighlighted")
		}
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.textColor = UIColor.white
		lbl.font = .cellFont
	}

	func setControlImages() {
		for (index, button) in fanButtons.enumerated() {
			setImage(on: button, imageName: "FanSpeed\(index + 1)Button")
			button.addTarget(self, action: #selector(fanButtonPressed), for: .touchUpInside)
		}
	}

	func setImageFor(buttonIndex index: Int) {
		for i in 0...index {
			setImage(on: fanButtons[i], imageName: "FanSpeed\(i + 1)Button")
		}
		for i in (index + 1)..<fanButtons.count {
			setImage(on: fanButtons[i], imageName: "FanSpeed\(i + 1)ButtonUnhighlighted")
		}
	}

	@objc func fanButtonPressed(_ sender: Any) {
		let buttonIndex = (sender as! UIButton).tag
		delegate?.setFanMode(HvacFanMode(rawValue: buttonIndex)!)
		setImageFor(buttonIndex: buttonIndex)
		print("Fan Button \(buttonIndex) pressed.")
		
		guard let device = device, let hvacFanMode = HvacFanMode(rawValue: buttonIndex) else {return}
		device.hvacCommand.fanMode = hvacFanMode
		TempDataApi.shared.command(to: device)
	}

	private func setImage(on button: UIButton, imageName: String) {
		let image = UIImage(named: imageName)
		button.setImage(image, for: .normal)
	}

	private func fanButtonStyle(btn: UIButton) {
		btn.backgroundColor = UIColor.white
		btn.height(44)
		btn.width(44)
	}
}
