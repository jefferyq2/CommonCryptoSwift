//
//  Digest.swift
//  CommonCryptoSwift
//
//  Created by Chris Amanse on 15/08/2016.
//
//

import Foundation
import CommonCryptoKit

public struct DigestGenerator {
    public var algorithm: DigestAlgorithm
    
    public func generate(from data: Data) -> Data {
        let dataBytesPointer = data.unsafeBytes
        let dataLength = UInt32(data.count)
        
        var result = Data(count: Int(algorithm.digestLength))
        
        let resultBytesPointer = result.unsafeMutableBytes
        
        _ = algorithm.digest(dataBytesPointer, dataLength, resultBytesPointer)
        
        return result
    }
    
    public init(algorithm: DigestAlgorithm = .MD2) {
        self.algorithm = algorithm
    }
}

// Digest Algorithm

public extension DigestGenerator {
    public struct DigestAlgorithm {
        public var digest: (UnsafePointer<Void>, CC_LONG, UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>!
        public var digestLength: Int32
    }
}

public extension DigestGenerator.DigestAlgorithm {
    public static let MD2 = DigestGenerator.DigestAlgorithm(digest: CC_MD2, digestLength: CC_MD2_DIGEST_LENGTH)
    public static let MD4 = DigestGenerator.DigestAlgorithm(digest: CC_MD4, digestLength: CC_MD4_DIGEST_LENGTH)
    public static let MD5 = DigestGenerator.DigestAlgorithm(digest: CC_MD5, digestLength: CC_MD5_DIGEST_LENGTH)
    public static let SHA1 = DigestGenerator.DigestAlgorithm(digest: CC_SHA1, digestLength: CC_SHA1_DIGEST_LENGTH)
    public static let SHA224 = DigestGenerator.DigestAlgorithm(digest: CC_SHA224, digestLength: CC_SHA224_DIGEST_LENGTH)
    public static let SHA256 = DigestGenerator.DigestAlgorithm(digest: CC_SHA256, digestLength: CC_SHA256_DIGEST_LENGTH)
    public static let SHA384 = DigestGenerator.DigestAlgorithm(digest: CC_SHA384, digestLength: CC_SHA384_DIGEST_LENGTH)
    public static let SHA512 = DigestGenerator.DigestAlgorithm(digest: CC_SHA512, digestLength: CC_SHA512_DIGEST_LENGTH)
}
