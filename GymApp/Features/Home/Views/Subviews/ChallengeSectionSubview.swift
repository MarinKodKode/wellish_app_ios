import SwiftUI

struct ChallengeSectionSubview: View {
    
//    let challenge: [ChallengeCardModel]
    
    @StateObject private var viewModel = ChallengesViewModel()
    @State private var selectedChallenge: BaseChallenge?
    @State private var showLogSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            SectionBarTitle(StringConstants.challengesOfTheWeek)
            
            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 8) {
//                    ForEach(challenge.indices, id: \.self) { index in
//                        Home_ChallengeCard(challenge: challenge[index])
//                            .padding(.leading, index == 0 ? 12 : 8)
//                            .padding(.trailing, index == challenge.count - 1 ? 16 : 8)
////                            .onTapGesture {
////                                selectedChallenge = challenge[index]
////                                showLogSheet = true
////                            }
//                    }
//                }
            }
            .padding(.top, 16)
        }
        .sheet(isPresented: $showLogSheet) {
            if let challenge = selectedChallenge {
                ChallengeLogSheet(
                    challenge: challenge,
                    viewModel: viewModel
                )
            }
        }
    }
}
