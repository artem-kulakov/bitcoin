//
//  ViewController.swift
//  bitcoin
//
//  Created by Artem Kulakov on 02.05.2019.
//  Copyright © 2019 Code Ultras. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var chtChart: LineChartView!
    
    var timer = Timer()
    var chartEntry = [ChartDataEntry]()
    var x = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()
    }

    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateChart), userInfo: nil, repeats: true)
    }
    
    @objc private func updateChart() {
        
        let y = Double.random(in: 0...10)
        
        let value = ChartDataEntry(x: Double(x), y: y)
        chartEntry.append(value)
        
        if chartEntry.count > 12 {
            chartEntry.remove(at: 0)
        }
        
        let line = LineChartDataSet(entries: chartEntry, label: "Visitor")
        line.colors = [UIColor.green]
        
        let data = LineChartData()
        data.addDataSet(line)
        
        chtChart.data = data
        chtChart.chartDescription?.text = "Visitors Count"
        
        x += 1
    }
}

