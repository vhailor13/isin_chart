//
//  ISINChartView.swift
//  ISINGraph
//
//  Created by Victor Sukochev on 13.11.2019.
//  Copyright © 2019 Victor Sukochev. All rights reserved.
//

import Macaw

enum ISINChatType
{
    case price
    case yied
}

fileprivate let gridXValuesCount: Int = 6
fileprivate let topAreaRelativeHeight: Double = 0.1
fileprivate let bottomLabelsAreaRelativeHeight: Double = 0.2
fileprivate let labelsRelativeHeight: Double = 0.075
fileprivate let bottomChartRelativeOffset: Double = 0.1
fileprivate let leftChartRelativeOffset: Double = 0.1

class ISINChatView: MacawView
{
    var items: [Obligation] = []
    {
        didSet {
            self.update()
        }
    }
    
    var type: ISINChatType = .price
    {
        didSet {
            self.update()
        }
    }
    
    var intervalTye: ISINIntervalType = .week
    {
        didSet {
            self.update()
        }
    }
    
    private let gridColor: Color = Color(val: 0xBBBBBB)
    private var minValue: Double = 0.0
    private var maxValue: Double = 0.0
    private var chartValues: [Double] = []
    private var gridXValues: [Double] = []
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.update()
    }
    
    // MARK: - Private
    
    private func update()
    {
        self.updateValues()
        
        self.node = [
            self.border(),
            self.grid(),
            self.chart()
        ].group()
    }
    
    private func updateValues()
    {
        self.minValue = Double.infinity
        self.maxValue = 0.0
        self.chartValues.removeAll()
        self.gridXValues.removeAll()
        
        let timeIntervalStep = self.intervalTye.timeInterval() / Double(gridXValuesCount)
        
        var lastDate = Date.distantPast

        self.items.forEach { item in
            guard item.date.timeIntervalSince(lastDate) > timeIntervalStep else { return }
            
            lastDate = item.date
            let value = self.type == .price ? item.price : item.yield
            self.chartValues.append(value)
            
            if value < self.minValue {
                self.minValue = value
            }
            
            if value > self.maxValue {
                self.maxValue = value
            }
        }
    }
    
    private func grid() -> Node
    {
        let width = Double(self.bounds.width)
        let height = Double(self.bounds.height)
        let startX = width * leftChartRelativeOffset
        let startY = height * (1.0 - bottomLabelsAreaRelativeHeight - bottomChartRelativeOffset)
        let stepX = width / Double(gridXValuesCount)
        let scale = (startY - (height * topAreaRelativeHeight)) / (self.maxValue - self.minValue)
        
        return [
            [
                startY,
                startY - (self.maxValue - self.minValue) / 2.0 * scale,
                startY - (self.maxValue - self.minValue) * scale
            ].map({ y in
                Line(x1: 0.0, y1: y, x2: width, y2: y).stroke(fill: self.gridColor, width: 1.0)
            }).group(),
            
            (0...gridXValuesCount).map({ i in
                let x = startX + Double(i) * stepX
                return Line(x1: x, y1: 0, x2: x, y2: height).stroke(fill: self.gridColor, width: 1.0)
                }).group(),
        ].group()
    }
    
    private func chart() -> Node
    {
        let width = Double(self.bounds.width)
        let height = Double(self.bounds.height)
        let startX = width * leftChartRelativeOffset
        let startY = height * (1.0 - bottomLabelsAreaRelativeHeight - bottomChartRelativeOffset)
        let stepX = width / Double(gridXValuesCount)
        let scale = (startY - (height * topAreaRelativeHeight)) / (self.maxValue - self.minValue)

        let polylineData = self.chartValues.enumerated().map({ [
            startX + Double($0) * stepX,
            startY - ($1 - self.minValue) * scale
            ]
        })
        return Polyline(points: polylineData.reduce([], +)).stroke(fill: Color.red, width: 2.0)
    }
    
    private func border() -> Node
    {
        return Rect(x: 0.0, y: 0.0,
                    w: Double(self.bounds.width),
                    h: Double(self.bounds.height)
        ).stroke(fill: self.gridColor, width: 1.0)
    }
}
