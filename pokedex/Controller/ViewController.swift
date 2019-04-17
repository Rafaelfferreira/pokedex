//
//  ViewController.swift
//  pokedex
//
//  Created by Jobe Diego Dylbas dos Santos on 15/04/19.
//  Copyright © 2019 Jobe Diego Dylbas dos Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UIView variables
    @IBOutlet weak var blueBall: UIView!
    @IBOutlet weak var miniBall1: UIView!
    @IBOutlet weak var miniBall2: UIView!
    @IBOutlet weak var bigBall: UIView!
    @IBOutlet weak var stackBallRed: UIView!
    @IBOutlet weak var stackBallYellow: UIView!
    @IBOutlet weak var stackBallGreen: UIView!
    @IBOutlet weak var screenBorder: UIView!
    @IBOutlet weak var infoScreen: UIView!
    
    // MARK: - Pokemon variables
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonHeightLabel: UILabel!
    @IBOutlet weak var pokemonTypeLabel: UILabel!
    @IBOutlet weak var pokemonWeightLabel: UILabel!
    
    // MARK: - System variables
    @IBOutlet weak var searchBar: UISearchBar!
    let defaultSession = URLSession(configuration: .default)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.customizeScreen()
    }
    
    private func customizeScreen(){
        blueBall.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1).cgColor
        blueBall.layer.borderWidth = 5.0
        blueBall.layer.cornerRadius = 19
        blueBall.clipsToBounds = true
        stackBallRed.layer.borderColor = UIColor.black.cgColor
        stackBallRed.layer.borderWidth = 1
        stackBallRed.layer.cornerRadius = 8
        stackBallYellow.layer.borderColor = UIColor.black.cgColor
        stackBallYellow.layer.borderWidth = 1
        stackBallYellow.layer.cornerRadius = 8
        stackBallGreen.layer.borderColor = UIColor.black.cgColor
        stackBallGreen.layer.borderWidth = 1
        stackBallGreen.layer.cornerRadius = 8
        miniBall1.layer.cornerRadius = 5
        miniBall2.layer.cornerRadius = 5
        bigBall.layer.cornerRadius = 8
        
        screenBorder.layer.cornerRadius = 5
        infoScreen.layer.cornerRadius = 5
        infoScreen.layer.borderWidth = 1
        infoScreen.layer.borderColor = UIColor.black.cgColor
        
        self.pokemonNameLabel.text = ""
        self.pokemonIDLabel.text = ""
        self.pokemonWeightLabel.text = ""
        self.pokemonHeightLabel.text = ""
        self.pokemonTypeLabel.text = ""
    }
    
    func winkBlueBall(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options:[.repeat], animations: {
            UIView.setAnimationRepeatCount(2)
            self.blueBall.backgroundColor = UIColor(red: 84/255, green: 168/255, blue: 246/255, alpha: 1)
            self.blueBall.backgroundColor = UIColor(red: 51/255, green: 104/255, blue: 154/255, alpha: 1)
        }, completion:nil)
    }
    
    func getSearchResults(searchTerm: String) {
        
        if let urlComponents = URLComponents(string: (PokemonAPI.URL.rawValue + searchTerm.lowercased())) {
            // 3
            guard let url = urlComponents.url else { return }
            print(url)
            // 4
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error ?? "erro")
                }
                var pokeResult: Pokemon = Pokemon()
                if let data = data {
                    DispatchQueue.main.async {
                        self.winkBlueBall()
                    }
                    do {
                        if let res = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                            let id = res["id"] as? Int,
                            let species = res["species"] as? [String: Any],
                            let height = res["height"] as? Int,
                            let weight = res["weight"] as? Int,
                            let imageURL = res["sprites"] as? [String: Any],
                            let type = self.getTypes(typeArray: ((res["types"] as? [[String:Any]])!))
                        {
                            pokeResult = Pokemon(id: id, name: species["name"] as! String,type: type, imageURL: imageURL["front_default"]! as! String , weight: weight, height: height)
                            self.getImage(imageURL: pokeResult.imageURL)
                            //self.getTypes(typeArray: type)
                        }
                    }
                    catch let error {
                        print(error)
                        DispatchQueue.main.async {
                            self.pokemonImage.image = UIImage(named: "missing")
                        }
                    }
                    DispatchQueue.main.async {
                        self.pokemonNameLabel.text = "Name: \(pokeResult.name)"
                        self.pokemonIDLabel.text = "ID: " + String(pokeResult.id)
                        self.pokemonTypeLabel.text = "Type: \(pokeResult.type)"
                        self.pokemonWeightLabel.text = "Weight: " + String(pokeResult.weight)
                        self.pokemonHeightLabel.text = "Height: " + String(pokeResult.height)
                        
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
                }
                
            }.resume()
        }
    }
    
    private func getTypes(typeArray: [[String:Any]]) -> String?{
        var arrayToBeFormatted: [String] = []
        for item in typeArray {
            if let typeDic = item["type"] as? [String:String]{
                if let newType = typeDic["name"]{
                    arrayToBeFormatted.append(newType)
                }
//
            }
        }
        
        //MARK: - Formatting the array into a single line string
        var typesString : String = arrayToBeFormatted[0]
        if arrayToBeFormatted.count > 1 {
            typesString = "\(typesString), \(arrayToBeFormatted[1])"
        }
        return typesString
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


