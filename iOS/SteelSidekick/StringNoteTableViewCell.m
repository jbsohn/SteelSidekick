//
//  StringNoteTableViewCell.m
//  SteelSidekick
//
//  Created by John Sohn on 4/22/16.
//
//

#import "StringNoteTableViewCell.h"

#define NUMBER_OF_COMPONENTS        2

typedef enum { PC_NOTE, PC_PITCH } PICKER_COMPONENTS;

@interface StringNoteTableViewCell() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *stringNotePickerView;
@property NSArray *notes;
@property NSArray *pitchValues;

@end

@implementation StringNoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.notes = @[@"C",
                   @"C\u266f/D\u266d",
                   @"D",
                   @"D\u266f/E\u266d",
                   @"E",
                   @"F",
                   @"F\u266f/G\u266d",
                   @"G",
                   @"G\u266f/A\u266d",
                   @"A",
                   @"A\u266f/B\u266d",
                   @"B"];

    self.pitchValues = @[@"0",
                         @"1",
                         @"2",
                         @"3",
                         @"4",
                         @"5",
                         @"6",
                         @"7",
                         @"8"];

    self.stringNotePickerView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return NUMBER_OF_COMPONENTS;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == PC_NOTE) {
        return [self.notes count];
    } else if (component == PC_PITCH) {
        return [self.pitchValues count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    NSString *title = @"";
    
    if (component == 0) {
        return self.notes[row];
    } else if (component == 1) {
        return self.pitchValues[row];
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == PC_NOTE) {
        self.note = (int) row;
    } else if (component == PC_PITCH) {
        self.pitch = (int) row;
    }
    
    [self.delegate didSelectStringNoteItem:self];
}

- (void)refresh {
    [self.stringNotePickerView selectRow:self.note inComponent:PC_NOTE animated:NO];
    [self.stringNotePickerView selectRow:self.pitch inComponent:PC_PITCH animated:NO];
}

@end
