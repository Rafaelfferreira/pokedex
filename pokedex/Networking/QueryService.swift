//
//  QueryService.swift
//  pokedex
//
//  Created by Jobe Diego Dylbas dos Santos on 15/04/19.
//  Copyright © 2019 Jobe Diego Dylbas dos Santos. All rights reserved.
//

import Foundation
import UIKit

class QueryService {

    let defaultSession = URLSession(configuration: .default)
    var resultPoke: Pokemon? = nil
    var pokeImage: UIImage? = nil
    
    func getSearchResults(searchTerm: String) {

        if let urlComponents = URLComponents(string: (PokemonAPI.URL.rawValue + searchTerm)) {
            // 3
            guard let url = urlComponents.url else { return }
            print(url)
            // 4
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("ERRO")
                    //return
                }
                
                if let data = data {
                    do {
                        let res = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let id = res!["id"] as? Int,
                            let species = res!["species"] as? [String: Any],
                            let height = res!["height"] as? Int,
                            let weight = res!["weight"] as? Int,
                            let imageURL = res!["sprites"] as? [String: String]
                        {
                            let pokeResult = Pokemon(id: id, name: species["name"] as! String, imageURL: imageURL["front_default"]! , weight: weight, height: height)
                                self.getImage(imageURL: pokeResult.imageURL)
                            }
                    }
                    catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }


    
    func decodeImage() -> UIImage{
        return pokeImage ?? UIImage()
    }


}
