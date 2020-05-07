//
//  PhotoModel.swift
//  ARGallery
//
//  Created by Bassist Zero on 5/6/20.
//  Copyright © 2020 Bassist_Zero. All rights reserved.
//

import Foundation

struct PhotoModel: Codable {
    let urls: UrlsModel
}

struct UrlsModel: Codable {
    let regular: String
}
