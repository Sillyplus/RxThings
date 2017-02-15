//
//  TodoListsViewController.swift
//  RxThings
//
//  Created by silly on 14/02/2017.
//  Copyright © 2017 silly. All rights reserved.
//

import UIKit
import SnapKit

class TodoListsViewController: UIViewController {
    var homeList = UITableView()
    var tools:[UIBarButtonItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup View Title
        self.navigationItem.title = "Lists"
        
        // Setup Home List
        homeList = UITableView(frame: self.view.bounds, style: .grouped)
        self.view.addSubview(homeList)
        homeList.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        homeList.backgroundColor = ColorConstant.backgroudColor
        homeList.delegate = self
        homeList.dataSource = self
        
        // Setup ToolBarItem
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Plus Math"), style: .plain, target: self, action: #selector(TodoListsViewController.navigateToAddView))
        let settingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Settings"), style: .plain , target: self, action: #selector(TodoListsViewController.navigateToSettingView))
        tools.append(addButton)
        tools.append(flexibleItem)
        tools.append(settingButton)
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarItems(tools, animated: false)
        
    }
    
    func navigateToAddView() {
        
    }
    
    func navigateToSettingView() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TodoListsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // TODO: Add customize cell and further views
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // Remove white space before separate line
        cell.separatorInset = UIEdgeInsetsMake(0, 0, cell.frame.size.width, 0)
        if cell.responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Setup Cell Image & Title
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Inbox"
            cell.imageView?.image = #imageLiteral(resourceName: "inbox")
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Today"
                cell.imageView?.image = #imageLiteral(resourceName: "star")
            case 1:
                cell.textLabel?.text = "Next"
                cell.imageView?.image = #imageLiteral(resourceName: "task")
            case 2:
                cell.textLabel?.text = "Scheduled"
                cell.imageView?.image = #imageLiteral(resourceName: "schedule")
            case 3:
                cell.textLabel?.text = "Someday"
                cell.imageView?.image = #imageLiteral(resourceName: "box")
            default:
                return cell
            }
        case 2:
            cell.textLabel?.text = "Projects"
            cell.imageView?.image = #imageLiteral(resourceName: "project")
        default:
            return cell
        }
        
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}

