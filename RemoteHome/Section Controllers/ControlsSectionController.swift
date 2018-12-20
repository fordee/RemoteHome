//
//  ControlsSectionController.swift
//  RemoteHome
//
//  Created by John Forde on 12/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation
import IGListKit

protocol ControlsSectionControllerDelegate: class {
	func refreshListController()
}

class ControlsSectionController: ListSectionController {

	enum CellClass: Int, CaseIterable {
		case header = 0
		case control
		case temperature
		case fan
		case airflow
	}

	var iotDevice: IoTDevice?
	var expanded = false

	weak var delegate: HeatingViewControllerDelegate?

	override init() {
		super.init()
		NotificationCenter.default.addObserver(self, selector: #selector(collapseCells), name: .collapseCells, object: nil)
	}

	override func numberOfItems() -> Int {
		if expanded {
			guard let iotDevice = iotDevice else { return CellClass.allCases.count }
			if !iotDevice.hvacCommand.on {
				return 2
			} else {
				return CellClass.allCases.count
			}
		} else {
			return 1
		}
	}

	override func didUpdate(to object: Any) {
		precondition(object is IoTDevice)
		iotDevice = (object as! IoTDevice)
	}

	override func cellForItem(at index: Int) -> UICollectionViewCell {

		let cellClass: AnyClass

		guard let cc = CellClass(rawValue: index) else { fatalError("Couldn't get Cell Class from index: \(index)")	}

		switch cc {
		case .header:
			cellClass = HeaderCell.self
		case .control:
			cellClass = ControlCell.self
		case .temperature:
			cellClass = TemperatureCell.self
		case .fan:
			cellClass = FanCell.self
		case .airflow:
			cellClass = AirflowCell.self
		}

		let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)

		guard let iotDevice = iotDevice else { return cell }

		if let cell = cell as? TemperatureCell {
			cell.device = iotDevice
			cell.roomTemperatureView.render(with: iotDevice)
			cell.roomTemperatureView.setTemperatureView.render(with: iotDevice)
			cell.roomTemperatureView.setTemperatureView.delegate = delegate
		} else if let cell = cell as? HeaderCell {
			cell.headerView.render(with: iotDevice)
		} else if let cell = cell as? ControlCell {
			cell.device = iotDevice
			cell.delegate = self
			cell.heatingDelegate = delegate
			cell.render(with: iotDevice)
		} else if let cell = cell as? FanCell {
			cell.device = iotDevice
			cell.delegate = delegate
			cell.render(with: iotDevice)
		} else if let cell = cell as? AirflowCell {
			cell.device = iotDevice
			cell.airflowView.airflowDirectionView.delegate = delegate
			cell.airflowView.airflowDirectionView.render(with: iotDevice)
		}
		return cell
	}

	override func sizeForItem(at index: Int) -> CGSize {
		guard let context = collectionContext else { return .zero}
		let width = context.containerSize.width

		guard let cc = CellClass(rawValue: index) else { fatalError("Couldn't get Cell Class from index: \(index)")	}

		switch cc {
		case .header:
			return CGSize(width: width, height: 56)
		case .control:
			let controlSize = (width - 12) / 3           // (width - sum(padding)) / 3 Controls accross
			let height: CGFloat = (controlSize * 2) + 10 // 2 x Controls horizontally + sum(padding)
			return CGSize(width: width, height: height)
		case .temperature:
			return CGSize(width: width, height: 150)
		case .fan:
			return CGSize(width: width, height: 94)
		case .airflow:
			return CGSize(width: width, height: 156)
		}
	}

	override func didSelectItem(at index: Int) {
		//print("index: \(index)")
		guard let type = iotDevice?.deviceType, DeviceType(rawValue: type) == .heatPump else { return } // Only expand if you are a heat pump
		
		if index == 0 {
			expanded = !expanded
			collectionContext?.performBatch(animated: true, updates: { batchContext in
				batchContext.reload(self)
			})
			if let deviceid = iotDevice?.deviceId, expanded == true {
				// Send notification to collapse all other cells
				NotificationCenter.default.post(name: .collapseCells, object: nil, userInfo: ["deviceid" : deviceid])
			}
		}
	}

	@objc func collapseCells(_ notification: Notification) {
		// Notification to collapse this cell if it isn't the cell that sent it (deteremined by the deviceid).
		if let deviceid = notification.userInfo?["deviceid"] as? String, let thisDeviceid = iotDevice?.deviceId, deviceid != thisDeviceid {
			expanded = false
			collectionContext?.performBatch(animated: true, updates: { batchContext in
				batchContext.reload(self)
			})
		}
	}

}

extension ControlsSectionController: ControlsSectionControllerDelegate {
	func refreshListController() {
		collectionContext?.performBatch(animated: true, updates: { batchContext in
			batchContext.reload(self)
		})
	}
}

extension Notification.Name {
	static let collapseCells = Notification.Name("collapseCells")
}
