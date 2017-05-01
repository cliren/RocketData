/**
 * Created by surenrk on 4/13/17.
 */

import RocketData
import PromiseKit

// Shared state object that holds all data providers

public class ChatDataController: DataController {
  let userDataProvider = CollectionDataProvider<UserModel>()

  override init() {
    super.init()
  }

  public override func perform(action: ActionType) {
    super.perform(action: action)

    switch action.type {
    case ActionKeys.FetchChatsAction.rawValue:
      print("Action switch: \(ActionKeys.FetchChatsAction.rawValue)")
      NetworkManager.fetchChats { (models, error) in
        if error == nil {
          print("chats retrieved successfully! \(models.count)")
          let fetchChatsAction = action as? FetchChatsAction
          self.userDataProvider.setData(models, cacheKey: fetchChatsAction?.cacheKey)
          self.notifySubscribers()
        }
      }
      break
    default:
      break

    }
  }


  public func setChats(chats: [UserModel], cacheKey: String) {
    userDataProvider.setData(chats, cacheKey: cacheKey)
  }

  public func users(withCacheKey cacheKey: String) -> [UserModel] {
    return userDataProvider.data
  }


  public func userCount() -> Int {
    return userDataProvider.count
  }

  public static func messageCount(forCacheKey cacheKey: String) -> Promise<Int>? {
    let messageDataProvider = CollectionDataProvider<MessageModel>()
    return Promise { fullfill, reject in
      messageDataProvider.fetchDataFromCache(withCacheKey: cacheKey) { messages, error in
        if let error = error {
          reject(error)
        } else {
          fullfill(messages?.count ?? 0)
        }
      }
    }
  }
}
