import Foundation

extension GNSSCodes {
    
    static let LEN_G1G2 = 511
    static let CRATE_G1G2 = 0.511E6
    
    static func generateG1G2(length: inout Int, chipRate: inout Double) -> [Int16]? {
        var R = [Int8](repeating: -1, count: 9)
        let code = [Int16](unsafeUninitializedCapacity: LEN_G1G2) { codeBuf, initializedCount in
            initializedCount = LEN_G1G2
            R.withUnsafeMutableBufferPointer { rBuf in
                for i in 0..<LEN_G1G2 {
                    codeBuf[i] = Int16(-rBuf[6])
                    let C = rBuf[4] * rBuf[8]
                    for j in (1...8).reversed() {
                        rBuf[j] = rBuf[j-1]
                    }
                    rBuf[0] = C
                }
            }
        }
        
        length = LEN_G1G2
        chipRate = CRATE_G1G2
        return code
    }
}
