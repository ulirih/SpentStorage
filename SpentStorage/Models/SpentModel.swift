//
//  SpentModel.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 02.11.2022.
//

import Foundation

struct SpentModel {
    var id: UUID
    var date: Date
    var price: Float
    var type: CategoryModel
}
