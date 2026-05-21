//
//  ProfileViewModel.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-05-21.
//

import Foundation
import SwiftUI
import Observation

@Observable

class ProfileViewModel {
    
    var username: String = ""
    var fullName: String = ""
    var email: String = ""
    
    var members: [Member] = []
    
    func addTestMember() {
        members.append(Member(name: "New Member", role: "Member"))
    }
}
