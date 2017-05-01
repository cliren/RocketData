//
//  ChatsViewController.swift
//  SampleApp
//
//  Created by Peter Livesey on 7/22/16.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

import UIKit
import RocketData

/**
 This is the home screen of the application.
 It represents a list of users who we are currently chatting with.
 Tapping on a row in this view controller will bring up a `MessagesViewController` which will show the current chat.
 */

class ChatsViewController: UIViewController, StoreSubscriber, UITableViewDataSource, UITableViewDelegate {

  var identifier = generateSubscriberIdentifier()
  let chatDataController = ChatDataController()

  fileprivate let cacheKey = CollectionCacheKey.chat.cacheKey()

  // MARK: - IBOutlets

  @IBOutlet weak var tableView: UITableView!

  // MARK: - View Lifecycle

  deinit {
    print("unsubscribe store from MessagesViewController")
    chatDataController.unsubscribe(listener: self)
  }

  init() {
    super.init(nibName: "ChatsViewController", bundle: nil)
    chatDataController.subscribe(listener: self)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func hasUpdatedData() {
    print("Updating Chats")
    self.tableView.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Hey Chat App"

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    chatDataController.perform(action: FetchChatsAction(cacheKey: cacheKey))
  }

  func getUsers() -> [UserModel] {
    let users = chatDataController.users(withCacheKey: cacheKey)
   return users
  }
  // MARK: - TableView

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chatDataController.userCount()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    // You can use subscript notation to access models from the CollectionDataProvider
    let users = getUsers()
    let user = users[indexPath.row]
    var text = user.name
//    let mesageCount = ChatDataController.messageCount(forCacheKey: cacheKey)
//    text += ": messages(\(mesageCount))"

    if !user.online {
      text += " (Offline)"
    }
    cell.textLabel?.text = text
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let users = getUsers()
    let user = users[indexPath.row]
    let messagesViewController = MessagesViewController(user: user)
    navigationController?.pushViewController(messagesViewController, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
