//
//  RefreshableScrollView.swift
//  ShadeInc
//
//  Created by Aria Askaryar on 8/15/22.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    
    var id: String
    var onPullUp: (()->Void)?
    var onPullDown: (()->Void)?
    @State var scrollHeight = CGFloat.zero
    @State var contentHeight = CGFloat.zero
    let content: Content

    init(id: String, onPullUp: (()->Void)?, onPullDown: (()->Void)?, @ViewBuilder content: () -> Content) {
        self.id = id
        self.content = content()
        self.onPullUp = onPullUp
        self.onPullDown = onPullDown
    }
    
    var body: some View {
        
        GeometryReader{ scrollProxy in
            
            ScrollView(showsIndicators: false)  {
                
                PullToRefresh(coordinateSpaceName: id) {
                    
                    if let onPullUp = onPullUp{
                        if scrollHeight > contentHeight{
                            onPullUp()
                        }
                    }
                    
                }
                
                VStack(alignment: .center){
                    
                    content
                    
                }
                .background(
                    GeometryReader {
                        Color.clear.preference(key: ContentHeightKey.self, value: $0.size.height)
                    }
                )
                
                if let onPullDown = onPullDown{
                    if scrollHeight < contentHeight{
                        
                        PullUpToRefresh(coordinateSpaceName: id, scrollHeight: scrollHeight){
                            onPullDown()
                        }
                    }
                }
                
//                if onPullUp != nil && scrollHeight < contentHeight{
//
//                    PullUpToRefresh(coordinateSpaceName: id, scrollHeight: scrollHeight){
//                        onPullDown()
//                    }
//                }
            }
            .coordinateSpace(name: id)
            .onChange(of: scrollProxy.size.height, perform: { newValue in
                scrollHeight = newValue
            })
            .onPreferenceChange(ContentHeightKey.self) {
                contentHeight = $0
            }
        }
    }
}

//struct RefreshableScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        RefreshableScrollView()
//    }
//}
