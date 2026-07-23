import Foundation

extension GNSSCodes {
    static let LEN_E1B = 4092
    static let LEN_E1C = 4092
    static let LEN_E5 = 10230
    static let CRATE_E1 = 1.023E6
    static let CRATE_E5 = 10.23E6

    private static func loadCode(name: String, prn: Int, length: Int) -> [Int16]? {
        guard prn >= 1 && prn <= 50 else { return nil }
        
        guard let url = Bundle.module.url(forResource: name, withExtension: "bin") else {
            print("Error: Could not find resource \(name).bin")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let byteOffset = (prn - 1) * length * MemoryLayout<Int16>.stride
            
            guard byteOffset + length * MemoryLayout<Int16>.stride <= data.count else {
                return nil
            }
            
            return data.withUnsafeBytes { rawBuffer in
                let binded = rawBuffer.bindMemory(to: Int16.self)
                let start = (prn - 1) * length
                let slice = binded[start..<(start + length)]
                return Array(slice)
            }
        } catch {
            // 🛡️ Sentinel: Removed raw error interpolation to prevent information leakage (e.g., exposing absolute file paths in production)
            print("Error loading resource: \(name).bin")
            return nil
        }
    }

    static func generateE1B(prn: Int, length: inout Int, chipRate: inout Double) -> [Int16]? {
        length = LEN_E1B
        chipRate = CRATE_E1
        return loadCode(name: "E1B", prn: prn, length: LEN_E1B)
    }

    static func generateE1C(prn: Int, length: inout Int, chipRate: inout Double) -> [Int16]? {
        length = LEN_E1C
        chipRate = CRATE_E1
        return loadCode(name: "E1C", prn: prn, length: LEN_E1C)
    }

    static func generateE5aI(prn: Int, length: inout Int, chipRate: inout Double) -> [Int16]? {
        length = LEN_E5
        chipRate = CRATE_E5
        return loadCode(name: "E5aI", prn: prn, length: LEN_E5)
    }

    static func generateE5aQ(prn: Int, length: inout Int, chipRate: inout Double) -> [Int16]? {
        length = LEN_E5
        chipRate = CRATE_E5
        return loadCode(name: "E5aQ", prn: prn, length: LEN_E5)
    }

    static func generateE5bI(prn: Int, length: inout Int, chipRate: inout Double) -> [Int16]? {
        length = LEN_E5
        chipRate = CRATE_E5
        return loadCode(name: "E5bI", prn: prn, length: LEN_E5)
    }

    static func generateE5bQ(prn: Int, length: inout Int, chipRate: inout Double) -> [Int16]? {
        length = LEN_E5
        chipRate = CRATE_E5
        return loadCode(name: "E5bQ", prn: prn, length: LEN_E5)
    }
}
