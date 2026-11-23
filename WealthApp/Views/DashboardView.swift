//
//  DashboardView.swift
//  WealthApp
//
//  Created by Juliana Lacerda on 2026-11-23.
//

import SwiftUI

struct DashboardView: View {
    var viewModel: AccountViewModel
    
    var body: some View {
        List {
            Section("Saldo total") {
                Text(viewModel.account.balance.formatted(.currency(code: viewModel.account.currencyCode)))
                    .font(.title.bold())
                Text(viewModel.account.holderName)
                    .foregroundStyle(.secondary)
            }
            
            Section("Transações") {
                ForEach(viewModel.transactions) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.description)
                            Text(transaction.category)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(transaction.amount.formatted(.currency(code: viewModel.account.currencyCode)))
                            .foregroundStyle(transaction.amount < 0 ? .red : .green)
                    }
                }
            }
            
            Section("Posições") {
                ForEach(viewModel.positions) { position in
                    HStack {
                        Text(position.assetName)
                        Spacer()
                        Text(position.currentValue.formatted(.currency(code: viewModel.account.currencyCode)))
                    }
                }
            }
        }
        .navigationTitle("Minha conta")
    }
}

#Preview {
    DashboardView(viewModel: AccountViewModel())
}
