
import SwiftUI

struct Metrics_StatisticsCardSkeleton: View {
        
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                StatisticCardWidgetSkeleton()
                Spacer()
                StatisticCardWidgetSkeleton()
            }
            .padding(.horizontal, 16)
        }
    }
}
