//
//  File.swift
//  
//
//  Created by emir kartal on 24.12.2023.
//

import Foundation

enum Decoders {
   static let mainDecoder: JSONDecoder = {
       let decoder = JSONDecoder()
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = Decoders.dateFormat
       decoder.dateDecodingStrategy = .formatted(dateFormatter)
       decoder.keyDecodingStrategy = .convertFromSnakeCase
       return decoder
   }()
   
    static let dateFormat = DateFormatsInApp.apiDateFormat.rawValue //"2020-11-28T15:14:22Z"
}

enum DateFormatsInApp: String {
    case apiDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    case uiDateFormat = "dd/MM/yyyy, HH:mm"
}

