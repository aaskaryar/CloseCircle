//
//  PullUpToRefresh.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 6/3/22.
//

import Foundation
import SwiftUI

struct PullUpToRefresh: View {
    
    var coordinateSpaceName: String
    var scrollHeight : CGFloat
    var onRefresh: ()->Void
    @State var needRefresh: Bool = false
    
    var body: some View {
        
        
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY < (scrollHeight - 50)) {
                Spacer()
                    .onAppear {
                        //print(geo.frame(in: .named(coordinateSpaceName)).midY)
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY > (scrollHeight-10)) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            //print(geo.frame(in: .named(coordinateSpaceName)).midY)
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
                
//                VStack(spacing: 10){
//                    Text("minY: \(geo.frame(in: .named(coordinateSpaceName)).minY)")
//                    Text("midY: \(geo.frame(in: .named(coordinateSpaceName)).midY)")
//                    Text("maxY: \(geo.frame(in: .named(coordinateSpaceName)).maxY)")
//                }
                
                Spacer()
            }
        }.padding(.bottom, -50)
    }
}
