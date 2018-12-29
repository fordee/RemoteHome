//
//  RoomDataSource.swift
//  RemoteHome
//
//  Created by John Forde on 27/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import MagazineLayout
import UIKit

// MARK: - DataSource

final class RoomDataSource: NSObject {

	private(set) var sectionInfos = [SectionInfo]()

	func insert(_ sectionInfo: SectionInfo, atSectionIndex sectionIndex: Int) {
		sectionInfos.insert(sectionInfo, at: sectionIndex)
	}

	func insert(_ room: Room, atIndex index: Int, inSectionAtIndex sectionIndex: Int) {
		sectionInfos[sectionIndex].rooms.insert(room, at: index)
	}

	func removeSection(atSectionIndex sectionIndex: Int) {
		sectionInfos.remove(at: sectionIndex)
	}

//	func removeItem(atItemIndex itemIndex: Int, inSectionAtIndex sectionIndex: Int) {
//		sectionInfos[sectionIndex].itemInfos.remove(at: itemIndex)
//	}

//	func setHeaderInfo(_ headerInfo: HeaderInfo, forSectionAtIndex sectionIndex: Int) {
//		sectionInfos[sectionIndex].headerInfo = headerInfo
//	}

}

// MARK: UICollectionViewDataSource

extension RoomDataSource: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sectionInfos.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sectionInfos[section].rooms.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomCell.reuseId, for: indexPath) as! RoomCell
		let room = sectionInfos[indexPath.section].rooms[indexPath.item]
		cell.render(with: room)
		return cell
	}

//	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//		let header = collectionView.dequeueReusableSupplementaryView(ofKind: MagazineLayout.SupplementaryViewKind.sectionHeader, withReuseIdentifier: Header.description(), for: indexPath) as! Header
//		header.set(sectionInfos[indexPath.section].headerInfo)
//		return header
//	}

}

// MARK: DataSourceCountsProvider

extension RoomDataSource: DataSourceCountsProvider {

	var numberOfSections: Int {
		return sectionInfos.count
	}

	func numberOfItemsInSection(withIndex sectionIndex: Int) -> Int {
		return sectionInfos[sectionIndex].rooms.count
	}

}

protocol DataSourceCountsProvider {
	var numberOfSections: Int { get }
	func numberOfItemsInSection(withIndex sectionIndex: Int) -> Int
}

// MARK: - SectionInfo

struct SectionInfo {
	//var itemInfos: [ItemInfo]
	var rooms: [Room]
}
