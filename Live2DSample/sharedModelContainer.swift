//
//  File.swift
//  TOSHESWidgetExtension
//
//  Created by 平井悠貴 on 2024/09/20.
//

// SharedModelContainer.swift
import Foundation
import SwiftData

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Todo.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
