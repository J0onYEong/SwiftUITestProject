//
//  ContentView.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/07/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    var body: some View {
        VStack {
            Button("window message 1") {
                openWindow(value: Message.ID(string: "1"))
            }
            
            Button("window message 2") {
                openWindow(value: Message.ID(string: "2"))
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
