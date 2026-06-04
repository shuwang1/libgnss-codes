import Foundation

extension GNSSCodes {
    
    static let LEN_G1G2 = 511
    static let CRATE_G1G2 = 0.511E6
    
    static func generateG1G2(length: inout Int, chipRate: inout Double) -> [Int16]? {
        var R = [Int8](repeating: -1, count: 9)
        var code = [Int16](repeating: 0, count: LEN_G1G2)
        
        for i in 0..<LEN_G1G2 {
            code[i] = Int16(-R[6])
            let C = R[4] * R[8]
            for j in (1...8).reversed() {
                R[j] = R[j-1]
            }
            R[0] = C
        }
        
        length = LEN_G1G2
        chipRate = CRATE_G1G2
        return code
    }
}
