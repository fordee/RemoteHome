//
//  MenuViewCell.swift
//  RemoteHome
//
//  Created by John Forde on 4/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

import Stevia

class MenuViewCell: UICollectionViewCell {

	var menuItemView = MenuItemView()

	required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}

	override init(frame: CGRect) {
		super.init(frame: frame)

		sv(
			menuItemView
		)

		// Here we layout the cell.
		layout(
			4,
			|-4-menuItemView-4-|,
			>=4
		)

		// Configure visual elements
		backgroundColor = UIColor.backgroundColor
	}
}

