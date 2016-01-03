
import Foundation
import UIKit

@objc protocol PhotoBrowserDelegate
{
    
    func photoBrowserDidSelectImage(image: UIImage, localIdentifier: String)
}