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
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDate)
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
    var config: MonthConfig
    
    init(entry: DayEntry) {
        self.entry = entry
        self.config = MonthConfig.determineConfig(from: entry.date)
    }
    
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(.orange.gradient)
            VStack {
                HStack(spacing:4) {
                    Text(config.emojiText)
                        .font(.title)
                    Text("🎃")
                        .font(.title)
                    Text(entry.date.weekdayDisplayFormat)
                        .font(.title3)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(config.weekdayTextColor)
                    Spacer()
                }
                Text(entry.date.dayDisplayFormat)
                    .font(.system(size:80,weight: .heavy))
                    .foregroundColor(config.dayTextColor)
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
            .configurationDisplayName("Monthly Style Widget")
            .description("The theme of our widget changes based on month.")
            .supportedFamilies([.systemSmall])
            
        }
    
    }
    
    
struct Monthly_Widget1_Previews: PreviewProvider {
    static var previews: some View {
        Monthly_WidgetEntryView(entry: DayEntry(date: dateToDisplay(month: 1,day: 22)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
    }
    
    static func dateToDisplay(month: Int, day: Int) -> Date {
        let components = DateComponents(calendar: Calendar.current,
                                        year: 2022,
                                        month: month,
                                        day: day)
        return Calendar.current.date(from:components)!
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
