//
//  ISINChartViewController.swift
//  ISINGraph
//
//  Created by Victor Sukochev on 12.11.2019.
//  Copyright © 2019 Victor Sukochev. All rights reserved.
//

import UIKit

class ISINChatViewController: UIViewController
{
    var api: ApiService? = nil
    var isin: String? = nil
    {
        didSet {
            self.update()
        }
    }
    
    var items: [Obligation] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func update()
    {
        guard let isin = self.isin else { return }
        
        self.api?.fetch(isin: isin, onSuccess: { [weak self] result in
            self?.items = result
        }, onError: { _ in
                // TODO: handle error
        })
    }
}
