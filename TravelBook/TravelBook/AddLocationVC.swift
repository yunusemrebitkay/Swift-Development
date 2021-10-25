//
//  AddLocationVC.swift
//  TravelBook
//
//  Created by Yunus Emre Bitkay on 24.10.2021.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class AddLocationVC: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    //Definitions
    @IBOutlet weak var textFieldLocationName: UITextField!
    @IBOutlet weak var textFieldLocationComment: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    //We define the CLLocation class and two variables for latitude and longitude
    var locationManager = CLLocationManager()
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    //Variables we defined to get data from other screen
    var selectedLocation = ""
    var selectedID : UUID?
    
    //We create the variables that we will throw the data we will receive in the database.
    var annotationName = ""
    var annotationComment = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Delegation is a design pattern that allows a class or struct to delegate some of its responsibilities to an instance of another type.
        //We delegate to MapView.
        mapView.delegate = self
        //We delegate to Location Manager.
        locationManager.delegate = self
        
        //We indicate exactly how accurately we will get the location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //We request location permission from user.As a permission, we asked it to give location permission while using the application.
        locationManager.requestWhenInUseAuthorization()
        
        //We are updating the location
        locationManager.startUpdatingLocation()
        
        //We create a Gesture Recognizer to hide the keyboard
        let gestureRecognizerKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //Adding to the View Screen
        view.addGestureRecognizer(gestureRecognizerKeyboard)
        
        //We created a Gesture Recognizer that will be active when you press the map.
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        //We set the hold time
        gestureRecognizer.minimumPressDuration = 1.25
        
        //Adding to MapView
        mapView.addGestureRecognizer(gestureRecognizer)
        
        //If something is selected from tableView then run getData function.
        if selectedLocation != ""{
            getData()
        }
    }
    
    //We get information from the database
    func getData(){
        //We connect to the database
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
        
        //We convert the id we received to string
        let idString = selectedID?.uuidString
        
        //We search the database with id
        fetchRequest.predicate = NSPredicate(format: "id = %@",idString!)
        
        //A Boolean value that indicates whether the objects resulting from a fetch request are faults.
        fetchRequest.returnsObjectsAsFaults = false
        
        //In case of an error in any operation performed in the database with Try-Catch, the program
        do{
            //If the number of results is more than one, do the following
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                //We take the objects we receive into the for loop.
                for vrResult in results as! [NSManagedObject]{
                    
                    //We take the location name and assign it to the variable we specified.
                    if let locationName = vrResult.value(forKey: "location_name") as? String{
                        annotationName = locationName
                        
                        //We take the location comment and assign it to the variable we specified.
                        if let locationComment = vrResult.value(forKey: "location_comment") as? String{
                            annotationComment = locationComment
                            
                            //We take the location latitude and assign it to the variable we specified.
                            if let latitude = vrResult.value(forKey: "latitude") as? Double{
                                annotationLatitude = latitude
                                
                                //We take the location longitude and assign it to the variable we specified.
                                if let longitude = vrResult.value(forKey: "longitude") as? Double{
                                   annotationLongitude = longitude
                                    
                                    //We create the pin
                                    let annotation = MKPointAnnotation()
                                    //We determine the name of the pin
                                    annotation.title = annotationName
                                    //We determine the name of the pin
                                    annotation.subtitle = annotationComment
                                    
                                    //We take the coordinates and assign them to the variable we specified.
                                    let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
                                    //We add the coordinates to the pin
                                    annotation.coordinate = coordinate
                                    
                                    //Adding pin to MapView
                                    mapView.addAnnotation(annotation)
                                    
                                    //We assign the location name and subtitle to the variables we defined before
                                    textFieldLocationName.text = annotationName
                                    textFieldLocationComment.text = annotationComment
                                    
                                    //We want the update to be stopped
                                    locationManager.stopUpdatingLocation()
                                    
                                    //We define the zoom level on the map.
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    
                                    //We define the region to display
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    
                                    //We add the region we defined to the map
                                    mapView.setRegion(region, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }catch{
            print("Christ no! we encountered a problem")
        }
    }
    
    //We create function to hide keyboard.
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    
    //When you press and hold the map, we create our function to add a pin.
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer){
        //Get touch points if gesture recognizer started
        if gestureRecognizer.state == .began{
            
            //We take the touched point.
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            //We translate the coordinates of the touched point and assign them to the variable we defined.
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            //We assign the selected latitude and longitude to the variables we defined earlier.
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            
            //We create the Pin (Annotation).
            let annotation = MKPointAnnotation()
            
            //We pin the coordinate we get.
            annotation.coordinate = touchedCoordinates
            
            //We determine the name of the pin
            annotation.title = textFieldLocationName.text
            
            //We determine the subtitle of the pin
            annotation.subtitle = textFieldLocationComment.text
            
            //We add the Pin we defined to the MapView.
            self.mapView.addAnnotation(annotation)
        }
    }
    
    //This function gives us the updated locations in an array
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Find location if no selected item came from tableView
        if selectedLocation == ""{
            
            //We get location as latitude and longitude
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            
            //We define the zoom level on the map.
            let span = MKCoordinateSpan(latitudeDelta: 0.05 , longitudeDelta: 0.05)
            
            //We define the region to display
            let region = MKCoordinateRegion(center: location, span: span)
            
            //We add the region we defined to the map
            mapView.setRegion(region, animated: true)
        }
    }
    
    //We create the function defined in the class to customize the pins.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //If we don't want to show the pin showing the user's location
        //We want to show only the clicked location.
        if annotation is MKUserLocation{
            return nil
        }
        
        //We define the pin's id
        let reuseId = "myAnnotation"
        
        //We get Pin from MapView
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
       
        //If the PinView has not been created yet, we create a new pinview below
        if pinView == nil {
            
            //We create the PinView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            //Show extra information with a bubble
            pinView?.canShowCallout = true
            
            //We determine the bubble color
            pinView?.tintColor = UIColor.black
            
            //We add a button that will show details on the information screen.
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            
            //Show this button on the right
            pinView?.rightCalloutAccessoryView = button
        }else{
            //If it has already created a pineview, show it as a pinview
            pinView?.annotation = annotation
        }
        
        //Send pinview back
        return pinView
    }

    
    //We create the function that will be run when clicking on the Pinview.
    //Navigasyona
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //If location is selected
        if selectedLocation != ""{
            //We get the location by latitude and longitude
            let requestLocation = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)

            //Class that allows us to connect coordinates and places
            //Creates the place I want to go as an object
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks , error) in
                
                //Checking for placemark
                if let placemark = placemarks{
                    
                    //We check if there is a placemark value
                    if placemark.count > 0 {
                        
                        //We get the 0th index in the array
                        let newPlacemark = MKPlacemark(placemark: placemark[0])
                        
                        //We define the object we receive into a variable.
                        let item = MKMapItem(placemark: newPlacemark)
                        
                        //We assign the name Pin to the name of the variable
                        item.name = self.annotationName
                        
                        //Before opening the map, we define the Departure type [Departure Type: (pedestrian, vehicle, bus)]
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        
                        //We open the map to get directions to the pin we have chosen with the type of Departure we have defined.
                        item.openInMaps(launchOptions: launchOptions)
                        
                    }
                }
            }
        }
    }
    
    
    //Aldığımız lokasyonu kayedicek fonksiyonu oluşturuoyurz
    @IBAction func buttonSaveClicked(_ sender: Any) {
        //We connect to the database
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: "Locations", into: context)
        
        //We transfer the data we receive to its counterpart in the database.
        newLocation.setValue(textFieldLocationName.text, forKey: "location_name")
        newLocation.setValue(textFieldLocationComment.text, forKey: "location_comment")
        newLocation.setValue(chosenLatitude, forKey: "latitude")
        newLocation.setValue(chosenLongitude, forKey: "longitude")
        newLocation.setValue(UUID(), forKey: "id")
        
        //In case of an error in any operation performed in the database with Try-Catch, the program
        do{
            //Save database
            try context.save()
            print("Success")
        }catch{
            print("Error")
        }
        
        //We post that you made a change when returning to the previous screen
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        
        //After saving, we automatically return to the previous screen.
        self.navigationController?.popViewController(animated: true)
    }
}
