//
//  SettingViewController.swift
//  RxThings
//
//  Created by silly on 15/02/2017.
//  Copyright © 2017 silly. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = "Setting"
        
        let resetButton = UIButton(type: .roundedRect)
        self.view.addSubview(resetButton)
        resetButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(88)
            make.height.equalTo(44)
        }
        resetButton.titleLabel?.text = "Reset"
        resetButton.setTitle("Reset", for: .normal)
        resetButton.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        resetButton.addTarget(self, action: #selector(SettingViewController.resetData), for: .touchUpInside)
        
    }
    
    func resetData() {
        TasksManager.dropTable()
        TasksManager.createTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
