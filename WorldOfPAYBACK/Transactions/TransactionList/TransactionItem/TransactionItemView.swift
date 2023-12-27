//
//  TransactionItemView.swift
//  WorldOfPAYBACK
//
//  Created by emir kartal on 27.12.2023.
//

import SwiftUI

struct TransactionItemView: View {
    
    let itemCellModel: TransactionItemViewModel
    
    init(itemCellModel: TransactionItemViewModel) {
        self.itemCellModel = itemCellModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(itemCellModel.partnerName)
                    .fontWeight(.bold)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .lineLimit(1)
                Text(itemCellModel.amount)
                    .fontWeight(.bold)
            }
            HStack {
                Text(itemCellModel.description ?? "")
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                Text(itemCellModel.bookingDate)
                    .font(.system(size: 13))
            }
        }
    }
}

#Preview {
    TransactionItemView(
        itemCellModel: TransactionItemViewModel(partnerName: "REWE",
                                                description: "desc",
                                                bookingDate: "",
                                                amount: "123 PBP"))
}
