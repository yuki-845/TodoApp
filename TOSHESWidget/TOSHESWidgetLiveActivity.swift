//
//  TOSHESWidgetLiveActivity.swift
//  TOSHESWidget
//
//  Created by 平井悠貴 on 2024/09/20.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TOSHESWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TOSHESWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TOSHESWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TOSHESWidgetAttributes {
    fileprivate static var preview: TOSHESWidgetAttributes {
        TOSHESWidgetAttributes(name: "World")
    }
}

extension TOSHESWidgetAttributes.ContentState {
    fileprivate static var smiley: TOSHESWidgetAttributes.ContentState {
        TOSHESWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TOSHESWidgetAttributes.ContentState {
         TOSHESWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TOSHESWidgetAttributes.preview) {
   TOSHESWidgetLiveActivity()
} contentStates: {
    TOSHESWidgetAttributes.ContentState.smiley
    TOSHESWidgetAttributes.ContentState.starEyes
}
