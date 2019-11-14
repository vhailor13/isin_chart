//
//  ViewController.swift
//  ISINGraph
//
//  Created by Victor Sukochev on 12.11.2019.
//  Copyright © 2019 Victor Sukochev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    fileprivate weak var chartVC: ISINChatViewController?

    @IBOutlet fileprivate weak var typeBtn: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupBtn()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "embed_chart_vc", let vc = segue.destination as? ISINChatViewController {
            vc.api = ApiServiceStub()
            vc.isin = "123456789101112"
            
            self.chartVC = vc
        }
    }
    
    // MARK: - Actions
    
    @IBAction func selectTypeAction()
    {
        let sheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        sheetVC.addAction(UIAlertAction(title: "Price", style: .default, handler: { _ in
            self.typeBtn.setTitle("Price", for: .normal)
            self.chartVC?.type = .price
        }))
        
        sheetVC.addAction(UIAlertAction(title: "Yield", style: .default, handler: { _ in
            self.typeBtn.setTitle("Yield", for: .normal)
            self.chartVC?.type = .yield
        }))
        
        self.present(sheetVC, animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private func setupBtn()
    {
        self.typeBtn.layer.cornerRadius = 22.0
        self.typeBtn.layer.borderWidth = 1.0
        self.typeBtn.layer.borderColor = UIColor.lightGray.cgColor        
    }
}

