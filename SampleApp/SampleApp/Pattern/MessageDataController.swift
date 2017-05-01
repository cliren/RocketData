/**
 * Created by surenrk on 4/13/17.
 */

import RocketData

// Shared state object that holds all data providers

public class MessageDataController: DataController {

  let userDataProvider = DataProvider<UserModel>()
  let messageDataProvider = CollectionDataProvider<MessageModel>()

  override init() {
  }

  public override func perform(action: ActionType) {
    super.perform(action: action)

    switch action.type {
    case ActionKeys.FetchMessagesAction.rawValue:
      print("Action switch: \(ActionKeys.FetchMessagesAction.rawValue)")
      if let user = userDataProvider.data {
        NetworkManager.fetchMessage(user) { (models, error) in
          if error == nil {
            let fetchMessagesAction = action as! FetchMessagesAction
            self.messageDataProvider.setData(models, cacheKey: fetchMessagesAction.cacheKey)
            self.notifySubscribers()
          }
        }
      }
      break
    case ActionKeys.SendMessageAction.rawValue:
      print("Action switch: \(ActionKeys.SendMessageAction.rawValue)")
      let sendMessageAction = action as! SendMessageAction
      messageDataProvider.append([sendMessageAction.message])
      self.notifySubscribers()
      break
    default:
      break
    }
  }

  public func messages(forUser user: UserModel) -> [MessageModel] {
    return messageDataProvider.data.filter { (message) -> Bool in
      return message.sender.id == user.id
    }
  }

  public func setCurrentUser(user: UserModel) {
    userDataProvider.setData(user)
  }

  public func currentUser() -> UserModel? {
    return userDataProvider.data
  }
}
