//
//  ConversationViewController.swift
//  ProjaBox
//
//  Created by Alexandru Clapa on 23/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ConversationViewController: JSQMessagesViewController {
	
	let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0))
	let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor(red: 237/255, green: 84/255, blue: 84/255, alpha: 1))
	var messages = [JSQMessage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.setup()
		self.addDemoMessages()
    }
	
	func addDemoMessages() {
		for i in 1...10 {
			let sender = (i%2 == 0) ? "Server" : self.senderId
			let messageContent = "Message nr. \(i)"
			let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
			self.messages += [message]
		}
		self.reloadMessagesView()
	}
	
	func setup() {
		self.senderId = UIDevice.currentDevice().identifierForVendor?.UUIDString
		self.senderDisplayName = UIDevice.currentDevice().identifierForVendor?.UUIDString
	}
	
	func reloadMessagesView() {
		self.collectionView?.reloadData()
	}
	
	// MARK: Collection View Methods
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.messages.count
	}
	
	override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
		let data = self.messages[indexPath.row]
		return data
	}
	
	override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
		self.messages.removeAtIndex(indexPath.row)
	}
	
	override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
		let data = messages[indexPath.row]
		switch(data.senderId) {
		case self.senderId:
			return self.outgoingBubble
		default:
			return self.incomingBubble
		}
	}
	
	override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
		return nil
	}
	
	// MARK: Toolbar Methodså
	
	override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
		let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
		self.messages += [message]
		self.finishSendingMessage()
	}
	
	override func didPressAccessoryButton(sender: UIButton!) {
		
	}

}
