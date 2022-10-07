//
//  ContentView.swift
//  Learn
//
//  Created by Mohammad Azam on 9/30/22.
//

import SwiftUI


struct DemoView: View {
    
    @State private var name: String = ""
    
    var body: some View {
        VStack {
            let _ = Self._printChanges()
            
            List(1...20, id: \.self) { index in
                Text("\(index)")
            }
            
            TextField("Name", text: $name)
            
            Button("Greet") {
                
            }
        }
    }
}



enum Sheets: Identifiable {
    case add
    case update(Order)
    
    var id: Int {
        switch self {
            case .add:
                return 1
            case .update(_):
                return 2
        }
    }
}

struct ContentView: View {
    
    @EnvironmentObject private var model: Model
    @State private var activeSheet: Sheets?
    
    
    var ordersTotal: Double {
        model.orders.reduce(0) { result, order in
            result + order.total
        }
    }
    
    var body: some View {
        NavigationStack {
            
            List {
                
                HStack {
                    Spacer()
                    Text("Total:")
                    Text(ordersTotal as NSNumber, formatter: NumberFormatter.currency)
                    Spacer()
                }.bold()
                
                ForEach(model.orders) { order in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(order.name)
                            Text(order.coffeeName)
                                .opacity(0.5)
                        }
                        Spacer()
                        Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                    }
                    .contentShape(Rectangle())
                    .onLongPressGesture {
                        activeSheet = .update(order)
                    }
                }
            }.task {
                do {
                    try await model.getAllOrders()
                } catch {
                    print(error.localizedDescription)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add New Order") {
                        activeSheet = .add
                    }
                }
            }
        }
        .sheet(item: $activeSheet, content: { sheet in
            switch sheet {
                case .add:
                    AddNewCoffeeOrderView()
                case .update(let order):
                    AddNewCoffeeOrderView(order: order)
            }
        })
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView().environmentObject(Model(orderService: OrderService(baseURL: URL(string: "https://island-bramble.glitch.me/orders")!)))
        }
    }
}
