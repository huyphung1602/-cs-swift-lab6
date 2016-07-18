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
  }
}
