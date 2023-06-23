//
//  SubstanceInfo.swift
//  Nitramine
//
//  Created by tarball on 6/21/23.
//

import SwiftUI
import PsychonautKit

struct ListStructure: Identifiable {
    let id = UUID()
    let text1: String
    let text2: String?
    let icon: String?
    let children: [ListStructure]?
    
    init(text1: String) {
        self.text1 = text1
        self.text2 = nil
        self.icon = nil
        self.children = nil
    }
    
    init(text1: String, text2: String?) {
        self.text1 = text1
        self.text2 = text2
        self.icon = nil
        self.children = nil
    }
    
    init(text1: String, children: [ListStructure]?) {
        self.text1 = text1
        self.text2 = nil
        self.icon = nil
        self.children = children
    }
    
    init(text1: String, icon: String?, children: [ListStructure]?) {
        self.text1 = text1
        self.text2 = nil
        self.icon = icon
        self.children = children
    }
    
    init(text1: String, text2: String?, icon: String?, children: [ListStructure]?) {
        self.text1 = text1
        self.text2 = text2
        self.icon = icon
        self.children = children
    }
}

struct SubstanceInfo: View {
    @State var name: String
    @State var substance: Substance?
    @State var loading = true
    
    var effectsArray: [ListStructure] {
        [
            ListStructure(text1: "Effects", icon: "person.circle", children: substance!.effects.map { ListStructure(text1: $0.name) })
        ]
    }
    
    var namesArray: [ListStructure] {
        [
            ListStructure(text1: "Common Names", icon: "text.bubble", children: substance!.commonNames!.map { ListStructure(text1: $0) })
        ]
    }
    
    var crossArray: [ListStructure] {
        [
            ListStructure(text1: "Cross Tolerances", icon: "arrow.left.arrow.right.circle", children: substance!.crossTolerances!.map { ListStructure(text1: $0) })
        ]
    }
    
    init(_ name: String) { self._name = State(initialValue: name) }
    
    var body: some View {
        Group {
            if loading {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.trailing, 3)
                    Text("Loading...")
                }
            } else {
                if let substance = substance {
                    List {
                        Section {
                            ListElement("Substance Name", substance.name, image: "pill.circle")
                            if let `class` = substance.class, `class`.chemical != nil || `class`.psychoactive != nil {
                                OutlineGroup(drugClassStructure(`class`), children: \.children) { `class` in
                                    ListElement(`class`.text1, `class`.text2, image: `class`.icon)
                                }
                            }
                            if let commonNames = substance.commonNames, !commonNames.isEmpty {
                                OutlineGroup(namesArray, children: \.children) { name in
                                    ListElement(name.text1.capitalizedSentence, name.text2, image: name.icon)
                                }
                            }
                            if !substance.effects.isEmpty {
                                OutlineGroup(effectsArray, children: \.children) { effect in
                                    ListElement(effect.text1, effect.text2, image: effect.icon)
                                }
                            }
                            if let crossTolerances = substance.crossTolerances, !crossTolerances.isEmpty {
                                OutlineGroup(crossArray, children: \.children) { cross in
                                    ListElement(cross.text1.capitalizedSentence, cross.text2, image: cross.icon)
                                }
                            }
                            if let tolerance = substance.tolerance, tolerance.full != nil || tolerance.half != nil || tolerance.zero != nil {
                                OutlineGroup(toleranceStructure(tolerance), children: \.children) { tolerance in
                                    ListElement(tolerance.text1, tolerance.text2?.capitalizedSentence, image: tolerance.icon)
                                }
                            }
                            if !substance.images.isEmpty {
                                NavigationLink {
                                    ImageView(substance.images)
                                } label: {
                                    ListElement("Images", "", image: "photo.circle")
                                }
                            }
                        }
                        Section {
                            if let addictionPotential = substance.addictionPotential {
                                TitledTextBox("Addiction Potential", body: addictionPotential.capitalizedSentence)
                            }
                        }
                        Section {
                            if let summary = substance.summary, !summary.isEmpty {
                                TitledTextBox("Summary", body: summary)
                            }
                        }
                        Section {
                            if let toxicity = substance.toxicity, !toxicity.isEmpty {
                                TitledTextBox("Toxicity", body: arrayToString(toxicity).capitalizedSentence)
                            }
                        }
                        if !substance.roas.isEmpty {
                            ForEach(substance.roas, id: \.self) { roa in
                                Section {
                                    TitledView(roa.name) {
                                        VStack {
                                            if let dose = roa.dose {
                                                CenterAlign { Text("Dosage").font(.title3).bold() }
                                                if let bioavailability = roa.bioavailability {
                                                    Divider()
                                                    HStack {
                                                        Text("Bioavailability")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", bioavailability.min))% - \(String(format: "%.1f", bioavailability.max))%")
                                                    }
                                                }
                                                if let threshold = dose.threshold {
                                                    Divider()
                                                    HStack {
                                                        Text("Threshold")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", threshold)) \(dose.units)")
                                                    }
                                                }
                                                if let light = dose.light {
                                                    Divider()
                                                    HStack {
                                                        Text("Light")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", light.min)) - \(String(format: "%.1f", light.max)) \(dose.units)")
                                                    }
                                                }
                                                if let common = dose.common {
                                                    Divider()
                                                    HStack {
                                                        Text("Common")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", common.min)) - \(String(format: "%.1f", common.max)) \(dose.units)")
                                                    }
                                                }
                                                if let strong = dose.strong {
                                                    Divider()
                                                    HStack {
                                                        Text("Strong")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", strong.min)) - \(String(format: "%.1f", strong.max)) \(dose.units)")
                                                    }
                                                }
                                                if let heavy = dose.heavy {
                                                    Divider()
                                                    HStack {
                                                        Text("Heavy")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", heavy))+ \(dose.units)")
                                                    }
                                                }
                                            }
                                            if roa.duration.afterglow != nil || roa.duration.comeup != nil || roa.duration.offset != nil || roa.duration.onset != nil || roa.duration.peak != nil || roa.duration.total != nil {
                                                Divider()
                                                CenterAlign { Text("Duration").font(.title3).bold() }
                                                if let total = roa.duration.total, let min = total.min, let max = total.max {
                                                    Divider()
                                                    HStack {
                                                        Text("Total")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", min)) - \(String(format: "%.1f", max)) \(total.units)")
                                                    }
                                                }
                                                if let onset = roa.duration.onset, let min = onset.min, let max = onset.max {
                                                    Divider()
                                                    HStack {
                                                        Text("Onset")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", min)) - \(String(format: "%.1f", max)) \(onset.units)")
                                                    }
                                                }
                                                if let comeup = roa.duration.comeup, let min = comeup.min, let max = comeup.max {
                                                    Divider()
                                                    HStack {
                                                        Text("Come Up")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", min)) - \(String(format: "%.1f", max)) \(comeup.units)")
                                                    }
                                                }
                                                if let peak = roa.duration.peak, let min = peak.min, let max = peak.max {
                                                    Divider()
                                                    HStack {
                                                        Text("Peak")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", min)) - \(String(format: "%.1f", max)) \(peak.units)")
                                                    }
                                                }
                                                if let offset = roa.duration.offset, let min = offset.min, let max = offset.max {
                                                    Divider()
                                                    HStack {
                                                        Text("Offset")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", min)) - \(String(format: "%.1f", max)) \(offset.units)")
                                                    }
                                                }
                                                if let afterglow = roa.duration.afterglow, let min = afterglow.min, let max = afterglow.max {
                                                    Divider()
                                                    HStack {
                                                        Text("After Effects")
                                                        Spacer()
                                                        Text("\(String(format: "%.1f", min)) - \(String(format: "%.1f", max)) \(afterglow.units)")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Text("Error loading.")
                }
            }
        }
        .navigationTitle(name)
        .onAppear {
            Task {
                do {
                    substance = try await PWAPI.requestSubstanceInfo(query: name)
                } catch {
                    print(error)
                }
                loading = false
            }
        }
    }
    
    func arrayToString(_ array: [String]) -> String {
        var ret = ""
        for index in 0...array.count-1 {
            if index == array.count - 1 {
                ret += array[index]
            } else {
                ret += array[index] + "\n"
            }
        }
        return ret
    }
    
    func toleranceStructure(_ tolerance: ToleranceInfo) -> [ListStructure] {
        var children: [ListStructure] = []
        if let full = tolerance.full {
            children.append(ListStructure(text1: "Full", text2: full))
        }
        if let half = tolerance.half {
            children.append(ListStructure(text1: "Half", text2: half))
        }
        if let zero = tolerance.zero {
            children.append(ListStructure(text1: "Zero", text2: zero))
        }
        return [
            ListStructure(text1: "Tolerance", icon: "staroflife.circle", children: children)
        ]
    }
    
    func drugClassStructure(_ class: SubstanceClass) -> [ListStructure] {
        var children: [ListStructure] = []
        if let chemical = `class`.chemical {
            children.append(ListStructure(text1: "Chemical", children: chemical.map { ListStructure(text1: $0) }))
        }
        if let psychoactive = `class`.psychoactive {
            children.append(ListStructure(text1: "Psychoactive", children: psychoactive.map { ListStructure(text1: $0) }))
        }
        return [
            ListStructure(text1: "Drug Class", icon: "cross.circle", children: children)
        ]
    }
}

extension String {
    var capitalizedSentence: String { self.prefix(1).capitalized + self.dropFirst() }
}
