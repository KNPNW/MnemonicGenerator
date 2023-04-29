import XCTest
import UncommonCrypto

@testable import MnemonicGenerator

final class MnemonicGeneratorTests: XCTestCase {
    func testExample() throws {
       
        XCTAssertEqual(MnemonicGenerator.isValidMnemonic(mnemonicPhase: "divide above find trip upgrade acoustic hobby order fringe whisper trade between"), true)
        
        XCTAssertEqual(MnemonicGenerator.isValidMnemonic(mnemonicPhase: "divide drama find trip upgrade acoustic hobby order fringe whisper trade between"), false)
    }
}
