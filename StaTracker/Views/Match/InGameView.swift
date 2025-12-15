
import SwiftUI

struct InGameView: View {
    @StateObject var vm: MatchViewModel
    @StateObject var fm: FlowViewModel
    
    @State var server: Player
    
    
    
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [.blue, .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScoreboardView(vm:vm)
                
                VStack(spacing: 0){
                    FlowControllerView(fm: fm, vm: vm)   // your flow UI
                        .onAppear {
                            fm.onPointFinished = { point in
                                // 1. Save to match
                                vm.savePoint(point)
                                
                                // 2. Reset FlowViewModel for the next point
//                                fm.currPoint = Point(server: vm.server)
                                fm.updateServer(server: vm.server)
                                fm.startFlow()
                            }
                        }
                        .padding()
                        .foregroundStyle(.white)
                }
            }
        }
    }
}




//#Preview{
//    InGameView()
//}
