//
//  TodoItem.swift
//  Live2DSample
//
//  Created by 平井悠貴 on 2024/09/15.
//
import SwiftData
import Foundation

import SwiftData
import Foundation

@Model
final class Todo {
    var content: String
    var isDone: Bool
    let registerDate: Date

    init(content: String, isDone: Bool = false) {
        self.content = content
        self.isDone = isDone
        registerDate = Date()
    }
}
