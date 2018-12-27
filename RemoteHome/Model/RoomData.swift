//
//  RoomData.swift
//  RemoteHome
//
//  Created by John Forde on 27/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import MagazineLayout
import UIKit

protocol DataSourceCountsProvider {
	var numberOfSections: Int { get }
	func numberOfItemsInSection(withIndex sectionIndex: Int) -> Int
}

// MARK: - SectionInfo

struct SectionInfo {
	//var itemInfos: [ItemInfo]
	var rooms: [Room]
}

// MARK: - ItemInfo

struct ItemInfo {
	let sizeMode: MagazineLayoutItemSizeMode
	let text: String
	let color: UIColor
}
