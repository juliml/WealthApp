//
//  MockAccountService.swift
//  WealthApp
//
//  Created by Juliana Lacerda on 2026-11-23.
//

import Foundation

/// O que o dashboard precisa, num só valor.
/// `Sendable`: pode atravessar tarefas concorrentes sem risco.
struct DashboardData: Sendable {
    let account: Account
    let transactions: [Transaction]
    let positions: [Position]
}

protocol AccountServiceProtocol: Sendable {
    func fetchAccount() async throws -> Account
    func fetchTransactions() async throws -> [Transaction]
    func fetchPositions() async throws -> [Position]
}

extension AccountServiceProtocol {
    /// As três buscas rodam **em paralelo** (`async let`) e só voltam
    /// para a MainActor quando as três terminarem.
    /// Este método é não-isolado: o paralelismo acontece fora da MainActor.
    func fetchAll() async throws -> DashboardData {
        async let account = fetchAccount()
        async let transactions = fetchTransactions()
        async let positions = fetchPositions()
        return try await DashboardData(
            account: account,
            transactions: transactions,
            positions: positions
        )
    }
}

/// Cache em memória protegido por um actor: várias tarefas podem ler
/// e escrever ao mesmo tempo sem condição de corrida — o actor
/// serializa o acesso ao estado.
actor AccountCache {
    private var account: Account?
    private var transactions: [Transaction]?
    private var positions: [Position]?
    
    func cachedAccount() -> Account? { account }
    func cachedTransactions() -> [Transaction]? { transactions }
    func cachedPositions() -> [Position]? { positions }
    
    func store(account: Account) { self.account = account }
    func store(transactions: [Transaction]) { self.transactions = transactions }
    func store(positions: [Position]) { self.positions = positions }
}

struct MockAccountService: AccountServiceProtocol {
    private let cache = AccountCache()
    
    func fetchAccount() async throws -> Account {
        if let cached = await cache.cachedAccount() { return cached }
        // Latência simulada de rede. Se a tarefa for cancelada aqui,
        // `Task.sleep` lança CancellationError — e nada é guardado no cache.
        try await Task.sleep(for: .milliseconds(600))
        try Task.checkCancellation()
        let account = Account(holderName: "Juliana", balance: 12_480.75, currencyCode: "CAD")
        await cache.store(account: account)
        return account
    }
    
    func fetchTransactions() async throws -> [Transaction] {
        if let cached = await cache.cachedTransactions() { return cached }
        try await Task.sleep(for: .milliseconds(900))
        try Task.checkCancellation()
        let transactions = [
            Transaction(description: "Depósito — salário", amount: 3_200, date: .now, category: "Renda"),
            Transaction(description: "Supermercado", amount: -184.90, date: .now.addingTimeInterval(-86_400), category: "Mercado"),
            Transaction(description: "Assinatura de streaming", amount: -16.99, date: .now.addingTimeInterval(-2 * 86_400), category: "Lazer")
        ]
        await cache.store(transactions: transactions)
        return transactions
    }
    
    func fetchPositions() async throws -> [Position] {
        if let cached = await cache.cachedPositions() { return cached }
        try await Task.sleep(for: .milliseconds(1_200))
        try Task.checkCancellation()
        let positions = [
            Position(assetName: "ETF S&P/TSX", quantity: 42, currentValue: 3_180.40),
            Position(assetName: "Ações — Banco Canadense", quantity: 25, currentValue: 2_450.00),
            Position(assetName: "Fundo de renda fixa", quantity: 100, currentValue: 5_120.35)
        ]
        await cache.store(positions: positions)
        return positions
    }
}
