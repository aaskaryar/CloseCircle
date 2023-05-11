//
//  TestingDataModel.swift
//  ShadeInc
//
//  Created by Randi Gjoni on 4/27/22.
//

import SwiftUI

class TestingDataModel: ObservableObject {
    @Published var lists : [TestModel] = []
    init()
    {
        for x in Constants.names
        {
            lists.append(TestModel(name: x, flip: false))
        }
    }
}


