import Foundation

public enum CodeType: Int {
    case L1CA = 1
    case L1CP = 2
    case L1CD = 3
    case L1CO = 4
    case L2CM = 5
    case L2CL = 6
    case L5I = 7
    case L5Q = 8
    case E1B = 10
    case E1C = 11
    case E5AI = 12
    case E5AQ = 13
    case E5BI = 14
    case E5BQ = 15
    case B1I = 16
    case L1SBAS = 27
    case G1 = 20
    case NH10 = 28
    case NH20 = 29
}

public struct GNSSCode {
    public let chips: [Int16]
    public let length: Int
    public let chipRate: Double
}

public class GNSSCodes {
    
    public static func generate(prn: Int, type: CodeType) -> GNSSCode? {
        var length: Int = 0
        var chipRate: Double = 0.0
        let chips: [Int16]?
        
        switch type {
        case .L1CA: chips = generateL1CA(prn: prn, length: &length, chipRate: &chipRate)
        case .L1CP: 
            if let c = generateL1CP(prn: prn, length: &length, chipRate: &chipRate) {
                return boc(code: c, length: &length, chipRate: &chipRate, m: 1, n: 1)
            }
            return nil
        case .L1CD:
            if let c = generateL1CD(prn: prn, length: &length, chipRate: &chipRate) {
                return boc(code: c, length: &length, chipRate: &chipRate, m: 1, n: 1)
            }
            return nil
        case .L1CO: chips = generateL1CO(prn: prn, length: &length, chipRate: &chipRate)
        case .L2CM: chips = generateL2CM(prn: prn, length: &length, chipRate: &chipRate)
        case .L2CL: chips = generateL2CL(prn: prn, length: &length, chipRate: &chipRate)
        case .L5I:  chips = generateL5I(prn: prn, length: &length, chipRate: &chipRate)
        case .L5Q:  chips = generateL5Q(prn: prn, length: &length, chipRate: &chipRate)
        case .L1SBAS: chips = generateL1CA(prn: prn, length: &length, chipRate: &chipRate)
        case .E1B:  chips = generateE1B(prn: prn, length: &length, chipRate: &chipRate)
        case .E1C:  chips = generateE1C(prn: prn, length: &length, chipRate: &chipRate)
        case .E5AI: chips = generateE5aI(prn: prn, length: &length, chipRate: &chipRate)
        case .E5AQ: chips = generateE5aQ(prn: prn, length: &length, chipRate: &chipRate)
        case .E5BI: chips = generateE5bI(prn: prn, length: &length, chipRate: &chipRate)
        case .E5BQ: chips = generateE5bQ(prn: prn, length: &length, chipRate: &chipRate)
        case .B1I:  chips = generateB1I(prn: prn, length: &length, chipRate: &chipRate)
        case .NH10: chips = generateNH10(length: &length, chipRate: &chipRate)
        case .NH20: chips = generateNH20(length: &length, chipRate: &chipRate)
        case .G1:   chips = generateG1G2(length: &length, chipRate: &chipRate)
        }
        
        guard let finalChips = chips else { return nil }
        return GNSSCode(chips: finalChips, length: length, chipRate: chipRate)
    }
    
    // MARK: - Internal Helpers (Ported from gnss_cmn.c)
    
    static func oct2bin(oct: String, n: Int, nbit: Int, skiplast: Bool = false, flip: Bool = false) -> [Int16] {
        var bin = [Int16](repeating: 0, count: nbit)
        
        let chars = Array(oct)
        let skip = 3 * n - nbit
        
        var outIdx = 0
        for i in 0..<n {
            let char = chars[i]
            guard let val = Int(String(char)), val >= 0, val < 8 else { continue }
            for k in 0..<3 {
                if !skiplast && i == 0 && k < skip { continue }
                if skiplast && i == n - 1 && k >= 3 - skip { continue }
                if outIdx < nbit {
                    // ⚡ Bolt: Calculate binary value mathematically instead of lookup array
                    bin[outIdx] = Int16(((val >> (2 - k)) & 1) << 1) - 1
                    outIdx += 1
                }
            }
        }
        
        if flip {
            return bin.reversed()
        }
        return bin
    }
    
    static func hex2bin(hex: String, n: Int, nbit: Int, skiplast: Bool = false, flip: Bool = false) -> [Int16] {
        var bin = [Int16](repeating: 0, count: nbit)
        
        let chars = Array(hex)
        let skip = 4 * n - nbit
        
        var outIdx = 0
        for i in 0..<n {
            let char = chars[i]
            guard let val = Int(String(char), radix: 16) else { continue }
            for k in 0..<4 {
                if !skiplast && i == 0 && k < skip { continue }
                if skiplast && i == n - 1 && k >= 4 - skip { continue }
                if outIdx < nbit {
                    // ⚡ Bolt: Calculate binary value mathematically instead of lookup array to prevent cache misses
                    bin[outIdx] = Int16(((val >> (3 - k)) & 1) << 1) - 1
                    outIdx += 1
                }
            }
        }
        
        if flip {
            return bin.reversed()
        }
        return bin
    }
    
    static func generateNH10(length: inout Int, chipRate: inout Double) -> [Int16] {
        length = 10
        chipRate = 1000.0
        return [-1, -1, -1, -1, 1, 1, -1, 1, -1, 1]
    }
    
    static func generateNH20(length: inout Int, chipRate: inout Double) -> [Int16] {
        length = 20
        chipRate = 500.0
        return [-1, -1, -1, -1, -1, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, 1, 1, 1, -1]
    }
    
    static func boc(code: [Int16], length: inout Int, chipRate: inout Double, m: Int, n: Int) -> GNSSCode {
        let N = 2 * m / n
        var bocCode = [Int16]()
        bocCode.reserveCapacity(N * code.count)
        
        for chip in code {
            for _ in 0..<N {
                bocCode.append(chip)
            }
        }
        
        for i in 0..<(N * code.count / 2) {
            bocCode[2 * i] = -bocCode[2 * i]
        }
        
        length *= N
        chipRate *= Double(N)
        
        return GNSSCode(chips: bocCode, length: length, chipRate: chipRate)
    }
}
