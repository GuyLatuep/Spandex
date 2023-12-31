//
//  SpandexApp.swift
//  Spandex
//
//  Created by Malte Polzin on 21.10.23.
//

import SwiftUI

@main
struct SpandexApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    getPermission()
                })
        }
    }
    
    func getPermission() {
        AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        )
    }
}


