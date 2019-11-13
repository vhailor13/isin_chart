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
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.update()
    }
    
    // MARK: - Private
    
    private func update()
    {
        self.node = [
            self.border(),
            self.grid()
        ].group()
    }
    
    private func grid() -> Node
    {
        let widthStep: Double = 44.0
        let heightStep: Double = 64.0
        let width = Double(self.bounds.width)
        let height = Double(self.bounds.height)
        
        return [
            stride(from: 0.0, through: height, by: heightStep).map({ y in
                Line(x1: 0.0, y1: y, x2: width, y2: y).stroke(fill: Color.black, width: 1.0)
                }).group(),
            stride(from: 0.0, through: width, by: widthStep).map({ x in
                Line(x1: x, y1: 0, x2: x, y2: height).stroke(fill: Color.black, width: 1.0)
                }).group()
        ].group()
    }
    
    private func border() -> Node
    {
        return Rect(x: 0.0, y: 0.0,
                    w: Double(self.bounds.width),
                    h: Double(self.bounds.height)
        ).stroke(fill: Color.black, width: 1.0)
    }
}
