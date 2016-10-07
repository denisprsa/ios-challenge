# iOS challenge
This challenge requires you to make a simple iOS app according to requirements specified below.

### Challenge requirements
* Objective-C or Swift.
* Minimum iOS platform: iOS 8; maximum: latest iOS.
* Support all devices except iPad.
* Support portrait orientation.
* Use CocoaPods for any external libraries.
* Library suggestions:
  * Image loading: SDWebImage
  * Networking: AFNetworking
* Use AutoLayout/Size classes.
* Write consistent and organized code.
* Follow design and app feature requirements.

### Bonus requirements
* Support portrait/landscape orientation.
* iPad support.
* Unit tests.

### Assessment
* Code quality.
* Precision/following app features.

### Design

* Framer prototype:
  * Available at http://share.framerjs.com/vbjhe8bwl6h9/
  * Some notes about the link:
    * It cannot be opened in Firefox.
    * You can [download code](http://share.framerjs.com/download/vbjhe8bwl6h9/project.zip) (code in app.coffee specifies animations and could be looked at for help).
    * You can open code in [Framer Studio](http://framerjs.com/download/) by clicking "OPEN" button in top right corner.

### Instructions

###### The Movie Database API
* To make requests you will need API key. To get it, you have to do:
  * Register yourself on https://www.themoviedb.org/.
  * Request for an API key at https://www.themoviedb.org/account/#user#/api/create
  (replace user with your username) or go to your account page and choose API on side menu.
  * Choose developer type and fill out the form. If you don't know how to fill out any of the fields, make it up as it doesn't matter.
  * After that you get API key which you will use when making requests.
* Apiary: http://docs.themoviedb.apiary.io/
* Official page: https://www.themoviedb.org/documentation/api
* Status codes: https://www.themoviedb.org/documentation/api/status-codes

###### Use this movie id: 264660 (Ex Machina)
* On play button click open trailer in a browser (Trailer URL: /movie/{id}/videos)
* Give user a possibility to rate the movie (use /movie/{id}/rating)

##### Some of the API paths to use (look into documentation also)
###### /configuration
* Example image URL: http://image.tmdb.org/t/p/w500/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg

###### /movie/{id}
* genres,
* release_date,
* title,
* runtime (minutes),
* revenue ($),
* tagline,
* vote_average,
* vote_count,
* overview,
* poster_path (poster image) (to get image, look into /configuration path)

###### /movie/{id}/credits
* cast objects
  * character
  * name
  * profile_path (actor image) (to get image, look into /configuration path)

###### /movie/{id}/videos
* provides links to open

###### /movie/{id}/rating
* you can use guest session
