//
//  ViewController.swift
//  DilPieChartDemo
//
//  Created by Apple Dev on 27/7/18.
//  Copyright © 2018 Dil. All rights reserved.
//

import UIKit

class ViewController: UIViewController,DilPieChartDelegate {

    var pieChart:DilPieChart!
    @IBOutlet weak var baseView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart = DilPieChart(frame: self.baseView.frame)
        pieChart.draw(values: [9,7,6,5,4,2,2,5], lables: ["a","s","d","f","g","h","j","k"], selected: 0)
        pieChart.delegate = self
        self.baseView.backgroundColor = UIColor.lightGray
        self.baseView.addSubview(pieChart)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func indexChanged() {
        print("current selected index:\(self.pieChart.selectedIndex)")
    }
}

