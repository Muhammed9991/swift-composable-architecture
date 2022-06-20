import Combine
import XCTest

@testable import ComposableArchitecture

final class NavigationTests: XCTestCase {
  func testCodability() throws {
    struct User: Codable, Hashable {
      var name: String
      var bio: String
    }
    enum Route: Codable, Hashable {
      case profile(User)
    }

    let path: NavigationState<Route> = [
      .init(id: 1, element: .profile(.init(name: "Blob", bio: "Blobbed around the world.")))
    ]
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let encoded = try encoder.encode(path)
    XCTAssertNoDifference(
      String(decoding: encoded, as: UTF8.self),
      """
      {
        "path" : [
          {
            "element" : {
              "profile" : {
                "_0" : {
                  "bio" : "Blobbed around the world.",
                  "name" : "Blob"
                }
              }
            },
            "idString" : "1",
            "idTypeName" : "Swift.Int"
          }
        ]
      }
      """
    )
    let decoded = try JSONDecoder().decode(NavigationState<Route>.self, from: encoded)
    XCTAssertNoDifference(
      decoded,
      path
    )
  }
}