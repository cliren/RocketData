/**
 * Created by surenrk on 4/13/17.
 */

import RocketData

func !=(lhs: StoreSubscriber, rhs: StoreSubscriber) -> Bool {
  return lhs.identifier != rhs.identifier
}

// Shared state object that holds all data providers

public class DataController {
  var subscribers: Array<StoreSubscriber>

  init() {
    self.subscribers = []
  }

  public func perform(action: ActionType) {
    // TODO: extract to protocol
  }

  func notifySubscribers() {
    self.subscribers.forEach {
      $0.hasUpdatedData()
    }
  }

  func subscribe(listener: StoreSubscriber) {
    self.subscribers.append(listener)
  }

  func unsubscribe(listener: StoreSubscriber) {
    self.subscribers = self.subscribers.filter({ $0 != listener })
  }
}
