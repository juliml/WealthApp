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
    
    // Agora começam vazios: o dashboard mostra o carregamento
    // até a busca assíncrona terminar.
    var account: Account?
    var transactions: [Transaction] = []
    var positions: [Position] = []
    var isLoading = false
    var errorMessage: String?
    
    private var loadTask: Task<Void, Never>?
    
    init(service: AccountServiceProtocol) {
        self.service = service
    }
    
    /// Cria a tarefa de carregamento (uma só por vez).
    /// Chamada pela View com `.task` — que já cancela sozinha
    /// quando a tela some.
    func startLoading() {
        guard loadTask == nil else { return }
        loadTask = Task { await load() }
    }
    
    func cancelLoading() {
        loadTask?.cancel()
        loadTask = nil
    }
    
    /// Caminho do pull-to-refresh: espera o carregamento terminar,
    /// para o indicador só sumir quando os dados chegarem.
    func reload() async {
        cancelLoading()
        await load()
    }
    
    private func load() async {
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
            loadTask = nil
        }
        do {
            let data = try await service.fetchAll()
            account = data.account
            transactions = data.transactions
            positions = data.positions
        } catch is CancellationError {
            // Sair da tela no meio do carregamento não é erro:
            // só interrompe em silêncio.
            return
        } catch {
            errorMessage = "Não foi possível carregar sua conta. Tente novamente."
        }
    }
}
