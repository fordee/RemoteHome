//
//  AirFlowCell.swift
//  RemoteHome
//
//  Created by John Forde on 28/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class AirflowCell: UICollectionViewCell {

	let airflowView = AirflowView()

	var device: IoTDevice? {
		didSet(value) {
			airflowView.device = device
		}
	}

	required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}

	override init(frame: CGRect) {
		super.init(frame: frame)

		sv(
			airflowView
		)

		// Here we layout the cell.
		layout(
			4,
			|-4-airflowView-4-|,
			>=8
		)

		// Configure visual elements
		backgroundColor = UIColor.backgroundColor
		layer.cornerRadius = 8
	}


}


