//
//  File.swift
//  
//
//  Created by Andreas M. (ada024) on 17/03/2021.
//

import Foundation

extension String {

    func base64Encoded() -> String? { data(using: .utf8)?.base64EncodedString() }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
