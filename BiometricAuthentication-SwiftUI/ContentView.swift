//
//  ContentView.swift
//  BiometricAuthentication-SwiftUI
//
//  Created by Negin Zahedi on 2024-05-25.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @ObservedObject var authenticationController = AuthenticationController()
    @State private var status = ""
    @State private var biometricAvailable = true
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text(status)
                .foregroundColor(biometricAvailable ? .primary : .red)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.top, 100)
                .padding(.bottom, 50)
            
            if !authenticationController.isLoggedIn {
                // Display biometric authentication buttons if user is not logged in
                if authenticationController.biometricType == .faceID {
                    Button {
                        authenticate()
                    } label: {
                        Label("Use FaceID", systemImage: "faceid")
                    }
                    .buttonStyle(.bordered)
                } else if authenticationController.biometricType == .touchID {
                    Button {
                        authenticate()
                    } label: {
                        Label("Use TouchID", systemImage: "touchid")
                    }
                    .buttonStyle(.bordered)
                } else {
                    Text("No Biometric Option Available")
                }
            }
            Spacer()
        }
        .onAppear(perform: checkPermission)
    }
    
    // MARK: - Methods
    
    /// Check biometric availability and update UI accordingly.
    func checkPermission() {
        authenticationController.askBiometricAvailability { error in
            if let error {
                status = "Error: " + "\n" + error.localizedDescription
                biometricAvailable = false
            } else {
                biometricAvailable = true
            }
        }
    }
    
    /// Authenticate using biometric authentication.
    func authenticate() {
        authenticationController.authenticate { result in
            switch result {
            case .success(_):
                status = "\n Logged In."
            case .failure(let failure):
                status = "Status:" + failure.localizedDescription
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
