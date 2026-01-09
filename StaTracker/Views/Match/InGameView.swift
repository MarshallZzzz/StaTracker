
import SwiftUI

struct InGameView: View {
    @ObservedObject var vm: MatchViewModel
    @ObservedObject var fm: FlowViewModel
    
    @State private var navigateToEndgame: Bool = false
    @FocusState private var isNotesFocused: Bool
    
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [.blue, .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
                // A background that catches taps when the keyboard is active
            if isNotesFocused {
                Color.clear
                    .contentShape(Rectangle()) // Makes transparent area clickable
                    .onTapGesture {
                        isNotesFocused = false
                    }
            }
            
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
    }
}




//#Preview{
//    InGameView()
//}
