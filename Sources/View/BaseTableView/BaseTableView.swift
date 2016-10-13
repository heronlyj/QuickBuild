//
//  BaseTableView.swift
//  zhysq
//
//  Created by lyj on 13/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

public class BaseTableView: UITableView {
    
    public let baseCellId = "BaseTableViewController.baseCell"
    
    public convenience init(frame: CGRect) {
        self.init(frame: frame, style: .grouped)
    }
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        registerBaseCells()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerBaseCells()
    }
    
    private func registerBaseCells() {
        
        let bundle = Bundle(for: BaseTableView.self)
        register(name: BaseLabelCell.reuseId, in: bundle)
        register(name: BaseSwitchCell.reuseId, in: bundle)
        register(name: BaseTextViewCell.reuseId, in: bundle)
        register(name: BaseImageListCell.reuseId, in: bundle)
        register(name: BaseTextFieldCell.reuseId, in: bundle)
        register(name: BaseSingleLabelCell.reuseId, in: bundle)
        
        register(UITableViewCell.self, forCellReuseIdentifier: baseCellId)
    }

    
    
}


public class BaseTextFieldCell: UITableViewCell {
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var textField: UITextField!
}

public class BaseLabelCell: UITableViewCell {
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var contentLabel: UILabel!
}

public class BaseSwitchCell: UITableViewCell {
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var switchItem: UISwitch!
}

public class BaseImageListCell: UITableViewCell {
    @IBOutlet public weak var imageCollectionView: ImageCollectionView!
}

public class BaseSingleLabelCell: UITableViewCell {
    @IBOutlet public weak var middleLabel: UILabel!
}

public class BaseTextViewCell: UITableViewCell {
    @IBOutlet public weak var textView: UITextView!
}
