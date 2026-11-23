//
//  LoginView.swift
//  WealthApp
//
//  Created by Juliana Lacerda on 2026-11-23.
//

import SwiftUI

struct LoginView: View {
    var onLogin: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("WealthApp")
                .font(.largeTitle.bold())
            Text("Sua conta, em um só lugar.")
                .foregroundStyle(.secondary)
            
            // Sem senha real hoje: só o fluxo login → dashboard.
            // Biometria e Keychain chegam no Dia 3 (quarta).
            Button("Entrar") {
                onLogin()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

#Preview {
    LoginView {}
}
