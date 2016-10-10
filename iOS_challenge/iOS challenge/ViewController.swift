//
//  ViewController.swift
//  iOS challenge
//
//  Created by Denis Prša on 7. 10. 16.
//  Copyright © 2016 Denis Prša. All rights reserved.
//

import UIKit
import HCSStarRatingView
import KeychainSwift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    // MARK: - Variables
    
    
    @IBOutlet weak var upperMarginContainter: UIView!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var realeseDateLabel: UILabel!
    @IBOutlet weak var revenuLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var IMDBRatingLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var scrollViewBackgoround: UIScrollView!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var blackOverlay: UIView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actorsCollectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mainTitle: UILabel!
    var dataForMovie: MovieData? = nil
    var originalBackgroundImage: UIImageView = UIImageView()
    var contextBlur = CIContext(options:nil)
    var filter: CIFilter!
    var sizeOriginalBackground = CGSize()
    var mainImageLoaded = false
    var movieID = "264660"
    var guestSession: GuestSession? = nil
    let keychain = KeychainSwift()
    var videos: [MovieVideo] = []
    

    // MARK: - Override Methods
    
    @IBAction func starVIewClick(_ sender: HCSStarRatingView) {
        if let guestSessionID = guestSession?.guestSessionID {
            APIManager.instance.setRating(
                id: movieID,
                value: Int(ratingView.value),
                guestSession: guestSessionID) { response in
                    
                    print(response)
            }
        }
    }
    
    @IBAction func playVideo(_ sender: AnyObject) {
        guard let key = videos[0].key else {
            return
        }
        
        UIApplication.shared.openURL(URL(string: "https://www.youtube.com/watch?v=\(key)")!)
    }
    
    @IBAction func shareMovie(_ sender: AnyObject) {
        print(dataForMovie?.url)
        if let myWebsite = NSURL(string: dataForMovie?.url ?? "") {
            let objectsToShare = ["", myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.layoutIfNeeded()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        upperMarginContainter.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
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
        
        scrollViewBackgoround.delegate = self
        //scrollViewBackgoround.zoomScale = 2
        
        self.mainImage.image = UIImage(named: "placeholder-movie")
    }
    
    private func sendRequestSession(){
        APIManager.instance.getGuestSession(){ response in
            self.guestSession = response as! GuestSession?
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            guard let guestSessionKey = self.guestSession?.guestSessionID,
                let expires = self.guestSession?.expiresAT
                else {
                    return
            }
            
            self.keychain.set(
                dateFormatter.string(from: expires),
                forKey: "guestSessionDate"
            )
            self.keychain.set(
                guestSessionKey,
                forKey: "guestSessionKey"
            )
        }
    }
    
    private func getUserSession() {
        let guestSessionData = keychain.get("guestSessionDate")
        let guestSessionKey = keychain.get("guestSessionKey")
        if let date = guestSessionData, let key = guestSessionKey {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            print(dateFormatter.date(from: date))
            
            if let sessionDate = dateFormatter.date(from: date){
                if sessionDate < Date(){
                    self.sendRequestSession()
                } else {
                    self.guestSession = GuestSession(success: true, guestSessionID: key, expiresAT: sessionDate)
                }
            }
        } else {
            print("NOOK")
            self.sendRequestSession()
        }
    }
    
    private func getData() {
        getUserSession()
        
        APIManager.instance.getMovie(id: movieID) { response in
            APIManager.instance.getActors(id: self.movieID) { castResponse in
                self.dataForMovie = response as! MovieData?
                self.dataForMovie?.cast = castResponse as! [Actor]?
                self.setupMainImage()
                self.setData()
            }
        }
        
        APIManager.instance.getVideos(id: movieID) { (response) in
            self.videos = response as! [MovieVideo]
        }
    }
    
    func setData() {
        var yearMovie = ""
        if let date = self.dataForMovie?.realeseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, YYYY"
            self.realeseDateLabel.text = dateFormatter.string(from: date as Date)
            dateFormatter.dateFormat = "YYYY"
            yearMovie = dateFormatter.string(from: date as Date)
        }
        
        self.mainTitle.text = self.dataForMovie?.title
        
        let uppercasedTitle = self.dataForMovie?.title?.uppercased()
        guard let tittleForNavBar = uppercasedTitle else { return }
        self.navigationBar.topItem?.title = tittleForNavBar + " \(yearMovie)"
        
        // revenue
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.maximumFractionDigits = 0
        self.revenuLabel.text = numberFormatter.string(from: NSNumber(value: self.dataForMovie?.revenue ?? 0))
        
        self.runTimeLabel.text = minutesToHoursMinutes(minutes: self.dataForMovie?.runtime ?? 0)
        
        self.votesLabel.text = "(\(dataForMovie?.voteCount ?? 0) votes)"
        
        self.IMDBRatingLabel.text = "\(dataForMovie?.voteAverage ?? 0.0)"
        
        self.overviewLabel.text = self.dataForMovie?.overview ?? ""
        self.introLabel.text = self.dataForMovie?.tagline ?? ""
        
        self.genreCollectionView.reloadData()
        self.actorsCollectionView.reloadData()
    }
    
    func minutesToHoursMinutes (minutes : Int) -> String {
        let (hr,  minf) = modf (Double(minutes) / 60)
        let (min,  _) = modf (minf * 60)
        return "\(Int(hr)) hr \(Int(min)) min"
    }
    
    private func setupMainImage(){
        // STARVIEW SETUP
        if let linkImage = self.dataForMovie?.poster {
            self.mainImage.sd_setImage(
                with: URL(string: "https://image.tmdb.org/t/p/w500" + linkImage),
                completed: { (image, error, imageCacheType, url) in
                    print(url)
                    self.originalBackgroundImage.image = image
                    
                    // BLUR SETUP
                    if let im = self.originalBackgroundImage.image {
                        self.sizeOriginalBackground = im.size
                        
                        let i = CIImage(image: im)
                        
                        self.filter = CIFilter(name: "CIGaussianBlur")
                        self.filter?.setValue(i, forKey: kCIInputImageKey)
                        self.filter?.setValue(0, forKey: kCIInputRadiusKey)
                        
                        let cgimg = self.contextBlur.createCGImage(
                            (self.filter?.outputImage)!,
                            from: CGRect(x: 0, y: 0, width: im.size.width, height: im.size.height)
                        )
                        
                        let newImage = UIImage(cgImage: cgimg!)
                        
                        self.mainImage.image = newImage
                    }
            })
        }
    }
    
    // MARK: - Functions for CollectionView
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == actorsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actorCell", for: indexPath) as! ActorCollectionViewCell
            cell.setup(data: (self.dataForMovie?.cast?[indexPath.row])!)
            
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenreCollectionViewCell
            
            guard let data = self.dataForMovie?.generes?[indexPath.row] else {
                return cell
            }
            
            cell.setup(data: data)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlowLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if collectionView == genreCollectionView {
            return CGSize(width: collectionViewLayout.itemSize.width + 15, height: collectionViewLayout.itemSize.height)
        }
        return collectionViewLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == actorsCollectionView {
            guard let items = self.dataForMovie?.cast?.count else {
                return 0
            }
            return items
        } else {
            guard let items = self.dataForMovie?.generes?.count else {
                return 0
            }
            return items
        }
    }

    // MARK: - ScrollView detect scroll
    
    var setted = false
    var calculating = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.scrollView{
            if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <= 260 {
                
                DispatchQueue.global(qos: .default).async { [weak self] () -> Void in
                    if (self?.calculating == false){
                        self?.calculating = true
                        let alpha = scrollView.contentOffset.y / 300
                        
                        let sliderValue = scrollView.contentOffset.y / 10
                        
                        self?.filter.setValue(sliderValue, forKey: kCIInputRadiusKey)
                        let outputImage = self?.filter.value(forKey: kCIOutputImageKey)
                        let cgimg = self?.contextBlur.createCGImage(
                            outputImage! as! CIImage,
                            from: CGRect(
                                x: 0, y: 0,
                                width: (self?.sizeOriginalBackground.width)!,
                                height: (self?.sizeOriginalBackground.height)!
                            )
                        )
                        let newImage = UIImage(cgImage: cgimg!)
                        
                        DispatchQueue.main.async { () -> Void in
                            self?.blackOverlay.backgroundColor = UIColor(white: 0, alpha: alpha)
                            self?.mainImage.image = newImage
                            self?.calculating = false
                        }
                    }
                }
                
                if scrollView.contentOffset.y < 120  {
                    let valueAlpha = 1.0 - (scrollView.contentOffset.y / 120)
                    self.playVideoButton.alpha = valueAlpha
                    let scale = scrollView.contentOffset.y / 30
                    self.scrollViewBackgoround.zoomScale = scale
                    self.scrollViewBackgoround.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y / 3 )
                }
                
            } else if (scrollView.contentOffset.y <= 0){
                setted = false
                mainImage.image = self.originalBackgroundImage.image
                blackOverlay.backgroundColor = UIColor(white: 0, alpha: 0)
            }
        }
    }
    
}

