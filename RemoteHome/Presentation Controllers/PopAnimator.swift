//
//  PopAnimator.swift
//  RemoteHome
//
//  Created by John Forde on 31/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

	let duration = 0.5
	var presenting = true
	var originFrame = CGRect.zero

	var dismissCompletion: (()->Void)?

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let containerView = transitionContext.containerView

		//containerView.backgroundColor = .white

		let toView = transitionContext.view(forKey: .to)!
		let modalView = presenting ? toView as! RoomView : transitionContext.view(forKey: .from)! as! RoomView
		modalView.frame = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0)

		let initialFrame = presenting ? originFrame : modalView.frame
		let finalFrame = presenting ? modalView.frame : originFrame

		let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
		let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height

		let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

		if presenting {
			modalView.transform = scaleTransform
			modalView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
			modalView.clipsToBounds = true

		//	(modalView as! RoomView).roomNamelabel.transform = scaleTransform.inverted()
			modalView.temperatureLabel.transform = scaleTransform.inverted()
			modalView.layoutIfNeeded()
		}

		modalView.roomNamelabel.isHidden = true

		containerView.addSubview(toView)
		containerView.bringSubviewToFront(modalView)

		UIView.animate(withDuration: duration,
									 //delay:0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
									 animations: {
										modalView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
										modalView.roomNamelabel.transform = self.presenting ? CGAffineTransform.identity : scaleTransform.inverted()
										modalView.temperatureLabel.transform = self.presenting ? CGAffineTransform.identity : scaleTransform.inverted()
										modalView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
										modalView.layer.cornerRadius = self.presenting ? 0.0 : 20.0 / xScaleFactor
										modalView.layoutIfNeeded()
		}, completion: { _ in
			if !self.presenting {
				self.dismissCompletion?()
			}
			modalView.roomNamelabel.isHidden = false
			transitionContext.completeTransition(true)
		})
	}
}

