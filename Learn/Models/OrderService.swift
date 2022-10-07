//
//  NetworkModel.swift
//  Learn
//
//  Created by Mohammad Azam on 10/5/22.
//

import Foundation

enum OrderServiceError: Error {
    case badURL
}

class OrderService {
    
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getAllOrders() async throws -> [Order] {
        
        guard let url = URL(string: "/orders", relativeTo: baseURL) else {
            throw OrderServiceError.badURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Order].self, from: data)
    }
    
    func placeOrder(_ order: Order) async throws -> Order? {
        
        guard let url = URL(string: "/newOrder", relativeTo: baseURL) else {
            throw OrderServiceError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let savedOrder = try JSONDecoder().decode(Order.self, from: data)
        
        return savedOrder
    }
    
    func updateOrder(_ order: Order) async throws -> Order? {
        
        guard let url = URL(string: "/orders/\(order.id!)", relativeTo: baseURL) else {
            throw OrderServiceError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let updatedOrder = try JSONDecoder().decode(Order.self, from: data)
        
        return  updatedOrder 
    }
    
}
