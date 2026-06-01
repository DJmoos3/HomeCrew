//
//  ChatView.swift
//  HomeCrew
//
//  Created by Erik on 2026-05-20.
//

import SwiftUI

struct ChatRoom: Identifiable {
    let id = UUID()
    let name: String
}

struct ChatView: View {

    let chatRooms = [
        ChatRoom(name: "Alla"),
        ChatRoom(name: "Anna"),
        ChatRoom(name: "Erik"),
    ]

    var body: some View {

        NavigationStack {

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

                    //Chat Room cards
                    ForEach(chatRooms) { chatRoom in

                        NavigationLink {
                            ChatRoomView(chatRoom: chatRoom)
                        } label: {
                            //Card layout
                            HStack(spacing: 18) {
                                //Profile Icon
                                Circle()
                                    .fill(
                                        HomeCrewTheme.primaryPurple.opacity(
                                            0.15
                                        )
                                    )
                                    .frame(width: 54, height: 54)
                                    .overlay(
                                        //Icon inside circle
                                        Image(systemName: "person.2.fill")
                                            .foregroundStyle(
                                                HomeCrewTheme.primaryPurple
                                            )
                                    )

                                VStack(alignment: .leading, spacing: 4) {

                                    Text(chatRoom.name)
                                        .font(.headline)
                                        .foregroundStyle(
                                            HomeCrewTheme.textPrimary
                                        )

                                    Text("Open conversation")
                                        .font(.subheadline)
                                        .foregroundStyle(
                                            HomeCrewTheme.textSecondary
                                        )
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
                                RoundedRectangle(
                                    cornerRadius: HomeCrewTheme.cornerRadius
                                )
                            )
                        }
                    }
                }
                .padding()
            }
            .background(HomeCrewTheme.background)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationTitle("Chat")
    }
}

#Preview {
    ChatView()
}
