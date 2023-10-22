//
//  ContentView.swift
//  Spandex
//
//  Created by Malte Polzin on 21.10.23.
//
/**
 Todo
 1. Text Tracking - done
 2. Snippet Matching
 3. Insert Snippet
 3. a remove trigger text
 3. b insert snippet

 
 
 */


import SwiftUI

struct Snippet {
    let trigger: String
    let content: String
    /**
     example xname
     ##should Match
     -xname
     - xname
     -the xname
     ##shouldn´t match
     -xnot
     -xnam
     -theuxname
     */
    func matches(_ string: String) -> Bool {
        let hasSuffix = string.hasSuffix(trigger)
        let isBoundary = (string.dropLast(trigger.count).last ?? " ").isWhitespace
        return hasSuffix && isBoundary
    }
}
extension Snippet {
    static var examples : [Snippet] = [
        Snippet(trigger: "xname", content: "Malte Polzin"),
        Snippet(trigger: "xsite", content: "polz.in"),
        Snippet(trigger: "xsnippet", content: "StringSnippet(trigger: \"<#trigger#>\", content: \"<#content#>\"),"),
        ]
}
extension NSEvent {
    var isDelete: Bool {
        keyCode == 51
    }
}

class SpandexModel: ObservableObject {
    @Published var text = ""
    @Published var snippets = Snippet.examples
    init() {
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { event in
            self.text = ""
        }
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { (event) in
            guard let characters = event.characters else {return}
            print(characters, event.keyCode)
            if event.isDelete && !self.text.isEmpty {
                self.text.removeLast()
            } else if event.keyCode > 100 {
                self.text = ""
            } else {
                self.text += characters
            }
            
            self.matchsnaippet()
        }
    }
    
    func matchsnaippet() {
        if let match = snippets.first(where: { $0.matches(self.text) }) {
            insertSnippet(match)
        }
    }
    
    func insertSnippet(_ snippet: Snippet) {
        print("inserting \(snippet)")
    }
}

struct ContentView: View {
    @StateObject var model = SpandexModel()
    var body: some View {
        VStack {
            Text("\(model.text)")
            List(model.snippets, id: \.trigger) { snippet in
                HStack {
                    Text(snippet.trigger)
                    Text(snippet.content).lineLimit(1)
                }.foregroundColor(snippet.matches(model.text) ? Color.red : Color.primary)
            }
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}

#Preview {
    ContentView()
}
