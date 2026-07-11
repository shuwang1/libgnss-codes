import Foundation

extension GNSSCodes {
    
    static let MAXBEIDOUSATNO = 37
    static let LEN_B1I = 2046
    static let CRATE_B1I = 2.046E6
    
    static func generateB1I(prn: Int, length: inout Int, chipRate: inout Double) -> [Int16]? {
        let tap: [[Int]] = [
            [1, 3], [1, 4], [1, 5], [1, 6], [1, 8], [1, 9], [1, 10], [1, 11],
            [2, 7], [3, 4], [3, 5], [3, 6], [3, 8], [3, 9], [3, 10], [3, 11],
            [4, 5], [4, 6], [4, 8], [4, 9], [4, 10], [4, 11], [5, 6], [5, 8],
            [5, 9], [5, 10], [5, 11], [6, 8], [6, 9], [6, 10], [6, 11], [8, 9],
            [8, 10], [8, 11], [9, 10], [9, 11], [10, 11]
        ]
        
        guard prn >= 1 && prn <= tap.count else { return nil }
        
        var R1 = [Int8](repeating: 0, count: 11)
        var R2 = [Int8](repeating: 0, count: 11)
        for i in 0..<11 {
            R1[i] = (i % 2 == 0) ? -1 : 1
            R2[i] = (i % 2 == 0) ? -1 : 1
        }
        
        let code = [Int16](unsafeUninitializedCapacity: LEN_B1I) { codeBuf, initializedCount in
            initializedCount = LEN_B1I
            R1.withUnsafeMutableBufferPointer { r1Buf in
                R2.withUnsafeMutableBufferPointer { r2Buf in
                    for i in 0..<LEN_B1I {
                        let g2Out = -(Int16(r2Buf[tap[prn - 1][0] - 1]) * Int16(r2Buf[tap[prn - 1][1] - 1]))
                        codeBuf[i] = -(Int16(r1Buf[10]) * g2Out)
                        
                        let p1_1 = r1Buf[0] * r1Buf[6] * r1Buf[7]
                        let p1_2 = r1Buf[8] * r1Buf[9] * r1Buf[10]
                        let C1 = -(p1_1 * p1_2)
                        
                        let p2_1 = r2Buf[0] * r2Buf[1] * r2Buf[2] * r2Buf[3]
                        let p2_2 = r2Buf[4] * r2Buf[7] * r2Buf[8] * r2Buf[10]
                        let C2 = -(p2_1 * p2_2)
                        
                        for j in (1...10).reversed() {
                            r1Buf[j] = r1Buf[j-1]
                            r2Buf[j] = r2Buf[j-1]
                        }
                        r1Buf[0] = C1
                        r2Buf[0] = C2
                    }
                }
            }
        }
        
        length = LEN_B1I
        chipRate = CRATE_B1I
        return code
    }
}
