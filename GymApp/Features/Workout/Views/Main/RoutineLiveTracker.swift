import SwiftUI

public struct RoutineCreatorSheet: View {
   
    @Binding var isPresented: Bool
    @StateObject private var vm = GymActivityViewModel()

    @State private var showingExercisePicker: Bool = false
    @State private var exercisePickerTargetSetIndex: Int? = nil

    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }

    public var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        headerView

                        nameAndCategorySection

//                        setsSection

                        tagsSection

                        saveButton
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Create Routine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView { exercise in
                    if let index = exercisePickerTargetSetIndex {
                        guard vm.gymActivity.sets.indices.contains(index) else { return }
                        // Actualizar el nombre del ejercicio en el set existente
                        vm.gymActivity.sets[index].exerciseName = exercise.name
                    } else {
                        // Crear nuevo set con el ejercicio seleccionado
                        vm.addSet(with: exercise)
                    }
                    exercisePickerTargetSetIndex = nil
                    showingExercisePicker = false
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { vm.errorMessage != nil },
                set: { if !$0 { vm.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(vm.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // MARK: - Header / Intro
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Create Your Routine")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            Text("Add exercises, sets, reps, and optional weights.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .multilineTextAlignment(.center)
    }

    // MARK: - Name / Category
    private var nameAndCategorySection: some View {
        VStack(spacing: 16) {
            inputCard(title: "Routine Name") {
                TextField("Enter name", text: $vm.gymActivity.name)
                    .foregroundColor(.white)
                    .autocapitalization(.words)
            }

            inputCard(title: "Category") {
                TextField(
                    "e.g., Strength",
                    text: .constant("")
                )
                .foregroundColor(.white)
            }

            inputCard(title: "Description (optional)") {
                TextField("Short description", text: Binding(
                    get: { vm.gymActivity.description ?? "" },
                    set: { vm.gymActivity.description = $0.isEmpty ? nil : $0 }
                ))
                .foregroundColor(.white)
            }
        }
    }

    // MARK: - Sets / Series
//    private var setsSection: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Text("Sets")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                Spacer()
//                Text("\(vm.gymActivity.sets.count) items")
//                    .foregroundColor(.gray)
//            }
//
//            if vm.gymActivity.sets.isEmpty {
//                Text("No sets yet. Add an exercise to begin.")
//                    .foregroundColor(.secondary)
//            }
//
//            // Iterar usando el array directamente con id
//            ForEach(Array(vm.gymActivity.sets.enumerated()), id: \.element.id) { index, set in
//                VStack(spacing: 12) {
//                    HStack {
//                        Text(set.exercise.name)
//                            .foregroundColor(.white)
//                            .font(.headline)
//
//                        Spacer()
//
//                        Button(action: {
//                            // Cambiar ejercicio del set existente
//                            exercisePickerTargetSetIndex = index
//                            showingExercisePicker = true
//                        }) {
//                            Text("Change")
//                                .font(.system(size: 14))
//                                .foregroundColor(.blue)
//                        }
//                    }
//
//                    // Lista de series (editable)
//                    VStack(spacing: 8) {
//                        ForEach(Array(set.series.enumerated()), id: \.element.id) { sIndex, serie in
//                            // Crear binding a cada Serie
//                            let serieBinding = Binding<Serie>(
//                                get: { vm.gymActivity.sets[index].series[sIndex] },
//                                set: { vm.gymActivity.sets[index].series[sIndex] = $0 }
//                            )
//
//                            SerieRowView(serie: serieBinding) {
//                                // onDelete
//                                vm.removeSerie(at: sIndex, fromSetAt: index)
//                            }
//                        }
//
//                        HStack {
//                            Button(action: {
//                                vm.addSerie(toSetAt: index)
//                            }) {
//                                HStack {
//                                    Image(systemName: "plus.circle")
//                                    Text("Add serie")
//                                }
//                                .foregroundColor(.blue)
//                            }
//
//                            Spacer()
//
//                            Button(action: {
//                                // Remover el set completo
//                                withAnimation { vm.removeSet(at: index) }
//                            }) {
//                                Text("Remove set")
//                                    .foregroundColor(.red)
//                            }
//                        }
//                    }
//                    .padding(.top, 6)
//                }
//                .padding()
//                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
//                .cornerRadius(16)
//            }
//
//            // Add set: abrir picker (sin target index => agregar nuevo set)
//            Button(action: {
//                exercisePickerTargetSetIndex = nil
//                showingExercisePicker = true
//            }) {
//                HStack {
//                    Image(systemName: "plus.circle.fill")
//                        .foregroundColor(.blue)
//                    Text("Add Set")
//                        .foregroundColor(.blue)
//                }
//            }
//        }
//    }

    // MARK: - Tags
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tags")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            inputCard {
                HStack {
                    TextField("Add tag", text: $vm.tagsInput)
                        .foregroundColor(.white)

                    Button("Add") {
                        vm.addTag(vm.tagsInput)
                        vm.tagsInput = ""
                    }
                    .disabled(vm.tagsInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(vm.gymActivity.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    // MARK: - Save
    private var saveButton: some View {
        Button(action: {
//            Task {
//                let ok = await vm.save()
//                if ok {
//                    isPresented = false
//                }
//            }
        }) {
            Text(vm.isSaving ? "Saving..." : "Save Routine")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
        .disabled(!vm.canSave || vm.isSaving)
    }

    // MARK: - Helpers
    private func inputCard<Content: View>(title: String? = nil, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            content()
        }
        .padding()
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .cornerRadius(12)
    }
}
