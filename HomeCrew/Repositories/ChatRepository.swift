//
//  ChatRepository.swift
//  HomeCrew
//
//  Created by Erik on 2026-06-04.
//

import Foundation
import FirebaseFirestore

final class ChatRepository {
    private lazy var db = Firestore.firestore()

    func fetchChats(householdId: String, currentUserId: String) async throws
        -> [Chat]
    {
        let snapshot =
            try await db
            .collection("households")
            .document(householdId)
            .collection("chats")
            .whereField("memberIds", arrayContains: currentUserId)
            .getDocuments()

        return try snapshot.documents.map {
            try $0.data(as: Chat.self)
        }
    }

    func fetchMessages(householdId: String, chatId: String) async throws
        -> [Message]
    {
        let snapshot =
            try await db
            .collection("households")
            .document(householdId)
            .collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "createdAt")
            .getDocuments()

        return try snapshot.documents.map {
            try $0.data(as: Message.self)
        }
    }

    func createGroupChatIfNeeded(
        householdId: String,
        memberIds: [String]
    ) async throws -> String {
        let snapshot = try await db
            .collection("households")
            .document(householdId)
            .collection("chats")
            .whereField("type", isEqualTo: ChatType.group.rawValue)
            .limit(to: 1)
            .getDocuments()

        if let existingChat = snapshot.documents.first {
            try await existingChat.reference.updateData([
                "memberIds": memberIds
            ])

            return existingChat.documentID
        }

        let ref = try await db
            .collection("households")
            .document(householdId)
            .collection("chats")
            .addDocument(data: [
                "type": ChatType.group.rawValue,
                "title": "Household Chat",
                "memberIds": memberIds,
                "createdAt": FieldValue.serverTimestamp()
            ])

        return ref.documentID
    }

    func createDirectChatIfNeeded(
        householdId: String,
        currentUserId: String,
        otherUserId: String,
        otherUserName: String
    ) async throws -> String {
        let sortedIds = [currentUserId, otherUserId].sorted()
        let directKey = sortedIds.joined(separator: "_")

        let snapshot = try await db
            .collection("households")
            .document(householdId)
            .collection("chats")
            .whereField("directKey", isEqualTo: directKey)
            .limit(to: 1)
            .getDocuments()

        if let existingChat = snapshot.documents.first {
            return existingChat.documentID
        }

        let data: [String: Any] = [
            "type": ChatType.direct.rawValue,
            "title": otherUserName,
            "memberIds": sortedIds,
            "directKey": directKey,
            "createdAt": FieldValue.serverTimestamp()
        ]

        let ref = try await db
            .collection("households")
            .document(householdId)
            .collection("chats")
            .addDocument(data: data)

        return ref.documentID
    }

    func sendMessage(
        householdId: String,
        chatId: String,
        senderId: String,
        text: String
    ) async throws {

        let chatRef = db
            .collection("households")
            .document(householdId)
            .collection("chats")
            .document(chatId)

        try await chatRef
            .collection("messages")
            .addDocument(data: [
            "text": text,
            "senderId": senderId,
            "createdAt": FieldValue.serverTimestamp()
        ])

        try await chatRef.updateData([
            "lastMessage": text,
            "lastMessageAt": FieldValue.serverTimestamp(),
            "lastMessageSenderId": senderId,
            "lastReadAtByUser.\(senderId)": FieldValue.serverTimestamp()
        ])
    }

    func listenToMessages(
        householdId: String,
        chatId: String,
        onChange: @escaping ([Message]) -> Void
    ) -> ListenerRegistration {
        db.collection("households")
            .document(householdId)
            .collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "createdAt")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    onChange([])
                    return
                }

                let messages = documents.compactMap {
                    try? $0.data(as: Message.self)
                }

                onChange(messages)
            }
    }

    func listenToChats(
        householdId: String,
        currentUserId: String,
        onChange: @escaping ([Chat]) -> Void
    ) -> ListenerRegistration {
        db.collection("households")
            .document(householdId)
            .collection("chats")
            .whereField("memberIds", arrayContains: currentUserId)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    onChange([])
                    return
                }

                let chats = documents.compactMap {
                    try? $0.data(as: Chat.self)
                }

                onChange(chats)
            }
    }

    func markChatAsRead(
        householdId: String,
        chatId: String,
        userId: String
    ) async throws {
        try await db
            .collection("households")
            .document(householdId)
            .collection("chats")
            .document(chatId)
            .updateData([
                "lastReadAtByUser.\(userId)": FieldValue.serverTimestamp()
            ])
    }
}
