//
//  Message.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/07/21.
//

import Foundation

class MessageManager: ObservableObject {
    @Published var messages: [Message.ID : String] = [
        Message.ID(string: "1") : "Hello1",
        Message.ID(string: "2") : "Hello2",
        Message.ID(string: "3") : "Hello3",
        Message.ID(string: "4") : "Hello4",
    ]
    
    
    func createNewMessage(message: String) {
        let nextNumber = messages.count+1
        let newMessage = Message(id: Message.ID(string: String(nextNumber)))
        
        messages[newMessage.id] = "Hello\(nextNumber)"
    }
}


struct Message: Identifiable {
    struct ID: Hashable, Codable {
        var string: String
    }
    var id: ID
}
