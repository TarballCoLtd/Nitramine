//
//  TitledTextBox.swift
//  Nitramine
//
//  Created by tarball on 6/22/23.
//

import SwiftUI

struct TitledTextBox: View {
    @State var title: String
    @State var text: String
    
    init(_ title: String, body: String) {
        self._title = State(initialValue: title)
        self._text = State(initialValue: body)
    }
    
    var body: some View {
        TitledView(title) { Text(text) }
    }
}
