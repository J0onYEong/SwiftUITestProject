//
//  SwiftUITestProjectApp.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/07/21.
//

import SwiftUI

@main
struct SwiftUITestProjectApp: App {
    @StateObject var messageManager = MessageManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        WindowGroup(for: Message.ID.self) { $mesageId in
            MessageDetail(messageId: mesageId)
                .environmentObject(messageManager)
        }
    }
}

