//
//  WeatherModel.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 30/10/2022.
//

import Foundation


struct WeatherSearchModel: Codable {
    let weather: [WeatherModel]?
    let name: String
    let id: Int
    let visibility: Int
    let main: Temperature?
}

struct WeatherModel: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temperature: Codable {
    let temp: Float
}
