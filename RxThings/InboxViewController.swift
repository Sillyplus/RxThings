//
//  InboxViewController.swift
//  RxThings
//
//  Created by silly on 17/02/2017.
//  Copyright © 2017 silly. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {
    
    lazy var tasksList = UITableView()
    lazy var inbox: [Task] = TasksManager.singleton.fetchInbox()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = "Inbox"
        
        self.view.addSubview(tasksList)
        tasksList.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tasksList.delegate = self
        tasksList.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension InboxViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return inbox.count
            return 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let task = inbox[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
    
}
