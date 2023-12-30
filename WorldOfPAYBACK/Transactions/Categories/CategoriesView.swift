//
//  CategoriesView.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 28.12.2023.
//

import SwiftUI

struct CategoriesView: View {
    
    var categories: Set<Int>
    var onDismiss: (_ category: Int?) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Category Filters")
                .font(.title)
                .padding(.top, 20)
            
            List(Array(categories).sorted(by: <), id: \.self) { category in
                Button {
                    onDismiss(category)
                    dismiss()
                } label: {
                    Text("category \(category)")
                        .foregroundStyle(.black)
                }
            }
            
            Button {
                onDismiss(nil)
                dismiss()
            } label: {
                Text("Clear")
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    CategoriesView(categories: [1,2,3]) { category in
        
    }
}
