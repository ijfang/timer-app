//
//  PauseButtonStyle.swift
//  Timer
//
//  Created by Isabelle Fang on 9/9/25.
//

import Foundation
import SwiftUI

// ButtonStyle - specifically applies to buttons
struct PauseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 70, height: 70)
            .foregroundColor(Color(.orange))
            .background(Color(.orange).opacity(0.3))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(Circle().stroke(Color(.orange).opacity(0.3), lineWidth: 2))
    }
}
