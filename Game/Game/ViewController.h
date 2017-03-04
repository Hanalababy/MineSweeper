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
    
    UIButton* flag;
    UIButton* mark;
    UILabel* numMines;
    
    UIView* resultView;
    
    /*setting view*/
    UIView* settingView;
    UIButton*settingBtn;
    UILabel* colLabel;
    UILabel* rowLabel;
    UILabel* mine;
    
    bool setFlag;
    bool setMark;
    int clicks; //total revealed cell
    int flag_mine;  //number of flag_mine
    int flags; //number of flag
    int mines;  //total number of mines
    float l;
    int col; //
    int row;
    
    /*timer*/
    UILabel* timer;
    NSTimer* myTimer;
    int min;
    int sec;
    
    UIButton* pause;
}

-(void)click:(id)sender;

@end

