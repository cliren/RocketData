//
//  MessageModel.swift
//  SampleApp
//
//  Created by Peter Livesey on 7/22/16.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

import Foundation
import RocketData

final public class MessageModel: SampleAppModel, Equatable {
    let id: Int
    let text: String
    let sender: UserModel

    init(id: Int, text: String, sender: UserModel) {
        self.id = id
        self.text = text
        self.sender = sender
    }

    // MARK: - SampleAppModel

    required public init?(data: [AnyHashable: Any]) {
        guard let id = data["id"] as? Int,
            let text = data["text"] as? String,
            let senderData = data["sender"] as? [AnyHashable: Any],
            let sender = UserModel(data: senderData as [AnyHashable: Any]) else {
                return nil
        }
        self.id = id
        self.text = text
        self.sender = sender
    }

    func data() -> [AnyHashable: Any] {
        return [
            "id": id,
            "text": text,
            "sender": sender.data()
        ]
    }

    // MARK: - Rocket Data Model

    public var modelIdentifier: String? {
        // We prepend UserModel to ensure this is globally unique
        print("MessageModel:\(id)")
        return "MessageModel:\(id)"
    }

    public func map(_ transform: (Model) -> Model?) -> MessageModel? {
        guard let newSender = transform(sender) as? UserModel else {
            // If transform returns nil, we should cascade this delete
            return nil
        }
        return MessageModel(id: id, text: text, sender: newSender)
    }

    public func forEach(_ visit: (Model) -> Void) {
        visit(sender)
    }
}

public func ==(lhs: MessageModel, rhs: MessageModel) -> Bool {
    return lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.sender == rhs.sender
}
