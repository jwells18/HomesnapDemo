//
//  CameraController.swift
//  WalkieTalkie
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Photos

class CameraController: UIViewController, CameraViewDelegate {
    
    let camera = Camera()
    private var cameraView: CameraView!
    
    override func viewDidLoad() {
        //Setup View
        self.view.backgroundColor = UIColor.black
        self.configureCamera()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Hide Navigation Bar
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        //Hide Status Bar
        return true
    }
    
    func setupView(){
        //Setup View Finder
        cameraView = CameraView(frame: self.view.frame)
        cameraView.delegate = self
        self.view.addSubview(cameraView)
    }
    
    func configureCamera() {
        camera.prepare {(error) in
            if let error = error {
                print(error)
            }
            else{
                try? self.camera.displayPreview(on: self.cameraView)
                self.camera.flashMode = .off
                self.camera.currentCameraPosition = .rear
            }
        }
    }
    
    //Camera Button Fuctions
    func captureImage(_ sender: UIButton) {
        camera.captureImage {(image, error) in
            if((image) != nil){
                //Image Taken
            }
            else{
                
            }
        }
    }
    
    //Button Delegates
    func backButtonPressed(sender: UIButton){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func toggleFlashButtonPressed(sender: UIButton){
        if camera.flashMode == .on {
            camera.flashMode = .off
            cameraView.toggleFlashButton.setImage(UIImage(named:"flashOff"), for: .normal)
        }
        else {
            camera.flashMode = .on
            cameraView.toggleFlashButton.setImage(UIImage(named:"flashOn"), for: .normal)
        }
    }
    
    func toggleCameraButtonPressed(sender: UIButton){
        do {
            try camera.switchCameras()
        }
        catch {
            print(error)
        }
    }
    
    func captureButtonPressed(sender: UIButton){
        captureImage(sender)
    }
    
    func viewDoubleTapped() {
        //Toggle Camera
        toggleCameraButtonPressed(sender: UIButton())
    }
}
