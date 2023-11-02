//
//  TodoListView.swift
//  MVVM_SwiftUI
//
//  Created by Thomas Woodfin on 10/24/2023.
//

import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel = TodoListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.loading {
                    ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle(tint: Color.blue)).foregroundColor(.blue)
                } else {
                    if viewModel.todos.isEmpty {
                        Text("Nothing to display.").alert(isPresented: Binding<Bool>(
                            get: { self.viewModel.error != nil },
                            set: { _ in self.viewModel.error = nil }
                        )) {
                            Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "Sorry, there are something went wrong. Please try later."), dismissButton: .default(Text("OK")))
                        }
                    }
                    else {
                        List(viewModel.todos) { todo in
                            Text(todo.title)
                        }
                    }
                    
                }
            }.onAppear {
                viewModel.fetchTodos()
            }.navigationBarTitle("Todos List", displayMode: .automatic)
        }
        
        
        
    }
}


#Preview {
    TodoListView()
}
