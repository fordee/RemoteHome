//
//  MenuItemView.swift
//  RemoteHome
//
//  Created by John Forde on 8/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia


class MenuItemView: UIView {

	var menuItemLabel = UILabel()
	var menuIcon = UIImageView(image: UIImage(named: "menu_icon"))

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv(
			menuIcon.style(menuItemImageStyle),
			menuItemLabel.style(menuItemLabelStyle)
		)

		// Here we layout the cell.
		layout(
			4,
			|-4-menuIcon-10-menuItemLabel-(>=16)-|,
			4
		)

		// Configure visual elements
		backgroundColor = UIColor.controlColor
		//menuItemLabel.numberOfLines = 0
		layer.cornerRadius = 8
	}

	private func menuItemImageStyle(iv: UIImageView)  {
		iv.height(34)
		iv.width(34)
	}

	private func menuItemLabelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.textColor = .white
		lbl.font = .cellFont
	}
}
