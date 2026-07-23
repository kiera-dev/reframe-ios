//
//  ContentView.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/20/26.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("appTheme") private var themeRaw = AppTheme.twilight.rawValue
    private var theme: AppTheme { AppTheme(rawValue: themeRaw) ?? .twilight }
    
    @State private var showMicro = false
    @State private var showPanic = false
    @State private var showSTOP = false
    @State private var showRumination = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                CalmingBackground(theme: theme)
                    .id(theme)
                
                VStack(spacing: 8) {
                    HStack {
                        Spacer()
                        ThemeToggleButton()
                    }
                    .padding(.horizontal)
                    
                    Text("ReFrame")
                        .font(.system(size: 40, weight: .thin, design: .rounded))
                        .tracking(4)
                        .foregroundStyle(theme.textPrimary)
                    
                    Text("take a moment")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(theme.textSecondary)
                        .padding(.bottom, 24)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            StreakView(theme: theme)
                            
                            ProtocolCard(icon: "wind", title: "Panic Spike Reset", subtitle: "For sudden overwhelm", theme: theme) { showPanic = true }
                            ProtocolCard(icon: "hand.raised", title: "STOP Protocol", subtitle: "Pause before reacting", theme: theme) { showSTOP = true }
                            ProtocolCard(icon: "ear", title: "Rumination Interrupt", subtitle: "Come back to your senses", theme: theme) { showRumination = true }
                            ProtocolCard(icon: "leaf", title: "90-Second Micro Reset", subtitle: "A quick full-body release", theme: theme) { showMicro = true }
                        }
                        .padding()
                    }
                }
                .padding(.top, 8)
            }
            .navigationDestination(isPresented: $showPanic) { PMRSessionView(protocol: ResetLibrary.panicSpike) }
            .navigationDestination(isPresented: $showRumination) { PMRSessionView(protocol: ResetLibrary.ruminationInterrupt) }
            .navigationDestination(isPresented: $showSTOP) { PMRSessionView(protocol: ResetLibrary.stopProtocol) }
            .navigationDestination(isPresented: $showMicro) { PMRSessionView(protocol: ResetLibrary.microPMR) }
        }
        .tint(theme.accent)
    }


    struct ProtocolCard: View {
        let icon: String
        let title: String
        let subtitle: String
        let theme: AppTheme
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 16) {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .light))
                        .foregroundStyle(theme.accent)
                        .frame(width: 44, height: 44)
                        .background(theme.accent.opacity(0.12), in: Circle())
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(title)
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.medium)
                        Text(subtitle)
                            .font(.system(.footnote, design: .rounded))
                            .foregroundStyle(theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.light))
                        .foregroundStyle(theme.textSecondary.opacity(0.6))
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 18)
                .background(theme.cardFill)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(theme.cardStroke, lineWidth: 1)
                )
                .foregroundStyle(theme.textPrimary)
            }
            .buttonStyle(.plain)
        }
    }
}
