//
//  TOSHESWidgetBundle.swift
//  TOSHESWidget
//
//  Created by 平井悠貴 on 2024/09/20.
//

import WidgetKit
import SwiftUI

@main
struct TOSHESWidgetBundle: WidgetBundle {
    var body: some Widget {
        TaskWidget()
        TOSHESWidgetControl()
        TOSHESWidgetLiveActivity()
    }
}
