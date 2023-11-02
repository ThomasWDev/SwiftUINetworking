//
//  TodoModel.swift
//  MVVM_SwiftUI
//
//  Created by Thomas Woodfin on 10/24/2023.
//

import Foundation

struct Todo: Identifiable, Decodable {
    let id: Int
    let title: String
}

