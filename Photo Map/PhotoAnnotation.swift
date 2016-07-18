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
      let resizeRenderImageView = UIImageView(frame: CGRectMake(0, 0, 45, 45))
      resizeRenderImageView.layer.borderColor = UIColor.whiteColor().CGColor
      resizeRenderImageView.layer.borderWidth = 3.0
      resizeRenderImageView.contentMode = UIViewContentMode.ScaleAspectFill
      resizeRenderImageView.image = photo

      UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
      resizeRenderImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
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
