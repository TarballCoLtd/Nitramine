//
//  CapsuleText.swift
//  Nitramine
//
//  Created by tarball on 6/22/23.
//

import SwiftUI

struct CapsuleText: View {
    @State var text: String
    let gradient = LinearGradient(gradient: Gradient(colors: [.accentColor, .cyan, .accentColor]), startPoint: .leading, endPoint: .trailing)
    
    init(_ text: String) {
        self._text = State(initialValue: text)
    }
    
    var body: some View {
        Text(text)
            .frame(minWidth: 0, minHeight: 0)
            .padding(.vertical, 5)
            .padding(.horizontal, 15)
            .overlay {
                Capsule()
                    .stroke(gradient, lineWidth: 1)
            }
    }
}
