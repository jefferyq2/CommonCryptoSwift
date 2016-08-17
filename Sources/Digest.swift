//
//  Digest.swift
//  CommonCryptoSwift
//
//  Created by Chris Amanse on 15/08/2016.
//
//

import Foundation
import CommonCryptoKit

public struct Digest {
    public static func generate(from data: Data, using algorithm: Algorithm) -> Data {
        // Get data pointers and lengths
        let daataBytesPointer = data.unsafeBytes
        let dataLength = UInt32(data.count)
        
        var result = Data(count: Int(algorithm.digestLength))
        
        let resultBytesPointer = result.unsafeMutableBytes
        
        // Digest
        _ = algorithm.digest(daataBytesPointer, dataLength, resultBytesPointer)
        
        return result
    }
}

// Digest Algorithm

public extension Digest {
    public struct Algorithm {
        public var digest: (UnsafePointer<Void>, CC_LONG, UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>!
        public var digestLength: Int32
    }
}

public extension Digest.Algorithm {
    public static var MD2: Digest.Algorithm {
        return Digest.Algorithm(digest: CC_MD2, digestLength: CC_MD2_DIGEST_LENGTH)
    }
    public static var MD4: Digest.Algorithm {
        return Digest.Algorithm(digest: CC_MD4, digestLength: CC_MD4_DIGEST_LENGTH)
    }
    public static var MD5: Digest.Algorithm {
        return Digest.Algorithm(digest: CC_MD5, digestLength: CC_MD5_DIGEST_LENGTH)
    }
    public static var SHA1: Digest.Algorithm {
        return Digest.Algorithm(digest: CC_SHA1, digestLength: CC_SHA1_DIGEST_LENGTH)
    }
    public static var SHA224: Digest.Algorithm {
        return Digest.Algorithm(digest: CC_SHA224, digestLength: CC_SHA224_DIGEST_LENGTH)
    }
    public static var SHA256: Digest.Algorithm {
        return Digest.Algorithm(digest: CC_SHA256, digestLength: CC_SHA256_DIGEST_LENGTH)
    }
    public static var SHA384: Digest.Algorithm {
        return Digest.Algorithm(digest: CC_SHA384, digestLength: CC_SHA384_DIGEST_LENGTH)
    }
    public static var SHA512: Digest.Algorithm {
        return Digest.Algorithm(digest: CC_SHA512, digestLength: CC_SHA512_DIGEST_LENGTH)
    }
}
