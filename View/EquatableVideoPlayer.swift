//
//  EquatableVideoPlayer.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 7/28/22.
//

import SwiftUI
import AVKit

struct EquatableVideoPlayer: View, Equatable {
    
    @State var player : AVPlayer
    var url : URL
    var ratio : Double
    var width : CGFloat
    var height : CGFloat
//    var size : CGFloat
//    var shape : Content
    
    var body: some View {
        
        VideoPlayer(player: player)
            //.ignoresSafeArea()
            .aspectRatio(ratio, contentMode: .fit)
            .if(ratio < 1, transform: { view in
                view.scaledToFill()
            })
            .frame(width: width, height: height)
                        
//        .frame(width: size, height:size, alignment: .center)
//        //.clipped()
//        .clipShape(shape)
//        .contentShape(shape)
        
        
    }
    
    static func == (lhs: EquatableVideoPlayer, rhs: EquatableVideoPlayer) -> Bool {
        return lhs.url == rhs.url && lhs.ratio == rhs.ratio
    }
}

//struct EquatableVideoPlayer_Previews: PreviewProvider {
//    static var previews: some View {
//        EquatableVideoPlayer()
//    }
//}
extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
