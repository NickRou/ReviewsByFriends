import Foundation

class UserManager: ObservableObject {
    @Published var currentUser: User?
    @Published var users: [User] = []
    
    private let usersKey = "savedUsers"
    
    init() {
        loadUsers()
    }
    
    func signUp(username: String, password: String) -> Bool {
        guard !users.contains(where: { $0.username == username }) else {
            return false // Username already exists
        }
        let newUser = User(username: username, password: password)
        users.append(newUser)
        saveUsers()
        currentUser = newUser
        return true
    }
    
    func login(username: String, password: String) -> Bool {
        if let user = users.first(where: { $0.username == username && $0.password == password }) {
            currentUser = user
            return true
        }
        return false
    }
    
    func logout() {
        currentUser = nil
    }
    
    private func saveUsers() {
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: usersKey)
        } catch {
            print("Failed to save users: \(error.localizedDescription)")
        }
    }
    
    private func loadUsers() {
        guard let data = UserDefaults.standard.data(forKey: usersKey) else { return }
        do {
            users = try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("Failed to load users: \(error.localizedDescription)")
        }
    }
}
