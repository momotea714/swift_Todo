//
//  Task.swift
//  CoreToDo
//
//  Created by Hirono Momotaro on 2017/10/16.
//  Copyright © 2017年 Hirono Momotaro. All rights reserved.
//

import Foundation
import Unbox

struct Task: Unboxable {
    var id: Int
    var category: String
    var name: String
    
    static let _idParamString = "task_id"
    static let _nameParamString = "task_name"
    static let _categoryParamString = "task_category"
    
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.category = try unboxer.unbox(key: "category")
        self.name = try unboxer.unbox(key: "name")
    }
    init() {
        self.id = 0
        self.category = ""
        self.name = ""
    }
    
    static func getDeleteQueryItems(task_id: Int) -> ([URLQueryItem]){
        return [URLQueryItem(name: _idParamString, value: String(task_id))]
    }
    
    static func getInsertQueryItems( task_name: String, task_category: String) -> ([URLQueryItem]){
        return [URLQueryItem(name: _nameParamString, value: task_name),
                URLQueryItem(name: _categoryParamString, value: task_category)]
    }
    
    static func getUpdateQueryItems(task_id: Int, task_name: String, task_category: String) -> ([URLQueryItem]){
        return [URLQueryItem(name: _idParamString, value: String(task_id)),
                URLQueryItem(name: _nameParamString, value: task_name),
                URLQueryItem(name: _categoryParamString, value: task_category)]
    }
}
