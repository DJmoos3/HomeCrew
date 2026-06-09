//
//  ChatListView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI

struct ChatListView: View {

    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(ChatNotificationViewModel.self) private
        var chatNotificationViewModel
    @State private var chatListViewModel = ChatListViewModel()

    @State private var householdViewModel = HouseholdViewModel()
    @State private var selectedChatId: String?
    @State private var selectedChatTitle = ""

    var body: some View {

        ScrollView {
            //Vertical layout for all parts
            VStack(spacing: 16) {

                //Header
                VStack(spacing: 10) {
                    //Decorative Icon Container
                    ZStack {
                        //Background Circle
                        Circle()
                            .fill(HomeCrewTheme.primaryPurple.opacity(0.12))
                            .frame(width: 110, height: 110)
                        //Chat icon
                        Image(systemName: "message.fill")
                            .font(.system(size: 46))
                            .foregroundStyle(HomeCrewTheme.primaryPurple)
                        //Second Icon Over-lay
                        Image(
                            systemName: "bubble.left.and.bubble.right.fill"
                        )
                        .font(.system(size: 24))
                        .foregroundStyle(HomeCrewTheme.mintGreen)
                        .offset(x: 34, y: 34)
                    }
                    //Subtext
                    Text("Stay connected with your household")
                        .font(.subheadline)
                        .foregroundStyle(HomeCrewTheme.textSecondary)
                }
                .padding(.top, 20)

                //Section title
                HStack {
                    Text("Chats")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(HomeCrewTheme.textPrimary)

                    Spacer()
                }

                if let errorMessage = chatListViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                groupChatCard

                ForEach(otherMembers) { member in
                    directChatCard(member: member)
                }
            }
            .padding()
        }
        .background(HomeCrewTheme.background)
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadHousehold()
        }
        .navigationDestination(item: $selectedChatId) { chatId in
            if let householdId = authViewModel.currentUser?.householdId,
                let currentUserId = authViewModel.currentUser?.id
            {
                ChatRoomView(
                    chatId: chatId,
                    title: selectedChatTitle,
                    householdId: householdId,
                    currentUserId: currentUserId,
                    members: householdViewModel.members
                )

            }
        }
        .onDisappear {
            chatListViewModel.stopListening()
        }
    }

    private var otherMembers: [Member] {
        householdViewModel.members.filter {
            $0.id != authViewModel.currentUser?.id
        }
    }

    private var groupChatCard: some View {
        let chat = groupChat()
        
        return Button {
            Task {
                guard let householdId = authViewModel.currentUser?.householdId
                else {
                    chatListViewModel.errorMessage = "No household found"
                    return
                }

                let memberIds = householdViewModel.members.map { $0.id }
                if let chatId = await chatListViewModel.openGroupChat(
                    householdId: householdId,
                    memberIds: memberIds
                ) {
                    chatNotificationViewModel.setActiveChat(chatId)
                    selectedChatId = chatId
                    selectedChatTitle = "Group Chat"
                }
            }
        } label: {
            chatCard(
                title: "Group Chat",
                subtitle: subtitle(for: chat),
                timestamp: timestamp(for: chat),
                systemImage: "person.3.fill",
                hasUnread: hasUnreadMessages(for: chat)
            )
        }
    }

    private func directChatCard(member: Member) -> some View {
        let chat = directChat(for: member)
        
        return Button {
            Task {
                guard let householdId = authViewModel.currentUser?.householdId,
                    let currentUserId = authViewModel.currentUser?.id
                else {
                    chatListViewModel.errorMessage =
                        "No user or household found"
                    return
                }

                if let chatId = await chatListViewModel.openDirectChat(
                    householdId: householdId,
                    currentUserId: currentUserId,
                    otherMember: member
                ) {
                    chatNotificationViewModel.setActiveChat(chatId)
                    selectedChatId = chatId
                    selectedChatTitle = member.name
                }
            }
        } label: {
            chatCard(
                title: member.name,
                subtitle: subtitle(for: chat),
                timestamp: timestamp(for: chat),
                systemImage: "person.2.fill",
                hasUnread: hasUnreadMessages(for: chat)
            )
        }
    }

    private func chatCard(
        title: String,
        subtitle: String,
        timestamp: String?,
        systemImage: String,
        hasUnread: Bool = false
    ) -> some View {
        HStack(spacing: 18) {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(HomeCrewTheme.primaryPurple.opacity(0.15))
                    .frame(width: 54, height: 54)
                    .overlay(
                        Image(systemName: systemImage)
                            .foregroundStyle(HomeCrewTheme.primaryPurple)
                    )

                if hasUnread {
                    Circle()
                        .fill(.red)
                        .frame(width: 10, height: 10)
                        .offset(x: 6, y: -6)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(HomeCrewTheme.textPrimary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(HomeCrewTheme.textSecondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }

            Spacer()
            
            if let timestamp {
                Text(timestamp)
                    .font(.caption)
                    .foregroundStyle(HomeCrewTheme.textSecondary)
            }

            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundStyle(HomeCrewTheme.darkBlue)
        }
        .padding()
        .frame(minHeight: HomeCrewTheme.cardHeight)
        .background(HomeCrewTheme.cardBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: HomeCrewTheme.cornerRadius)
        )
    }
    
    private func displayDate(_ date: Date) -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return date.formatted(date: .omitted, time: .shortened)
        }

        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }

        return date.formatted(date: .abbreviated, time: .omitted)
    }
    
    private func timestamp(for chat: Chat?) -> String? {
        guard let date = chat?.lastMessageAt else {
            return nil
        }
        return displayDate(date)
    }

    private func loadHousehold() async {
        await authViewModel.fetchCurrentUser()

        guard let householdId = authViewModel.currentUser?.householdId,
            let currentUserId = authViewModel.currentUser?.id
        else {
            return
        }

        await householdViewModel.fetchHouseholdMembers(
            householdId: householdId
        )

        chatListViewModel.startListeningToChats(
            householdId: householdId,
            currentUserId: currentUserId
        )
    }

    private func groupChat() -> Chat? {
        chatListViewModel.chats.first { $0.type == .group }
    }

    private func directChat(for member: Member) -> Chat? {
        chatListViewModel.chats.first { chat in
            chat.type == .direct && chat.memberIds.contains(member.id)
        }
    }

    private func memberName(for userId: String?) -> String {
        guard let userId else { return "Someone" }

        if userId == authViewModel.currentUser?.id {
            return "You"
        }

        return householdViewModel.members.first { $0.id == userId }?.name
            ?? "Someone"
    }

    private func subtitle(for chat: Chat?) -> String {
        guard let chat else {
            return "No messages yet"
        }

        guard let lastMessage = chat.lastMessage else {
            return "No messages yet"
        }

        let senderName = memberName(for: chat.lastMessageSenderId)

        return "\(senderName): \(lastMessage)"
    }

    private func hasUnreadMessages(for chat: Chat?) -> Bool {
        guard let chat else { return false }

        guard let currentUserId = authViewModel.currentUser?.id else {
            return false
        }

        guard let lastMessageAt = chat.lastMessageAt else {
            return false
        }

        // Visa inte oläst om jag själv skickade senaste meddelandet
        if chat.lastMessageSenderId == currentUserId {
            return false
        }

        guard let lastReadAt = chat.lastReadAtByUser?[currentUserId] else {
            return true
        }

        return lastMessageAt > lastReadAt
    }
}
