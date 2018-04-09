//
//  CategoryController.swift
//  taskapp
//
//  Created by 宇都宮 正暉 on 2018/04/02.
//  Copyright © 2018年 masaki.utsunomiya. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var Categorytext: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var categories = try! Realm().objects(Category.self)
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Cellに値を設定する.
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name

        return cell
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return .delete
    }
    
    
    @IBAction func AddCategory(_ sender: UIButton) {
        let category = Category()
        try! realm.write {
            category.name = self.Categorytext.text!
            if categories.count != 0 {
                category.id = categories.max(ofProperty: "id")! + 1
            }
            self.realm.add(category)
        }
        tableView.reloadData()
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
