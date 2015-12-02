//
//  Meme.swift
//  MemeMe
//
//  Created by Scott Knutti on 12/2/15.
//  Copyright © 2015 Scott Knutti. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText: String = ""
    var bottomText: String = ""
    var image: UIImage?
    var memedImage: UIImage?
    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}