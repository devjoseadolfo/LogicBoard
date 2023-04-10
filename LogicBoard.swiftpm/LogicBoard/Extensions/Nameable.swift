protocol Nameable { 
    var name: String { get set }
}

extension Nameable {
    mutating func changeName(to newName: String) {
        name = newName
    }
}
