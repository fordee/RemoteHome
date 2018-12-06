//
//  TemperatureCell.swift
//  RemoteHome
//
//  Created by John Forde on 13/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class TemperatureCell: UICollectionViewCell {

	let roomTemperatureView = RoomTemperatureView()
	var device: IoTDevice? {
		didSet(value) {
			roomTemperatureView.device = device
		}
	}

	required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}

	override init(frame: CGRect) {
		super.init(frame: frame)

		sv(
			roomTemperatureView
		)

		// Here we layout the cell.
		layout(
			4,
			|-4-roomTemperatureView-4-|,
			>=4
		)

		// Configure visual elements
		backgroundColor = UIColor.backgroundColor
	}

}
