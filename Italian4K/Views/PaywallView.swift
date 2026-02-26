//
//  PaywallView.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    
    @State private var product: Product?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                
                Text("Unlock All Vocabulary Categories")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                
                Text("One‑time purchase. No subscriptions, no ads — just full access.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Button(product != nil
                       ? "Unlock All Categories — \(product!.displayPrice)"
                       : "Unlock All Categories") {
                    PurchaseService.shared.purchasePro { success in
                        if success { dismiss() }
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.primary)
                
                Button("Restore Purchases") {
                    Task {
                        await PurchaseService.shared.restorePurchases()
                        dismiss()
                    }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                
                Button("Not Now") {
                    dismiss()
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            .task {
                do {
                    let products = try await Product.products(
                        for: [PurchaseService.productID]
                    )
                    product = products.first
                } catch {
                    print("Failed to load product:", error)
                }
            }
            .padding(30)
        }
    }
}

#Preview {
    PaywallView()
}
