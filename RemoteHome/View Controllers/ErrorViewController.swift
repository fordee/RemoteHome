//
//  ErrorViewController.swift
//  RemoteHome
//
//  Created by John Forde on 9/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

protocol ErrorViewControllerDelegate: AnyObject {
	func handleOkButton()
}

class ErrorViewController: UIViewController {

	let v = PopUpErrorView()
	var message: String?

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {
		super.init(nibName: nil, bundle: nil) // Dummy to allow initialization
		modalPresentationStyle = .custom
		transitioningDelegate = self
	}

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		v.errorView.delegate = self
		v.errorView.render(with: message ?? "")
	}
}

extension ErrorViewController: ErrorViewControllerDelegate {
	func handleOkButton() {
		dismiss(animated: true, completion: nil)
	}
}

extension ErrorViewController: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
	}

	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return SlideInAnimationController()//BounceAnimationController()
	}

	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return SlideOutAnimationController()
	}
}
