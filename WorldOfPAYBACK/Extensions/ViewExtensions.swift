//
//  ViewExtensions.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 27.12.2023.
//

import Foundation
import SwiftUI
import WorldOfPAYBACKNetworking

extension View {
    func apiErrorAlert(error: Binding<APIError?>, buttonTitle: String = "OK") -> some View {
        let errorMessage = error.wrappedValue?.failureReason
        return alert(isPresented: .constant(errorMessage != nil), error: error.wrappedValue) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.failureReason ?? error.recoverySuggestion ?? "")
        }
    }
    
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}


