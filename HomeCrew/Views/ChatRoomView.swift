//
//  ChatRoomView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI

struct ChatRoomView: View {

    @State private var viewModel = ChatViewModel()

    let chatId: String
    let title: String
    let householdId: String
    let currentUserId: String

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.messages) { message in
                        MessageCell(
                            message: message,
                            isMe: message.senderId == currentUserId
                        )
                    }
                }
                .padding()
            }

            Divider()
                .overlay(HomeCrewTheme.cardBackground)

            HStack {
                TextField(
                    "Skriv ett meddelande...",
                    text: $viewModel.newMessageText,
                    axis: .vertical
                )
                .lineLimit(1...5)
                .padding(12)
                .background(HomeCrewTheme.cardBackground)
                .foregroundStyle(HomeCrewTheme.textPrimary)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: HomeCrewTheme.cornerRadius
                    )
                )
                Button {
                    Task {
                        await viewModel.sendMessage(
                            householdId: householdId,
                            chatId: chatId,
                            senderId: currentUserId
                        )
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundStyle(HomeCrewTheme.background)
                        .frame(width: 44, height: 44)
                        .background(HomeCrewTheme.primaryPurple)
                        .clipShape(Circle())
                }
                .disabled(viewModel.newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(HomeCrewTheme.background)
        }
        .background(HomeCrewTheme.background)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMessages(householdId: householdId, chatId: chatId)
        }
    }
}

struct MessageCell: View {

    let message: Message
    let isMe: Bool

    var body: some View {
        HStack {
            if isMe {
                Spacer()
            } else {
                Circle()
                    .fill(HomeCrewTheme.primaryPurple)
                    .frame(width: 25, height: 25)

            }

            Text(message.text)
                .padding(12)
                .background(
                    isMe
                        ? HomeCrewTheme.primaryPurple
                        : HomeCrewTheme.cardBackground
                )
                .foregroundStyle(
                    isMe
                        ? HomeCrewTheme.background
                        : HomeCrewTheme.textPrimary
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(
                    maxWidth: 260,
                    alignment: isMe ? .trailing : .leading
                )

            if !isMe {
                Spacer()
            }
        }
    }
}

#Preview {
    ChatRoomView(chatId: "Test", title: "Test", householdId: "Test", currentUserId: "Test")
}
