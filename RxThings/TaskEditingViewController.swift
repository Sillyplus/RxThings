//
//  TaskEditingViewController.swift
//  RxThings
//
//  Created by silly on 15/02/2017.
//  Copyright © 2017 silly. All rights reserved.
//

import UIKit

class TaskEditingViewController: UIViewController {

    var navigationBar: UINavigationBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup NavigationBar
        let barHeight = CGFloat(64.0)
        let barWidth = self.view.frame.width
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: barWidth, height: barHeight))
        navigationBar?.tintColor = .white
        self.view.addSubview(navigationBar!)
        let navigationItem = UINavigationItem(title: "To-Do")
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(TaskEditingViewController.cancelAddTask))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(TaskEditingViewController.finishAddTask))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        self.navigationBar?.setItems([navigationItem], animated: false)
        
        // Setup Add View
        self.view.backgroundColor = .white
    }
    
    func finishAddTask() {
        self.dismiss(animated: true) { 
            // TODO: Save Task Info
        }
    }
    
    func cancelAddTask() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
