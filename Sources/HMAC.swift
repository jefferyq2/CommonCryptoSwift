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
    public static func generate(from data: Data, withKey key: Data, using algorithm: Algorithm) -> Data {
        // Get data pointers
        let dataBytesPointer = data.unsafeBytes
        let keyBytesPointer = key.unsafeBytes
        
        var result = Data(count: Int(algorithm.digestLength))
        
        let resultBytesPointer = result.unsafeMutableBytes
        
        // HMAC
        CCHmac(algorithm.digestAlgorithm, keyBytesPointer, key.count, dataBytesPointer, data.count, resultBytesPointer)
        
        return result
    }
}

// HMAC Algorithm

public extension HMAC {
    public struct Algorithm {
        public var digestAlgorithm: CCHmacAlgorithm
        public var digestLength: Int32
    }
}

public extension HMAC.Algorithm {
    public static var SHA1: HMAC.Algorithm {
        return HMAC.Algorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA1), digestLength: CC_SHA1_DIGEST_LENGTH)
    }
    public static var MD5: HMAC.Algorithm {
        return HMAC.Algorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgMD5), digestLength: CC_MD5_DIGEST_LENGTH)
    }
    public static var SHA256: HMAC.Algorithm {
        return HMAC.Algorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA256), digestLength: CC_SHA256_DIGEST_LENGTH)
    }
    public static var SHA384: HMAC.Algorithm {
        return HMAC.Algorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA384), digestLength: CC_SHA384_DIGEST_LENGTH)
    }
    public static var SHA512: HMAC.Algorithm {
        return HMAC.Algorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA512), digestLength: CC_SHA512_DIGEST_LENGTH)
    }
    public static var SHA224: HMAC.Algorithm {
        return HMAC.Algorithm(digestAlgorithm: CCHmacAlgorithm(kCCHmacAlgSHA224), digestLength: CC_SHA224_DIGEST_LENGTH)
    }
}
