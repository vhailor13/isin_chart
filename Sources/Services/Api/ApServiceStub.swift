//
//  ApServiceStub.swift
//  ISINGraph
//
//  Created by Victor Sukochev on 12.11.2019.
//  Copyright © 2019 Victor Sukochev. All rights reserved.
//

import Foundation

class ApiServiceStub: ApiService
{
    func fetch(isin: String, onSuccess: DataBlock?, onError: ErrorBlock?)
    {
        let startDate = Date(timeIntervalSince1970: 0)
        let dayInterval: TimeInterval = 24.0 * 3600.0
        let result = (0...1000).map({ Obligation(
            price: Double.random(in: 5.0..<15.0),
            yield: Double.random(in: 2.0..<8.0),
            date: Date(timeInterval: Double($0) * dayInterval, since: startDate)
            )
        })
        
        onSuccess?(result)
    }
}
