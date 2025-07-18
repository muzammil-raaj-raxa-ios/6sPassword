//
//  AppWidget.swift
//  AppWidget
//
//  Created by r a a j on 18/07/2025.
//

import WidgetKit
import SwiftUI

struct UserDataModel: TimelineEntry {
    let date: Date
    let fastestTime: String
    let bestAccuracy: String
}

struct UserDataProvider: TimelineProvider {
    func placeholder(in context: Context) -> UserDataModel {
        UserDataModel(date: Date(), fastestTime: "--", bestAccuracy: "--")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (UserDataModel) -> ()) {
        let entry = UserDataModel(
            date: Date(),
            fastestTime: fetchFastestTime(),
            bestAccuracy: fetchbestAccuracy()
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<UserDataModel>) -> ()) {
        let now = Date()
        let entry = UserDataModel(
            date: now,
            fastestTime: fetchFastestTime(),
            bestAccuracy: fetchbestAccuracy()
        )
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
    private func fetchFastestTime() -> String {
        let sharedDefaults = UserDefaults(suiteName: "group.fastestTime")
        let fastestTime = sharedDefaults?.string(forKey: "fastestTime") ?? "0.0s"
        print("Widget read time:", fastestTime)
        return fastestTime
    }
    
    private func fetchbestAccuracy() -> String {
        let sharedDefaults = UserDefaults(suiteName: "group.fastestTime")
        let bestAccuracy = sharedDefaults?.string(forKey: "bestAccuracy") ?? "0%"
        print("best accuracy:", bestAccuracy)
        return bestAccuracy
    }
}


struct FastestTimeWidgetEntryView: View {
    var entry: UserDataModel
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack(spacing: 0) {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.yellow)
                    .font(.title)
                    .padding(.bottom, 8)
                
                Text("Fastest Time")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .medium))
                
                Text("\(entry.fastestTime)s")
                    .foregroundColor(.yellow)
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
            .containerBackground(for: .widget) {
                Color("PRIMARY")
            }
            
        case .systemMedium:
            HStack(spacing: 70) {
                VStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.yellow)
                        .font(.title2)
                    Text("Fastest")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Text("\(entry.fastestTime)s")
                        .foregroundColor(.yellow)
                        .font(.title2)
                        .bold()
                }
                
                VStack(spacing: 6) {
                    Image(systemName: "target")
                        .foregroundColor(.yellow)
                        .font(.title2)
                    Text("Accuracy")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Text("\(entry.bestAccuracy)%")
                        .foregroundColor(.yellow)
                        .font(.title2)
                        .bold()
                }
            }
            .padding()
            .containerBackground(for: .widget) {
                Color("PRIMARY")
            }
            
        default:
            EmptyView()
        }
    }
}

@main
struct FastestTimeWidget: Widget {
    let kind: String = "FastestTimeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UserDataProvider()) { entry in
            FastestTimeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Fastest Time")
        .description("See your best typing speed.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
