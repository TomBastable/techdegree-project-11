//
//  ReminderTableViewCell.swift
//  Location Reminder
//
//  Created by Tom Bastable on 06/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var frame: CGRect {
      get {
          return super.frame
      }
      set (newFrame) {
          var frame =  newFrame
          frame.origin.y += 4
          frame.size.height -= 2 * 5
          super.frame = frame
      }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureReminderCellWith(reminder: Reminder) {
        
        guard let locationName = reminder.locationName, let title = reminder.title, let subtitle = reminder.subtitle else{
            return
        }
        
        self.locationLabel.text = "\(reminder.whenEntering.whenEnteringString) \(locationName)"
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }

}
