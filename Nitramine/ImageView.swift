//
//  ImageSheet.swift
//  Nitramine
//
//  Created by tarball on 6/22/23.
//

import SwiftUI
import PsychonautKit

struct ImageView: View {
    @State var images: [ImageLink]
    
    init(_ images: [ImageLink]) {
        self._images = State(initialValue: images)
    }
    
    var body: some View {
        ScrollView {
            ForEach(images, id: \.self) { link in
                AsyncImage(url: URL(string: link.image)!) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                .padding(.bottom)
            }
        }
        .navigationTitle("Images")
    }
}
