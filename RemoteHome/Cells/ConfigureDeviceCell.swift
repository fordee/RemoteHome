//
//  ConfigureDeviceCell.swift
//  RemoteHome
//
//  Created by John Forde on 16/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class ConfigureDeviceCell: UICollectionViewCell {

	let configureDeviceView = ConfigureDeviceView()

	required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}

	override init(frame: CGRect) {
		super.init(frame: frame)

		sv(
			configureDeviceView
		)

		// Here we layout the cell.
		layout(
			4,
			|-4-configureDeviceView-4-|,
			>=4
		)

		// Configure visual elements
		backgroundColor = UIColor.backgroundColor
	}
}
