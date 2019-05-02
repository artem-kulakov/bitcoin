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
    
    var visitors: [Double] = [1.0, 1.5, 1.3, 1.4, 1.0, 2.1, 2.2, 1.5]
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateChart), userInfo: nil, repeats: true)
    }
    
    @objc private func updateChart() {
        var chartEntry = [ChartDataEntry]()
        
        
        
        for i in 0..<visitors.count {
            let value = ChartDataEntry(x: Double(i), y: visitors[i])
            chartEntry.append(value)
        }
        
        let line = LineChartDataSet(entries: chartEntry, label: "Visitor")
        line.colors = [UIColor.green]
        
        let data = LineChartData()
        data.addDataSet(line)
        
        chtChart.data = data
        chtChart.chartDescription?.text = "Visitors Count"
    }
}

