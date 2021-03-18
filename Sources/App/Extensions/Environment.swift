
//  Created by Andreas M. (ada024) on 17/03/2021.
//

import Foundation
import Vapor

extension Environment {
    static let secretKey = Self.get("SECRET_KEY")!.base64Decoded()!
}
