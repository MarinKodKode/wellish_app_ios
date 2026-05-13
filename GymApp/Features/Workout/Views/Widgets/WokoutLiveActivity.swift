//
//  WokoutLiveActivity.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 14/10/25.
//

import Foundation
import SwiftUI
import WidgetKit
import ActivityKit

struct WorkoutLiveActivity : Widget {
    var body : some WidgetConfiguration {
        ActivityConfiguration(for  : WorkoutActivityAttributes.self){ context in
            VStack(spacing : 8){
                HStack {
                    Image(systemName : "dumbbell.fil")
                        .foregroundColor(Color.fitnessTextPrimary)
                    Text(context.attributes.workoutName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                
                
                HStack {
                    VStack(alignment: .leading, spacing: 4){
                        Text("Descanso")
                            .font(.caption2)
                            .foregroundColor(.energyOrange)
                        Text("\(context.state.restTimeRemaining)s")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.energyOrange)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4){
                        Text(context.state.currentExercise)
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Text("Set \(context.state.currentSet)/\(context.state.totalSets)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Siguiente: \(context.state.nextExercise)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .activityBackgroundTint(Color(red : 0.12, green: 0.14, blue: 0.22))
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland : { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading){
                    VStack(alignment: .leading){
                        Text("DESCANSO")
                            .font(.caption2)
                            .foregroundColor(.orange)
                        Text("\(context.state.restTimeRemaining)s")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text(context.state.currentExercise)
                            .font(.caption)
                        Text("Set \(context.state.currentSet)/\(context.state.totalSets)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.purple)
                        Text("Siguiente: \(context.state.nextExercise)")
                            .font(.caption)
                    }
                }
            } compactLeading: {
                Image(systemName: "dumbbell.fill")
                    .foregroundColor(.purple)
            } compactTrailing: {
                Text("\(context.state.restTimeRemaining)s")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            } minimal: {
                Image(systemName: "dumbbell.fill")
                    .foregroundColor(.purple)
            }
        }
    }
}
