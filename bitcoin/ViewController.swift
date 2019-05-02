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

    @IBOutlet weak var btcLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var chtChart: LineChartView!

    @IBAction func buyButton(_ sender: UIButton) {
        if (usd_score >= deal_amount_usd) {
            btc_score += deal_amount_usd / btc_value;
            usd_score -= deal_amount_usd;
        } else {
            btc_score += usd_score / btc_value;
            usd_score = 0;
        }

        let formatter = NumberFormatter()

        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        btcLabel.text = "Ƀ" + formatter.string(from: NSNumber(value: btc_score))!
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        usdLabel.text = formatter.string(from: NSNumber(value: usd_score))!
    }
    
    @IBAction func sellButton(_ sender: UIButton) {
        if (btc_score >= deal_amount_btc) {
            usd_score += deal_amount_btc * btc_value;
            btc_score -= deal_amount_btc;
        } else {
            usd_score += btc_score * btc_value;
            btc_score = 0;
        }

        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        btcLabel.text = "Ƀ" + formatter.string(from: NSNumber(value: btc_score))!
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        usdLabel.text = formatter.string(from: NSNumber(value: usd_score))!
    }
    
    var timer = Timer()
    var chartEntry = [ChartDataEntry]()
    var x = 0
    
    // Initial score
    var btc_score = 0.0;
    var usd_score = 100000.0;
    var deal_amount = 10000.0;
    
    // Deal amount
    var deal_amount_usd = 0.0;
    var deal_amount_btc = 0.0;
    
    // BTC change
    var random = Double();
    var max_btc_change = 50.0; // percent
    var min_btc_change = 33.0; // percent
    var btc_change = Double();
    
    // BTC value
    var btc_value = 5000.0;
    var btc_value_change = Double();
    var btc_value_change_per_second = Double();
    
    // Trend duration
    var max_trend_duration = 3.0;
    var min_trend_duration = 1.0;
    var trend_duration = 0.0;

    override func viewDidLoad() {
        super.viewDidLoad()
        fillInitialChartEntry()
        scheduledTimerWithTimeInterval()
    }

    func fillInitialChartEntry() {
        let initialData = [4900.0, 5100.0, 5300.0, 5500.0, 5200.0, 4900.0, 4600.0, 4700.0, 4500.0, 4700.0, 4900.0, 5000.0]
        for i in 0...11 {
            let value = ChartDataEntry(x: Double(i-12), y: initialData[i])
            chartEntry.append(value)
        }
        let line = LineChartDataSet(entries: chartEntry, label: "Visitor")
        line.colors = [UIColor.green]
        
        let data = LineChartData()
        data.addDataSet(line)
        
        chtChart.data = data
        chtChart.chartDescription?.text = "Visitors Count"
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1.6, target: self, selector: #selector(self.updateChart), userInfo: nil, repeats: true)
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

        // Show total score
        let total_score = round(btc_score * btc_value + usd_score);
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        
        totalLabel.text = formatter.string(from: NSNumber(value: total_score))!
        
        // Deal amount
        let n = log10(total_score / 100000);
        let clicks = 10 + 10 * n;
        deal_amount_usd = total_score / clicks
        deal_amount_btc = deal_amount_usd / btc_value;

        // Append data to the chart
        let value = ChartDataEntry(x: Double(x), y: btc_value)
        chartEntry.append(value)
        
        // Remove old data from the chart
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

