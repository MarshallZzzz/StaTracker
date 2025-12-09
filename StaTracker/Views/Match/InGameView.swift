
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
                HStack(spacing: 12) {
                    Spacer()
                    // Current Player
                    VStack(spacing: 0) {
                        Text("\(vm.currPlayer)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white.opacity(0.8))
                        
                        //
                        Text("0")
                            .font(.system(size: 100, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("🎾")
                            .font(.system(size: 20))
                            .opacity(server == .curr ? 1 : 0)
                        
                    }
                    
                    // Divider
                    Rectangle()
                        .fill(.white.opacity(0.5))
                        .frame(height: 2)
                        .frame(maxWidth: 50)
                    
                    // Opponent Player
                    VStack(spacing: 0) {
                        Text("\(vm.oppPlayer)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white.opacity(0.8))
                        
                        Text("0")
                            .font(.system(size: 100, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("🎾")
                            .font(.system(size: 20))
                            .opacity(server == .opp ? 1 : 0)

                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .padding(.top, 60)
                .padding(.bottom, 20)

                VStack(spacing: 20){
                    Text("Points")
                    FlowControllerView(fm: fm)
//                    if server == .curr{
//                        ServePromptingView()
//                    }
//                    else{
//                        ReceivePromptingView()
//                    }
                }
                .padding()
                .foregroundStyle(.white)
                
            }
        }
        
    }
}


//#Preview{
//    InGameView()
//}
