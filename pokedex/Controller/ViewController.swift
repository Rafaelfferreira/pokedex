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
    let queryService = QueryService()
    
    @IBAction func teste(_ sender: UIButton) {
        queryService.getSearchResults(searchTerm:  "pikachu")
        pokemonImage.image = queryService.decodeImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        queryService.getSearchResults(searchTerm: searchText)
    }
}
