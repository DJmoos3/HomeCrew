//
//  ChatListViewModel.swift
//  HomeCrew
//
//  Created by Erik on 2026-06-09.
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
@MainActor
final class ChatListViewModel {
    var chats: [Chat] = []
    var errorMessage: String?

    private let repository = ChatRepository()

    private var chatsListener: ListenerRegistration?

    func openGroupChat(
        householdId: String,
        memberIds: [String]
    ) async -> String? {
        do {
            return try await repository.createGroupChatIfNeeded(
                householdId: householdId,
                memberIds: memberIds
            )
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    func openDirectChat(
        householdId: String,
        currentUserId: String,
        otherMember: Member
    ) async -> String? {
        do {
            return try await repository.createDirectChatIfNeeded(
                householdId: householdId,
                currentUserId: currentUserId,
                otherUserId: otherMember.id,
                otherUserName: otherMember.name
            )
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    func startListeningToChats(
        householdId: String,
        currentUserId: String
    ) {
        chatsListener?.remove()

        chatsListener = repository.listenToChats(
            householdId: householdId,
            currentUserId: currentUserId
        ) { [weak self] chats in
            Task { @MainActor in
                self?.chats = chats
            }
        }
    }

    func stopListening() {
        chatsListener?.remove()
        chatsListener = nil
    }
}
