import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var authManager = AuthManager() // Initialize AuthManager
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingSignUp = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Username or email", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Login") {
                    // Handle login
                }
                .padding()
                
                SignInWithAppleButton(.signIn) { _ in
                    authManager.signInWithApple()
                } onCompletion: { result in
                    // Result handling is now managed by AuthManager
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 45)
                .padding()

                Button("Don't have an account? Sign Up") {
                    showingSignUp = true
                }
                .sheet(isPresented: $showingSignUp) {
//                    SignUpView()
                }

                if authManager.isAuthenticated {
                    // Optionally display email and name after successful authorization
                    Text("Welcome, \(authManager.fullName)")
                    Text("Email: \(authManager.email)")
                }
            }
            .padding()
            .navigationBarTitle("Sign In")
        }
    }
}

#Preview {
    LoginView()
}
