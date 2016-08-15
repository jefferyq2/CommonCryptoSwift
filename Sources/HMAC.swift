//
//  HMAC.swift
//  CommonCryptoSwift
//
//  Created by Chris Amanse on 15/08/2016.
//
//

import Foundation
import CommonCryptoKit

public struct HMAC {
    var algorithm: HMACAlgorithm = .SHA1
    
    func authenticate(data: Data, withKey key: Data) -> Data {
        let dataBytesPointer = data.unsafeBytes
        let keyBytesPointer = data.unsafeBytes
        
        var result = Data(count: Int(algorithm.digestLength))
        
        let resultBytesPointer = result.unsafeMutableBytes
        
        CCHmac(algorithm.digestAlgorithm, keyBytesPointer, key.count, dataBytesPointer, data.count, resultBytesPointer)
        
        return result
    }
}

// HMAC Algorithm

public extension HMAC {
    public struct HMACAlgorithm {
        public var digestAlgorithm: CCHmacAlgorithm
        public var digestLength: Int32
    }
}

public extension HMAC.HMACAlgorithm {
    public static let SHA1 = HMAC.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA1), digestLength: CC_SHA1_DIGEST_LENGTH)
    public static let MD5 = HMAC.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgMD5), digestLength: CC_MD5_DIGEST_LENGTH)
    public static let SHA256 = HMAC.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA256), digestLength: CC_SHA256_DIGEST_LENGTH)
    public static let SHA384 = HMAC.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA384), digestLength: CC_SHA384_DIGEST_LENGTH)
    public static let SHA512 = HMAC.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA512), digestLength: CC_SHA512_DIGEST_LENGTH)
    public static let SHA224 = HMAC.HMACAlgorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA224), digestLength: CC_SHA224_DIGEST_LENGTH)
}
