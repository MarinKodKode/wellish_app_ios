import SwiftUI

struct ChallengesSection: View {
 
    @StateObject private var viewModel = ChallengesViewModel()
    @State private var selectedChallenge: BaseChallenge?
    @State private var showLogSheet = false
    @State private var selectedAvailable: AvailableChallenge?
    @State private var showJoinSheet = false
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
 
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
 
                    // Retos activos
                    ForEach(viewModel.challenges) { challenge in
                        ChallengeRingCard(challenge: challenge)
                            .onTapGesture {
                                activeSheet = .logChallenge(challenge)
                            }
                    }
 
                    // Separador sutil
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 1, height: 50)
                        .padding(.horizontal, 4)
 
                    // Retos disponibles para unirse
                    ForEach(availableChallenges) { available in
                        JoinChallengeRingCard(challenge: available)
                            .onTapGesture {
                                activeSheet = .joinChallenge(available)
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .logChallenge(let challenge):
                ChallengeLogSheet(challenge: challenge, viewModel: viewModel)
            case .joinChallenge(let available):
                JoinChallengeSheet(challenge: available)
            }
        }
        .overlay(
            Group {
                if viewModel.showSuccessAnimation {
                    SuccessAnimationView()
                        .transition(.scale.combined(with: .opacity))
                }
            }
        )
    }
}
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}

// MARK: - Mini History Card

struct MiniHistoryCard: View {
    let entry: ChallengeHistoryEntry
    let color: Color
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: entry.date)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(dateString)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 3)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: entry.progress)
                    .stroke(color, lineWidth: 3)
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(entry.progress * 100))%")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            
            if entry.completed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.caption)
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Challenge History View

struct ChallengeHistoryView: View {
    let challenge: BaseChallenge
    @ObservedObject var viewModel: ChallengesViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                let history = viewModel.getHistory(for: challenge, last: 30)
                
                if history.isEmpty {
                    Text("Sin historial disponible")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(history) { entry in
                        HistoryRow(entry: entry, challenge: challenge)
                    }
                }
            }
            .navigationTitle("Historial")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - History Row

struct HistoryRow: View {
    let entry: ChallengeHistoryEntry
    let challenge: BaseChallenge
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: entry.date)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateString)
                    .font(.headline)
                
                Text("\(entry.value) / \(entry.goalValue) \(challenge.unit)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(entry.progress * 100))%")
                    .font(.headline)
                    .foregroundColor(challenge.color)
                
                if entry.completed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Success Animation

struct SuccessAnimationView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("¡Reto Completado!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
        }
    }
}

struct ChallengeRingCard: View {
 
    let challenge: BaseChallenge
    private let size: CGFloat = 72
    private let strokeWidth: CGFloat = 6
 
    var body: some View {
        VStack(spacing: 8) {
 
            ZStack {
                Circle()
                    .stroke(challenge.color.opacity(0.15), lineWidth: strokeWidth)
                    .frame(width: size, height: size)
 
                Circle()
                    .trim(from: 0, to: challenge.progress)
                    .stroke(
                        challenge.color,
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: challenge.progress)
 
                if challenge.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(challenge.color)
                } else {
                    Image(systemName: challenge.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(challenge.color)
                }
            }
 
            Text(formattedValue)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
 
            Text(challenge.subtitle)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(width: size + 16)
    }
 
    private var formattedValue: String {
        if challenge.currentValue >= 1000 {
            let k = Double(challenge.currentValue) / 1000.0
            return String(format: "%.1fk", k)
        }
        return "\(challenge.currentValue)"
    }
}
struct JoinChallengeRingCard: View {
 
    let challenge: AvailableChallenge
    private let size: CGFloat = 72
    private let strokeWidth: CGFloat = 5
 
    var body: some View {
        VStack(spacing: 8) {
 
            ZStack {
                // Ring punteado
                Circle()
                    .stroke(
                        challenge.color.opacity(0.3),
                        style: StrokeStyle(
                            lineWidth: strokeWidth,
                            lineCap: .round,
                            dash: [4, 5]
                        )
                    )
                    .frame(width: size, height: size)
 
                VStack(spacing: 2) {
                    Image(systemName: challenge.icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(challenge.color.opacity(0.5))
 
                    Image(systemName: "plus")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(challenge.color.opacity(0.5))
                }
            }
 
            Text("Unirse")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.gray)
 
            Text(challenge.label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray.opacity(0.6))
                .lineLimit(1)
        }
        .frame(width: size + 16)
        .opacity(0.7)
        
    }
}

struct JoinChallengeSheet: View {
 
    let challenge: AvailableChallenge
    @Environment(\.dismiss) private var dismiss
 
    var body: some View {
        VStack(spacing: 24) {
            Capsule()
                .fill(Color.white.opacity(0.2))
                .frame(width: 36, height: 4)
                .padding(.top, 12)
 
            Image(systemName: challenge.icon)
                .font(.system(size: 52))
                .foregroundColor(challenge.color)
                .padding(.top, 16)
 
            Text(challenge.label)
                .font(.title2.bold())
                .foregroundColor(.white)
 
            Text("Únete a este reto y empieza a registrar tu progreso diario.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
 
            Spacer()
 
            Button(action: {
                // TODO: unirse al reto cuando venga de Firestore
                dismiss()
            }) {
                Text("Unirse al reto")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(challenge.color)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.07, green: 0.09, blue: 0.14))
        .presentationDetents([.medium])
    }
}

 struct AvailableChallenge: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let color: Color
}

private let availableChallenges: [AvailableChallenge] = [
    AvailableChallenge(icon: "moon.fill",         label: "Sueño",     color: .indigo),
    AvailableChallenge(icon: "fork.knife",         label: "Calorías",  color: .orange),
    AvailableChallenge(icon: "heart.fill",         label: "Frecuencia",color: .red),
    AvailableChallenge(icon: "figure.run",         label: "Cardio",    color: .green),
]


// MARK: - Preview

#Preview {
    ChallengesSection()
}


enum ActiveSheet: Identifiable {
    case logChallenge(BaseChallenge)
    case joinChallenge(AvailableChallenge)
    
    var id: String {
        switch self {
        case .logChallenge(let c): return "log-\(c.id)"
        case .joinChallenge(let c): return "join-\(c.id.uuidString)"
        }
    }
}
