//
//  HSSaveButton.swift
//  Homesnap
//
//  Created by Justin Wells on 3/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class HSSaveButton: UIButton{
    
    var filled: Bool = true
    var strokeWidth: CGFloat = 2.0
    var strokeColor: UIColor?
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(heartIn: self.bounds)
        
        if self.strokeColor != nil {
            self.strokeColor?.setStroke()
        } else {
            self.tintColor.setStroke()
        }
        
        bezierPath.lineWidth = self.strokeWidth
        bezierPath.stroke()
        
        if self.filled {
            self.tintColor.setFill()
            bezierPath.fill()
        }
    }
}

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()
        
        //Calculate Radius of Arcs using Pythagoras
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2
        
        //Left Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)
        
        //Top Centre Dip
        self.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))
        
        //Right Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)
        
        //Right Bottom Line
        self.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))
        
        //Left Bottom Line
        self.close()
    }
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
