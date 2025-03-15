//
//  BirdDiaryApp.swift
//  BirdDiary
//
//  Created by KI on 2024/10/04.
//

import SwiftUI

@main
struct BirdDiaryApp: App {
    @AppStorage("selectedTheme") private var selectedTheme: String = "light" // デフォルトはライトテーマ

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(selectedTheme == "dark" ? .dark : .light)
        }
    }
}
