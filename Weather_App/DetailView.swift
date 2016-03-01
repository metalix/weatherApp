//
//  DetailView.swift
//  Weather_App
//
//  Created by Rafał Kozłowski on 23.02.2016.
//  Copyright © 2016 Rafał Kozłowski. All rights reserved.
//

import UIKit

class DetailView: UIView {

    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var middleColor: UIColor = UIColor.yellowColor()
    @IBInspectable var endColor: UIColor = UIColor.whiteColor()
    
    override func drawRect(rect: CGRect) {
        
        //Background gradient
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor,middleColor.CGColor, endColor.CGColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 0.5, 1.0]
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: self.bounds.height)
        
        CGContextDrawLinearGradient(context, gradient, endPoint, startPoint, CGGradientDrawingOptions.DrawsBeforeStartLocation)
    }
}
