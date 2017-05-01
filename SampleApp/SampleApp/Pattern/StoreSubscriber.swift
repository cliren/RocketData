/**
 * Created by surenrk on 4/13/17.
 */

import Foundation

public func generateSubscriberIdentifier() -> String {
  return NSUUID().uuidString
}

// View controllers subscribe to receive data updates. Each subscriber has a unique identifier for the purpose of
// tracking subscription
protocol StoreSubscriber {
  func hasUpdatedData()
  var identifier: String { get set }
}
