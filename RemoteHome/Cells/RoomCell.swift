//
//  RoomCell.swift
//  RemoteHome
//
//  Created by John Forde on 27/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia
import MagazineLayout

class RoomCell: MagazineLayoutCollectionViewCell {

	static let reuseId = "RoomCell"

	let roomNamelabel = UILabel()
	let temperatureLabel = UILabel()

	required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}

	override init(frame: CGRect) {
		super.init(frame: frame)

		sv(
			roomNamelabel.style(labelStyle),
			temperatureLabel.style(temperatureLabelStyle)
		)

		temperatureLabel.centerInContainer()

		layout(
			8,
			|-roomNamelabel-(>=8)-|,
			>=8
		)

		// Configure visual elements
		backgroundColor = UIColor.controlColor
	}

	private func labelStyle(lbl: UILabel) {
		//lbl.height(44)
		lbl.textColor = .white
		lbl.font = .cellFont
		lbl.numberOfLines = 0
	}

	private func temperatureLabelStyle(lbl: UILabel) {
		labelStyle(lbl: lbl)
		lbl.font = .cellTempFont
		lbl.text = "23.1°"
	}
}

