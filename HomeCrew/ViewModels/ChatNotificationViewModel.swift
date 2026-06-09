//
//  ChatNotificationViewModel.swift
//  HomeCrew
//
//  Created by Erik on 2026-06-09.
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
@MainActor
final class ChatNotificationViewModel {
    var hasUnreadMessages = false
    var activeChatId: String?

    private let repository = ChatRepository()
    private var chatsListener: ListenerRegistration?

    func startListening(
        householdId: String,
        currentUserId: String
    ) {
        chatsListener?.remove()

        chatsListener = repository.listenToChats(
            householdId: householdId,
            currentUserId: currentUserId
        ) { [weak self] chats in
            Task { @MainActor in
                guard let self else { return }

                self.hasUnreadMessages = chats.contains { chat in
                    guard let chatId = chat.id else { return false }

                    if chatId == self.activeChatId {
                        return false
                    }

                    guard let lastMessageAt = chat.lastMessageAt else {
                        return false
                    }

                    guard let lastReadAt = chat.lastReadAtByUser?[currentUserId] else {
                        return true
                    }

                    return lastMessageAt > lastReadAt
                }
            }
        }
    }

    func setActiveChat(_ chatId: String?) {
        activeChatId = chatId

        if chatId != nil {
            hasUnreadMessages = false
        }
    }

    func stopListening() {
        chatsListener?.remove()
        chatsListener = nil
    }
}
