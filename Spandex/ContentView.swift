//
//  ContentView.swift
//  Spandex
//
//  Created by Malte Polzin on 21.10.23.
//

import SwiftUI

struct Snippet {
    let trigger: String
    let content: String
}

extension NSEvent {
    var isDelete: Bool {
        keyCode == 53
    }
}

class SpandexModel: ObservableObject {
    init() {
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { (event) in
            guard let characters = event.characters else {return}
            print(characters, event.keyCode)
        }
    }
}
struct ContentView: View {
    @StateObject var model = SpandexModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

enum Color: CaseIterable {
    case blue
    case white
    case red
}

