//
//  ISINChartView.swift
//  ISINGraph
//
//  Created by Victor Sukochev on 13.11.2019.
//  Copyright © 2019 Victor Sukochev. All rights reserved.
//

import Macaw

enum ISINChartType
{
    case price
    case yield
}

fileprivate let gridXValuesCount: Int = 6
fileprivate let topAreaRelativeHeight: Double = 0.25
fileprivate let bottomLabelsAreaRelativeHeight: Double = 0.1
fileprivate let labelsRelativeHeight: Double = 0.075
fileprivate let bottomChartRelativeOffset: Double = 0.1
fileprivate let leftChartRelativeOffset: Double = 0.1
fileprivate let labelFont: Font = Font(name: "Helvetica", size: 14, weight: "bold")
fileprivate let gridColor: Color = Color(val: 0xBBBBBB)
fileprivate let selectionColor: Color = Color(val: 0x5555FF)

class ISINChatView: MacawView
{
    var items: [Obligation] = []
    {
        didSet {
            self.update()
        }
    }
    
    var type: ISINChartType = .price
    {
        didSet {
            self.update()
        }
    }
    
    var intervalType: ISINIntervalType = .week
    {
        didSet {
            self.update()
        }
    }
        
    private var minValue: Double = 0.0
    private var maxValue: Double = 0.0
    private var chartValues: [Double] = []
    private var gridDates: [Date] = []
    
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
            self.chart(),
            self.yAxisLabels(),
            self.xAxisLabels(),
            self.intervalsLabels()
        ].group()
    }
    
    private func updateValues()
    {
        self.minValue = Double.infinity
        self.maxValue = 0.0
        self.chartValues.removeAll()
        self.gridDates.removeAll()
        
        let timeIntervalStep = self.intervalType.timeInterval() / Double(gridXValuesCount)
        
        var lastDate = Date.distantPast
        var i: Int = 0
        
        self.items.forEach { item in
            guard item.date.timeIntervalSince(lastDate) > timeIntervalStep else { return }
            
            defer {
                i += 1
            }
            
            lastDate = item.date
            let value = self.type == .price ? item.price : item.yield
            self.chartValues.append(value)
            self.gridDates.append(item.date)
            
            guard i < gridXValuesCount else { return }
            
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
        let bottomLineY = height * (1.0 - bottomChartRelativeOffset)
        let stepX = width / Double(gridXValuesCount)
        let scale = (startY - (height * topAreaRelativeHeight)) / (self.maxValue - self.minValue)
        
        return [
            [
                startY,
                startY - Double(Int((self.maxValue - self.minValue) / 2.0)) * scale,
                startY - Double(Int(self.maxValue - self.minValue)) * scale
            ].map({ y in
                Line(x1: 0.0, y1: y, x2: width, y2: y).stroke(fill: gridColor, width: 1.0)
            }).group(),
            
            (0...gridXValuesCount).map({ i in
                let x = startX + Double(i) * stepX
                return Line(x1: x, y1: 0, x2: x, y2: startY + bottomLabelsAreaRelativeHeight * height).stroke(fill: gridColor, width: 1.0)
                }).group(),
            
            Line(x1: 0.0, y1: bottomLineY, x2: width, y2: bottomLineY).stroke(fill: gridColor, width: 1.0)
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
        
        let chartLabels = self.chartValues.enumerated().filter({ $0.0 > 0 }).map({
            Text(text: String(format: "%.02f", $1),
            font: labelFont,
            fill: Color.black,
            place: Transform.move(
                dx: startX + Double($0) * stepX - 16.0,
                dy: startY - ($1 - self.minValue) * scale - 20.0
            ))
        }).group()
        
        return [
            Polyline(points: polylineData.reduce([], +)).stroke(fill: Color.red, width: 2.0),
            chartLabels
        ].group()
    }
    
    private func border() -> Node
    {
        return Rect(x: 0.0, y: 0.0,
                    w: Double(self.bounds.width),
                    h: Double(self.bounds.height)
        ).stroke(fill: gridColor, width: 1.0)
    }
    
    private func yAxisLabels() -> Node
    {
        let width = Double(self.bounds.width)
        let height = Double(self.bounds.height)
        let startX = width * leftChartRelativeOffset
        let startY = height * (1.0 - bottomLabelsAreaRelativeHeight - bottomChartRelativeOffset)
        let scale = (startY - (height * topAreaRelativeHeight)) / (self.maxValue - self.minValue)
        
        return [
            self.minValue,
            (self.maxValue + self.minValue) /  2.0,
            self.maxValue
            ].map({
                Text(text: "\(Int($0))",
                     font: labelFont,
                     fill: Color.black,
                     place: Transform.move(dx: startX - 16.0, dy: startY - (Double(Int($0 - self.minValue))) * scale - 8.0))
            }).group()
    }
    
    private func xAxisLabels() -> Node
    {
        let width = Double(self.bounds.width)
        let height = Double(self.bounds.height)
        let startX = width * leftChartRelativeOffset
        let startY = height * (1.0 - bottomLabelsAreaRelativeHeight - bottomChartRelativeOffset)
        let stepX = width / Double(gridXValuesCount)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        
        return self.gridDates.enumerated().map({ (i, date) in
                       let x = startX + Double(i) * stepX
            
            return Text(text: dateFormatter.string(from: date),
            font: labelFont,
            fill: Color.black,
            place: Transform.move(dx: x - 16.0, dy: startY + 16.0))
        }).group()
    }
    
    private func intervalsLabels() -> Node
    {
        let width = Double(self.bounds.width)
        let height = Double(self.bounds.height)
        let startX = width * leftChartRelativeOffset
        let y = height * (1.0 - bottomChartRelativeOffset / 2.0) - 8.0
        let stepX = width / 5.0
        
        return (0...5).map({ i in
            let text = Text(text: ISINIntervalType(rawValue: i)!.label(),
            font: labelFont,
            fill: i == self.intervalType.rawValue ? selectionColor : Color.black,
            place: Transform.move(dx: startX + stepX * Double(i), dy: y))
            
            text.onTap { _ in
                self.intervalType = ISINIntervalType(rawValue: i)!
            }
            
            return text
        }).group()
    }
}
