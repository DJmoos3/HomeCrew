//
//  ChatListView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI

struct ChatListView: View {

    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(ChatNotificationViewModel.self) private var chatNotificationViewModel
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
                    currentUserId: currentUserId
                )

            }
        }
    }

    private var otherMembers: [Member] {
        householdViewModel.members.filter {
            $0.id != authViewModel.currentUser?.id
        }
    }

    private var groupChatCard: some View {
        Button {
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
                title: "Groupd Chat",
                subtitle: "Chat with everyone in your household",
                systemImage: "person.3.fill"
            )
        }
    }

    private func directChatCard(member: Member) -> some View {
        Button {
            Task {
                guard let householdId = authViewModel.currentUser?.householdId,
                    let currentUserId = authViewModel.currentUser?.id
                else {
                    chatListViewModel.errorMessage = "No user or household found"
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
                subtitle: "Open conversation",
                systemImage: "person.2.fill"
            )
        }
    }

    private func chatCard(
        title: String,
        subtitle: String,
        systemImage: String
    ) -> some View {
        HStack(spacing: 18) {
            Circle()
                .fill(HomeCrewTheme.primaryPurple.opacity(0.15))
                .frame(width: 54, height: 54)
                .overlay(
                    Image(systemName: systemImage)
                        .foregroundStyle(HomeCrewTheme.primaryPurple)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(HomeCrewTheme.textPrimary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(HomeCrewTheme.textSecondary)
            }

            Spacer()

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

    private func loadHousehold() async {

        await authViewModel.fetchCurrentUser()
        guard let householdId = authViewModel.currentUser?.householdId else {
            return
        }

        await householdViewModel.fetchHouseholdMembers(
            householdId: householdId
        )

    }
}
