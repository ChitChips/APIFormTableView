//
//  APICustomTextField.m
//  APIFormTableView
//
//  Created by AURELIEN PINSTON on 26/08/13.
//  Copyright (c) 2013 apinston. All rights reserved.
//

#import "APICustomTextField.h"

@implementation APICustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

@end
