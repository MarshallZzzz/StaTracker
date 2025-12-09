//
//  MenuCard.swift
//  StaTracker
//
//  Created by Marshall Zhang on 11/24/25.
//

import SwiftUI

struct MenuCard: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 6, y: 4)
    }
}

#Preview {
    MenuCard(title: "Start Match", subtitle: "Test subtitle")
        .padding()
}

