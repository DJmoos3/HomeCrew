//
//  ChatListViewModel.swift
//  HomeCrew
//
//  Created by Erik on 2026-06-09.
//


import Foundation
import Observation

@Observable
@MainActor
final class ChatListViewModel {
    var errorMessage: String?

    private let repository = ChatRepository()

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
}