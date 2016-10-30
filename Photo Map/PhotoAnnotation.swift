//
//  PhotoAnnotation.swift
//  Photo Map
//
//  Created by Chau Vo on 7/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
  var photo: UIImage!

  var title: String? {
    return "\(coordinate.latitude)"
  }

  var key: String {
    return "\(coordinate.latitude),\(coordinate.longitude)"
  }

  var thumbnail: UIImage? {
    if let photo = photo {
      let resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
      resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
      resizeRenderImageView.layer.borderWidth = 3.0
      resizeRenderImageView.contentMode = UIViewContentMode.scaleAspectFill
      resizeRenderImageView.image = photo

      UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
      resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
      let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      return thumbnail
    }
    return nil
  }

  init(coordinate: CLLocationCoordinate2D, photo: UIImage) {
    self.coordinate = coordinate
    self.photo = photo
  }
}
