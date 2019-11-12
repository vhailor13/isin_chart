//
//  ApiService.swift
//  ISINGraph
//
//  Created by Victor Sukochev on 12.11.2019.
//  Copyright © 2019 Victor Sukochev. All rights reserved.
//

import Foundation

typealias DataBlock = (([Obligation]) -> ())
typealias ErrorBlock = ((Error) -> ())

protocol ApiService
{
    func fetch(isin: String, onSuccess: DataBlock?, onError: ErrorBlock?)
}
