//
//  ViewController.swift
//  DialogViewer
//
//  Created by Lei Zhao on 6/24/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

    private var sections = [
        ["header": "First Witch", "content": "Hey, when will the three of us meet up later?"],
        ["header": "Second Witch", "content": "When everything's straightened out."],
        ["header": "Third Witch", "content": "That'll be just before sunset."],
        ["header": "First Witch", "content": "Where?"],
        ["header": "Second Witch", "content": "The dirt patch."],
        ["header": "Third Witch", "content": "I guess we'll see Mac there."],
    ]
    
    override func viewDidLoad() {
        collectionView?.registerClass(ContentCell.self, forCellWithReuseIdentifier: "CONTENT")
        
        var contentInset = collectionView?.contentInset
        contentInset?.top = 20
        collectionView?.contentInset = contentInset!
    }

}

