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
    var clearView: UIView?
    var quickInputView: UIView?
    var inputField: UITextField?
    var detailButton: UIButton?
    var keyboardHeight: CGFloat = 0
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Setup View Title
        self.navigationItem.title = "Lists"
        
        /// Setup Home List
        homeList = UITableView(frame: self.view.bounds, style: .grouped)
        self.view.addSubview(homeList)
        homeList.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        homeList.backgroundColor = ColorConstant.backgroudColor
        homeList.delegate = self
        homeList.dataSource = self
        
        /// Setup ToolBarItem
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Plus Math"), style: .plain, target: self, action: #selector(TodoListsViewController.addNewTask))
        let settingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Settings"), style: .plain , target: self, action: #selector(TodoListsViewController.navigateToSettingView))
        tools.append(addButton)
        tools.append(flexibleItem)
        tools.append(settingButton)
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.setToolbarItems(tools, animated: false)
        
        /// Setup QuickInput Bar Views
        clearView = UIView(frame: self.navigationController!.toolbar.frame)
        self.view.addSubview(clearView!)
        clearView?.isHidden = true
        quickInputView = UIView()
        self.clearView?.addSubview(quickInputView!)
        quickInputView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        })
        quickInputView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        inputField = UITextField()
        quickInputView?.addSubview(inputField!)
        inputField?.delegate = self
        inputField?.backgroundColor = .clear
        inputField?.returnKeyType = .send
        inputField?.borderStyle = .roundedRect
        inputField?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 68))
        }
        detailButton = UIButton(type: UIButtonType.detailDisclosure)
        quickInputView?.addSubview(detailButton!)
        detailButton?.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo((inputField?.snp.right)!).offset(5)
            make.right.equalTo(quickInputView!).offset(-5)
            make.top.equalTo(quickInputView!).offset(2)
        }
        detailButton?.addTarget(self, action: #selector(TodoListsViewController.navigateToAddView), for: .touchUpInside)
        detailButton?.isEnabled = false
        
    }
    
    func addNewTask() {
        /// Change QuickInput Bar
        self.navigationController?.setToolbarHidden(true, animated: false)
        clearView?.isHidden = false
        
        // TODO: Obtain real KeyBoard Height
        keyboardHeight = 255
    }
    
    /// Touch other part of the screen, close Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputField?.resignFirstResponder()
        self.clearView?.isHidden = true
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func navigateToAddView() {
        let taskEditingViewController = TaskEditingViewController()
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.present(taskEditingViewController, animated: true) {
            // Do Something
        }
    }
    
    func navigateToSettingView() {
        let settingViewController = SettingViewController()
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.show(settingViewController, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        /// Dispose of any resources that can be recreated.
    }
    
}

extension TodoListsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.detailButton?.isEnabled = true
        /// resize ClearView
        clearView?.frame = self.view.frame
        /// Move quickInputView to the top of the keyboard
        let animationDuration = 0.4
        UIView.animate(withDuration: animationDuration) {
            let frameY = self.view.frame.height - self.keyboardHeight - 44
            self.quickInputView?.frame = CGRect(x: 0, y: frameY, width: self.view.frame.width, height: 44)
            self.quickInputView?.snp.removeConstraints()
            self.quickInputView?.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: frameY, left: 0, bottom: self.keyboardHeight, right: 0))
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.detailButton?.isEnabled = false
        /// Move quickInputView to the buttom of the screen
        let animationDuration = 0.4
        UIView.animate(withDuration: animationDuration) {
            self.quickInputView?.snp.remakeConstraints({ (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            })
        }
        /// resize ClearView after remake quickInpurView constraints
        self.clearView?.frame = CGRect(x: 0, y: self.view.frame.height - 44, width: self.view.frame.width, height: 44)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == nil || textField.text == "" {
            return false
        }
        textField.resignFirstResponder()
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.clearView?.isHidden = true
        
        // TODO: Create Task with TextField text
        let task = Task(title: textField.text!)
        let tasksManager = TasksManager.singleton
        tasksManager.save(task)
        
        /// Clear text
        textField.text = ""
        return true
    }
    
}


extension TodoListsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var newViewController: UIViewController
        
        // TODO: Setup Real NewVC
        switch indexPath.section {
        case 0:
            newViewController = InboxViewController()
        case 1:
            switch indexPath.row {
            case 0:
                newViewController = TodayViewController()
            case 1:
                newViewController = NextViewController()
            case 2:
                newViewController = ScheduledViewController()
            case 3:
                newViewController = SomedayViewController()
            default:
                newViewController = UIViewController()
            }
        case 2:
            newViewController = ProjectsViewController()
        default:
            newViewController = UIViewController()
        }
        
        /// Navigate to Next View
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.show(newViewController, sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        /// Remove white space before separate line
        cell.separatorInset = UIEdgeInsetsMake(0, 0, cell.frame.size.width, 0)
        if cell.responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
        }
        
        /// Setup Cell Image & Title
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

