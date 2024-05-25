//
//  AuthenticationController.swift
//  BiometricAuthentication-SwiftUI
//
//  Created by Negin Zahedi on 2024-05-25.
//

import Foundation
import LocalAuthentication

class AuthenticationController: ObservableObject {
    
    // MARK: - Properties
    
    // Biometric data type
    @Published var biometricType: LABiometryType = .none
    
    // Track login state
    @Published var isLoggedIn: Bool = false
    
    // Context for biometric authentication
    fileprivate var context: LAContext?
    
    // MARK: - Initialization
    
    init() {
        context = LAContext()
    }
    
    deinit {
        context = nil
    }
    
    // MARK: - Biometric Authentication
    
    /// Check if biometric authentication is available.
    ///
    /// - Parameter completion: A closure to call with the result of the operation.
    func askBiometricAvailability(completion: @escaping (Error?) -> Void) {
        if let context = context {
            var failureReason: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &failureReason) {
                biometricType = context.biometryType
                completion(nil)
            } else {
                completion(failureReason)
            }
        }
    }
    
    /// Perform biometric authentication.
    ///
    /// - Parameter completion: A closure to call with the result of the operation.
    func authenticate(completion: @escaping (Result<Bool, LAError>) -> Void) {
        if let context = context {
            let reason = "Please authenticate using Face ID to log in."
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async {
                        self.isLoggedIn = true  // Set logged in state to true upon successful authentication
                    }
                    completion(.success(true))
                } else if let error = error as? LAError {
                    completion(.failure(error))
                }
            }
        }
    }
}
