//
//  FullImageViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {

  @IBOutlet weak var photoImageView: UIImageView!

  var selectedPhoto: UIImage?

  override func viewDidLoad() {
    super.viewDidLoad()

    if let selectedPhoto = selectedPhoto {
      photoImageView.image = selectedPhoto
    }
  }

}
