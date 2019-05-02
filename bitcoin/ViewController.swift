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
        
        // Change BTC value
        btc_value += btc_value_change_per_second;
        
        // Limit bottom level of BTC
        if (btc_value < 500) {
            btc_value = btc_value * (1 + max_btc_change / 100);
        }
        
        // Limit top level of BTC
        if (btc_value > 1000000) {
            btc_value = btc_value * (1 - min_btc_change / 100);
        }

        // Show BTC value
//        var btc_value_output = Math.floor(btc_value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
//        $$(".btc_value").text('$' + btc_value_output);
        
        // Step-decrease trend duration
        trend_duration -= 1;

        // Append data
//        series.append(new Date().getTime(), btc_value);
        
        // Show total score
//        total_score = Math.round(btc_score * btc_value + usd_score);
//        total_score_output = Math.floor(total_score).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
//        $$('.total_score_inner').text('$' + total_score_output);
        
        // Deal amount
//        n = Math.log10(total_score / 100000);
//        clicks = 10 + 10 * n;
//        deal_amount_usd = total_score / clicks
//        deal_amount_usd_output = Math.floor(deal_amount_usd).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        // $$('.deal_amount').text('$' + deal_amount_usd_output);
//        deal_amount_btc = deal_amount_usd / btc_value;

        
//        let y = Double.random(in: 0...10)
        
        let value = ChartDataEntry(x: Double(x), y: btc_value)
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

