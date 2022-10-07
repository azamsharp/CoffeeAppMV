//
//  AddNewCoffeeOrderView.swift
//  Learn
//
//  Created by Mohammad Azam on 10/5/22.
//

import SwiftUI

struct AddNewCoffeeOrderError {
    var name: String = ""
    var coffeeName: String = ""
    var total: String = ""
}

// You can use a separate view model to collect and validate information
// This can be useful if you have a large form with validation 
struct AddCoffeeViewState {
    
    var name: String = ""
    var coffeeName: String = ""
    var total: String = ""
    var size: CoffeeSize = .medium
    var errors: AddNewCoffeeOrderError = AddNewCoffeeOrderError()
    
    mutating func isValid() -> Bool {
       
        if name.isEmpty {
            errors.name = "Name cannot be empty!"
        }
        
        if coffeeName.isEmpty {
            errors.coffeeName = "Coffee name cannot be empty"
        }
        
        if total.isEmpty {
            errors.total = "Total cannot be empty"
        } else if !total.isNumeric {
            errors.total = "Total can only be numbers"
        } else if total.isLessThan(0) {
            errors.total = "Total cannot be less than 0"
        }
        
        return errors.name.isEmpty && errors.coffeeName.isEmpty && errors.total.isEmpty
    }
}

struct AddNewCoffeeOrderView: View {
    
    @State private var name: String = ""
    @State private var coffeeName: String = ""
    @State private var total: String = ""
    @State private var size: CoffeeSize = .medium
    @State private var errors: AddNewCoffeeOrderError = AddNewCoffeeOrderError()
    
    let order: Order? 
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var model: Model
    
    init(order: Order? = nil) {
        self.order = order
    }
    
    private func placeOrder(_ order: Order) async {
        try? await model.placeOrder(order)
        dismiss()
    }
    
    private func updateOrder(_ order: Order) async {
        try? await model.updateOrder(order)
        dismiss() 
    }
    
    private func updateOrPlaceOrder() async {
        if let order {
            // update the order
            let order = Order(id: order.id, name: name, coffeeName: coffeeName, total: Double(total)!, size: size)
            await updateOrder(order)
            
        } else {
            // place the order
            let order = Order(name: name, coffeeName: coffeeName, total: Double(total)!, size: size)
            await placeOrder(order)
        }
    }
    
    var isFormValid: Bool {
        
        if name.isEmpty {
            errors.name = "Name cannot be empty!"
        }
        
        if coffeeName.isEmpty {
            errors.coffeeName = "Coffee name cannot be empty"
        }
        
        if total.isEmpty {
            errors.total = "Total cannot be empty"
        } else if !total.isNumeric {
            errors.total = "Total can only be numbers"
        } else if total.isLessThan(0) {
            errors.total = "Total cannot be less than 0"
        }
        
        return errors.name.isEmpty && errors.coffeeName.isEmpty && errors.total.isEmpty
        
    }
    
    var body: some View {
        
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                !errors.name.isEmpty ? Text(errors.name) : nil
                
                TextField("Coffee name", text: $coffeeName)
                !errors.coffeeName.isEmpty ? Text(errors.coffeeName) : nil
                
                TextField("Total", text: $total)
                !errors.total.isEmpty ? Text(errors.total) : nil
                
                Picker("Coffee Size", selection: $size) {
                    ForEach(CoffeeSize.allCases) { coffeeSize in
                        Text(coffeeSize.rawValue).tag(coffeeSize)
                    }
                }.pickerStyle(.segmented)
            }
            .onAppear {
                if let order {
                    // editing mode
                    name = order.name
                    coffeeName = order.coffeeName
                    total = String(order.total)
                    size = order.size
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(order != nil ? "Update Order": "Place Order") {
                        Task {
                            if isFormValid {
                                await updateOrPlaceOrder()
                            }
                        }
                    }
                }
            }
        }
        
    }
}

struct AddNewCoffeeOrderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddNewCoffeeOrderView().environmentObject(Model(orderService: OrderService(baseURL: URL(string: "https://island-bramble.glitch.me/orders")!)))
        }
    }
}

