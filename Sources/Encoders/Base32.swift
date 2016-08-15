//
//  Base32.swift
//  CommonCryptoSwift
//
//  Created by Chris Amanse on 15/08/2016.
//
//

import Foundation

public struct Base32 {
    // Encoding
    
    public static func characterFor(nickel: UInt8) -> Character? {
        let unicodeScalarValue: UInt32? = {
            switch nickel {
            case 0...25: return "A".unicodeScalars.first!.value + UInt32(nickel)
            case 26...31: return "2".unicodeScalars.first!.value + UInt32(nickel) - 26
            default: return nil
            }
        }()
        
        if let value = unicodeScalarValue {
            return Character(UnicodeScalar(value))
        } else {
            return nil
        }
    }
    
    public static func encode(data: Data) -> String {
        var characters: [Character] = []
        
        // Divide into groups of 5 bytes
        var lowerBoundIndex = data.startIndex
        var upperBoundIndex = data.startIndex
        
        repeat {
            lowerBoundIndex = upperBoundIndex
            upperBoundIndex = upperBoundIndex.advanced(by: 5)
            
            let lessThanFiveBytes: Bool
            let numberOfBytesLeft: Int?
            
            if upperBoundIndex > data.count {
                upperBoundIndex = data.count
                
                numberOfBytesLeft = lowerBoundIndex.distance(to: upperBoundIndex)
                
                lessThanFiveBytes = true
            } else {
                numberOfBytesLeft = nil
                lessThanFiveBytes = false
            }
            
            // Get subdata piece
            let piece = data.subdata(in: lowerBoundIndex ..< upperBoundIndex)
            
            // Combine 5 bytes into a single Int
            var fiveByte: Int = 0
            
            for (index, byte) in piece.enumerated() {
                let shiftLeftsCount = (4 - index) * 8
                let shifted = Int(byte) << shiftLeftsCount
                
                fiveByte = fiveByte | shifted
            }
            
            // Divide 40 bits into groups of 5 bits
            
            for index in 0..<8 {
                // Check if should simply append "="
                // Only checks at the end
                if upperBoundIndex == data.count && lessThanFiveBytes {
                    let paddingCount: Int = {
                        switch numberOfBytesLeft! {
                        case 1: return 6
                        case 2: return 4
                        case 3: return 3
                        case 4: return 1
                        default: return 0
                        }
                    }()
                    
                    // Only pad when all nickels are accounted for
                    if paddingCount > 7 - index {
                        // Pad remaining groups with "=" instead of mapping
                        for _ in 0..<paddingCount {
                            characters.append(Character("="))
                        }
                        
                        // No need to continue mapping (encoding finsihed)
                        break
                    }
                    
                }
                
                // Create a 5 bit Int
                
                let shiftCounts = (7 - index) * 5
                
                let byte = fiveByte >> shiftCounts
                let nickel = byte & 0x1f
                
                // Add mapped character
                characters.append(Base32.characterFor(nickel: UInt8(nickel))!)
            }
            
        } while upperBoundIndex < data.count
        
        return String(characters)
    }
    
    // Decoding
    
    public static func byteFor(_ character: Character) -> UInt8 {
        let unicodeScalarValue = String(character).unicodeScalars.first!.value
        
        switch unicodeScalarValue {
        case 50...55: return UInt8(unicodeScalarValue - 24)
        case 61: return 0x00
        case 65...90: return UInt8(unicodeScalarValue - 65)
        default: return 0xFF
        }
    }
    
    public static func decode(string: String) -> Data? {
        var bytes: [UInt8] = []
        
        // Divide into groups of 8 characters
        
        var lowerBoundIndex = string.startIndex
        var upperBoundIndex = string.startIndex
        
        repeat {
            lowerBoundIndex = upperBoundIndex
            upperBoundIndex = string.index(upperBoundIndex, offsetBy: 8, limitedBy: string.endIndex) ?? string.endIndex
            
            let substring = string.substring(with: lowerBoundIndex ..< upperBoundIndex)
            
            // Decode characters into nickels and combine into a five byte Int
            let decodedBytes = substring.characters.lazy.map { byteFor($0) }
            
            var fiveByte: UInt = 0
            
            for (index, byte) in decodedBytes.enumerated() {
                let shiftLeftsCount: UInt = (7 - UInt(index)) * 5
                
                let shiftedNickel = UInt(byte) << shiftLeftsCount
                
                fiveByte = fiveByte | shiftedNickel
            }
            
            // Split five byte Int into UInt8's
            for index in 0..<5 {
                let shiftRightsCount: UInt = (4 - UInt(index)) * 8
                
                let shifted = fiveByte >> shiftRightsCount
                
                let byte = UInt8(shifted & 0x00000000FF)
                
                bytes.append(byte)
            }
        } while upperBoundIndex < string.endIndex
        
        // Remove trailing zeroes for "="
        
        var trailingCount = 0
        
        var index: String.CharacterView.Index? = string.index(string.startIndex, offsetBy: string.characters.count - 1)
        while let i = index, string[i] == "=" && trailingCount < 6 {
            trailingCount += 1
            
            index = string.index(i, offsetBy: -1, limitedBy: string.startIndex)
        }
        
        let paddedBytesCount: Int = {
            switch trailingCount {
            case 1: return 1
            case 3: return 2
            case 4: return 3
            case 6: return 4
            default: return 0
            }
        }()
        
        bytes.removeLast(paddedBytesCount)
        
        return Data(bytes)
    }
}
