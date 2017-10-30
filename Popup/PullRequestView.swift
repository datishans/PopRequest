//
//  PullRequestView.swift
//  PopRequest
//
//  Created by Stephan on 28/10/2017.
//  Copyright © 2017 Maxim. All rights reserved.
//

import AppKit

class PullRequestView : NSCollectionViewItem {
    override func awakeFromNib() {
        view.wantsLayer = true
        
        
        if let imageView = imageView {
            imageView.layer?.cornerRadius = imageView.frame.width / 2
        }
        
        
        
    }
    
    private func updateUI() {
        
    }
}
