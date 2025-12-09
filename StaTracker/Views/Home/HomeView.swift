import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {

                // Header
                VStack(spacing: 6) {
                    Text("Tennis Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Track every point. Improve every match.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)

                // Main Buttons
                VStack(spacing: 16) {

                    NavigationLink {
                        MatchView()
                    } label: {
                        MenuCard(title: "Start New Match",
                                 subtitle: "Track serves, rallies, and point outcomes.")
                    }

                    NavigationLink {
                        PastMatchesView()
                    } label: {
                        MenuCard(title: "Past Matches",
                                 subtitle: "Review stats and match history.")
                    }

                    Button {
                        vm.exportCSV()
                    } label: {
                        MenuCard(title: "Export CSV",
                                 subtitle: "Download all match data.")
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .sheet(isPresented: $vm.showShareSheet) {
                if let csv = vm.csvString {
                    ShareSheet(activityItems: [csv])
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
