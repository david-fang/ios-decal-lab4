//
//  CategoryViewController.swift
//  PokedexLab
//
//  Created by SAMEER SURESH on 2/25/17.
//  Copyright © 2017 iOS Decal. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemonArray: [Pokemon]?
    var cachedImages: [Int:UIImage] = [:]
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokeInfoCell", for: indexPath) as! PokemonInfoViewCell
        let pokemon = pokemonArray![indexPath.row]
        
        cell.pokemonName.text = pokemon.name
        cell.pokemonNumber.text = String.init(format: "#%d", pokemon.number)
        cell.pokemonStats.text = String.init(format: "%d/%d/%d", pokemon.attack, pokemon.defense, pokemon.health)
        
        if let image = cachedImages[indexPath.row] {
            cell.pokemonImg.image = image
        } else {
            let url = URL(string: pokemon.imageUrl)!
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                self.cachedImages[indexPath.row] = image
                                cell.pokemonImg.image = UIImage(data: imageData)
                            }
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code")
                    }
                }
            }
            downloadPicTask.resume()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        performSegue(withIdentifier: "ShowInfo", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowInfo") {
            if let destination = segue.destination as? PokemonInfoViewController {
                if let ind = self.selectedIndexPath?.row {
                    if let arr = self.pokemonArray {
                        destination.image = cachedImages[ind]
                        destination.pokemon = arr[ind]
                    }
                    
                }
            }
        }
    }
    
}



