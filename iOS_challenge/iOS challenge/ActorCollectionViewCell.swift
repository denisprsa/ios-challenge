//
//  ActorCollectionViewCell.swift
//  iOS challenge
//
//  Created by Denis Prša on 7. 10. 16.
//  Copyright © 2016 Denis Prša. All rights reserved.
//
import SDWebImage
import UIKit

class ActorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameInMovie: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    // MARK: - SET VALUES
    
    func setup(data: Actor) {
        
        guard let name = data.name, let roleName = data.roleName, let image = data.picture else {
            return
        }
        
        self.name.text = name
        self.image.sd_setImage(
            with:  URL(string: "https://image.tmdb.org/t/p/w500" + image),
            placeholderImage: UIImage(named: "ProfilePlaceholderSuit")
        )
        self.nameInMovie.text = "- " + roleName
    }
}
