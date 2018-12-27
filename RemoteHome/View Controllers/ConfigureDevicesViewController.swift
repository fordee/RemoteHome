//
//  ConfigureDevicesViewController.swift
//  RemoteHome
//
//  Created by John Forde on 9/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import IGListKit
import PromiseKit

protocol ConfigureDevicesViewControllerDelegate: AnyObject {
	func setDeviceAttributes(of deviceid: String, deviceName: String, deviceType: String, isActive: Bool)
}

class ConfigureDevicesViewController: UIViewController {

	var iotDevices: [IoTDevice] = []
	let v = ConfigureView()

	lazy var adapter: ListAdapter = {
		return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
	}()

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Configure Devices"
		
		NotificationCenter.default.addObserver(self, selector: #selector(refreshDevices), name: .refreshDevices, object: nil)

		// Setup IGListView Adapter
		adapter.collectionView = v.listView
		adapter.dataSource = self

		// Load data into ListKit view
		iotDevices = DeviceDataApi.shared.devices
		self.adapter.performUpdates(animated: true)

		// And also perform a refresh
		refreshData()
	}

	@objc func refreshDevices(_ notification: Notification) {
		print("Notification received. Refreshing data.")
		refreshData()
	}

	private func refreshData() {
		firstly {
			DeviceDataApi.shared.fetchAccessId()
		}.then { accessString in
			DeviceDataApi.shared.refreshDeviceData()
		}.done { devices in
			self.iotDevices = devices
			self.adapter.reloadData(completion: nil)
		}.catch { error in
			print(error.localizedDescription)
			let reason = error.getReason()
			print(reason)
			self.showErrorDialog(reason)
		}
	}
}

// MARK: List Adapter Data Source
extension ConfigureDevicesViewController: ListAdapterDataSource {
	func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
		return iotDevices as [ListDiffable]
	}

	func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
		let cdsc = ConfigDeviceSectionController()
		cdsc.delegate = self
		return cdsc
	}

	func emptyView(for listAdapter: ListAdapter) -> UIView? {
		return nil
	}
}

extension ConfigureDevicesViewController: ConfigureDevicesViewControllerDelegate {
	func setDeviceAttributes(of deviceid: String, deviceName: String, deviceType: String, isActive: Bool) {
		print("setDeviceAttributes called")
		firstly {
			DeviceDataApi.shared.fetchAccessId()
		}.then { accessString in
			DeviceDataApi.shared.setDeviceAttributes(of: deviceid, deviceName: deviceName, deviceType: deviceType, isActive: isActive)
		}.catch { error in
			let reason = error.getReason()
			print(reason)
			self.showErrorDialog(reason)
		}
	}
	
}

