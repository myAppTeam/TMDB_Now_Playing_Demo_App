//
//  Extensions.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import UIKit.UIImageView

private var activityIndicatorAssociationKey: UInt8 = 0

extension UIImageView {
    
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
            self.activityIndicator.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2);
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
    
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        self.showActivityIndicator()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.hideActivityIndicator()
                self.image = image
                self.layoutIfNeeded()
            }
        }.resume()
    }
}
