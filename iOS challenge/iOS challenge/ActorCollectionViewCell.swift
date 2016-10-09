//
//  ActorCollectionViewCell.swift
//  iOS challenge
//
//  Created by Denis Prša on 7. 10. 16.
//  Copyright © 2016 Denis Prša. All rights reserved.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameInMovie: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    // MARK: - SET VALUES
    
    func setup(json: JSON?) {
        let image = json?["image"].string ?? ""
        
        self.name.text = json?["name"].string ?? ""
        self.image.image = UIImage(named: image)
        self.nameInMovie.text = json?["name_in_movie"].string ?? ""
    }
}
