//
//  LearnApp.swift
//  Learn
//
//  Created by Mohammad Azam on 9/30/22.
//

import SwiftUI

@main
struct LearnApp: App {
    
    private var service = OrderService(baseURL: URL(string: "https://island-bramble.glitch.me/orders")!)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Model(orderService: service))
        }
    }
}
