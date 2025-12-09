
import SwiftUI

struct EnumStepButtons<T: CaseIterable & RawRepresentable & Hashable>: View where T.RawValue == String {
    
    let cases: [T]
    let action: (T) -> Void
    
    // Define a grid layout with two flexible columns
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(_ type: T.Type, action: @escaping (T) -> Void) {
        self.cases = Array(type.allCases)
        self.action = action
    }
    
    var body: some View {
        // Use LazyVGrid to arrange items in the defined columns
        LazyVGrid(columns: columns, spacing: 10) { // Add spacing between rows/columns
            ForEach(cases, id: \.self) { value in
                Button(action: {
                    withAnimation(.spring()) {
                        action(value)
                    }
                }) {
                    Text(value.rawValue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.15))
                        .cornerRadius(12)
                        .font(.headline)
                }
                // Removes default button padding if you place this view in a List/Form
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
