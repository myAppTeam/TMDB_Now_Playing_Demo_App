//
//  Extensions.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import UIKit.UIImageView

private var activityIndicatorAssociationKey: UInt8 = 0
private let imageCache = NSCache<NSString, UIImage>()

extension UIView {
    var activityIndicator: UIActivityIndicatorView! {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorAssociationKey) as? UIActivityIndicatorView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &activityIndicatorAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    
    func showActivityIndicator() {
        if (self.activityIndicator == nil) {
            if #available(iOS 13.0, *) {
                self.activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
            } else {
                // Fallback on earlier versions
                self.activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
            }
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
            self.activityIndicator.center = self.center
            self.activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin , .flexibleTopMargin , .flexibleBottomMargin]
            self.activityIndicator.isUserInteractionEnabled = false
            OperationQueue.main.addOperation({ () -> Void in
                self.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()
            })
        }
    }
    
    func hideActivityIndicator() {
        OperationQueue.main.addOperation({ () -> Void in
            self.activityIndicator.stopAnimating()
        })
    }
}

extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        
        self.showActivityIndicator()
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.hideActivityIndicator()
            print("imageCache local")
            self.image = nil
            self.image = cachedImage
        }else {
            OperationQueue.main.addOperation({ () -> Void in
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let image = UIImage(data: data)
                    else { return }
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async() {
                        self.hideActivityIndicator()
                        print("imageCache downloaded")
                        self.image = nil
                        self.image = image
                        self.layoutIfNeeded()
                    }
                }.resume()
            })
        }
    }
}
