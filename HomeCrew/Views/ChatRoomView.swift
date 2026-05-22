//
//  ChatRoomView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isMe: Bool
}

struct ChatRoomView: View {

    let chatRoom: ChatRoom

    @State private var messageText = ""

    @State var messages = [
        Message(text: "Hej!", isMe: true),
        Message(text: "Glöm inte att städa ditt rum", isMe: true),
        Message(text: "Okej", isMe: false),
        Message(text: "Tack!", isMe: true),
    ]

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(messages) { message in
                        MessageCell(message: message)
                    }
                }
                .padding()
            }
            
            Divider()

            HStack {
                TextField("Skriv ett meddelande...", text: $messageText, axis: .vertical)
                    .lineLimit(1...5)
                    .textFieldStyle(.roundedBorder)
                Button {
                    messages.append(Message(text: messageText, isMe: true))
                    messageText = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
        }
        .navigationTitle(chatRoom.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageCell: View {

    let message: Message

    var body: some View {
        HStack {
            if message.isMe {
                Spacer()
            } else {
                Circle().frame(width: 25, height: 25)
            }
            Text(message.text)
                .padding(12)
                .background(message.isMe ? Color.blue : Color.gray.opacity(0.2))
                .foregroundStyle(message.isMe ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(
                    maxWidth: 260,
                    alignment: message.isMe ? .trailing : .leading
                )
            

            if !message.isMe {
                Spacer()
            }

        }
    }
}

#Preview {
    ChatRoomView(
        chatRoom: ChatRoom(name: "Erik")
    )
}
