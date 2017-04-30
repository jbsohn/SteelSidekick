//
//  StringNoteTableViewCell.h
//  SteelSidekick
//
//  Created by John Sohn on 4/22/16.
//
//

#import <UIKit/UIKit.h>
#import "SGuitar.h"
#import "CustomGuitarViewController.h"

@class StringNoteTableViewCell;
@protocol StringNoteTableViewCellDelegate
- (void)didSelectStringNoteItem:(StringNoteTableViewCell *)cell;
@end

@interface StringNoteTableViewCell : UITableViewCell

@property (weak, nonatomic) id <StringNoteTableViewCellDelegate> delegate;
@property int note;
@property int pitch;
@property int stringNumber;

- (void)refresh;

@end
