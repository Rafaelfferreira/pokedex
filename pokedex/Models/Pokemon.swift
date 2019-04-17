//
//  Pokemon.swift
//  pokedex
//
//  Created by Jobe Diego Dylbas dos Santos on 15/04/19.
//  Copyright © 2019 Jobe Diego Dylbas dos Santos. All rights reserved.
//

import Foundation
import UIKit

class Pokemon {
    var id: Int = 9999999
    var name: String = "MissingNO"
    var type: String = "nil"
    var imageURL: String = "missing"
    var weight: Int = -1193091841941
    var height: Int = 1231093193123
    
    init(){}
    
    init(id: Int, name: String, type: String,imageURL: String, weight: Int, height: Int){
        self.id = id
        self.name = name
        self.type = type
        self.imageURL = imageURL
        self.weight = weight
        self.height = height
    }
}
