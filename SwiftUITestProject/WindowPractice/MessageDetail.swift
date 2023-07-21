//
//  MessageDetail.swift
//  SwiftUITestProject
//
//  Created by 최준영 on 2023/07/21.
//

import SwiftUI

struct MessageDetail: View {
    @EnvironmentObject var messageManager: MessageManager
    var messageId: Message.ID?
    
    var body: some View {
        if let id = messageId {
            Text(messageManager.messages[id] ?? "Error in messages")
        }
        else {
            Text("Error")
        }
    }
}

struct MessageDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
