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

	//private let service = DeviceService()

	var user: AWSCognitoIdentityUser?
	var userAttributes: [AWSCognitoIdentityProviderAttributeType]?
	var mfaSettings: [AWSCognitoIdentityProviderMFAOptionType]?

	var tokenString: String?



	//let tempDataApi = TempDataApi.shared
	var menuItems: [MenuItem] = [MenuItem(menuName: "Dashboard", iconName: "HeatIcon"),		// 0
		MenuItem(menuName: "Rooms", iconName: "HeatIcon"),				// 1
		MenuItem(menuName: "Scenes", iconName: "HeatIcon"),			// 2
		MenuItem(menuName: "Heating", iconName: "HeatIcon"),			// 3
		MenuItem(menuName: "Lighting", iconName: "HeatIcon"),		// 4
		MenuItem(menuName: "Settings", iconName: "HeatIcon"),		// 5
		MenuItem(menuName: "Logout", iconName: "HeatIcon")]			// 6


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

		loadUserValues()
	}

	func loadUserValues() {
		//self.resetAttributeValues()
		self.fetchUserAttributes()
	}

	func fetchUserAttributes() {
		//self.resetAttributeValues()
		user = AppDelegate.defaultUserPool().currentUser()
		user?.getDetails().continueOnSuccessWith(block: { (task) -> Any? in
			guard task.result != nil else {
				return nil
			}
			self.userAttributes = task.result?.userAttributes
			self.mfaSettings = task.result?.mfaOptions
			self.userAttributes?.forEach({ (attribute) in
				print("Name: " + attribute.name!)
			})
			print("Task: \(task)")
//			DispatchQueue.main.async {
//				self.setAttributeValues()
//			}
			self.fetchAccessId()
			return nil
		})
	}

	func fetchAccessId() {
		guard let user = AppDelegate.defaultUserPool().currentUser() else {
			return
		}
		user.getSession().continueOnSuccessWith(block: { (getSessionTask) -> AnyObject? in
			DispatchQueue.main.async(execute: {
				let getSessionResult = getSessionTask.result
				//let idToken = getSessionResult?.idToken?.tokenString
				self.tokenString = getSessionResult?.idToken?.tokenString
				DeviceDataApi.shared.tokenString = self.tokenString
				//IoTDeviceDataSource.token = self.tokenString
				print("tokenString: \(String(describing: self.tokenString))")

				// Refresh IoT Data and discard the result. This is so that the devices array has data
				_ = DeviceDataApi.shared.refreshDeviceData()
			})
			return nil
		})
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
		case 3:
			let vc = HeatingViewController()
			navigationController?.pushViewController(vc, animated: true)
		case 5:
			let vc = SettingsMenuViewController()
			navigationController?.pushViewController(vc, animated: true)
		case 6:
			user?.signOut()
			fetchUserAttributes()
		default:
			break
		}
	}
}
