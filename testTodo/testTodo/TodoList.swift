//
//  TodoList.swift
//  testTodo
//
//  Created by 김가빈 on 12/21/23.
//
import Foundation

struct TodoList {
    var title: String = ""
    var content: String?
    var isComplete: Bool = false
    
    init(title: String, content: String?, isComplete: Bool = false) {
        self.title = title
        self.content = content
        self.isComplete = isComplete
    }
}
