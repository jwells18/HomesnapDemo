//
//  HSPullupController.swift
//  Homesnap
//
//  Created by Justin Wells on 3/31/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//  
//  Fork of PullupController created by Mario Iannotta https://github.com/MarioIannotta/PullUpController)

import UIKit

protocol PullupControllerDelegate {
    func pullupControllerDidDismiss()
    func pullupControllerDidPan(currentHeight: CGFloat)
}

open class HSPullupController: UIViewController {
    
    private var leftConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    var pullupControllerDelegate: PullupControllerDelegate!
    var visibleHeight = CGFloat(50)
    
    //Initial Height of PullupController
    open var pullUpControllerPreviewOffset: CGFloat{
        return 50
    }
    
    //Preferred Portrait Controller Size
    open var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 400)
    }
    
    //Preferred Landscape Controller Size
    open var pullUpControllerPreferredLandscapeFrame: CGRect {
        return CGRect(x: 10, y: 10, width: 300, height: UIScreen.main.bounds.height - 20)
    }
    
    open var isDismissable: Bool{
        return true
    }
    
    open var dismissableHeight: CGFloat{
        return 150
    }

    open func dismiss(){
        self.pullupControllerDelegate.pullupControllerDidDismiss()
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    /**
     A list of y values, in screen units expressed in the pull up controller coordinate system.
     At the end of the gestures the pull up controller will scroll to the nearest point in the list.
     
     Please keep in mind that this array should contains only sticky points in the middle of the pull up controller's view;
     There is therefore no need to add the fist one (pullUpControllerPreviewOffset), and/or the last one (pullUpControllerPreferredSize.height).
     
     For a complete list of all the sticky points you can use `pullUpControllerAllStickyPoints`.
     */
    open var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return []
    }
    
    /**
     A list of y values, in screen units expressed in the pull up controller coordinate system.
     At the end of the gesture the pull up controller will scroll at the nearest point in the list.
     */
    public final var pullUpControllerAllStickyPoints: [CGFloat] {
        var sc_allStickyPoints = [pullUpControllerPreviewOffset, pullUpControllerPreferredSize.height]
        sc_allStickyPoints.append(contentsOf: pullUpControllerMiddleStickyPoints)
        return sc_allStickyPoints.sorted()
    }
    
    /**
     A Boolean value that determines whether bouncing occurs when scrolling reaches the end of the pull up controller's view size.
     The default value is false.
     */
    open var pullUpControllerIsBouncingEnabled: Bool {
        return false
    }
    
    private var isPortrait: Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }
    
    private var portraitPreviousStickyPointIndex: Int?
    
    /**
     This method will move the pull up controller's view in order to show the provided visible point.
     
     You may use on of `pullUpControllerAllStickyPoints` item to provide a valid visible point.
     - parameter visiblePoint: the y value to make visible, in screen units expressed in the pull up controller coordinate system.
     - parameter completion: The closure to execute after the animation is completed. This block has no return value and takes no parameters. You may specify nil for this parameter.
     */
    open func pullUpControllerMoveToVisiblePoint(_ visiblePoint: CGFloat, completion: (() -> Void)?) {
        //guard isPortrait else { return }
        topConstraint?.constant = (parent?.view.frame.height ?? 0) - visiblePoint
        
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.parent?.view?.layoutIfNeeded()
                //Set Current Height
                let parentViewHeight = self?.parent?.view.frame.height
                let currentHeight = parentViewHeight! - (self?.view.frame.minY)!
                self?.visibleHeight = currentHeight
                self?.pullupControllerDelegate.pullupControllerDidPan(currentHeight: currentHeight)
            },
            completion: { _ in
                completion?()
        }
        )
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let isPortrait = size.height > size.width
        var targetStickyPoint: CGFloat?
        
        if !isPortrait {
            portraitPreviousStickyPointIndex = currentStickyPointIndex
        } else if
            let portraitPreviousStickyPointIndex = portraitPreviousStickyPointIndex,
            portraitPreviousStickyPointIndex < pullUpControllerAllStickyPoints.count
        {
            targetStickyPoint = pullUpControllerAllStickyPoints[portraitPreviousStickyPointIndex]
            self.portraitPreviousStickyPointIndex = nil
        }
        
        coordinator.animate(alongsideTransition: { [weak self] coordinator in
            self?.refreshConstraints(size: size)
            if let targetStickyPoint = targetStickyPoint {
                self?.pullUpControllerMoveToVisiblePoint(targetStickyPoint, completion: nil)
            }
        })
    }
    
    fileprivate func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
        panGestureRecognizer?.minimumNumberOfTouches = 1
        panGestureRecognizer?.maximumNumberOfTouches = 1
        if let panGestureRecognizer = panGestureRecognizer {
            view.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    fileprivate func setupConstraints() {
        guard let parentView = parent?.view else { return }

        topConstraint = view.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0)
        leftConstraint = view.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 0)
        widthConstraint = view.widthAnchor.constraint(equalToConstant: pullUpControllerPreferredSize.width)
        heightConstraint = view.heightAnchor.constraint(equalToConstant: pullUpControllerPreferredSize.height)
        
        NSLayoutConstraint.activate([topConstraint, leftConstraint, widthConstraint, heightConstraint].flatMap { $0 })
    }
    
    private var currentStickyPointIndex: Int {
        let stickyPointTreshold = (self.parent?.view.frame.height ?? 0) - (topConstraint?.constant ?? 0)
        let stickyPointsLessCurrentPosition = pullUpControllerAllStickyPoints.map { abs($0 - stickyPointTreshold) }
        guard let minStickyPointDifference = stickyPointsLessCurrentPosition.min() else { return 0 }
        return stickyPointsLessCurrentPosition.index(of: minStickyPointDifference) ?? 0
    }
    
    private func nearestStickyPointY(yVelocity: CGFloat) -> CGFloat {
        var currentStickyPointIndex = self.currentStickyPointIndex
        if abs(yVelocity) > 700 { // 1000 points/sec = "fast" scroll
            if yVelocity > 0 {
                currentStickyPointIndex = max(currentStickyPointIndex - 1, 0)
            } else {
                currentStickyPointIndex = min(currentStickyPointIndex + 1, pullUpControllerAllStickyPoints.count - 1)
            }
        }
        
        return (parent?.view.frame.height ?? 0) - pullUpControllerAllStickyPoints[currentStickyPointIndex]
    }
    
    @objc private func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        let topConstraint = self.topConstraint!
        let parentViewHeight = parent?.view.frame.height
        
        let yTranslation = gestureRecognizer.translation(in: view).y
        gestureRecognizer.setTranslation(.zero, in: view)
        
        topConstraint.constant += yTranslation
        
        if !pullUpControllerIsBouncingEnabled {
            topConstraint.constant = max(topConstraint.constant, parentViewHeight! - pullUpControllerPreferredSize.height)
            if isDismissable{
                topConstraint.constant = min(topConstraint.constant, parentViewHeight!)
            }
            else{
                topConstraint.constant = min(topConstraint.constant, parentViewHeight! - pullUpControllerPreviewOffset)
            }
        }
        
        if gestureRecognizer.state == .ended {
            //Dismiss or Animate to nearest Sticky Point
            topConstraint.constant = nearestStickyPointY(yVelocity: gestureRecognizer.velocity(in: view).y)
            if isDismissable && self.view.frame.minY > parentViewHeight!-dismissableHeight {
                self.dismiss()
            }
            else{
                
                UIView.animate(
                    withDuration: 0.3,
                    animations: { [weak self] in
                        self?.parent?.view.layoutIfNeeded()
                        //Set Current Height
                        let currentHeight = parentViewHeight! - (self?.view.frame.minY)!
                        self?.visibleHeight = currentHeight
                        self?.pullupControllerDelegate.pullupControllerDidPan(currentHeight: currentHeight)
                    }
                )
            }
        }
    }
    
    fileprivate func setInitialVisibleHeight(){
        self.visibleHeight = self.pullUpControllerPreviewOffset
    }
    
    private func setPortraitConstraints(parentViewSize: CGSize) {
        topConstraint?.constant = parentViewSize.height - pullUpControllerPreviewOffset
        leftConstraint?.constant = (parentViewSize.width - min(pullUpControllerPreferredSize.width, parentViewSize.width))/2
        widthConstraint?.constant = pullUpControllerPreferredSize.width
        heightConstraint?.constant = pullUpControllerPreferredSize.height
    }
    
    private func setLandscapeConstraints() {
        topConstraint?.constant = pullUpControllerPreferredLandscapeFrame.origin.y
        leftConstraint?.constant = pullUpControllerPreferredLandscapeFrame.origin.x
        widthConstraint?.constant = pullUpControllerPreferredLandscapeFrame.width
        heightConstraint?.constant = pullUpControllerPreferredLandscapeFrame.height
    }
    
    fileprivate func refreshConstraints(size: CGSize) {
        if size.width > size.height {
            setLandscapeConstraints()
        } else {
            setPortraitConstraints(parentViewSize: size)
        }
    }
}

extension UIViewController {
    /*
     Adds the specified pull up view controller as a child of the current view controller.
     - parameter pullUpController: the pull up controller to add as a child of the current view controller.
     */
    open func addPullUpController(pullUpController: HSPullupController, attachView: UIView) {
        addChildViewController(pullUpController)
        
        pullUpController.view.translatesAutoresizingMaskIntoConstraints = false
        attachView.addSubview(pullUpController.view)
        
        pullUpController.setInitialVisibleHeight()
        pullUpController.setupPanGestureRecognizer()
        pullUpController.setupConstraints()
        pullUpController.refreshConstraints(size: view.frame.size)
    }
}
