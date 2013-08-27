//
//  APIFormCell.h
//  APIFormTableView
//
//  Created by AURELIEN PINSTON on 26/08/13.
//  Copyright (c) 2013 apinston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APICustomTextField.h"

@interface APIFormCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *fieldLabel;
@property (nonatomic, weak) IBOutlet APICustomTextField *valueTextField;

@end
