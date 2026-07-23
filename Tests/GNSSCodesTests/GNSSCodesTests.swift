import Testing
@testable import GNSSCodes

@Test func testL1CA_PRN1() {
    let code = GNSSCodes.generate(prn: 1, type: .L1CA)
    #expect(code != nil)
    #expect(code?.chips.count == 1023)
}

@Test func testB1I_PRN1() {
    let code = GNSSCodes.generate(prn: 1, type: .B1I)
    #expect(code != nil)
    #expect(code?.chips.count == 2046)
}

@Test func testG1() {
    let code = GNSSCodes.generate(prn: 1, type: .G1)
    #expect(code != nil)
    #expect(code?.chips.count == 511)
}

@Test func testE1B_PRN1() {
    let code = GNSSCodes.generate(prn: 1, type: .E1B)
    #expect(code != nil)
    #expect(code?.chips.count == 4092)
}

@Test func testE5aI_PRN1() {
    let code = GNSSCodes.generate(prn: 1, type: .E5AI)
    #expect(code != nil)
    #expect(code?.chips.count == 10230)
}

@Test func testL2CM_PRN1() {
    let code = GNSSCodes.generate(prn: 1, type: .L2CM)
    #expect(code != nil)
    #expect(code?.chips.count == 10230)
}

@Test func testL5I_PRN1() {
    let code = GNSSCodes.generate(prn: 1, type: .L5I)
    #expect(code != nil)
    #expect(code?.chips.count == 10230)
}

@Test func testL1CD_PRN1() {
    let code = GNSSCodes.generate(prn: 1, type: .L1CD)
    #expect(code != nil)
    #expect(code?.chips.count == 20460) // BOC(1,1) of 10230 is 20460
}

@Test func testL1CO_PRN1() {
    let code = GNSSCodes.generate(prn: 1, type: .L1CO)
    #expect(code != nil)
    #expect(code?.chips.count == 1800)
}

@Test func testL1CP_PRN1() {
    let code = GNSSCodes.generate(prn: 1, type: .L1CP)
    #expect(code != nil)
    #expect(code?.chips.count == 20460) // BOC(1,1) of 10230 is 20460
}

@Test func testLoadCodeErrorHandling() {
    let code = GNSSCodes.generate(prn: 49, type: .E1B)
    #expect(code != nil)
}

@Test func testLoadCodeErrorHandlingInvalid() {
    let code = GNSSCodes.generate(prn: 99, type: .E1B)
    #expect(code == nil)
}
