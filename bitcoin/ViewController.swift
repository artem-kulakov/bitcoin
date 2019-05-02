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
    
    // Initial score
    var btc_score = 0;
    var usd_score = 100000;
    var deal_amount = 10000;
    
    // BTC change
    var random = Double();
    var max_btc_change = 50.0; // percent
    var min_btc_change = 33.0; // percent
    var btc_change = Double();
    
    // BTC value
    var btc_value = 10000.0;
    var btc_value_change = Double();
    var btc_value_change_per_second = Double();
    
    // Trend duration
    var max_trend_duration = 3.0;
    var min_trend_duration = 1.0;
    var trend_duration = 0.0;

    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()
    }

    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateChart), userInfo: nil, repeats: true)
    }
    
    @objc private func updateChart() {
        
        if (trend_duration == 0) {
            // Random trend duration
            trend_duration = floor(Double.random(in: 0...1) * (max_trend_duration - min_trend_duration + 1)) + min_trend_duration;
            
            // Random value
            random = Double.random(in: 0...1) * 2 - 1;
            
            // BTC change in %
            if (random > 0) {
                btc_change = random * max_btc_change;
            } else {
                btc_change = random * min_btc_change;
            }
            
            // BTC change in absolute terms
            btc_value_change = btc_value * btc_change / 100;
            btc_value_change_per_second = btc_value_change / trend_duration;
        }

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

