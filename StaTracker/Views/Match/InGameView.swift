
import SwiftUI

struct InGameView: View {
    @StateObject var vm: MatchViewModel
    @StateObject var fm: FlowViewModel
    
    @State var server: ServingPlayer
    
    
    
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [.blue, .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScoreboardView(vm:vm, server: server)
                
                VStack(spacing: 0){
                    FlowControllerView(fm: fm)   // your flow UI
                        .onAppear {
                            fm.onPointFinished = { point in
                                // 1. Save to match
                                vm.savePoint(point)
//                                vm.processScoring(Point)
                                
                                switchServerAfterGame()
                                // 2. Reset FlowViewModel for the next point
                                fm.currPoint = Point(server: vm.match.server)
                                fm.startFlow()
                            }
                        }
                    
                        .padding()
                        .foregroundStyle(.white)
                    
                }
            }
        }
    }
    
    private func switchServerAfterGame() {
        server = server == .curr ? .opp : .curr
    }
}




//#Preview{
//    InGameView()
//}
