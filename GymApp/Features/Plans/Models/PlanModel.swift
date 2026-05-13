//
//  Plan.swift
//  Wellish
//

import Foundation

public struct Plan: Identifiable, Codable, Hashable {

    // MARK: - Required Properties
    public let id: String
    public var name: String
    public var createdAt: Date
    public var updatedAt: Date
    public var elements: [PlanElement]

    // MARK: - Optional Properties
    public var description: String?
    public var category: String?
    public var creator: String?
    public var tags: [String]
    public var thumbnailURL: String?
    public var notes: String?

    // MARK: - Plan Configuration
    public var goal: PlanGoal
    public var durationWeeks: Int
    public var startDate: Date?
    public var activitiesPerWeek: Int

    // MARK: - Premium & Sharing
    public var shareable: Bool
    public var isPremiumPlan: Bool
    public var isBeingTracked: Bool

    // MARK: - Init

    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String? = nil,
        category: String? = nil,
        creator: String? = nil,
        tags: [String] = [],
        thumbnailURL: String? = nil,
        notes: String? = nil,
        elements: [PlanElement] = [],
        goal: PlanGoal = .general,
        durationWeeks: Int = 4,
        startDate: Date? = nil,
        activitiesPerWeek: Int = 3,
        shareable: Bool = false,
        isPremiumPlan: Bool = false,
        isBeingTracked: Bool = false
    ) {
        self.id = id
        self.name = name
        self.createdAt = Date()
        self.updatedAt = Date()
        self.description = description
        self.category = category
        self.creator = creator
        self.tags = tags
        self.thumbnailURL = thumbnailURL
        self.notes = notes
        self.elements = elements
        self.goal = goal
        self.durationWeeks = durationWeeks
        self.startDate = startDate
        self.activitiesPerWeek = activitiesPerWeek
        self.shareable = shareable
        self.isPremiumPlan = isPremiumPlan
        self.isBeingTracked = isBeingTracked
    }

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id, name, createdAt, updatedAt, elements
        case description, category, creator, tags, thumbnailURL, notes
        case goal, durationWeeks, startDate, activitiesPerWeek
        case shareable, isPremiumPlan, isBeingTracked
    }

    // MARK: - Custom Decoder (tolerante a campos faltantes)

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        createdAt = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt) ?? Date()
        elements = try c.decodeIfPresent([PlanElement].self, forKey: .elements) ?? []
        description = try c.decodeIfPresent(String.self, forKey: .description)
        category = try c.decodeIfPresent(String.self, forKey: .category)
        creator = try c.decodeIfPresent(String.self, forKey: .creator)
        tags = try c.decodeIfPresent([String].self, forKey: .tags) ?? []
        thumbnailURL = try c.decodeIfPresent(String.self, forKey: .thumbnailURL)
        notes = try c.decodeIfPresent(String.self, forKey: .notes)
        goal = try c.decodeIfPresent(PlanGoal.self, forKey: .goal) ?? .general
        durationWeeks = try c.decodeIfPresent(Int.self, forKey: .durationWeeks) ?? 4
        startDate = try c.decodeIfPresent(Date.self, forKey: .startDate)
        activitiesPerWeek = try c.decodeIfPresent(Int.self, forKey: .activitiesPerWeek) ?? 3
        shareable = try c.decodeIfPresent(Bool.self, forKey: .shareable) ?? false
        isPremiumPlan = try c.decodeIfPresent(Bool.self, forKey: .isPremiumPlan) ?? false
        isBeingTracked = try c.decodeIfPresent(Bool.self, forKey: .isBeingTracked) ?? false
    }

    // MARK: - Firestore Helper

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "createdAt": createdAt,
            "updatedAt": updatedAt,
            "elements": elements.map { $0.toDictionary() },
            "tags": tags,
            "goal": goal.rawValue,
            "durationWeeks": durationWeeks,
            "activitiesPerWeek": activitiesPerWeek,
            "shareable": shareable,
            "isPremiumPlan": isPremiumPlan,
            "isBeingTracked": isBeingTracked
        ]
        if let description = description { dict["description"] = description }
        if let category = category { dict["category"] = category }
        if let creator = creator { dict["creator"] = creator }
        if let thumbnailURL = thumbnailURL { dict["thumbnailURL"] = thumbnailURL }
        if let notes = notes { dict["notes"] = notes }
        if let startDate = startDate { dict["startDate"] = startDate }
        return dict
    }

    // MARK: - Computed Properties

    public var endDate: Date? {
        guard let startDate = startDate else { return nil }
        return Calendar.current.date(byAdding: .weekOfYear, value: durationWeeks, to: startDate)
    }

    public var totalActivities: Int { elements.count }

    public var completedActivities: Int { elements.filter { $0.completed }.count }

    public var completionPercentage: Double {
        guard totalActivities > 0 else { return 0 }
        return (Double(completedActivities) / Double(totalActivities)) * 100
    }

    public var isCompleted: Bool {
        !elements.isEmpty && elements.allSatisfy { $0.completed }
    }

    public var isActive: Bool {
        guard let startDate = startDate, let endDate = endDate else { return false }
        let now = Date()
        return now >= startDate && now <= endDate
    }

    public var daysRemaining: Int? {
        guard let endDate = endDate else { return nil }
        let now = Date()
        guard now < endDate else { return 0 }
        return Calendar.current.dateComponents([.day], from: now, to: endDate).day
    }

    public var currentWeek: Int? {
        guard let startDate = startDate else { return nil }
        let now = Date()
        guard now >= startDate else { return nil }
        let weeks = Calendar.current.dateComponents([.weekOfYear], from: startDate, to: now).weekOfYear ?? 0
        return min(weeks + 1, durationWeeks)
    }

    public var formattedDuration: String {
        durationWeeks == 1 ? "1 semana" : "\(durationWeeks) semanas"
    }

    public var progressText: String { "\(completedActivities)/\(totalActivities) completadas" }
    public var hasImage: Bool { thumbnailURL != nil }
    public var categoryName: String { category ?? "Sin categoria" }
    public var totalDays: Int { durationWeeks * 7 }

    // MARK: - Methods

    public mutating func addElement(_ element: PlanElement) {
        elements.append(element)
        updatedAt = Date()
    }

    public mutating func removeElement(at index: Int) {
        guard index >= 0 && index < elements.count else { return }
        elements.remove(at: index)
        updatedAt = Date()
    }

    public mutating func removeElement(id: String) {
        elements.removeAll { $0.id == id }
        updatedAt = Date()
    }

    public mutating func markElementCompleted(at index: Int, completed: Bool = true) {
        guard index >= 0 && index < elements.count else { return }
        elements[index].completed = completed
        elements[index].completedAt = completed ? Date() : nil
        updatedAt = Date()
    }

    public mutating func markElementCompleted(id: String, completed: Bool = true) {
        guard let index = elements.firstIndex(where: { $0.id == id }) else { return }
        markElementCompleted(at: index, completed: completed)
    }

    public mutating func start() {
        startDate = Date()
        updatedAt = Date()
    }

    public mutating func resetProgress() {
        for i in 0..<elements.count {
            elements[i].completed = false
            elements[i].completedAt = nil
        }
        updatedAt = Date()
    }

    public func elements(forDay day: Int) -> [PlanElement] {
        elements.filter { $0.day == day }
    }

    public func todaysActivities() -> [PlanElement] {
        guard let startDate = startDate else { return [] }
        let daysPassed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        let currentDay = (daysPassed % totalDays) + 1
        return elements(forDay: currentDay)
    }

    public func upcomingActivity() -> PlanElement? {
        elements.first { !$0.completed }
    }
}
