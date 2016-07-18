//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!

  var selectedImage: UIImage?

  override func viewDidLoad() {
    super.viewDidLoad()

    mapView.delegate = self

    //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
    let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                          MKCoordinateSpanMake(0.1, 0.1))
    mapView.setRegion(sfRegion, animated: false)
  }

  @IBAction func onCameraButtonTapped(sender: UIButton) {
    let vc = UIImagePickerController()
    vc.delegate = self
    vc.allowsEditing = true
    vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary

    presentViewController(vc, animated: true, completion: nil)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "tagSegue" {
      if let locationVC = segue.destinationViewController as? LocationsViewController {
        locationVC.delegate = self
      }
    }
  }

}

extension PhotoMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    // Get the image captured by the UIImagePickerController
    let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    // let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage

    // Do something with the images (based on your use case)
    selectedImage = originalImage

    print("get image here")
    // Dismiss UIImagePickerController to go back to your original view controller
    dismissViewControllerAnimated(true) {
      self.performSegueWithIdentifier("tagSegue", sender: self)
    }
  }

}

extension PhotoMapViewController: LocationsViewControllerDelegate {
  func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
    print("lat: \(latitude)")
    print("lng: \(longitude)")
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
    annotation.title = "Picture!"
    mapView.addAnnotation(annotation)
  }
}

extension PhotoMapViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseID = "myAnnotationView"

    var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
      annotationView!.canShowCallout = true
      annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
    }

    if let imageView = annotationView?.leftCalloutAccessoryView as? UIImageView {
      imageView.image = UIImage(named: "camera")
    }

    return annotationView
  }
}
