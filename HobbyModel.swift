//
//  HobbyModel.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/10/22.
//

import SwiftUI
struct HobbyModel: Identifiable, Equatable, Codable, Hashable{
    static func == (lhs: HobbyModel, rhs: HobbyModel) -> Bool {
            return lhs.id == rhs.id
    }
    
    static let emptyHobby : HobbyModel = HobbyModel(id: "", name: "", url: "", privacy: "", uid: "", followers: nil, categories: nil)
    
    var id: String
    var name: String
    var url: String
    var privacy: String
    var uid: String
    var followers: [String]?
    var pendingFollowers : [String]?
    var categories: [String]?
    
    
}
