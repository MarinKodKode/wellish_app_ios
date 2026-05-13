
import SwiftUI

struct PopularPlansSection: View {
    
    let plans: [Plan]
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(StringConstants.plansSubtitle)
                .font(.title2.bold())
                .foregroundColor(.fitnessTextPrimary)
                .padding(.horizontal)

            if plans.isEmpty {
                Text("Cargando planes...")
                    .foregroundColor(.fitnessTextSecondary)
                    .italic()
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(plans.enumerated()), id: \.element.self) { index, plan in
                            TemplateCard(plan: plan) {
                                navigationRouter.goTo(.planDetail(plan))
                            }
                            .padding(.leading, index == 0 ? 20 : 8)
                            .padding(.trailing, index == plans.count - 1 ? 20 : 8)
                        }
                    }
                }
            }
        }
    }
}

