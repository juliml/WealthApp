//
//  Account.swift
//  WealthApp
//
//  Created by Juliana Lacerda on 2026-11-23.
//

import Foundation

struct Account: Identifiable, Sendable {
    let id = UUID()
    let holderName: String
    let balance: Double
    let currencyCode: String
}

struct Transaction: Identifiable, Sendable {
    let id = UUID()
    let description: String
    let amount: Double
    let date: Date
    let category: String
}

struct Position: Identifiable, Sendable {
    let id = UUID()
    let assetName: String
    let quantity: Double
    let currentValue: Double
}
