//
//  Currencies.swift
//  Interview
//
//  Created by ilker sevim on 30.01.2022.
//

import Foundation

// MARK: - Currencies
struct Currencies: Codable, Hashable{
    
    let data: [Currrency]?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
}

// MARK: - Currrency
struct Currrency: Codable, Hashable {
    let id, name, minSize: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case minSize = "min_size"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(minSize)
    }
}

