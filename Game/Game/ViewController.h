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
    NSMutableArray* mask;
    UIView* resultView;
    UIButton* flag;
      UIButton* mark;
    UILabel* numMines;
    bool setFlag;
    bool setMark;
    int clicks;
    int flags;
    int flag_mine;
    int mines;
    float l;
    int n;
    UILabel* timer;
    NSTimer* myTimer;
    int min;
    int sec;
    
    UIButton* pause;
}

-(void)click:(id)sender;

@end

