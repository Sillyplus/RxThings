//
//  TaskEditingViewController.swift
//  RxThings
//
//  Created by silly on 15/02/2017.
//  Copyright © 2017 silly. All rights reserved.
//

import UIKit

class TaskEditingViewController: UIViewController {

    lazy var navigationBar = UINavigationBar()
    lazy var bgView = UIView()
    lazy var titleTFBV = UIView()
    lazy var titleTF = UITextField()
    lazy var noteBV = UIView()
    lazy var noteTV = UITextView()
    var keyboardRect = CGRect()
    var task: Task?
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(TaskEditingViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        /// Setup NavigationBar
        let barHeight = CGFloat(64.0)
        let barWidth = self.view.frame.width
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: barWidth, height: barHeight))
        navigationBar.tintColor = .white
        self.view.addSubview(navigationBar)
        let navigationItem = UINavigationItem(title: "To-Do")
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(TaskEditingViewController.cancelAddTask))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(TaskEditingViewController.finishAddTask))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        self.navigationBar.setItems([navigationItem], animated: false)
        
        /// Setup Add View
        self.view.addSubview(bgView)
        bgView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().priority(255)
            make.top.equalTo(navigationBar.frame.height).priority(256)
            make.height.equalToSuperview().priority(257)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(TaskEditingViewController.hideKeyboard))
        tap.cancelsTouchesInView = true
        bgView.addGestureRecognizer(tap)
        
        /// Title
        bgView.addSubview(titleTFBV)
        titleTFBV.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        titleTFBV.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left)
            make.right.equalTo(bgView.snp.right)
            make.width.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(44)
        }
        titleTFBV.addSubview(titleTF)
        titleTF.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        titleTF.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().priority(255)
            make.leftMargin.equalTo(16).priority(256)
        }
        titleTF.returnKeyType = .done
        titleTF.delegate = self
        
        /// Remind
        let remindBV = UIView()
        bgView.addSubview(remindBV)
        remindBV.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        remindBV.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left)
            make.right.equalTo(bgView.snp.right)
            make.width.equalToSuperview()
            make.height.equalTo(88)
            make.top.equalTo(titleTFBV.snp.bottom).offset(44)
        }
        
        /// Due
        let dueDateBV = UIView()
        bgView.addSubview(dueDateBV)
        dueDateBV.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dueDateBV.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left)
            make.right.equalTo(bgView.snp.right)
            make.width.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(remindBV.snp.bottom).offset(44)
        }
        
        /// Note
        bgView.addSubview(noteBV)
        noteBV.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        noteBV.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left)
            make.right.equalTo(bgView.snp.right)
            make.width.equalToSuperview()
            make.height.equalTo(132)
            make.top.equalTo(dueDateBV.snp.bottom).offset(44)
        }
        noteBV.addSubview(noteTV)
        noteTV.delegate = self
        noteTV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        /// Init with Task
        if self.task != nil {
            self.titleTF.text = self.task!.title
            if self.task?.note != nil {
                self.noteTV.text = self.task!.note
            }
        }
    }
    
    func hideKeyboard() {
        titleTF.resignFirstResponder()
        noteTV.resignFirstResponder()
    }
    
    func finishAddTask() {
        if titleTF.text == "" || titleTF.text == nil {
            // TODO: Alert
            return
        }
        self.dismiss(animated: true) { 
            // TODO: Save Task Info
        }
    }
    
    func cancelAddTask() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension TaskEditingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension TaskEditingViewController: UITextViewDelegate {
    
    /// Obtain keyboard size
    func keyboardWillShow(sender: Notification) {
        let userInfo = sender.userInfo
        self.keyboardRect = (userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let timeInterval = 0.25
        let offset = 0 - keyboardRect.height + 64
        UIView.animate(withDuration: timeInterval) {
            self.bgView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(offset)
            })
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let timeInterval = 0.25
        UIView.animate(withDuration: timeInterval) {
            self.bgView.snp.remakeConstraints({ (make) in
                make.edges.equalToSuperview().priority(255)
                make.top.equalTo(self.navigationBar.frame.height).priority(256)
                make.height.equalToSuperview().priority(257)
            })
        }
    }
    
}
