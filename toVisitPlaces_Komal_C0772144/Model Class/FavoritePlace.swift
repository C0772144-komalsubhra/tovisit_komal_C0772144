

import Foundation
class FavoritePlace{
    var lat: Double
    var long: Double
    var speed: Double
    var course: Double
    var altitude: Double
    var address: String
    
    init(lat: Double, long: Double, speed: Double, course: Double, altitude: Double, address: String) {
        self.lat = lat
        self.long = long
        self.speed = speed
        self.course = course
        self.altitude = altitude
        self.address = address
    }
}
