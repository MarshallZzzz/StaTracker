//
//  PastMatchesView.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

//
//  PastMatches.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

import SwiftUI

struct PastMatchesView: View {
    @State private var matches = MatchStorageService().loadAllMatches()

    var body: some View {
        List(matches) { match in
            VStack(alignment: .leading) {
                Text("Match on \(match.date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.headline)
                Text("\(match.points.count) points tracked")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Past Matches")
    }
}

#Preview {
    PastMatchesView()
}
