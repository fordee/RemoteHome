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
		self.fetchUserAttributes()
	}

	func fetchUserAttributes() {
		//self.resetAttributeValues()
		user = AppDelegate.defaultUserPool().currentUser()
		user?.getDetails().continueOnSuccessWith { task in
			guard let result = task.result else { return nil }

			self.userAttributes = result.userAttributes
			self.mfaSettings = result.mfaOptions
			self.userAttributes?.forEach { attribute in
				print("Name: " + attribute.name!)
			}
			print("Task: \(task)")
//			DispatchQueue.main.async {
//				self.setAttributeValues()
//			}
			self.fetchAccessId()
			return nil
		}
	}

	func fetchAccessId() {
		guard let user = AppDelegate.defaultUserPool().currentUser() else { return }

		user.getSession().continueOnSuccessWith { getSessionTask in
			DispatchQueue.main.async {
				let getSessionResult = getSessionTask.result
				//let idToken = getSessionResult?.idToken?.tokenString
				self.tokenString = getSessionResult?.idToken?.tokenString
				DeviceDataApi.shared.tokenString = self.tokenString
				// Get IoTData while we are here. TODO: Should return promise here.
				self.refreshIoTData()
			}
		}
	}

	private func refreshIoTData() {
		firstly {
			DeviceDataApi.shared.refreshDeviceData()
			}.catch { error in
			print("We have an error folks: \(error)")
			if let reason = error.getReason() {
				print(reason)
				self.showErrorDialog(reason)
			}
		}
	}

	private func showErrorDialog(_ message: String) {
		let vc = ErrorViewController()
		vc.message = message
		self.present(vc, animated: true, completion:  nil)
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
