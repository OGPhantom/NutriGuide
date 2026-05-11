//
//  NutriGuideApp.swift
//  NutriGuide
//
//  Created by Никита Сторчай on 01.05.2026.
//

import SwiftUI
import SwiftData

@main
struct NutriGuideApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [MealEntry.self, MealIngredient.self, UserProfile.self])
    }
}
