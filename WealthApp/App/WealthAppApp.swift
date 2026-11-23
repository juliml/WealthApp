//
//  WealthAppApp.swift
//  WealthApp
//
//  Created by Juliana Lacerda on 2026-11-23.
//

import SwiftUI

@main
struct WealthAppApp: App {
    @State private var isAuthenticated = false
    @State private var viewModel: AccountViewModel
    
    init() {
        _viewModel = State(initialValue: MainActor.assumeIsolated {
            AccountViewModel(service: MockAccountService())
        })
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isAuthenticated {
                    DashboardView(viewModel: viewModel)
                } else {
                    LoginView {
                        isAuthenticated = true
                    }
                }
            }
        }
    }
}
