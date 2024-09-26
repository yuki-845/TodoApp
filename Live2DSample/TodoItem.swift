//
//  TodoItem.swift
//  Live2DSample
//
//  Created by 平井悠貴 on 2024/09/15.
//
import SwiftData
import Foundation




@Model
final class Todo {
    var id: UUID
    var content: String
    var isDone: Bool
    var registerDate: Date
    var isHide: Bool
    init(id: UUID = UUID(), content: String, isDone: Bool = false, registerDate: Date = Date(), isHide: Bool = true) {
        self.id = id
        self.content = content
        self.isDone = isDone
        self.registerDate = registerDate
        self.isHide = isHide
    }
}

