import UniformTypeIdentifiers
import SwiftUI

struct CircuitDocument: FileDocument {
    static var readableContentTypes: [UTType] = [.circ, .json]
    
    var circuitData: CircuitData
    
    init(circuitData: CircuitData) {
        self.circuitData = circuitData
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
               throw CocoaError(.fileReadCorruptFile)
           }
        circuitData = try JSONDecoder().decode(CircuitData.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self.circuitData)
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        return fileWrapper
    }
}
