//
//  SettingsMenuViewController.swift
//  RemoteHome
//
//  Created by John Forde on 9/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import IGListKit

class SettingsMenuViewController: UIViewController {

	//let tempDataApi = TempDataApi.shared
	var menuItems: [MenuItem] = [MenuItem(menuName: "Configure Devices", iconName: "HeatIcon"),
															 MenuItem(menuName: "Rooms", iconName: "HeatIcon"),
															 MenuItem(menuName: "Scenes", iconName: "HeatIcon")]

	let v = MenuView()

	lazy var adapter: ListAdapter = {
		return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
	}()

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Settings"

		// Setup IGListView Adapter
		adapter.collectionView = v.listView
		adapter.dataSource = self
		adapter.collectionViewDelegate = self

	}

}

// MARK: List Adapter Data Source
extension SettingsMenuViewController: ListAdapterDataSource {
	func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
		return menuItems as [ListDiffable]
	}

	func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
		return MenuSectionController()
	}

	func emptyView(for listAdapter: ListAdapter) -> UIView? {
		return nil
	}
}

extension SettingsMenuViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Did Select Item At: \(indexPath.section)")
		switch indexPath.section {
		case 0:
			let vc = ConfigureDevicesViewController()
			navigationController?.pushViewController(vc, animated: true)
			break
		case 1:
			break

		case 2:
			break

		default:
			break
		}
	}
}
