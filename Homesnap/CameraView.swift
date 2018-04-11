//
//  CameraCaptureButton.swift
//  WalkieTalkie
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol CameraViewDelegate: class {
    func backButtonPressed(sender: UIButton)
    func toggleFlashButtonPressed(sender: UIButton)
    func toggleCameraButtonPressed(sender: UIButton)
    func captureButtonPressed(sender: UIButton)
    func viewDoubleTapped()
}

class CameraView: UIView{
    
    var captureButton: UIButton!
    var photoModeButton: UIButton!
    var toggleCameraButton: UIButton!
    var toggleFlashButton: UIButton!
    var previousButton: UIButton!
    var doubleTapGesture: UITapGestureRecognizer!
    var delegate: CameraViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup Previous Button
        previousButton = UIButton(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        previousButton.setImage(UIImage(named: "back"), for: .normal)
        previousButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        previousButton.tintColor = UIColor.white
        self.addSubview(previousButton)
        
        //Setup Flash Button
        toggleFlashButton = UIButton(frame: CGRect(x: w-10-50-10-50, y: 10, width: 50, height: 50))
        toggleFlashButton.setImage(UIImage(named: "flashOff"), for: .normal)
        toggleFlashButton.addTarget(self, action: #selector(toggleFlashButtonPressed), for: .touchUpInside)
        toggleFlashButton.tintColor = UIColor.white
        self.addSubview(toggleFlashButton)
        
        //Setup Previous Button
        toggleCameraButton = UIButton(frame: CGRect(x: w-10-50, y: 10, width: 50, height: 50))
        toggleCameraButton.setImage(UIImage(named: "toggleCamera"), for: .normal)
        toggleCameraButton.addTarget(self, action: #selector(toggleCameraButtonPressed), for: .touchUpInside)
        toggleCameraButton.tintColor = UIColor.white
        self.addSubview(toggleCameraButton)

        //Setup Capture Button
        captureButton = UIButton(frame: CGRect(x: (w/2)-40, y: h-80-25, width: 80, height: 80))
        captureButton.layer.borderColor = UIColor.white.cgColor
        captureButton.layer.borderWidth = 8
        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        captureButton.addTarget(self, action: #selector(captureButtonPressed), for: .touchUpInside)
        self.addSubview(captureButton)
        
        //Setup Double Tap to Toggle Camera GestureRecognizer
        doubleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewDoubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(doubleTapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    // Button Delegates
    func backButtonPressed(sender: UIButton){
        delegate.backButtonPressed(sender: sender)
    }
    
    func toggleFlashButtonPressed(sender: UIButton){
        delegate.toggleFlashButtonPressed(sender: sender)
    }
    
    func toggleCameraButtonPressed(sender: UIButton){
        delegate.toggleCameraButtonPressed(sender: sender)
    }
    
    func captureButtonPressed(sender: UIButton){
        delegate.captureButtonPressed(sender: sender)
    }
    
    func viewDoubleTapped(){
        delegate.viewDoubleTapped()
    }
}
