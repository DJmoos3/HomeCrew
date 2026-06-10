//
//  ChatRoomViewModel.swift
//  HomeCrew
//
//  Created by Erik on 2026-06-09.
//


import Foundation
import Observation
import FirebaseFirestore

@Observable
@MainActor
final class ChatRoomViewModel {
    var messages: [Message] = []
    var newMessageText = ""
    var errorMessage: String?

    private let repository = ChatRepository()
    private var messagesListener: ListenerRegistration?

    func startListeningToMessages(
        householdId: String,
        chatId: String
    ) {
        messagesListener?.remove()

        messagesListener = repository.listenToMessages(
            householdId: householdId,
            chatId: chatId
        ) { [weak self] messages in
            Task { @MainActor in
                self?.messages = messages
            }
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
        } catch {
            errorMessage = error.localizedDescription
            newMessageText = text
        }
    }

    func markChatAsRead(
        householdId: String,
        chatId: String,
        userId: String
    ) async {
        do {
            try await repository.markChatAsRead(
                householdId: householdId,
                chatId: chatId,
                userId: userId
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func stopListening() {
        messagesListener?.remove()
        messagesListener = nil
    }
}