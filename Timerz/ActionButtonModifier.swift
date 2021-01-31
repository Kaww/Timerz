//
//  ActionButtonModifier.swift
//  Timerz
//
//  Created by KAWRANTIN LE GOFF on 31/01/2021.
//

import SwiftUI

struct ActionButton: ViewModifier {
    let color: Color
    let style: ActionButtonStyle
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: style == ActionButtonStyle.filledLarge ? 20 : 18, weight: .medium, design: .rounded))
            .frame(
                width: style == ActionButtonStyle.filledLarge ? 100 : 85,
                height: style == ActionButtonStyle.filledLarge ? 40 : 35)
            .background(style == ActionButtonStyle.regular ? Color.clear : color)
            .foregroundColor(style == ActionButtonStyle.regular ? color : .white)
            .clipShape(Capsule())
    }
    
    enum ActionButtonStyle {
        case filled, filledLarge, regular
    }
}

extension View {
    func actionButtonStyle(color: Color, style: ActionButton.ActionButtonStyle) -> some View {
        self.modifier(ActionButton(color: color, style: style))
    }
}
