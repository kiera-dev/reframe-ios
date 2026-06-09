//
//  Theme.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/27/26.
//

import SwiftUI

extension Color {
    static let midnightDeep = Color(red: 0.04, green: 0.07, blue: 0.18)
    static let softTeal = Color(red: 0.45, green: 0.73, blue: 0.71)
    static let calmSage = Color(red: 0.65, green: 0.75, blue: 0.68)
}

struct CalmingBackground: View {
    @State private var drifting = false

    var body: some View {
        ZStack {
            Color.midnightDeep.ignoresSafeArea()
            Circle()
                .fill(Color.softTeal.opacity(0.12))
                .blur(radius: 100)
                .offset(x: drifting ? -130 : -150, y: drifting ? -215 : -200)
            Circle()
                .fill(Color.calmSage.opacity(0.1))
                .blur(radius: 100)
                .offset(x: drifting ? 165 : 150, y: drifting ? 285 : 300)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 9).repeatForever(autoreverses: true)) {
                drifting = true
            }
        }
    }
}
