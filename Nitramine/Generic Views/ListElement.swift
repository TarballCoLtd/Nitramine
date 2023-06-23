//
//  ListElement.swift
//  Nitramine
//
//  Created by tarball on 6/21/23.
//

import SwiftUI

struct ListElement: View {
    @State var text1: String
    @State var text2: String
    @State var image: String?
    
    init(_ text1: String, _ text2: String?) {
        self._text1 = State(initialValue: text1)
        self._text2 = State(initialValue: text2 ?? "")
    }
    
    init(_ text1: String, _ text2: String?, image: String?) {
        self._text1 = State(initialValue: text1)
        self._text2 = State(initialValue: text2 ?? "")
        self._image = State(initialValue: image)
    }
    
    var body: some View {
        if text2.count > 12 {
            VStack {
                HStack {
                    symbol
                    Text(text1)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(text2)
                }
            }
        } else {
            HStack {
                symbol
                Text(text1)
                Spacer()
                Text(text2)
            }
        }
    }
    
    @ViewBuilder
    var symbol: some View {
        if let image = image {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 25)
                .padding(.trailing, 2)
        }
    }
}
