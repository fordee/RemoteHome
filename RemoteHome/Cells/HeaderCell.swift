//
//  HeaderCell.swift
//  RemoteHome
//
//  Created by John Forde on 19/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class HeaderCell: UICollectionViewCell {

	let headerView = HeaderView()

	required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}

	override init(frame: CGRect) {
		super.init(frame: frame)

		sv(
			headerView
		)

		// Here we layout the cell.
		layout(
			4,
			|-4-headerView-4-|,
			>=4
		)

		// Configure visual elements
		backgroundColor = UIColor.backgroundColor
	}

}
