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
        Group {
            if viewModel.isLoading, viewModel.account == nil {
                ProgressView("Carregando sua conta…")
            } else if let errorMessage = viewModel.errorMessage, viewModel.account == nil {
                VStack(spacing: 16) {
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                    Button("Tentar novamente") {
                        viewModel.startLoading()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else if let account = viewModel.account {
                List {
                    Section("Saldo total") {
                        Text(account.balance.formatted(.currency(code: account.currencyCode)))
                            .font(.title.bold())
                        Text(account.holderName)
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
                                Text(transaction.amount.formatted(.currency(code: account.currencyCode)))
                                    .foregroundStyle(transaction.amount < 0 ? .red : .green)
                            }
                        }
                    }
                    
                    Section("Posições") {
                        ForEach(viewModel.positions) { position in
                            HStack {
                                Text(position.assetName)
                                Spacer()
                                Text(position.currentValue.formatted(.currency(code: account.currencyCode)))
                            }
                        }
                    }
                }
                .navigationTitle("Minha conta")
                .refreshable {
                    await viewModel.reload()
                }
            } else {
                VStack(spacing: 16) {
                    Text("Nenhum estado: loading=\(viewModel.isLoading), conta=\(viewModel.account == nil ? "vazia" : "ok"), erro=\(viewModel.errorMessage ?? "nenhum")")
                        .multilineTextAlignment(.center)
                    Button("Carregar") {
                        viewModel.startLoading()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .task {
            viewModel.startLoading()
        }
//        .onDisappear {
//            viewModel.cancelLoading()
//        }
    }
}

