//
//  DateExtensions.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 27.12.2023.
//

import Foundation
import WorldOfPAYBACKNetworking

extension Date {
    func convertToString(
        format: DateFormatsInApp,
        timeZone: TimeZone = .current,
        locale: Foundation.Locale? = nil
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.timeZone = timeZone
        if let locale {
            formatter.locale = locale
        }
        return formatter.string(from: self)
    }
}
