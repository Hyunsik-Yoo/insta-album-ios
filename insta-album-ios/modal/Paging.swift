import Foundation

struct Paging: Codable {
    var cursors: Cursor
    var next: String?
}
