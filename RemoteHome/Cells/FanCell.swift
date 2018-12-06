//
//  FanCell.swift
//  RemoteHome
//
//  Created by John Forde on 27/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

protocol FanCellDelegate: class {
	func setFanMode(_ fanMode: HvacFanMode)
}

class FanCell: UICollectionViewCell {

	let fanView = FanView()
	let fanButton = UIButton()

	var device: IoTDevice? {
		didSet(value) {
			fanView.device = device
		}
	}

	required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setControlImages(on: false)
		fanView.delegate = self

		sv(
			fanView,
			fanButton.style(fanButtonStyle)
		)

		// Here we layout the cell.
		layout(
			4,
			|-4-fanView-(>=4)-fanButton-4-|,
			4
		)

		// Configure visual elements
		backgroundColor = UIColor.backgroundColor
	}

	func setControlImages(on: Bool) {
		setImage(on: fanButton, imageName: on ? "AutoButton" : "AutoButtonUnhighlighted")
	}

	private func setImage(on button: UIButton, imageName: String) {
		let image = UIImage(named: imageName)
		button.contentMode = .scaleAspectFill
		button.setImage(image, for: .normal)
	}

	private func fanButtonStyle(btn: UIButton) {
		btn.backgroundColor = UIColor.controlColor
		btn.height(86)
		btn.width(86)
		btn.layer.cornerRadius = 8
		btn.addTarget(self, action: #selector(fanButtonPressed(_:)), for: .touchUpInside)
	}

	@objc func fanButtonPressed(_ sender: Any) {
		print("Fan Button Auto pressed.")
		fanView.setAllFanButtonsOff()
		setControlImages(on: true)
		guard let device = device else {return}
		device.hvacCommand.fanMode = .fanSpeedAuto
		TempDataApi.shared.command(to: device)
	}
}

extension FanCell: FanCellDelegate {
	func setFanMode(_ fanMode: HvacFanMode) {
		setImage(on: fanButton, imageName: "AutoButtonUnhighlighted")
	}
}
