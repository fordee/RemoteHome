//
//  MenuViewController.swift
//  RemoteHome
//
//  Created by John Forde on 8/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import IGListKit
import AWSCognitoIdentityProvider
import PromiseKit

class MenuViewController: UIViewController {

	//let tempDataApi = TempDataApi.shared
	var menuItems: [MenuItem] = [
		MenuItem(menuName: "Rooms", iconName: "HeatIcon"),				// 0
		MenuItem(menuName: "Heating", iconName: "HeatIcon"),			// 1
		MenuItem(menuName: "Automation", iconName: "HeatIcon"),		// 2
		MenuItem(menuName: "Settings", iconName: "HeatIcon"),			// 3
		MenuItem(menuName: "Logout", iconName: "HeatIcon")]				// 4

	let v = MenuView()

	lazy var adapter: ListAdapter = {
		return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
	}()

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Remote Home"

		// Setup IGListView Adapter
		adapter.collectionView = v.listView
		adapter.dataSource = self
		adapter.collectionViewDelegate = self

		refreshIoTData()
		refreshRoomData()
	}

	private func refreshIoTData() {
		firstly {
			DeviceDataApi.shared.fetchAccessId()
		}.then { accessString in
			DeviceDataApi.shared.refreshDeviceData().filterValues { $0.isActive }
		}.done { devices in
			// Do nothing. DeviceDataApi devices is populated.
		}.catch { error in
			let reason = error.getReason()
			self.showErrorDialog(reason)
		}
	}

	private func refreshRoomData() {
		firstly {
			DeviceDataApi.shared.fetchAccessId()
			}.then { accessString in
				DeviceDataApi.shared.refreshRoomData()
			}.done { rooms in
				// Do nothing. DeviceDataApi devices is populated.
			}.catch { error in
				let reason = error.getReason()
				self.showErrorDialog(reason)
		}
	}
}

// MARK: List Adapter Data Source
extension MenuViewController: ListAdapterDataSource {
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

extension MenuViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Did Select Item At: \(indexPath.section)")
		switch indexPath.section {
		case 0:
			let vc = RoomsViewController()
			navigationController?.pushViewController(vc, animated: true)
		case 1:
			let vc = HeatingViewController()
			navigationController?.pushViewController(vc, animated: true)
		case 3:
			let vc = SettingsMenuViewController()
			navigationController?.pushViewController(vc, animated: true)
		case 4:
			DeviceDataApi.shared.user!.signOut() // User should never be nil. Crash if this is the case.
			firstly {
				DeviceDataApi.shared.fetchAccessId()
			}.catch { error in
				let reason = error.getReason()
				self.showErrorDialog(reason)
			}
		default:
			break
		}
	}
}
