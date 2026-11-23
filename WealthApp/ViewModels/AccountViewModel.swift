//
//  AccountViewModel.swift
//  WealthApp
//
//  Created by Juliana Lacerda on 2026-11-23.
//

import Foundation
import Observation

@MainActor
@Observable
final class AccountViewModel {
    private let service: AccountServiceProtocol
    
    var account: Account
    var transactions: [Transaction]
    var positions: [Position]
    var isLoading = false
    
    init(service: AccountServiceProtocol) {
        self.service = service
        self.account = service.account
        self.transactions = service.transactions
        self.positions = service.positions
    }
}
