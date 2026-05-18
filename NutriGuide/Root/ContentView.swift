//
//  ContentView.swift
//  NutriGuide
//
//  Created by Никита Сторчай on 01.05.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases) { tab in
                NavigationStack {
                    tab.content
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.systemImage)
                }
                .tag(tab)
            }
        }
        .colorScheme(.light)
        .tint(NutriColors.olive)
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewFixtures.previewContainer(includeMeals: true))
}
