//
//  RankViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 2/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import Charts
class RankViewController: UIViewController,ChartViewDelegate {

    @IBOutlet weak var lb_myrank: UILabel!
    @IBOutlet weak var lb_allrank: UILabel!
    @IBOutlet weak var lb_mypoint: UILabel!
    @IBOutlet weak var chartView: BarChartView!
    var viewModel = ViewModel(){
        didSet{
            //self.updateChartData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRank()
    }
}
extension RankViewController{
    struct Graph {
        var minRange : Int?
        var maxRange : Int?
        var average : Int!
        var no : Int?
    }
    struct ViewModel {
        var graphs = [Graph]()
        var noStudent : Int?
        var score : Double?
    }
    func initRank(){
        APIUser.getRank(success: {(success) in

            if let content = success.value(forKey: "content") as? NSDictionary{
                if let array = content.value(forKey: "graph") as? NSArray{
                    for i in 0..<array.count{
                        if let graph = array[i] as? NSDictionary{
                            var rank = Graph()
                            if let minRange = graph.value(forKey: "minRange") as? Double{
                                rank.minRange = Int(minRange)
                            }
                            if let maxRange = graph.value(forKey: "maxRange") as? Double{
                                rank.maxRange = Int(maxRange)
                            }
                            if let no = graph.value(forKey: "no") as? Int{
                                rank.no = no
                            }
                            self.viewModel.graphs.append(rank)
                        }
                    }
                }
                if let yourRank = content.value(forKey: "yourRank") as? Int{
                    self.lb_myrank.text = "\(yourRank)"
                    
                }
                if let noStudents = content.value(forKey: "noStudents") as?  Int{
                    self.viewModel.noStudent = noStudents
                    self.lb_allrank.text = "/\(noStudents)"
                }
                if let yourScore = content.value(forKey: "yourScore") as? Int{
                        self.viewModel.score = Double(yourScore)
                        self.lb_mypoint.text = "\(yourScore)"
                }
                self.updateChartData()
            }
        })
    }
    func findMin() ->Int{
        var min = Int.max
            for i in 0..<self.viewModel.graphs.count{
                if let maxRange = self.viewModel.graphs[i].maxRange{
                    if maxRange < min{
                        min = maxRange
                    }
                }
            }
        return min
    }
    func findMax() ->Int{
        var max = Int.min
            for i in 0..<self.viewModel.graphs.count{
                if let minRange = self.viewModel.graphs[i].minRange{
                    if minRange > max{
                        max = minRange
                    }
                }
            }
        return max
    }
    func initChart(){
        chartView.delegate = self
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.maxVisibleCount = 60
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        if self.findMin() - 10 < 0{
            xAxis.axisMinimum = 0
        }else{
            xAxis.axisMinimum = Double(self.findMin() - 5)
        }
        xAxis.axisMaximum = Double(self.findMax())
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.positiveSuffix = " คน"
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 3
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        chartView.legend.enabled = false
        chartView.chartDescription?.text = "Procedure score"
        chartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
    }
    func updateChartData() {
        //self.viewModel.graphs.reverse()
        self.initChart()
        self.setDataCount(self.viewModel.graphs.count, range: UInt32(self.viewModel.noStudent ?? 0))
    }
    func setDataCount(_ count: Int, range: UInt32) {
        var colors = [NSUIColor]()
        var yVals = [ChartDataEntry]()
            for i in 0..<self.viewModel.graphs.count{
                var avg = 0
                avg = (self.findMax() - self.findMin()) / self.viewModel.graphs.count
                if let score = self.viewModel.score{
                    if score >= Double (self.viewModel.graphs[i].minRange ?? 0) {
                        if score < Double (self.viewModel.graphs[i].maxRange ?? Int.max){
                            colors.append(Constant().getColorMain())
                        }else{
                            colors.append(NSUIColor(netHex:0xddddddd))
                        }
                    }else{
                        colors.append(NSUIColor(netHex:0xddddddd))
                    }
                }else{
                    colors.append(NSUIColor(netHex:0xddddddd))
                }
                
                yVals.append(BarChartDataEntry(x: Double(self.findMin() + (i * avg)), y: Double(self.viewModel.graphs[i].no!)))
            }
        var set1: BarChartDataSet! = nil
        if let set = chartView.data?.dataSets.first as? BarChartDataSet {
            set1 = set
            set1.values = yVals
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(values: yVals, label: "Number of students")
            set1.colors = colors
            set1.drawValuesEnabled = false
            let data = BarChartData(dataSet: set1)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            data.barWidth = 1
            chartView.data = data
        }
    }
}
