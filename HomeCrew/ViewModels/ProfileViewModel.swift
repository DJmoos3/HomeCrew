//
//  ProfileViewModel.swift
//  HomeCrew
//
//  Created by Urwa Adil on 2026-05-21.
//

//import Foundation
//import SwiftUI
//import Observation
//
//@Observable
//
//class ProfileViewModel {
//    
//    var username: String = ""
//    var fullName: String = ""
//    var email: String = ""
//    
//    var members: [Member] = []
//    
//    func addTestMember() {
//        members.append(Member(name: "New Member", role: "Member"))
//    }
//}
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Observation

@Observable
@MainActor
final class ProfileViewModel {

    var username: String = ""
    var fullName: String = ""
    var email: String = ""

    var members: [Member] = []
    var householdId: String? = nil
    var householdName: String = ""

    func fetchUser() async {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument()

            let data = snapshot.data()

            self.username = data?["username"] as? String ?? ""
            self.fullName = data?["fullName"] as? String ?? ""
            self.email = data?["email"] as? String ?? ""
            self.householdId = data?["householdId"] as? String

            if let householdId {
                await fetchHouseholdMembers(householdId: householdId)
            }

        } catch {
            print("Error fetching user: \(error)")
        }
    }

    func fetchHouseholdMembers(householdId: String) async {

        do {
            let snapshot = try await Firestore.firestore()
                .collection("households")
                .document(householdId)
                .getDocument()

            let data = snapshot.data()
            self.householdName = data?["name"] as? String ?? ""
            
            let memberIds = data?["memberIds"] as? [String] ?? []

            self.members = memberIds.map {
                Member(name: $0, role: "Member")
            }

        } catch {
            print("Error fetching household: \(error)")
        }
    }

    func addTestMember() {
        members.append(Member(name: "New Member", role: "Member"))
    }
}
