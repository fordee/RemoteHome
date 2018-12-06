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

	//let tempDataApi = TempDataApi.shared
	var tempData: [TempItem] = []
	var temps: [Double] = []
	var humids: [Double] = []
	//var timer: Timer?

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
		iotDevices = TempDataApi.shared.devices

		firstly {
			refreshTempData()
			}.done { returnSting in
				print(returnSting)
				self.iotDevices = TempDataApi.shared.devices
				self.adapter.performUpdates(animated: true)
			}.catch { error in
				print("Error: \(error)")
		}
	}

	private func refreshTempData() -> Promise<String> {
		return Promise { seal in
			TempDataApi.shared.refreshTempData()
			seal.fulfill("Done")
		}
	}

	@objc func refreshDevices(_ notification: Notification) {
		print("Notification received. Refreshing data.")
		firstly {
			refreshTempData()
			}.done { returnSting in
				print("Calling reload data...")
				self.iotDevices = TempDataApi.shared.devices
				self.adapter.reloadData(completion: nil)
			}.catch { error in

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

