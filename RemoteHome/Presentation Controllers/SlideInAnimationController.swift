//
//  SlideInPresentationController.swift
//  RemoteHome
//
//  Created by John Forde on 9/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

class SlideInAnimationController: NSObject,
UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext:
		UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.3
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

		if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to), let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {

			let containerView = transitionContext.containerView
			toView.frame = transitionContext.finalFrame(for: toViewController)
			containerView.addSubview(toView)
			let time = transitionDuration(using: transitionContext)

			toView.center.y += containerView.bounds.size.height
			//toView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

			UIView.animate(withDuration: time, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [], animations: {
				toView.center.y -= containerView.bounds.size.height
			}, completion: { finished in
				transitionContext.completeTransition(finished)
			})
		}
	}
}
