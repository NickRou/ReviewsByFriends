import SwiftUI

struct LoginView: View {
    @ObservedObject var userManager: UserManager
    @Binding var showingLoginView: Bool
    @State private var username = ""
    @State private var password = ""
    @State private var isSigningUp = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Login / Sign Up")) {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                }
                
                Button(isSigningUp ? "Sign Up" : "Login") {
                    if isSigningUp {
                        if userManager.signUp(username: username, password: password) {
                            alertMessage = "Sign up successful!"
                            showingLoginView = false  // Redirect to main view
                        } else {
                            alertMessage = "Username already exists"
                            showAlert = true
                        }
                    } else {
                        if userManager.login(username: username, password: password) {
                            alertMessage = "Login successful!"
                            showingLoginView = false  // Redirect to main view
                        } else {
                            alertMessage = "Invalid username or password"
                            showAlert = true
                        }
                    }
                }
                
                Button(isSigningUp ? "Already have an account? Login" : "Don't have an account? Sign Up") {
                    isSigningUp.toggle()
                }
            }
            .navigationTitle(isSigningUp ? "Sign Up" : "Login")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
