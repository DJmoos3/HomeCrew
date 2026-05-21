//
//  ProfileViewModel.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-05-21.
//

import Foundation
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var fullName: String = ""
    @Published var email: String = ""
    
    @Published var members: [Member] = []
    
    func addTestMember() {
        members.append(Member(name: "New Member", role: "Member"))
    }
}
