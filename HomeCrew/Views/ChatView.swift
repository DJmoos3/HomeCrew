//
//  ChatView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI

struct ChatRoom: Identifiable {
    let id = UUID()
    let name: String

}

struct ChatView: View {

    let chatRooms = [
        ChatRoom(name: "Alla"),
        ChatRoom(name: "Anna"),
        ChatRoom(name: "Erik"),
    ]

    var body: some View {
        List(chatRooms) { chatRoom in
            NavigationLink {
                ChatRoomView(chatRoom: chatRoom)
            } label: {
                HStack {
                    Circle()
                        .frame(width: 50, height: 50)
                    Text(chatRoom.name)
                }
            }

        }
//        .navigationTitle("Chat") //Verkar inte fungera pga TabView

    }
}

#Preview {
    ChatView()
}
