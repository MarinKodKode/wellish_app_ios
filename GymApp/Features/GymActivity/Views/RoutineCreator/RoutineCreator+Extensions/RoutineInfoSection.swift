import SwiftUI

extension RoutineCreatorView {
    
    var routineInfoSection: some View {
        widget.enhancedSectionView(
            title: StringConstants.routinedetailsTitle,
            icon: "dumbbell.fill",
            iconColor: .primaryFitnessBlue
        ) {
            VStack(spacing: 20) {
                widget.customTextField(
                    placeholder: StringConstants.routineName,
                    text: $vm.gymActivity.name,
                    icon: "pencil",
                    iconColor: .primaryFitnessBlue
                )
#warning("Replace constant value asap")
                widget.customTextField(
                    placeholder: StringConstants.routineDescription,
                    text: .constant("Test Value"),
                    icon: "text.alignleft",
                    iconColor: .fitnessTextSecondary
                )
            }
        }
    }
}
