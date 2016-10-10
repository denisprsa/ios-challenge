//
//  GenreCollectionViewCell.swift
//  iOS challenge
//
//  Created by Denis Prša on 9. 10. 16.
//  Copyright © 2016 Denis Prša. All rights reserved.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        print("genre button pressed")
    }
   
    // MARK: - SET VALUES
    
    func setup(data: Genres) {
        guard let name = data.name else {
            return
        }
        button.setTitle(name, for: .normal)
        
        //button.bounds.size.width = button.bounds.size.width + 14
        
    }
}
