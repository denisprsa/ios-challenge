//
//  ViewController.swift
//  iOS challenge
//
//  Created by Denis Prša on 7. 10. 16.
//  Copyright © 2016 Denis Prša. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    // MARK: - Variables
    
    @IBOutlet weak var blackOverlay: UIView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actorsCollectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    var dataForMovie: MovieData? = nil
    var originalBackgroundImage: UIImageView = UIImageView()
    
    

    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setup()
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.layoutIfNeeded()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        // SET IMAGE BACKGROUND TO NAVIGATION BAR
        let image = UIImage(named: "navBarBackgorund")
        UINavigationBar.appearance().setBackgroundImage(image, for: .default)
        //self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Comic_Andy", size: 22)]
        
        // DELEGATE, DATASOURCE
        actorsCollectionView.delegate = self
        actorsCollectionView.dataSource = self
        
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        
        scrollView.delegate = self
        
        // STARVIEW SETUP
        self.originalBackgroundImage.image = mainImage.image
        
    }
    
    private func getData() {
        // Get movie from this id
        APIManager.instance.getActors(id: "264660") { response in
            var data = JSON(response).dictionaryValue
            
            var genres:[Genres]? = []
            if let genresList = data["genres"] {
                for (_, subJson)  in genresList {
                    if let name = subJson["name"].string, let id = subJson["id"].int {
                        
                        genres?.append(Genres(
                            id: id,
                            name: name
                        ))
                    }
                }
            }
            
            self.dataForMovie = MovieData(
                title: data["original_title"]?.string,
                runtime: data["runtime"]?.string,
                voteAverage: data["vote_average"]?.double,
                voteCount: data["vote_count"]?.intValue,
                overview: data["overview"]?.string,
                realeseDate: data["release_date"]?.string,
                revenue: data["revenue"]?.double,
                generes: genres,
                cast: nil,
                storyLine: data["release_date"]?.string,
                video: nil
                
            )
            
            self.setData()
        }
    }
    
    func setData() {
        self.mainTitle.text = self.dataForMovie?.title
        
        let uppercasedTitle = self.dataForMovie?.title?.uppercased()
        guard let tittleForNavBar = uppercasedTitle else { return }
        self.navigationBar.topItem?.title = tittleForNavBar
        
        
        
    }
    
    // MARK: - Functions for CollectionView
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == actorsCollectionView {
            let json = JSON([
                "name": "Denis",
                "image": "tmp"
                ])
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actorCell", for: indexPath) as! ActorCollectionViewCell
            cell.setup(json: json)
            
            return cell

        } else {
            let json = JSON([
                "name": "Denis",
                "image": "tmp"
                ])
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenreCollectionViewCell
            cell.setup(json: json)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }

    // MARK: - ScrollView detect scroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <= 260 {
            let alpha = scrollView.contentOffset.y / 360
            blackOverlay.backgroundColor = UIColor(white: 0, alpha: alpha)

            let radius = scrollView.contentOffset.y / 2
            let iterations = scrollView.contentOffset.y / 50
            
            mainImage.image = self.originalBackgroundImage.image?.blurredImage(
                withRadius: radius,
                iterations: UInt(iterations),
                tintColor: .black
            )
            
        }
    }
    
}

