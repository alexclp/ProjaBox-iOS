//
//  CompressedImage.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 28/06/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class CompressedImage: UIImage {

}

extension UIImage {
	var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
	var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
	var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
	var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
	var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
	var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}
