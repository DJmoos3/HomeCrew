//
//  ChatRoomView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI

struct ChatRoomView: View {

    @State private var chatRoomViewModel = ChatRoomViewModel()
    @Environment(ChatNotificationViewModel.self) private
        var chatNotificationViewModel

    let chatId: String
    let title: String
    let householdId: String
    let currentUserId: String
    let members: [Member]

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(chatRoomViewModel.messages) { message in
                        MessageCell(
                            message: message,
                            isMe: message.senderId == currentUserId,
                            senderName: senderName(for: message.senderId),
                            initials: initials(for: message.senderId),
                            avatarColor: avatarColor(for: message.senderId)
                        )
                    }
                }
                .padding()
            }

            Divider()
                .overlay(HomeCrewTheme.cardBackground)

            HStack {
                TextField(
                    "Write a message...",
                    text: $chatRoomViewModel.newMessageText,
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
                        await chatRoomViewModel.sendMessage(
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
                .disabled(
                    chatRoomViewModel.newMessageText
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty
                )
            }
            .padding()
            .background(HomeCrewTheme.background)
        }
        .background(HomeCrewTheme.background)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            chatNotificationViewModel.setActiveChat(chatId)

            chatRoomViewModel.startListeningToMessages(
                householdId: householdId,
                chatId: chatId
            )

            await chatRoomViewModel.markChatAsRead(
                householdId: householdId,
                chatId: chatId,
                userId: currentUserId
            )
        }
        .onChange(of: chatRoomViewModel.messages.count) { _, _ in
            Task {
                await chatRoomViewModel.markChatAsRead(
                    householdId: householdId,
                    chatId: chatId,
                    userId: currentUserId
                )
            }
        }
        .onDisappear {
            chatRoomViewModel.stopListening()
            chatNotificationViewModel.setActiveChat(nil)
        }
    }

    private func member(for userId: String) -> Member? {
        members.first { $0.id == userId }
    }

    private func senderName(for userId: String) -> String {
        if userId == currentUserId {
            return "You"
        }

        return member(for: userId)?.name ?? "Unknown"
    }

    private func initials(for userId: String) -> String {
        let name = member(for: userId)?.name ?? "?"
        let parts = name.split(separator: " ")

        let initials =
            parts
            .prefix(2)
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .joined()

        return initials.isEmpty ? "?" : initials
    }

    private func avatarColor(for userId: String) -> Color {
        let colors: [Color] = [
            .purple,
            .blue,
            .green,
            .orange,
            .pink,
            .teal,
            .indigo,
        ]

        let value = abs(userId.hashValue)
        return colors[value % colors.count]
    }
}

struct MessageCell: View {

    let message: Message
    let isMe: Bool
    let senderName: String
    let initials: String
    let avatarColor: Color

    var body: some View {
        HStack(alignment: .bottom) {
            if isMe {
                Spacer()
            } else {
                avatar
            }

            VStack(alignment: isMe ? .trailing : .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(senderName)
                        .font(.caption)
                        .fontWeight(.semibold)

                    Text(
                        message.createdAt.formatted(
                            date: .abbreviated,
                            time: .shortened
                        )
                    )
                    .font(.caption2)
                }
                .foregroundStyle(HomeCrewTheme.textSecondary)

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
            }

            if !isMe {
                Spacer()
            }
        }
    }

    private var avatar: some View {
        Circle()
            .fill(avatarColor)
            .frame(width: 30, height: 30)
            .overlay {
                Text(initials)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
    }
}

#Preview {
    ChatRoomView(
        chatId: "Test",
        title: "Test",
        householdId: "Test",
        currentUserId: "Test",
        members: []
    )
}
