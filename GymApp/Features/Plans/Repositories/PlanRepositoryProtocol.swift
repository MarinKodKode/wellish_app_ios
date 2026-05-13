//
//  PlanRepositoryProtocol.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 17/10/25.
//

import Foundation

protocol PlanServiceProtocol {
    var errorMessage: String? { get set }
    var lastSyncDate: Date? { get }

    func getPlans() async -> [Plan]
    func getPlan(by id: String) async -> Plan?
    func getPlans(for userId: String) async -> [Plan]
    func savePlanLocally(_ plan: Plan) async -> Bool
    func savePlanRemote(_ plan: Plan) async -> Bool
    func updatePlan(_ plan: Plan) async -> Bool
}
