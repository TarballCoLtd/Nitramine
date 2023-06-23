//
//  ContentView.swift
//  Nitramine
//
//  Created by tarball on 6/20/23.
//

import SwiftUI
import PsychonautKit

struct ContentView: View {
    @State var substances: [String]?
    @State var loading = true
    @State var search = ""
    
    var filtered: [String]? {
        guard let substances = substances else { return substances }
        guard !search.isEmpty else { return substances }
        return substances.filter { $0.range(of: search, options: .caseInsensitive) != nil }
    }
    
    var body: some View {
        NavigationView {
            if loading {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.trailing, 3)
                    Text("Loading...")
                }
            } else {
                if let filtered = filtered {
                    List {
                        ForEach(filtered, id: \.self) { substance in
                            NavigationLink {
                                SubstanceInfo(substance)
                            } label: {
                                Text(substance)
                            }
                        }
                    }
                    .navigationTitle("Substances")
                    .searchable(text: $search)
                    .refreshable {
                        substances = try? await PWAPI.requestSubstances()
                    }
                } else {
                    Text("Error loading.")
                }
            }
        }
        .onAppear {
            Task {
                substances = try? await PWAPI.requestSubstances()
                loading = false
            }
        }
    }
}
