//
//  PullRequestsViewController.swift
//  PopRequest
//
//  Created by Stephan on 28/10/2017.
//  Copyright © 2017 Maxim. All rights reserved.
//

import AppKit

class PullRequestViewController : NSViewController, NSCollectionViewDelegate  {

    @IBOutlet var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        collectionView.maxNumberOfColumns = 1
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func viewDidLayout() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {

        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: collectionView.frame.size.width - 20.0, height: 50.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout
        
        view.wantsLayer = true
    }
    
    
}

extension PullRequestViewController : NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PullRequestView"), for: indexPath)
        
        guard let collectionViewItem = item as? PullRequestView else {
            return item
        }
        
        // 5
        //let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath)
        //collectionViewItem.imageFile = imageFile
        return item
    }
    
}
