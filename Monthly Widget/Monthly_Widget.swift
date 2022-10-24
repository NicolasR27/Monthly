//
//  Monthly_Widget.swift
//  Monthly Widget
//
//  Created by Nicolas Rios on 10/23/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DayEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


struct DayEntry: TimelineEntry {
    let date: Date
   
}

struct Monthly_WidgetEntryView : View {
    var entry: DayEntry
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(.orange.gradient)
            VStack {
                HStack {
                    Text("🎃")
                        .font(.title)
                    Text(entry.date.weekdayDisplayFormat)
                        .font(.title3)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(.black.opacity(0.6))
                    Spacer()
                }
                Text(entry.date.dayDisplayFormat)
                    .font(.system(size:80,weight: .heavy))
                    .foregroundColor(.white.opacity(0.6))
                    Spacer()
            }
        }
        
    }
    
}
    struct Monthly_Widget: Widget {
        let kind: String = "Monthly_Widget"

        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                Monthly_WidgetEntryView(entry: entry)
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
        }
    }
    
    
struct Monthly_Widget1_Previews: PreviewProvider {
    static var previews: some View {
        Monthly_WidgetEntryView(entry: DayEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

    
extension Date {
    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
        
    }
    var dayDisplayFormat: String {
        self.formatted(.dateTime.day())
        
    }
    
}
