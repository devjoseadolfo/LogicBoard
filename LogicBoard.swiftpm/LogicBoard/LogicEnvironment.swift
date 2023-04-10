import SwiftUI

class LogicEnvironment: ObservableObject {
    @Published var board: LogicBoard
    @Published var showDock: Bool = true
    
    @Published var selectedCircuit: Circuit {
        willSet {
            board.selectedCircuit = newValue
        }
    }

    init() {
        let board = LogicBoard()
        self.board = board
        self.selectedCircuit = board.selectedCircuit
    }
}

