//
//  TitledView.swift
//  Nitramine
//
//  Created by tarball on 6/22/23.
//

import SwiftUI

struct TitledView<Content: View>: View {
    @State var title: String
    var content: Content
    
    init(_ title: String, content: @escaping () -> Content) {
        self._title = State(initialValue: title)
        self.content = content()
    }
    
    var body: some View {
        VStack {
            CenterAlign { CapsuleText(title.capitalizedSentence).font(.title2).bold() }
            Divider()
            CenterAlign { content.multilineTextAlignment(.center) }
        }
    }
}
