//
//  ViewController.h
//  Game
//
//  Created by Tang Hana on 2017/2/23.
//  Copyright © 2017年 Tang Hana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    NSMutableArray* field;
    NSMutableArray* booms;
    UIView* gameOver;
    UIButton* flag;
    bool setFlag;
    int flags;
    int flag_mine;
    int mines;
    
    UIButton* pause;
}

-(void)click:(id)sender;

@end

