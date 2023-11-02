//
//  TodoListViewModel.swift
//  MVVM_SwiftUI
//
//  Created by Thomas Woodfin on 10/24/2023.
//

import Foundation
import Combine
import SwiftUI

class TodoListViewModel: ObservableObject {
    
    ///Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
    private var cancellables = Set<AnyCancellable>()
    
    @Published var todos = [Todo]()
    @Published var error: Error?
    @Published var loading = false
    
    func fetchTodos() {
        loading = true
        
        if let url = URL(string: "https://mocki.io/v1/3f36d12d-35ec-4ede-9b82-149982d24578") {
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data) // Extract data from the response
                .decode(type: [Todo].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main) // Switch to the main thread
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let fetchError):
                        self.error = fetchError
                        self.loading = false
                    }
                }, receiveValue: { fetchedTodos in
                    self.loading = false
                    self.todos = fetchedTodos
                })
                .store(in: &cancellables)
        }
    }
}

