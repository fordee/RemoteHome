//
//  MainMenuSectionController.swift
//  RemoteHome
//
//  Created by John Forde on 7/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation
import IGListKit


class MenuSectionController: ListSectionController {

	var menuItem: MenuItem?
	var itemIndex: Int?

	override init() {
		super.init()
	}

	override func numberOfItems() -> Int {
		return 1
	}

	override func didUpdate(to object: Any) {
		precondition(object is MenuItem)
		menuItem = object as? MenuItem
	}

	override func cellForItem(at index: Int) -> UICollectionViewCell {
		let cell = collectionContext!.dequeueReusableCell(of: MenuViewCell.self, for: self, at: index) as! MenuViewCell
		cell.menuItemView.render(with: menuItem!)
		return cell
	}

	override func sizeForItem(at index: Int) -> CGSize {
		guard let context = collectionContext else { return .zero}
		let width = context.containerSize.width
		return CGSize(width: width, height: 50)
	}

}
