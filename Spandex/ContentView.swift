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
import Sauce

struct Snippet {
    let trigger: String
    let content: String

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
    
    func delete() {
        let eventSource = CGEventSource(stateID: .combinedSessionState)
        let keyDownEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey: CGKeyCode(51),
            keyDown: true)
        
        let keyUpEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey: CGKeyCode(51),
            keyDown: false)
        
        keyDownEvent?.post(tap: .cghidEventTap)
        keyUpEvent?.post(tap: .cghidEventTap)
    }
    
    func insert() {
        let keycode = Sauce.shared.keyCode(for: .v)
        let eventSource = CGEventSource(stateID: .combinedSessionState)
        let keyDownEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey: keycode,
            keyDown: true)
        keyDownEvent?.flags.insert(.maskCommand)

        let keyUpEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey: keycode,
            keyDown: false)
        
        keyDownEvent?.post(tap: .cghidEventTap)
        keyUpEvent?.post(tap: .cghidEventTap)
    }
    
    func insertSnippet(_ snippet: Snippet) {
        print("inserting \(snippet)")
        for _ in snippet.trigger {
            self.delete()
        }
        
        // save current clipboard
        let oldClipboard = NSPasteboard.general.string(forType: .string)
        // set clipbpoard to snippet content
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(snippet.content, forType: .string)
        // insert clipboard
        insert()
        //restore old clipboard to current clipboard
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if let oldClipboard = oldClipboard {
                NSPasteboard.general.setString(snippet.content, forType: .string)
            }
        }
        
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
