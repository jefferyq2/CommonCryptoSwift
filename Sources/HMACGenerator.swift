//
//  HMACGenerator.swift
//  CommonCryptoSwift
//
//  Created by Chris Amanse on 15/08/2016.
//
//

import Foundation
import CommonCryptoKit

public struct HMACGenerator {
    public var algorithm: HMACAlgorithm
    
    public func generate(from data: Data, withKey key: Data) -> Data {
        let dataBytesPointer = data.unsafeBytes
        let keyBytesPointer = data.unsafeBytes
        
        var result = Data(count: Int(algorithm.digestLength))
        
        let resultBytesPointer = result.unsafeMutableBytes
        
        CCHmac(algorithm.digestAlgorithm, keyBytesPointer, key.count, dataBytesPointer, data.count, resultBytesPointer)
        
        return result
    }
    
    public init(algorithm: HMACAlgorithm = .SHA1) {
        self.algorithm = algorithm
    }
}

// HMAC Algorithm

public extension HMACGenerator {
    public struct HMACAlgorithm {
        public var digestAlgorithm: CCHmacAlgorithm
        public var digestLength: Int32
    }
}

public extension HMACGenerator.HMACAlgorithm {
    public static let SHA1 = HMACGenerator.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA1), digestLength: CC_SHA1_DIGEST_LENGTH)
    public static let MD5 = HMACGenerator.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgMD5), digestLength: CC_MD5_DIGEST_LENGTH)
    public static let SHA256 = HMACGenerator.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA256), digestLength: CC_SHA256_DIGEST_LENGTH)
    public static let SHA384 = HMACGenerator.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA384), digestLength: CC_SHA384_DIGEST_LENGTH)
    public static let SHA512 = HMACGenerator.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA512), digestLength: CC_SHA512_DIGEST_LENGTH)
    public static let SHA224 = HMACGenerator.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA224), digestLength: CC_SHA224_DIGEST_LENGTH)
}
