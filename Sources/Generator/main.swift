import Foundation
@testable import GNSSCodes

let resourcesURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    .appendingPathComponent("Sources")
    .appendingPathComponent("GNSSCodes")
    .appendingPathComponent("Resources")

func generateAndSave(type: CodeType, name: String) {
    let fileURL = resourcesURL.appendingPathComponent("\(name).bin")
    var allData = Data()
    
    for prn in 1...50 {
        if let code = GNSSCodes.generate(prn: prn, type: type) {
            let chips = code.chips
            chips.withUnsafeBufferPointer { buffer in
                if let baseAddress = buffer.baseAddress {
                    let data = Data(bytes: baseAddress, count: buffer.count * MemoryLayout<Int16>.stride)
                    allData.append(data)
                }
            }
        }
    }
    
    do {
        try allData.write(to: fileURL)
        print("Generated \(name).bin with \(allData.count) bytes.")
    } catch {
        print("Error writing \(name).bin: \(error)")
    }
}

generateAndSave(type: .E1B, name: "E1B")
generateAndSave(type: .E1C, name: "E1C")
generateAndSave(type: .E5AI, name: "E5aI")
generateAndSave(type: .E5AQ, name: "E5aQ")
generateAndSave(type: .E5BI, name: "E5bI")
generateAndSave(type: .E5BQ, name: "E5bQ")
