//
//  GooglMapViewController.swift
//  GlobalDemoProject
//
//  Created by Dharmik Gorasiya on 15/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
class GooglMapViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,GMSAutocompleteFetcherDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    var templatitude = 0.0
    var newPolyline = GMSPolyline()
    var locManager = CLLocationManager()
    var routePath :GMSMutablePath = GMSMutablePath()
    var tempcurrentLocation: CLLocation!
    var marker:GMSMarker!
    var arrAddress = [placeAddressModel]()
    var placesClient : GMSPlacesClient = GMSPlacesClient()
    var placesNameArray : [GMSAutocompletePrediction] = []
    var gmsFetcher: GMSAutocompleteFetcher!
    //var currentLocation:CLLocation = CLLocation(latitude: 21.2423, longitude: 72.8781)
    
    @IBOutlet weak var myMapView: GMSMapView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var addressOuterview: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addressOuterview.isHidden = true
        if(PermisionManager.checkForLocationService())
        {
            marker = GMSMarker()
            myMapView.delegate = self
            if(LocationManager.sharedManger.currentLocation != nil)
            {
                myMapView.camera = GMSCameraPosition(target: LocationManager.sharedManger.currentLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                CurrentLocationMarker(coordinate:LocationManager.sharedManger.currentLocation.coordinate)
            }
            else
            {
                return
            }
            setupMap()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private Method
    
    func setupMap()
    {
        if(PermisionManager.checkForLocationService())
        {
            routeDraw()
            placesClient = GMSPlacesClient.shared()
            gmsFetcher = GMSAutocompleteFetcher()
            gmsFetcher.delegate = self
        }
    }
    
    func setDefault()
    {
        txtAddress.delegate = self
        tblAddress.dataSource = self
        tblAddress.delegate = self
    }

    // Current Location Marker Set
    func CurrentLocationMarker(coordinate: CLLocationCoordinate2D) {
        marker.position = coordinate
        marker.icon =  UIImage(named: "current_Location")//icon_location//markerImage
        marker.tracksViewChanges = true
        CATransaction.begin()
        CAAnimation.init().duration = 0.5
        marker.layer.latitude = coordinate.latitude
        marker.layer.longitude = coordinate.longitude
        CATransaction.commit()
        marker.map = self.myMapView
    }
    func addMarker(latitude:String,longitude:String) {
        let coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
        let marker1 = GMSMarker(position:coordinate)
        marker1.icon =  UIImage(named: "current_Location")
        marker1.map = self.myMapView
    }
    //MARK:- Button Action
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseAddressTapped(_ sender: Any) {
        self.addressOuterview.isHidden = true
    }
    
    //MARK: - Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddress.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let data = arrAddress[indexPath.row]
        cell.lblAddress.text = data.address
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let data = arrAddress[indexPath.row]
        txtAddress.text = data.address
        self.addressOuterview.isHidden = true
        addressToGetLatlong(placeID: data.placeId)
        self.view.endEditing(true)
    }
    func tableView(_ tableView: UITableView,heightForRowAt indexPath:IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func removeSubview(){
        if let viewWithTag = self.view.viewWithTag(101) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
    }
    
    //MARK: - Textfield Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtAddress.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        self.addressOuterview.isHidden = false
        self.tblAddress.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.tblAddress.reloadData()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        //self.txtAddress.text = ""
        self.arrAddress.removeAll()
        self.tblAddress.reloadData()
        self.placeAutocomplete(searchText: "\(textField.text!)\(string)")
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.placesNameArray.removeAll()
        self.arrAddress.removeAll()
        return true
    }
    
    func placeAutocomplete(searchText: String) {
        let filter = GMSAutocompleteFilter()
        //filter.type = .establishment//.city//.establishment
        filter.country = "IN"//"GH" //"IN"
        
        /*if let countryCode = UserDefaults.standard.string(forKey: "Current_Country_Code_Key")
        {
            filter.country = countryCode
        }*/
        //
        //filter.type = .city
        //        filter.country = "GH"
        // filter.country = "GH,IN"
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error :- \(error.localizedDescription)")
                return
            }
            if let results = results {
                for result in results {
                    self.arrAddress.append(placeAddressModel(address: "\(result.attributedFullText.string)", placeId: "\(result.placeID!)"))
                }
                self.addressOuterview.isHidden = false
                self.tblAddress.reloadData()
            }
        })
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print("\(error.localizedDescription)")
    }
    
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        for prediction in predictions {
            if let prediction = prediction as GMSAutocompletePrediction?{
                self.placesNameArray.append(prediction)
                
            }
        }
    }
    
    //MARK:- Draw Route
    func routeDraw()
    {
        GoogleMapManager.drawRoute(CLLatitude: "\(LocationManager.sharedManger.currentLocation.coordinate.latitude)", CLLongitude: "\(LocationManager.sharedManger.currentLocation.coordinate.longitude)", DLLatitude: "21.221901", DLLongitude: "72.900063") { (isSucess, response) in
            if(isSucess)
            {
                let path = GMSPath.init(fromEncodedPath: response)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 5
                polyline.strokeColor = UIColor.red
                polyline.map = self.myMapView
                self.addMarker(latitude: "21.221901", longitude: "72.900063")
            }
            else
            {
                Utility.showAlert("Alert", message: response)
            }
        }
    }
    
    //MARK: - Placeid to get latlong
    func addressToGetLatlong(placeID:String)
    {
        GoogleMapManager.placeIdToLatLong(placeId: placeID) { (isSucess, response) in
            print(response)
            print(Double(truncating: response!["lat"] as! NSNumber))
           // self.myMapView.camera = GMSCameraPosition(target: LocationManager.sharedManger.currentLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            self.CurrentLocationMarker(coordinate: CLLocation(latitude: Double(truncating: response!["lat"] as! NSNumber), longitude: Double(truncating: response!["lng"] as! NSNumber)).coordinate)
            self.myMapView.animate(toLocation: CLLocationCoordinate2D(latitude: Double(truncating: response!["lat"] as! NSNumber), longitude: Double(truncating: response!["lng"] as! NSNumber)))
         
            /*
             {
             lat = "21.2044594";
             lng = "72.8404893";
             }
             */
        }
    }
    
    func distanceAndDurationCalculation()
    {
        GoogleMapManager.getDistanceAndDuration(CLLatitude: "\(LocationManager.sharedManger.currentLocation.coordinate.latitude)", CLLongitude: "\(LocationManager.sharedManger.currentLocation.coordinate.longitude)", DLLatitude: "21.221901", DLLongitude: "72.900063") { (isSuccess, response) in
            print(response)
            /*if let distance:NSDictionary = dicElement["distance"] as? NSDictionary
             {
             let duration:NSDictionary = dicElement["duration"] as! NSDictionary
             
             }
             else
             {
             self.addressOuterview.isHidden = true
             self.requestDeliveryOuterview.isHidden = true
             CommonData.txtfieldAlert(title: KAlertSorry, message: KAlertSelectAddressNotFound, viewController: self)
             }*/
        }
    }
}
