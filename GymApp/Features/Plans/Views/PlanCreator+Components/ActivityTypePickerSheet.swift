import SwiftUI

struct ActivityTypePickerSheet: View {

    @Binding var isPresented: Bool
    
    let day: Int
    
    @ObservedObject var viewModel: PlanCreatorViewModel
    
    var body: some View {
        NavigationStack {
            List {
                mainActivitiesSection
                otherActivitiesSection
            }
            .navigationTitle("Día \(day)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
            }
        }
    }
    
    // MARK: - Main Activities Section
    
    private var mainActivitiesSection: some View {
        Section {
            // Gym
            NavigationLink {
                ActivityPickerView(
                    vm: viewModel,
                    category: .gym,
                    day: day,
                    dismissSheet: $isPresented
                )
            } label: {
                ActivityTypeRow(
                    icon: "dumbbell.fill",
                    title: "Rutina de Gym",
                    subtitle: "Elige de tus rutinas",
                    color: .blue
                )
            }
            
            // Running
            NavigationLink {
                ActivityPickerView(
                    vm: viewModel,
                    category: .running,
                    day: day,
                    dismissSheet: $isPresented
                )
            } label: {
                ActivityTypeRow(
                    icon: "figure.run",
                    title: "Correr",
                    subtitle: "Agrega distancia y tiempo",
                    color: .green
                )
            }
            
            // Rest
            NavigationLink {
                ActivityPickerView(
                    vm: viewModel,
                    category: .rest,
                    day: day,
                    dismissSheet: $isPresented
                )
            } label: {
                ActivityTypeRow(
                    icon: "bed.double.fill",
                    title: "Día de descanso",
                    subtitle: "Recuperación activa",
                    color: .gray
                )
            }
        }
    }
    
    // MARK: - Other Activities Section
    
    private var otherActivitiesSection: some View {
        Section("Otras actividades") {
            // Cycling
            NavigationLink {
                ActivityPickerView(
                    vm: viewModel,
                    category: .cycling,
                    day: day,
                    dismissSheet: $isPresented
                )
            } label: {
                ActivityTypeRow(
                    icon: "bicycle",
                    title: "Ciclismo",
                    subtitle: "Configura tu ruta",
                    color: .orange
                )
            }
            
            // Swimming
            NavigationLink {
                ActivityPickerView(
                    vm: viewModel,
                    category: .swimming,
                    day: day,
                    dismissSheet: $isPresented
                )
            } label: {
                ActivityTypeRow(
                    icon: "figure.pool.swim",
                    title: "Natación",
                    subtitle: "Define tu sesión",
                    color: .cyan
                )
            }
            
            // Yoga
            NavigationLink {
                ActivityPickerView(
                    vm: viewModel,
                    category: .yoga,
                    day: day,
                    dismissSheet: $isPresented
                )
            } label: {
                ActivityTypeRow(
                    icon: "figure.mind.and.body",
                    title: "Yoga",
                    subtitle: "Elige tu práctica",
                    color: .purple
                )
            }
            
            // Walking
            NavigationLink {
                ActivityPickerView(
                    vm: viewModel,
                    category: .walking,
                    day: day,
                    dismissSheet: $isPresented
                )
            } label: {
                ActivityTypeRow(
                    icon: "figure.walk",
                    title: "Caminar",
                    subtitle: "Distancia y paso",
                    color: Color(hex: "10B981")
                )
            }
        }
    }
    
    // MARK: - Cancel Button
    
    private var cancelButton: some View {
        Button("Cancelar") {
            isPresented = false
        }
    }
}
