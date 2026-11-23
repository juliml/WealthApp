//
//  MockAccountService.swift
//  WealthApp
//
//  Created by Juliana Lacerda on 2026-11-23.
//

import Foundation

/// Protocolo que o ViewModel usa. Hoje ele devolve dados fixos;
/// no Dia 2 (concorrência) a implementação assíncrona entra aqui,
/// sem mudar nenhuma View.

protocol AccountServiceProtocol: Sendable {
    var account: Account { get }
    var transactions: [Transaction] { get }
    var positions: [Position] { get }
}

struct MockAccountService: AccountServiceProtocol {
    let account = Account(
        holderName: "Juliana",
        balance: 12_480.75,
        currencyCode: "CAD"
    )
    
    let transactions: [Transaction] = [
        Transaction(description: "Depósito — salário", amount: 3_200, date: .now, category: "Renda"),
        Transaction(description: "Supermercado", amount: -184.90, date: .now.addingTimeInterval(-86_400), category: "Mercado"),
        Transaction(description: "Assinatura de streaming", amount: -16.99, date: .now.addingTimeInterval(-2 * 86_400), category: "Lazer")
    ]
    
    let positions: [Position] = [
        Position(assetName: "ETF S&P/TSX", quantity: 42, currentValue: 3_180.40),
        Position(assetName: "Ações — Banco Canadense", quantity: 25, currentValue: 2_450.00),
        Position(assetName: "Fundo de renda fixa", quantity: 100, currentValue: 5_120.35)
    ]
}
