//
//  TaskTableViewCell.swift
//  CoreToDo
//
//  Created by Hirono Momotaro on 2017/10/09.
//  Copyright © 2017年 Hirono Momotaro. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TaskCell"
    
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
