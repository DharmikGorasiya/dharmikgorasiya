//
//  localization+string.swift
//  iChatMessaging
//
//  Created by Dharmik Gorasiya on 12/02/18.
//  Copyright © 2018 iChatMessaging. All rights reserved.
//

import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
