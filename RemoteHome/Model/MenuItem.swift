//
//  MenuItem.swift
//  RemoteHome
//
//  Created by John Forde on 4/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import IGListKit

class MenuItem {
	var menuName: String
	var icon: UIImageView

	init(menuName: String, iconName: String) {
		self.menuName = menuName
		self.icon = UIImageView(image: UIImage(named: iconName))
	}

	// MARK: Equatable Protocol
	static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
		return lhs.menuName == rhs.menuName
	}

}

extension MenuItem: ListDiffable {
	public func diffIdentifier() -> NSObjectProtocol {
		return menuName as NSObjectProtocol
	}

	public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		guard let object = object as? MenuItem else { return false }
		return self.menuName == object.menuName
	}
}
