//
//  ViewController.swift
//  pokedex
//
//  Created by Jobe Diego Dylbas dos Santos on 15/04/19.
//  Copyright © 2019 Jobe Diego Dylbas dos Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    let defaultSession = URLSession(configuration: .default)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchBar.delegate = self
    }
    
    func getSearchResults(searchTerm: String) {
        
        if let urlComponents = URLComponents(string: (PokemonAPI.URL.rawValue + searchTerm)) {
            // 3
            guard let url = urlComponents.url else { return }
            print(url)
            // 4
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("ERRO")
                }
                
                if let data = data {
                    do {
                        let res = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let id = res!["id"] as? Int,
                            let species = res!["species"] as? [String: Any],
                            let height = res!["height"] as? Int,
                            let weight = res!["weight"] as? Int,
                            let imageURL = res!["sprites"] as? [String: Any]
                        {
                            print(id)
                            let pokeResult = Pokemon(id: id, name: species["name"] as! String, imageURL: imageURL["front_default"]! as! String , weight: weight, height: height)
                            
                            self.getImage(imageURL: pokeResult.imageURL)
                        }
                    }
                    catch let error {
                        print(error)
                    }
                    DispatchQueue.main.async {
                        print("lola")
                    }
                }
                
                }.resume()
        }
    }
    
    private func getImage(imageURL: String){
        if let urlComponents = URLComponents(string: imageURL) {
            
            guard let url = urlComponents.url else {return}
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                guard let data = data,
                    error == nil,
                    let image = UIImage(data: data) else { return }
                DispatchQueue.main.async{
                    self.pokemonImage.image = image
                    self.pokemonImage.contentMode = .scaleAspectFill
                }
                
            }.resume()
        }
    }
    
    
}


extension ViewController: UISearchBarDelegate {
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.getSearchResults(searchTerm: searchText)
    }
}


