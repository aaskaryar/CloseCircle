//
//  PullToRefresh.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 5/11/22.
//

import Foundation
import SwiftUI

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        //print(geo.frame(in: .named(coordinateSpaceName)).midY)
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            //print(geo.frame(in: .named(coordinateSpaceName)).maxY)
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                } else {
                    Text("⬇️")
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}
