//
//  ViewController.swift
//  ISINGraph
//
//  Created by Victor Sukochev on 12.11.2019.
//  Copyright © 2019 Victor Sukochev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "embed_chart_vc", let vc = segue.destination as? ISINChatViewController {
            vc.api = ApiServiceStub()
            vc.isin = "123456789101112"
        }
    }

}

