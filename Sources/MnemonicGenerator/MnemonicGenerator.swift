import Foundation
import UncommonCrypto

public struct MnemonicGenerator {
    
    static public func generateMnemonicArray() -> [String] {
        return generateMnemonicString().split(separator: " ").map({ (substring) in
            return String(substring)
        })
    }
    
    static public func generateMnemonicString() -> String {
        let entropy = getEntropy()
        let checkSum = calculateCheckSum(entropy: entropy)
        return getPhase(entropy: entropy, checkSum: checkSum)
    }
    
    static public func isValidMnemonic(mnemonicPhase: String) -> Bool {
        let mnemonicArray = mnemonicPhase.split(separator: " ").map({ (substring) in
            return String(substring)
        })
        let binaryPhase = mnemonicArrayToString(words: mnemonicArray)
        guard binaryPhase.count != 0 else { return false }
        let (main, checkSum) = splitMnemonicPhase(binaryPhase)
        let entropy = binaryToUint8(main)
        
        return checkSum == calculateCheckSum(entropy: entropy)
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
        var binaryPhase = ""
        for num in entropy {
            binaryPhase += intToBinary(Int(num))
        }
        binaryPhase += intToBinary(Int(checkSum), bits: 4)
        let nums = separate(binaryPhase)
        let convertedNums = binaryStringToDecimal(nums: nums)
        return decimalsToPhase(nums: convertedNums)
    }
    
    private static func intToBinary(_ num: Int, bits: Int = 8) -> String {
        var result = ""
        let binaryNum = "00000000000" + String(num, radix: 2)
        result += binaryNum[binaryNum.index(binaryNum.endIndex, offsetBy: -bits)...]
        return result
    }
    
    private static func binaryToUint8(_ string: String, bits: Int = 8) -> [UInt8] {
        var result = [UInt8]()
        var prev = 0
        for i in stride(from: bits, through: string.count, by: bits) {
            let num = String(string[string.index(string.startIndex, offsetBy: prev)..<string.index(string.startIndex, offsetBy: i)])
            result.append(UInt8(num, radix: 2)!)
            prev = i
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
    
    private static func binaryStringToDecimal(nums: [String]) -> [Int] {
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
    
    private static func mnemonicArrayToString(words: [String]) -> String {
        var result = ""
        for word in words {
            guard let num = wordToInt[word] else { return "" }
            result += intToBinary(num, bits: 11)
        }
        return result
    }
    
    private static func splitMnemonicPhase(_ string: String) -> (String, UInt8) {
        let splitIndex = string.index(string.endIndex, offsetBy: -4)
        let main = String(string[string.startIndex..<splitIndex])
        let checkSum = UInt8(String(string[splitIndex...]), radix: 2)!
        return (main, checkSum)
    }
    
    
}
