//
//  RemoteViewController.swift
//  RemoteHome
//
//  Created by John Forde on 12/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import IGListKit
import PromiseKit

class HeatingViewController: UIViewController {

	var iotDevices: [IoTDevice] = []
	let v = ControlsView()

	lazy var adapter: ListAdapter = {
		return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
	}()

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Heating"
		NotificationCenter.default.addObserver(self, selector: #selector(refreshDevices), name: .refreshDevices, object: nil)
		// Setup IGListView Adapter
		adapter.collectionView = v.listView
		adapter.dataSource = self
		// Load data into ListKit view
		iotDevices = DeviceDataApi.shared.devices
		self.adapter.performUpdates(animated: true)
		// And refresh data. It may be old.
		firstly {
			DeviceDataApi.shared.fetchAccessId()
		}.then {
			DeviceDataApi.shared.refreshDeviceData()
		}.done { devices in
			self.iotDevices = devices
			self.adapter.performUpdates(animated: true)
		}.catch { error in
			print("Error: \(error)")
			let reason = error.getReason()
			self.showErrorDialog(reason)
		}
	}

	@objc func refreshDevices(_ notification: Notification) {
		print("Notification received. Refreshing data.")
		firstly {
			DeviceDataApi.shared.fetchAccessId()
		}.then {
			DeviceDataApi.shared.refreshDeviceData()
		}.done { devices in
			self.iotDevices = devices
			self.adapter.reloadData(completion: nil)
		}.catch { error in
			print("Error: \(error)")
			let reason = error.getReason()
			self.showErrorDialog(reason)
		}
	}
}

// MARK: List Adapter Data Source
extension HeatingViewController: ListAdapterDataSource {
	func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
		return iotDevices as [ListDiffable]
	}

	func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
		return ControlsSectionController()
	}

	func emptyView(for listAdapter: ListAdapter) -> UIView? {
		return nil
	}
}

