//
//  UIDeselectableSegmentControl.swift
//  strokeRehab
//
//  Created by mobiledev on 20/5/2022.
//

import UIKit


class UIDeselectableSegmentedControl: UISegmentedControl {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let previousSelectedSegmentIndex = self.selectedSegmentIndex

        super.touchesEnded(touches, with: event)

        if previousSelectedSegmentIndex == self.selectedSegmentIndex {

            self.selectedSegmentIndex = UISegmentedControl.noSegment
            let touch = touches.first!
            let touchLocation = touch.location(in: self)
            if bounds.contains(touchLocation) {
                self.sendActions(for: .valueChanged)
            }
        }
    }
}
