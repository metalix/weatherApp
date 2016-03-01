//
//  GraphView.swift
//  Weather_App
//
//  Created by Rafał Kozłowski on 20.02.2016.
//  Copyright © 2016 Rafał Kozłowski. All rights reserved.
//

import UIKit

class GraphView: UIView {

    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.yellowColor()
    @IBInspectable var circleColor: UIColor = UIColor.darkGrayColor()
    
    override func drawRect(rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
       
        //Background gradient
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: self.bounds.height)

        
        //Graph
        let margin: CGFloat = 0
        let columnXPoint = { (column: Double) -> CGFloat in
            let spacer = (width) / CGFloat(graphPoints.count - 1)
            let x: CGFloat = CGFloat(column) * spacer
            return x
        }
        
        let topBorder: CGFloat = 25
        let bottomBorder: CGFloat = 10
        let graphHeight = height - topBorder - bottomBorder
        var maxValue = (graphPoints).maxElement()
        var columnYPoint = { (graphPoint: Double) -> CGFloat in
            var y: CGFloat = CGFloat(graphPoint) / CGFloat(maxValue!) * graphHeight
            y = graphHeight + topBorder - y
            return y
        }
        
        let minValue = (graphPoints).minElement()
        if minValue < 0 {
            maxValue = abs(maxValue!) - minValue!
            
             columnYPoint = { (graphPoint: Double) -> CGFloat in
                var y: CGFloat = CGFloat(graphPoint) / CGFloat(maxValue!) * graphHeight
                y = graphHeight + topBorder - y + (CGFloat(minValue!)/CGFloat(maxValue!) * graphHeight)
                return y
            }
        }
        
        let graphPath = UIBezierPath()
        graphPath.moveToPoint(CGPoint(x:columnXPoint(0), y:columnYPoint(graphPoints[0])))
        
        var pathPoints: [CGPoint] = []
        
        for i in 0..<graphPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(Double(i)), y:columnYPoint(graphPoints[i]))
            pathPoints.append(nextPoint)
        }

        graphPath.interpolatePointsWithHermite(pathPoints)
        
        // Gradient Graph
        CGContextSaveGState(context)
        
        let clippingPath = graphPath.copy() as! UIBezierPath
        clippingPath.addLineToPoint(CGPoint(x: columnXPoint(Double(graphPoints.count - 1)), y: height))
        clippingPath.addLineToPoint(CGPoint(x: columnXPoint(0), y: height))
        clippingPath.closePath()
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue!)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y:self.bounds.height)
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsBeforeStartLocation)
        CGContextRestoreGState(context)
        
        //Circle of the graph
        circleColor.setFill()
        
        for i in 0..<graphPoints.count {
            
            if (i + 1) % 2 == 0 {
                var point = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(graphPoints[i]))
                point.x -= 5.0/2
                point.y -= 5.0/2
                
                let circle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
                circle.fill()
                
                point.x -= 7.0/2
                point.y -= 7.0/2

                let bigCircle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: 12.0, height: 12.0)))
                bigCircle.lineWidth = 3
                circleColor.setStroke()
                bigCircle.stroke()
                
                // Text
                point.x -= 10.0
                point.y -= 20.0
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .Center
                let attrs = [NSFontAttributeName: UIFont(name: "Avenir", size: 14)!,NSForegroundColorAttributeName: circleColor, NSParagraphStyleAttributeName: paragraphStyle]

                let string = "\(graphPoints[i])º"
                string.drawWithRect(CGRect(x: point.x, y: point.y, width: 45 , height: 20), options: .UsesLineFragmentOrigin, attributes: attrs, context: nil)
                
            }
        }
        
    }
}