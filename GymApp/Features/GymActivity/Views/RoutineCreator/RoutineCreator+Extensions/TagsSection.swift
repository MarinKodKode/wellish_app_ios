
import SwiftUI

extension RoutineCreatorView {
   
    var tagsSection: some View {
        widget.enhancedSectionView(
            title: StringConstants.routineTagsAndCategories,
            icon: "tag.fill",
            iconColor: .premiumFitnessPurple
        ) {
            VStack(spacing: 20) {
                HStack(spacing: 12) {
                    widget.customTextField(
                        placeholder: StringConstants.routineAddNewTag,
                        text: $newTagText,
                        icon: "plus",
                        iconColor: .premiumFitnessPurple
                    )

                    Button(StringConstants.add) {
                        vm.addTag(newTagText)
                        newTagText = ""
                    }
                    .disabled(newTagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(newTagText.isEmpty ? Color.gray.opacity(0.3) : Color.premiumFitnessPurple)
                    .foregroundColor(.white)
                    .font(.subheadline.weight(.semibold))
                    .cornerRadius(12)
                }

                if !vm.gymActivity.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(vm.gymActivity.tags, id: \.self) { tag in
                                EnhancedTagChip(tag: tag) { vm.removeTag(tag) }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }

                widget.customTextField(
                    placeholder: StringConstants.routineCategories,
                    text: .constant("some some some"),
                    icon: "square.grid.2x2",
                    iconColor: .fitnessTextSecondary
                )
            }
        }
    }
}
