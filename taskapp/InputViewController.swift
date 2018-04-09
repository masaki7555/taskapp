//
//  InputViewController.swift
//  taskapp
//
//  Created by 宇都宮 正暉 on 2018/03/23.
//  Copyright © 2018年 masaki.utsunomiya. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextView: UITextField!
    @IBOutlet weak var addCategory: UIButton!
    
    var task: Task!
    let realm = try! Realm()
    var categoryList:[String] = []
    var pickerView: UIPickerView = UIPickerView()
    var categoryArray = try! Realm().objects(Category.self)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //カテゴリーリスト選択
        var tempArray:[String] = []
        for category in categoryArray {
            tempArray.append(category.name)
        }
        categoryList = tempArray
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true

        titleTextfield.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
        //カテゴリー選択の処理
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(InputViewController.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(InputViewController.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
        
        self.categoryTextView.inputView = pickerView
        self.categoryTextView.inputAccessoryView = toolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextfield.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            let cate = realm.objects(Category.self).filter("name contains 'Fido'")
            cate.tasks.append(task)
            
            
            self.realm.add(self.task, update: true)
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    //カテゴリー選択の処理
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextView.text = categoryList[row]
    }
    @objc func cancel() {
        self.categoryTextView.text = ""
        self.categoryTextView.endEditing(true)
    }
    @objc func done() {
        self.categoryTextView.endEditing(true)
    }
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    


    // タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }

        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
}
