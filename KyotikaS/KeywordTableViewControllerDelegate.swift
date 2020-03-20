//
//  KeywordTableViewControllerDelegate.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/20.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

protocol KeywordTableViewControllerDelegate : NSObjectProtocol {
    func treasureAnnotationsForTag(tag: Tag) -> [TreasureAnnotation]
    func showRelatedTargetLocations(_ ta: TreasureAnnotation)
    func showTargetLocations(tagName: String, treasureAnnotation: [TreasureAnnotation])
    func hideTargetLocations()
}
