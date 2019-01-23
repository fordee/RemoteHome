//
//  RoomsView.swift
//  RemoteHome
//
//  Created by John Forde on 27/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia
import MagazineLayout

class RoomsView: UIView {

	var listView: UICollectionView!

	weak var delegate: RoomsViewControllerDelegate?

	private lazy var dataSource = RoomDataSource()

	convenience init() {
		self.init(frame: CGRect.zero)

		let collectionViewlayout = MagazineLayout()
		listView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewlayout)
		listView.register(RoomCell.self, forCellWithReuseIdentifier: RoomCell.reuseId)
		listView.delegate = self//superview?.parentViewController as? UICollectionViewDelegateMagazineLayout // TODO: A bit dodgy...
		listView.dataSource = dataSource

		let rooms = DeviceDataApi.shared.rooms

		let section0 = SectionInfo(rooms: rooms)
		dataSource.insert(section0, atSectionIndex: 0)

		render()
	}

	func render() {

		sv([listView])
		backgroundColor = UIColor.backgroundColor
		listView.backgroundColor = UIColor.backgroundColor

		layout(0,
					 |listView|,
					 0)
	}

}

// MARK: UICollectionViewDelegateMagazineLayout
//
extension RoomsView: UICollectionViewDelegateMagazineLayout {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Selected cell: \(indexPath.item)")
		let selectedView = collectionView.cellForItem(at: indexPath)?.contentView
		delegate?.handleCellPressed(indexPath: indexPath, selectedView: selectedView!)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeModeForItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode {
		return MagazineLayoutItemSizeMode.init(widthMode: .halfWidth, heightMode: .dynamic)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForHeaderInSectionAtIndex index: Int) -> MagazineLayoutHeaderVisibilityMode {
		return MagazineLayoutHeaderVisibilityMode.hidden//visible(heightMode: .dynamic)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForBackgroundInSectionAtIndex index: Int) -> MagazineLayoutBackgroundVisibilityMode {
		return MagazineLayoutBackgroundVisibilityMode.visible
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, horizontalSpacingForItemsInSectionAtIndex index: Int) -> CGFloat {
		return 12
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, verticalSpacingForElementsInSectionAtIndex index: Int) -> CGFloat {
		return 12
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForItemsInSectionAtIndex index: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 8, left: 8, bottom: 24, right: 8)
	}

}

