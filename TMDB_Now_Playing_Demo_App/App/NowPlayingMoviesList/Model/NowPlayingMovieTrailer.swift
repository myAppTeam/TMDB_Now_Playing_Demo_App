//
//  NowPlayingMovieTrailer.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import Foundation

struct NowPlayingMovieTrailer: Codable {
    let id: Int
    let results : [Trailer]
    
//    enum CodingKeys: String, CodingKey {
//        case trailers = "results"
//    }
}

struct Trailer: Codable {
    let name, key, site, type, id, publishedAt, iSo6391, iSo31661: String
    let official: Bool
    let size: Int
    
    public var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    
//    enum CodingKeys: String, CodingKey {
//        case name, official, key, site, type, id
//        case iSO_639_1 = "iso_639_1"
//        case iSO_3166_1 = "iso_3166_1"
//        case size = "size"
//        case publishedAt = "published_at"
//    }
}

/*
 {
     "id": 209112,
     "results": [
         {
             "iso_639_1": "en",
             "iso_3166_1": "US",
             "name": "Batman v Superman: Dawn of Justice | Full Movie Preview | Warner Bros. Entertainment",
             "key": "1NxYygdBHmw",
             "site": "YouTube",
             "size": 1080,
             "type": "Clip",
             "official": true,
             "published_at": "2020-03-24 19:05:38 UTC",
             "id": "615f9bfa8e2ba600214f912f"
         },
         {
             "iso_639_1": "en",
             "iso_3166_1": "US",
             "name": "Communion",
             "key": "s-MUzvASr8s",
             "site": "YouTube",
             "size": 1080,
             "type": "Clip",
             "official": true,
             "published_at": "2016-03-28 15:50:11 UTC",
             "id": "5dd69cb83faba00019f6eebc"
         },
         {
             "iso_639_1": "en",
             "iso_3166_1": "US",
             "name": "Batman v Superman: Dawn of Justice - Official Final Trailer [HD]",
             "key": "NhWg7AQLI_8",
             "published_at": "2016-02-15 00:30:04 UTC",
             "site": "YouTube",
             "size": 1080,
             "type": "Trailer",
             "official": true,
             "id": "58f20527c3a3682ea7008159"
         },
         {
             "iso_639_1": "en",
             "iso_3166_1": "US",
             "name": "Batman v Superman: Dawn of Justice - Official Trailer 2 [HD]",
             "key": "fis-9Zqu2Ro",
             "published_at": "2015-12-03 05:00:02 UTC",
             "site": "YouTube",
             "size": 1080,
             "type": "Trailer",
             "official": true,
             "id": "58f2050ac3a3682e6600815a"
         },
         {
             "iso_639_1": "en",
             "iso_3166_1": "US",
             "name": "Batman v Superman - Exclusive Sneak [HD]",
             "key": "6as8ahAr1Uc",
             "published_at": "2015-12-01 01:53:00 UTC",
             "site": "YouTube",
             "size": 1080,
             "type": "Teaser",
             "official": true,
             "id": "571c8dc4c3a36842aa000190"
         },
         {
             "iso_639_1": "en",
             "iso_3166_1": "US",
             "name": "Batman v Superman: Dawn of Justice - Comic-Con Trailer [HD]",
             "key": "0WWzgGyAH6Y",
             "published_at": "2015-07-11 19:09:23 UTC",
             "site": "YouTube",
             "size": 1080,
             "type": "Trailer",
             "official": true,
             "id": "58f20572c3a3682eb6008579"
         }
     ]
 }
 */
