//
//  DilBarChart.swift
//  DilBarChartDemo
//
//  Created by Apple Dev on 26/7/18.
//  Copyright © 2018 Dil. All rights reserved.
//

import Foundation
import UIKit
protocol DilPieChartDelegate {
    func indexChanged()
}


class DilPieChart:UIView{
    
    var delegate:DilPieChartDelegate?
    var selectedIndex:Int = 0
    var values:[Double] = []
    var valueSum:Double = 0
    var labels:[String] = []
    
    var startPoints:[CGFloat] = []
    var endPoints:[CGFloat] = []
    var layers:[CAShapeLayer] = []
    
    var centerPoint:CGPoint
    var radius:CGFloat
    var angelOffset:CGFloat = 0
    var colors:[CGColor] = []
    
    // the input frame is the canvas frame, the
    override init(frame: CGRect) {
        let width = (frame.size.width > frame.size.height) ? frame.size.height : frame.size.width
        let height = (frame.size.width > frame.size.height) ? frame.size.height : frame.size.width
        self.centerPoint = CGPoint(x: (frame.origin.x + width) / 2, y: (frame.origin.y + height) / 2)
        self.radius = width * 3 / 8
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height))
        self.backgroundColor = UIColor.white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(sender:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        let longPressRocognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.addGestureRecognizer(longPressRocognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(values:[Double], lables:[String], selected:Int){
        self.angelOffset = values.count <= 1 ? 0 : CGFloat(Double.pi * 2 * 2 / 360)
        self.valueSum = values.reduce(0, +)
        self.values = values
        self.labels = lables
        self.startPoints = []
        self.endPoints = []
        if self.layers.count > 0{
            self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }
        if self.colors.count <= 0 {
            self.values.forEach { (_) in
                self.colors.append(getRandomColor().cgColor)
            }
        }
        self.selectedIndex = selected
        self.layers = []
        if values.count <= 0{
            drawArc(start: 0, end: CGFloat.pi * 2, highlight: false, color:UIColor.red.cgColor)
            self.startPoints.append(0)
            self.endPoints.append(CGFloat.pi * 2)
        }else{
            var start:CGFloat = CGFloat(0)
            for i in 0..<values.count{
                self.startPoints.append(start)
                self.endPoints.append(start + CGFloat( 2 * Double.pi * values[i] / valueSum ))
                drawArc(start:self.startPoints[i], end: self.endPoints[i], highlight: i == self.selectedIndex, color:self.colors[i])
                start = start + CGFloat( 2 * Double.pi * values[i] / valueSum )
            }
        }
    }
    
    func drawArc(start:CGFloat, end:CGFloat, highlight:Bool, color:CGColor){
        let circlePath = UIBezierPath(arcCenter: self.centerPoint, radius: self.radius, startAngle: start, endAngle:end - self.angelOffset, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = highlight ? 8.0 : 3.0
        self.layer.addSublayer(shapeLayer)
        self.layers.append(shapeLayer)
    }
    
    
    @objc func tapped(sender: UITapGestureRecognizer)
    {
        let newIndex = findselectIndex(point:sender.location(in: self))
        if newIndex != self.selectedIndex{
            self.draw(values: self.values, lables: self.labels, selected: newIndex)
            delegate?.indexChanged()
        }
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        let newIndex = findselectIndex(point:sender.location(in: self))
        if newIndex != self.selectedIndex{
            self.draw(values: self.values, lables: self.labels, selected: newIndex)
            delegate?.indexChanged()
        }
    }
    
    func findselectIndex(point:CGPoint)->Int{
        let x = point.x - self.centerPoint.x
        let y = point.y - self.centerPoint.y
        var alpha:CGFloat = 0
        if y > 0 {
            alpha = CGFloat(Double.pi / 2 ) - atan(x/y)
        }else {
            alpha = CGFloat(Double.pi * 3 / 2 ) - atan(x/y)
        }
        for i in 0..<self.startPoints.count {
            if self.startPoints[i] <= alpha && self.endPoints[i] > alpha{
                return i
            }
        }
        return 0
    }
    
    func getRandomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(CGFloat(arc4random_uniform(255)) / 255)
        let green:CGFloat = CGFloat(CGFloat(arc4random_uniform(255)) / 255)
        let blue:CGFloat = CGFloat(CGFloat(arc4random_uniform(255)) / 255)
        
        print("\(red),\(green) ,\(blue) ")
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
}
