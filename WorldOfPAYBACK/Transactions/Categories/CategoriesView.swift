//
//  CategoriesView.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 28.12.2023.
//

import SwiftUI

struct CategoriesView: View {
    
    var onDismiss: (_ category: Int?) -> Void
    var categories: [Int] = [1,2,3]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Category Filters")
                .font(.title)
                .padding(.top, 20)
            
            List(categories, id: \.self) { category in
                Button {
                    onDismiss(category)
                    dismiss()
                }label: {
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
    CategoriesView { category in
        
    }
}
