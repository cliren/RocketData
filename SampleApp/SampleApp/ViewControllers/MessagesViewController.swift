//
//  MessagesViewController.swift
//  SampleApp
//
//  Created by Peter Livesey on 7/22/16.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

import UIKit
import Foundation
import RocketData

/**
 This view controller displays a list of messages between the current user and another user.
 It has a button to say "hey" to the other user. The only thing you can do in chats is say "hey".
 */

class MessagesViewController: UIViewController, StoreSubscriber, UITableViewDataSource, UITableViewDelegate {

  var identifier = generateSubscriberIdentifier()
  let messageDataController = MessageDataController()

  /// This is the cache key we use for the CollectionDataProvider. It's generated based on the other user's id.
  fileprivate let cacheKey: String

  // MARK: - IBOutlets

  @IBOutlet weak var tableView: UITableView!

  // MARK: - View Lifecycle

  deinit {
    print("unsubscribe store from MessagesViewController")
    messageDataController.unsubscribe(listener: self)
  }

  init(user: UserModel) {
    cacheKey = CollectionCacheKey.messages(user.id).cacheKey()

    messageDataController.setCurrentUser(user: user)
    super.init(nibName: "MessagesViewController", bundle: nil)

    messageDataController.subscribe(listener: self)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func hasUpdatedData() {
    print("Updating Messages")
    self.tableView.reloadData()
    if let loggedInUser = messageDataController.currentUser() {
      let messages = messageDataController.messages(forUser: loggedInUser)
      title = "Chat with \(loggedInUser.name) (\(messages.count)) "
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let user = messageDataController.currentUser() {
      title = "Chat with \(user.name)"
    }

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    messageDataController.perform(action: FetchMessagesAction(cacheKey: cacheKey))

  }

  func getMessages() -> [MessageModel] {
    if let loggedInUser = messageDataController.currentUser() {
      let messages = messageDataController.messages(forUser: loggedInUser)
      return messages
    } else {
      return []
    }
  }

  // MARK: - Actions

  @IBAction func heyButtonPressed() {
    // Here is where you'd send an actualy network request. But we're just going to create a message model locally.
    if let loggedInUser = messageDataController.currentUser() {
      let newMessageId = NetworkManager.nextMessageId()
      let message = MessageModel(id: newMessageId, text: "hey \( NSUUID().uuidString)", sender: loggedInUser)

      messageDataController.perform(action: SendMessageAction(message: message))
    }

  }

  // MARK: - TableView

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return getMessages().count
  }


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

    let messages = getMessages()
    let message = messages[indexPath.row]
    var text = message.sender.name
    if !message.sender.online {
      text += " (Offline)"
    }
    text += ": \(message.text)"
    cell.textLabel?.text = text
    return cell
  }
}
