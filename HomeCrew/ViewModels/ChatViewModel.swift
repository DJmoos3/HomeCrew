//
//  ChatViewModel.swift
//  HomeCrew
//
//  Created by Erik on 2026-06-04.
//

import Foundation
import Observation

@Observable
@MainActor
final class ChatViewModel {
    var chats: [Chat] = []
    var messages: [Message] = []

    var newMessageText = ""
    var isLoading = false
    var errorMessage: String?

    private let repository = ChatRepository()

    func loadChats(householdId: String, currentUserId: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            chats = try await repository.fetchChats(
                householdId: householdId,
                currentUserId: currentUserId
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadMessages(householdId: String, chatId: String) async {
        do {
            messages = try await repository.fetchMessages(
                householdId: householdId,
                chatId: chatId
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

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

    func sendMessage(
        householdId: String,
        chatId: String,
        senderId: String
    ) async {
        let text = newMessageText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else { return }

        newMessageText = ""

        do {
            try await repository.sendMessage(
                householdId: householdId,
                chatId: chatId,
                senderId: senderId,
                text: text
            )

            await loadMessages(householdId: householdId, chatId: chatId)
        } catch {
            errorMessage = error.localizedDescription
            newMessageText = text
        }
    }
}
