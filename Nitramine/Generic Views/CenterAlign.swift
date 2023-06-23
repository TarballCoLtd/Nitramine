//
//  CenterAlign.swift
//  Nitramine
//
//  Created by tarball on 6/22/23.
//

import SwiftUI

struct CenterAlign<Content: View>: View {
    var content: Content
    
    init(content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}
