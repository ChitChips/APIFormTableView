//
//  APIViewController.m
//  APIFormTableView
//
//  Created by AURELIEN PINSTON on 26/08/13.
//  Copyright (c) 2013 apinston. All rights reserved.
//

#import "APITableViewController.h"
#import "APICustomTextField.h"
#import "APIFormCell.h"

@interface APITableViewController ()
{
    NSMutableArray *_fieldItems;
    NSMutableArray *_valueItems;
    
    APICustomTextField *_currentTextField;
    NSString *_saveValue;
    
    UIToolbar *_numberToolbar;
} 

@end

@implementation APITableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Setup keyboard for textfields
    //Add "Done", "Previous" and "Next" button to keyboard
    _numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    _numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UISegmentedControl *leftItems = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    leftItems.segmentedControlStyle = UISegmentedControlStyleBar;
    leftItems.momentary = YES; // do not preserve button's state
    [leftItems addTarget:self action:@selector(nextPrevHandlerDidChange:) forControlEvents:UIControlEventValueChanged];
    _numberToolbar.opaque = YES;
    _numberToolbar.items = [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc] initWithCustomView:leftItems],
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)],
                                nil];
    [_numberToolbar sizeToFit];
    
    //Setup array
    [self createFieldItems];
    [self createValueItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _fieldItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_fieldItems objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellForm";
    APIFormCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSMutableArray *currentFieldArray = [_fieldItems objectAtIndex:indexPath.section];
    NSMutableArray *currentValueArray = [_valueItems objectAtIndex:indexPath.section];
    
    cell.fieldLabel.text = [currentFieldArray objectAtIndex:indexPath.row];
    cell.valueTextField.text = [currentValueArray objectAtIndex:indexPath.row];
    cell.valueTextField.indexPath = indexPath;
    cell.valueTextField.delegate = self;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    APIFormCell *cell = (APIFormCell *)[tableView cellForRowAtIndexPath:indexPath];
    _currentTextField = cell.valueTextField;
    [_currentTextField becomeFirstResponder];
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = (APICustomTextField *)textField;
    _currentTextField.inputAccessoryView = _numberToolbar;
    _saveValue = _currentTextField.text;
    _currentTextField.text = @"";
    [self.tableView scrollToRowAtIndexPath:_currentTextField.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //Update and save data
    APICustomTextField *tmp = (APICustomTextField *)textField;
    NSIndexPath *index = tmp.indexPath;
    
    if ([tmp.text isEqualToString:@""])
        tmp.text = _saveValue;
    
    NSMutableArray *tmpArray = [_valueItems objectAtIndex:index.section];
    [tmpArray replaceObjectAtIndex:index.row withObject:tmp.text];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //Limit length of textfield
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 3) ? NO : YES;
}

#pragma marks - IBAction Keyboard

- (IBAction)doneWithNumberPad:(id)sender
{
    //Remove keyboard
    [_currentTextField resignFirstResponder];
}

- (IBAction)nextPrevHandlerDidChange:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex])
    {
        //Previous keyboard
        case 0:
        {
            //Change row
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentTextField.indexPath.row - 1 inSection:_currentTextField.indexPath.section]];
            if (cell != nil)
            {
                APIFormCell *cellForm = (APIFormCell *)cell;
                _currentTextField = cellForm.valueTextField;
                [_currentTextField becomeFirstResponder];
                
            }
            //Change section
            else
            {
                if (_currentTextField.indexPath.section > 0)
                {
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:_currentTextField.indexPath.section - 1] - 1) inSection:_currentTextField.indexPath.section - 1]];
                    
                    if (cell != nil)
                    {
                        APIFormCell *cellForm = (APIFormCell *)cell;
                        _currentTextField = cellForm.valueTextField;
                        [_currentTextField becomeFirstResponder];
                    }
                }
            }
            break;
        }
        //Next keyboard
        case 1:
        {
            //Change row
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentTextField.indexPath.row + 1 inSection:_currentTextField.indexPath.section]];
            if (cell != nil)
            {
                APIFormCell *cellForm = (APIFormCell *)cell;
                _currentTextField = cellForm.valueTextField;
                [_currentTextField becomeFirstResponder];
            }
            //Change section
            else
            {                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_currentTextField.indexPath.section + 1]];
                //Not Comment Cell
                if (cell != nil)
                {
                    APIFormCell *cellForm = (APIFormCell *)cell;
                    _currentTextField = cellForm.valueTextField;
                    [_currentTextField becomeFirstResponder];
                }
            }
            break;
        }
        default:
            break;
    }
}


#pragma marks - Create Array

- (void)createFieldItems
{
    NSMutableArray *array0 = [NSMutableArray arrayWithObjects:
                                                        @"field01",
                                                        @"field02",
                                                        @"field03",
                                                        @"field04",
                                                        @"field05",
                                                        nil];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:
                              @"field11",
                              @"field12",
                              @"field13",
                              @"field14",
                              @"field15",
                              nil];
    
    
    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:
                              @"field21",
                              @"field22",
                              @"field23",
                              @"field24",
                              @"field25",
                              nil];
    
    NSMutableArray *array3 = [NSMutableArray arrayWithObjects:
                              @"field31",
                              @"field32",
                              @"field33",
                              @"field34",
                              @"field35",
                              nil];
    
    NSMutableArray *array4 = [NSMutableArray arrayWithObjects:
                              @"field41",
                              @"field42",
                              @"field43",
                              @"field44",
                              @"field45",
                              nil];
    
    NSMutableArray *array5 = [NSMutableArray arrayWithObjects:
                              @"field51",
                              @"field52",
                              @"field53",
                              @"field54",
                              @"field55",
                              nil];
    
    _fieldItems = [NSMutableArray arrayWithObjects:
                                array0,
                                array1,
                                array2,
                                array3,
                                array4,
                                array5,
                                nil];
}

- (void)createValueItems
{
    NSMutableArray *array0 = [NSMutableArray arrayWithObjects:
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              nil];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              nil];
    
    
    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              nil];
    
    NSMutableArray *array3 = [NSMutableArray arrayWithObjects:
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              nil];
    
    NSMutableArray *array4 = [NSMutableArray arrayWithObjects:
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              nil];
    
    NSMutableArray *array5 = [NSMutableArray arrayWithObjects:
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              @"0",
                              nil];;
    
    _valueItems = [NSMutableArray arrayWithObjects:
                   array0,
                   array1,
                   array2,
                   array3,
                   array4,
                   array5,
                   nil];
}

@end
