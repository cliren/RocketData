/**
 * Created by surenrk on 4/13/17.
 */

import PromiseKit

enum ActionKeys: String {
  case SendMessageAction = "SendMessageAction"
  case FetchChatsAction = "FetchChatsAction"
  case FetchMessagesAction = "FetchMessagesAction"
}

public protocol ActionType {
  var type: String { get }
}

public struct FetchMessagesAction: ActionType {
  public var type: String = ActionKeys.FetchMessagesAction.rawValue
  let cacheKey: String

  init(cacheKey: String) {
    self.cacheKey = cacheKey
  }
}

public struct FetchChatsAction: ActionType {
  public var type: String = ActionKeys.FetchChatsAction.rawValue
  let cacheKey: String

  init(cacheKey: String) {
    self.cacheKey = cacheKey
  }
}

public struct SendMessageAction: ActionType {
  public var type: String = ActionKeys.SendMessageAction.rawValue
  var message: MessageModel

  init(message: MessageModel) {
    self.message = message
  }
}
