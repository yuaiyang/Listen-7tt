//
//  SetTableViewCell.m
//  Radio
//
//  Created by 雨爱阳 on 15/10/20.
//  Copyright (c) 2015年 雨爱阳. All rights reserved.
//

#import "SetTableViewCell.h"
#import "ShareHandle.h"
@implementation SetTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}



- (IBAction)turnon:(UISwitch *)sender {
    
    ShareHandle * handle = [ShareHandle shareHandle];
    
    if (sender.tag == 10) {

        if (!sender.on) {
            
            [handle isUseMobelListen:NO];
            

            
        }else if (sender.on){
            
            [handle isUseMobelListen:YES];

        }
        
    }else if (sender.tag == 115){

        if (!sender.on) {
            [handle isUseMobelDownLoade:NO];

            
        }else if (sender.on){
            
            [handle isUseMobelDownLoade:YES];

        }
        
        
    }else if(sender.tag == 11){
        if (!sender.on) {
            
            [handle isPlayWithOn:NO];

            
        }

        else if (sender.on){
            
            [handle isPlayWithOn:YES];

            
        }
        
    }

}





@end
