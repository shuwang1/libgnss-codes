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
        
        guard prn >= 1 && prn <= MAXBEIDOUSATNO else { return nil }
        
        var R1 = [Int8](repeating: 0, count: 11)
        var R2 = [Int8](repeating: 0, count: 11)
        var code = [Int16](repeating: 0, count: LEN_B1I)
        
        for i in 0..<11 {
            R1[i] = (i % 2 == 0) ? -1 : 1
            R2[i] = (i % 2 == 0) ? -1 : 1
        }
        
        for i in 0..<LEN_B1I {
            let g2Out = -(Int16(R2[tap[prn - 1][0] - 1]) * Int16(R2[tap[prn - 1][1] - 1]))
            code[i] = -(Int16(R1[10]) * g2Out)
            
            let C1 = -(R1[0] * R1[6] * R1[7] * R1[8] * R1[9] * R1[10])
            let C2 = -(R2[0] * R2[1] * R2[2] * R2[3] * R2[4] * R2[7] * R2[8] * R2[10])
            
            for j in (1...10).reversed() {
                R1[j] = R1[j-1]
                R2[j] = R2[j-1]
            }
            R1[0] = C1
            R2[0] = C2
        }
        
        length = LEN_B1I
        chipRate = CRATE_B1I
        return code
    }
}
