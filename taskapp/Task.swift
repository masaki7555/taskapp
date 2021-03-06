//
//  Task.swift
//  taskapp
//
//  Created by 宇都宮 正暉 on 2018/03/23.
//  Copyright © 2018年 masaki.utsunomiya. All rights reserved.
//

import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var title = ""
    
    // 内容
    @objc dynamic var contents = ""
    
    /// 日時
    @objc dynamic var date = Date()
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }

    @objc dynamic var owner: Category?
}

class Category: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    let tasks = List<Task>()
    override static func primaryKey() -> String? {
        return "id"
    }
}
