
import SwiftUI

struct InGameView: View {
    @ObservedObject var vm: MatchViewModel
    @ObservedObject var fm: FlowViewModel
    
    @State private var navigateToEndgame: Bool = false
    
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
                            fm.onMatchFinished = {self.navigateToEndgame = true}
                            fm.onPointFinished = { point in
                                // 1. Save to match
                                //if match is in tie break -> add point to different function
                                if vm.match.inTieBreak{
                                    vm.match.addTieBreakPoint(point)
                                }else{
                                    vm.match.addPoint(point)
                                }
                                
                                if vm.isMatchComplete(){
                                    fm.finishMatch()
                                  
                                } else{
                                    
                                    fm.prepareNextPoint(server: vm.match.server)
                                    fm.updateServer(vm.match.server)
                                    fm.startFlow()
                                }
                            }
                        }
                        .padding()
                        .foregroundStyle(.white)
                }
            }

        }
        .fullScreenCover(isPresented: $navigateToEndgame) {
            EndGameView(vm: vm)
                }
//                .onAppear {
//                    fm.onPointFinished = { point in
//                        vm.match.addPoint(point)
//                        
//                        // Only reset flow if match isn't over
//                        if !vm.isMatchComplete() {
//                            fm.currPoint = Point(server: vm.match.server)
//                            fm.updateServer(server: vm.match.server)
//                            fm.startFlow()
//                        }
//                    }
//                }
//        
    }
}




//#Preview{
//    InGameView()
//}
