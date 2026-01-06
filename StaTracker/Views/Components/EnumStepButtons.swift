import SwiftUI

struct EnumStepButtons<T: CaseIterable & RawRepresentable & Hashable>: View where T.RawValue == String {
    
    let cases: [T]
    let action: (T) -> Void
    
    // Define a single flexible column layout for full-width items
    private let fullWidthColumn: [GridItem] = [GridItem(.flexible())]
    
    // Define a two-column layout for paired items
    private let twoColumns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(_ type: T.Type, action: @escaping (T) -> Void) {
        // Ensure raw values are capitalized if they weren't in the enum definition
        self.cases = Array(type.allCases)
        self.action = action
    }
    
    // A helper function to create a button view
    private func buttonView(for value: T) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                action(value)
            }
        }) {
            Text(value.rawValue)
                .textCase(.uppercase) // Ensure UI is all caps if enum raw value isn't
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.15))
                .cornerRadius(12)
                .font(.headline)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Group cases into pairs
            ForEach(cases.chunked(into: 2), id: \.self) { pair in
                if pair.count == 2 {
                    // Use a two-column grid for pairs
                    LazyVGrid(columns: twoColumns, spacing: 10) {
                        buttonView(for: pair[0])
                        buttonView(for: pair[1])
                    }
                } else if let singleCase = pair.first {
                    // Use a single-column grid (which spans full width) for the last single item
                    LazyVGrid(columns: fullWidthColumn, spacing: 10) {
                        buttonView(for: singleCase)
                    }
                }
            }
        }
    }
}

struct promptBackButton: View{
    var action: () -> Void
    
    var body: some View {
        Button(action:{
            withAnimation(.spring())
            {action()}}){
            Image(systemName: "chevron.left")
                .font(.system(size: 14, weight: .semibold))
                .padding(8) // Space between the icon and the circle border
                .background(
                    Circle()
                        .stroke(Color.white, lineWidth: 1) // The circular border
                )
        }
    }
}

// Extension to help chunk arrays into specified sizes
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
