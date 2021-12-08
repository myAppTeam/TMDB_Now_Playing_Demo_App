//
//  ImageCache.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 05/12/21.
//

import Foundation

class ImageCache {

    //Headers
//    HTTP/2 200
//    content-type: image/jpeg
//    content-length: 246815
//    date: Tue, 02 Nov 2021 00:07:00 GMT
//    server: openresty
//    last-modified: Sun, 12 Sep 2021 07:45:51 GMT
//    cache-control: max-age=31449600
//    etag: "5048a5124d533b72d9e3a34edf773be0"
//    expires: Tue, 01 Nov 2022 00:07:00 GMT
//    x-rack-cache: fresh
//    x-content-digest: 680a336396e5783212ad8509f0a4c2f22862e006
//    access-control-allow-origin: *
//    accept-ranges: bytes
//    vary: Accept-Encoding
//    x-cache: Hit from cloudfront
//    via: 1.1 4d1daf728c8f336e79bd83ec18bb8cb0.cloudfront.net (CloudFront)
//    x-amz-cf-pop: MRS52-P1
//    x-amz-cf-id: XZDpT7Wzg2hhF8HF54NdN8SP-wiYBw4H7DaDaJ-be8ly_SkyMrkiCQ==
//    age: 2866291
    // Custom URL cache with 1 GB disk storage
    lazy var cache: URLCache = {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent("DownloadCache")
        if #available(iOS 13.0, *) {
            let cache = URLCache(memoryCapacity: 10_000_000, diskCapacity: 1_000_000_000, directory: diskCacheURL)
        } else {
            // Fallback on earlier versions
            let cache = URLCache(memoryCapacity: 100_000_000, diskCapacity: 1_000_000_000, diskPath: diskCacheURL.path)
        }
        print("Cache path: \(diskCacheURL.path)")
        return cache
    }()

    // Custom URLSession that uses our cache
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        return URLSession(configuration: config)
    }()

    init(url: URL) {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let targetURL = documentURL.appendingPathComponent(url.lastPathComponent)
        downloadFile(remoteURL: url, targetURL: targetURL)
    }

    func downloadFile(remoteURL: URL, targetURL: URL) {
        let request = URLRequest(url: remoteURL, cachePolicy: .returnCacheDataElseLoad)
        print("Download Request : \(request.url?.absoluteString)")
        let downloadTask = session.downloadTask(with: request) { url, response, error in
            print("url : \(url)")
            print("Download Task complete")

            // Store data in cache
            if let response = response, let url = url,
               self.cache.cachedResponse(for: request) == nil,
               let data = try? Data(contentsOf: url, options: [.mappedIfSafe]) {
                self.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
            }
                                                                
            // Move file to target location
            guard let tempURL = url else { return }
            _ = try? FileManager.default.replaceItemAt(targetURL, withItemAt: tempURL)
        }
        OperationQueue.main.addOperation({ () -> Void in
            downloadTask.resume()
        })
    }
}
