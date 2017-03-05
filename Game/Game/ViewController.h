//
//  ViewController.h
//  Game
//
//  Created by Tang Hana on 2017/2/23.
//  Copyright © 2017年 Tang Hana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
    /*setting view*/
    UIView* settingView;
    UIButton*settingBtn;
    UILabel* colLabel;
    UILabel* rowLabel;
    UILabel* mine;
    NSMutableArray* field;
    NSMutableArray* bombs;
    NSMutableArray* mask;
    
    /*result view*/
    UIView* resultView;
    
    /*flag*/
    UIButton* flag;
    bool setFlag;
    
    /*marl*/
    UIButton* mark;
    bool setMark;
    
    /*mines*/
    UILabel* numMines;
    
    /*general variable*/
    int clicks; //total revealed cell
    int flag_mine;  //number of flag_mine
    int flags; //number of flag
    int mines;  //total number of mines
    float l; //length of a cell
    int col;
    int row;
    
    /*timer*/
    UILabel* timer;
    NSTimer* myTimer;
    int min;
    int sec;
}
@end

