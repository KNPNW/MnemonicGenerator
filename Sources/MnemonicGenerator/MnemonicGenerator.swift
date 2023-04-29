import Foundation
import UncommonCrypto

public struct MnemonicGenerator {
    
    static public func generateMnemonicArray() -> [String] {
        let entropy = getEntropy()
        let checkSum = calculateCheckSum(entropy: entropy)
        
        return [""]
    }
    
    static public func generateMnemonicString() -> String {
        let entropy = getEntropy()
        let checkSum = calculateCheckSum(entropy: entropy)
        return getPhase(entropy: entropy, checkSum: checkSum)
    }
    
    static public func isValidMnemonic(mnemonicPhase: String) -> Bool {
        return true
    }
    
    private static func calculateCheckSum(entropy: [UInt8]) -> UInt8 {
        let size = entropy.count / 4
        let hash = SHA2.hash(type: .sha256, bytes: entropy)
        return (hash[0] >> (8 - size))
    }
    
    private static func getEntropy() -> [UInt8] {
        return try! SecureRandom.bytes(size: 128 / 8)
    }
    
    private static func getPhase(entropy: [UInt8], checkSum: UInt8) -> String {
        var binaryPhase = uint8ToBinary(entropy)
        binaryPhase += uint8ToBinary([checkSum], bits: 4)
        let nums = separate(binaryPhase)
        let convertedNums = stringToDecimal(nums: nums)
        return decimalsToPhase(nums: convertedNums)
    }
    
    private static func uint8ToBinary(_ array: [UInt8], bits: Int = 8) -> String {
        var result = ""
        for num in array {
            let binaryNum = "00000000" + String(num, radix: 2)
            result += binaryNum[binaryNum.index(binaryNum.endIndex, offsetBy: -bits)...]
        }
        return result
    }
    
    private static func separate(_ string: String, size: Int =  11) -> [String] {
        var result = [String]()
        var prev = 0
        for i in stride(from: size, through: string.count, by: size) {
            result.append(String(string[string.index(string.startIndex, offsetBy: prev)..<string.index(string.startIndex, offsetBy: i)]))
            prev = i
        }
        return result
    }
    
    private static func stringToDecimal(nums: [String]) -> [Int] {
        var result = [Int]()
        for num in nums {
            result.append(Int(num, radix: 2)!)
        }
        return result
    }
    
    private static func decimalsToPhase(nums: [Int]) -> String {
        var phase = ""
        for num in nums {
            phase += (intToWords[num]!) + " "
        }
        return phase
    }
}
