//
//  MenuCell+MenuItem.swift
//  RemoteHome
//
//  Created by John Forde on 4/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

extension MenuItemView {

	func render(with: MenuItem) {
		menuItemLabel.text = with.menuName
		menuIcon.image = with.icon.image
	}

}

