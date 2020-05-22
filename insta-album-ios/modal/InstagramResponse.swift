import Foundation

struct InstagramResponse<T: Codable>: Codable {
    var data: [T]?
    var paging: Paging
}
