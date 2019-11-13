//
//  ISINIntervalType.swift
//  ISINGraph
//
//  Created by Victor Sukochev on 13.11.2019.
//  Copyright © 2019 Victor Sukochev. All rights reserved.
//

import Foundation

enum ISINIntervalType: Int
{
    case week = 0;
    case month = 1;
    case yearQuater = 2;
    case yearHalf = 3;
    case year = 4;
    case twoYears = 5;
}

extension ISINIntervalType
{
    func timeInterval() -> TimeInterval
    {
        let dayInterval = 24.0 * 3600.0
        
        switch self {
        case .week: return 7.0 * dayInterval
        case .month: return 30.0 * dayInterval
        case .yearQuater: return 91.0 * dayInterval
        case .yearHalf: return 182.0 * dayInterval
        case .year: return 365.0 * dayInterval
        case .twoYears: return 730.0 * dayInterval
        }
    }
}

extension ISINIntervalType
{
    func label() -> String
    {
        switch self {
        case .week: return "1W"
        case .month: return "1M"
        case .yearQuater: return "3M"
        case .yearHalf: return "6M"
        case .year: return "1Y"
        case .twoYears: return "2Y"
        }
    }
}
