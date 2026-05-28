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
             .overlay(HomeCrewTheme.cardBackground)

            HStack {
                TextField("Skriv ett meddelande...", text: $messageText, axis: .vertical)
                    .lineLimit(1...5)
                    .padding(12)
                    .background(HomeCrewTheme.cardBackground)
                                .foregroundStyle(HomeCrewTheme.textPrimary)
                                .clipShape(
                                               RoundedRectangle(
                                                   cornerRadius: HomeCrewTheme.cornerRadius
                                               )
                                           )
                   // .textFieldStyle(.roundedBorder)
                Button {
                    messages.append(Message(text: messageText, isMe: true))
                    messageText = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundStyle(HomeCrewTheme.background)
                                        .frame(width: 44, height: 44)
                                        .background(HomeCrewTheme.primaryPurple)
                                        .clipShape(Circle())
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
            .background(HomeCrewTheme.background)
        }
        .background(HomeCrewTheme.background)
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
                Circle()
                    .fill(HomeCrewTheme.primaryPurple)
                    .frame(width: 25, height: 25)
                    
                
            }
            Text(message.text)
                .padding(12)
                .background(message.isMe ? HomeCrewTheme.primaryPurple
                            : HomeCrewTheme.cardBackground)
                .foregroundStyle(message.isMe ? HomeCrewTheme.background
                                 : HomeCrewTheme.textPrimary
                             )
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
