//
//  PlaceDetailsViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceDetailsViewController: UIViewController {
    //MARK: - Outlet
    @IBOutlet var placeDetailsView: PlaceDetailsView!
    
    //MARK - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var place: PlaceSearch!
    var placeDetails: PlaceDetails!
    var location = Location.all
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlaceDetailsUI(placeDetails: placeDetails)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        location = Location.all
    }
    
    //MARK: - Actions
    @IBAction func showWebsite(_ sender: UIButton) {
        if let placeDetails = placeDetails {
            guard let url = URL(string: placeDetails.website ?? "") else { return }
            UIApplication.shared.open(url)
        } else {
            showAlert(title: "Error", message: "Failed to get you to the website. Try again!")
        }
    }
    
    @IBAction func addLocationOnMap(_ sender: UIButton) {
        addToLocationListSetup()
        showAlert(title: "Success", message: "Location has been added successfully!")
    }
    
    //MARK: - Methods
    private func addToLocationListSetup() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        let tabItem = tabItems[1]
        
        if checkLocationList() == false {
            saveLocation()
            tabItem.badgeValue = "New"
            location = Location.all
        } else {
            location = Location.all
            showAlert(title: "Error", message: "You already add this location in your location list!")
            tabItem.badgeValue = nil
        }
    }
    
    private func checkLocationList() -> Bool {
        var isAdded = false
        guard location.count != 0 else { return false }
        for loc in location {
            if placeDetails.placeId == loc.placeId {
                isAdded = true
                break
            }
        }
        return isAdded
    }
    
    private func setPlaceDetailsUI(placeDetails: PlaceDetails) {
        placeDetailsView.placeDetailsConfigureUI = placeDetails
        placeDetailsView.placeDetailsConfigure(rating: placeDetails.rating ?? 0.0, placeDetailsPhoneNumber: placeDetails.internationalPhoneNumber ?? "no phone number available", weekdayText: (placeDetails.openingHours?.weekdayText ?? ["no schedule available"]), backgroundPlaceDetailsImageURL: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: (place.photos?[0].photoReference ?? "")))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showLocationOnMapSegue,
            let mapVC = segue.destination as? MapViewController {
            mapVC.placeDetails = placeDetails
        }
    }
}

//MARK: - CoreData's methods
extension PlaceDetailsViewController {
    private func saveLocation() {
        let location = Location(context: AppDelegate.viewContext)
        location.placeId = placeDetails.placeId
        location.photoReference = place.photos?[0].photoReference
        location.name = placeDetails.name
        location.address = placeDetails.address
        location.phoneNumber = placeDetails.internationalPhoneNumber
        location.rating = placeDetails.rating ?? 0.0
        //location.openingHours = (place.openingHours?.openNow)!
        location.latitude = placeDetails.geometry.location.latitude
        location.longitude = placeDetails.geometry.location.longitude
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try AppDelegate.viewContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
}
