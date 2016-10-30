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
  var selectedFullImage: UIImage?

  // Create a dictionary of photo annotations with the "lat,lng" as the key
  var photoAnnotations = [String: PhotoAnnotation]()

  override func viewDidLoad() {
    super.viewDidLoad()

    mapView.delegate = self

    //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
    let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                          MKCoordinateSpanMake(0.1, 0.1))
    mapView.setRegion(sfRegion, animated: false)
  }

  @IBAction func onCameraButtonTapped(_ sender: UIButton) {
    let vc = UIImagePickerController()
    vc.delegate = self
    vc.allowsEditing = true
    vc.sourceType = UIImagePickerControllerSourceType.photoLibrary

    present(vc, animated: true, completion: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "tagSegue":
        if let locationVC = segue.destination as? LocationsViewController {
          locationVC.delegate = self
        }
      case "fullImageSegue":
        if let fullImageVC = segue.destination as? FullImageViewController {
          fullImageVC.selectedPhoto = selectedFullImage
        }
      default:
        break
      }
    }
  }

}

extension PhotoMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    // Get the image captured by the UIImagePickerController
    let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    // let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage

    // Do something with the images (based on your use case)
    selectedImage = originalImage

    // Dismiss UIImagePickerController to go back to your original view controller
    dismiss(animated: true) {
      self.performSegue(withIdentifier: "tagSegue", sender: self)
    }
  }

}

extension PhotoMapViewController: LocationsViewControllerDelegate {
  func locationsPickedLocation(_ controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
    if let selectedImage = selectedImage {
      let coordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
        
      let photoAnnotation = PhotoAnnotation(coordinate: coordinate, photo: selectedImage)
      photoAnnotations[photoAnnotation.key] = photoAnnotation

      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      annotation.title = photoAnnotation.title ?? "Picture"
      mapView.addAnnotation(annotation)
      mapView.selectAnnotation(annotation, animated: true)
    }
  }
}

extension PhotoMapViewController: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseID = "myAnnotationView"

    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
      annotationView!.canShowCallout = true
      annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
      annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }

    let coordinateString = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"

    if let imageView = annotationView?.leftCalloutAccessoryView as? UIImageView, let photoAnnotation = photoAnnotations[coordinateString] {
      imageView.image = photoAnnotation.thumbnail

      annotationView?.image = photoAnnotation.thumbnail
//        annotationView?.backgroundColor = UIColor.whiteColor()
    }

    return annotationView
  }

  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if let annotation = view.annotation {
      let coordinateString = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
      if let photoAnnotation = photoAnnotations[coordinateString] {
        selectedFullImage = photoAnnotation.photo
        performSegue(withIdentifier: "fullImageSegue", sender: self)
      }
    }
  }

}
