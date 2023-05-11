//
//  PostView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 4/8/22.
//

import SwiftUI
struct PostModel: Identifiable
{
    var id: String
    var title: String
    var pic: String
    var time: Date
    var user: UserModel
}
