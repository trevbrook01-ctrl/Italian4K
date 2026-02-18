//
//  PurchaseService.swift
//  Italian4K
//
//  Created by WARREN PETERS on 17/02/2026.
//

import Foundation
import Combine
import StoreKit

@MainActor
final class PurchaseService: ObservableObject {
    
    // MARK: - Product Identifier
    static let productID = "com.warrenpeters.italian4k.pro.unlock"
    static let shared = PurchaseService()
    
private let proKey = "isProUnlocked"

    
    // MARK: - Published State
    @Published private(set) var isProUnlocked: Bool = false
    private(set) var product: Product?
    private var updatesTask: Task<Void, Never>?
    
    // MARK: - Init
    private init() {
        // Start with persisted value, then verify entitlement
        isProUnlocked = UserDefaults.standard.bool(forKey: proKey)
        
        Task {
            await loadProduct()
            await refreshEntitlements()
        }
        
        updatesTask = Task {
            for await result in Transaction.updates {
                if let transaction = try? await self.checkVerified(result) {
                    await transaction.finish()
                    await self.refreshEntitlements()
                }
            }
        }
    }
    
    // MARK: - Product Loading
    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            product = products.first
            
            if let product {
                print("✅ IAP product loaded:", product.id, product.displayPrice)
            } else {
                print("⚠️ Product not found:", Self.productID)
            }
        } catch {
            print("❌ Product fetch failed:", error.localizedDescription)
        }
    }
    
    // MARK: - Purchase
    func purchasePro(completion: @escaping (Bool) -> Void) {
        Task {
            let success = await purchasePro()
            completion(success)
        }
    }
    
    func purchasePro() async -> Bool {
        guard let product else {
            await loadProduct()
            guard product != nil else { return false }
            return await purchasePro()
        }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                
                await refreshEntitlements()
                return isProUnlocked
                
            case .userCancelled, .pending:
                return false
                
            @unknown default:
                return false
            }
        } catch {
            print("❌ Purchase failed:", error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Restore Purchases
    func restorePurchases() async {
        await refreshEntitlements()
    }
    
    // MARK: - Entitlement Refresh
    private func refreshEntitlements() async {
        var unlocked = false
        
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result),
               transaction.productID == Self.productID {
                unlocked = true
                break
            }
        }
        
        isProUnlocked = unlocked
        UserDefaults.standard.set(isProUnlocked, forKey: proKey)
        
        print("🔐 Pro unlocked:", unlocked)
    }
    
    // MARK: - Verification Helper
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreKitError.notEntitled
        }
    }
    
    deinit {
        updatesTask?.cancel()
    }
}

