//
//  ViewController.m
//  Game
//
//  Created by Tang Hana on 2017/2/23.
//  Copyright © 2017年 Tang Hana. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    col=10;  //default column of field
    row=15;   //default row of field
    mines=10;  //default number of mines
    
    [self start];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setting

-(void)setting{
    settingView=[[UIView alloc]init];
    settingView.frame=self.view.frame;
    settingView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.8];
    [self.view addSubview:settingView];
    
    /*slider*/
    UISlider* columnSlider = [[UISlider alloc]init];
    columnSlider.frame = CGRectMake(120, 100, self.view.frame.size.width-150, 20); //滑动条的位置，大小
    columnSlider.minimumValue = 10; //最小值
    columnSlider.maximumValue = 20; //最大值
    columnSlider.value = col; //默认值
    columnSlider.tag=1;
    [columnSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    columnSlider.thumbTintColor = [UIColor whiteColor];
    columnSlider.minimumTrackTintColor = [UIColor colorWithRed:54 / 256.0 green:148 / 256.0 blue:111 / 256.0 alpha:1];
    
    [settingView addSubview:columnSlider];
    colLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,100,100,20)];
    colLabel.textColor=[UIColor whiteColor];
    colLabel.text=[NSString stringWithFormat:@"COL: %d",(int)columnSlider.value];
    [settingView addSubview:colLabel];
    
    UISlider* rowSlider = [[UISlider alloc]init];
    rowSlider.frame = CGRectMake(120, 150, self.view.frame.size.width-150, 20); //滑动条的位置，大小
    rowSlider.minimumValue = 10; //最小值
    rowSlider.maximumValue = 20; //最大值
    rowSlider.value = row; //默认值
    rowSlider.tag=2;
    [rowSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    rowSlider.thumbTintColor = [UIColor whiteColor];
    rowSlider.minimumTrackTintColor = [UIColor colorWithRed:54 / 256.0 green:148 / 256.0 blue:111 / 256.0 alpha:1];
    [settingView addSubview:rowSlider];
    rowLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,150,100,20)];
    rowLabel.textColor=[UIColor whiteColor];
    rowLabel.text=[NSString stringWithFormat:@"ROW: %d",(int)rowSlider.value];
    [settingView addSubview:rowLabel];
    
    
    /*slider*/
    UISlider* mineSlider = [[UISlider alloc]init];
    mineSlider.frame = CGRectMake(120, 200, self.view.frame.size.width-150, 20); //滑动条的位置，大小
    mineSlider.minimumValue = 10; //最小值
    mineSlider.maximumValue = 30; //最大值
    mineSlider.value = mines; //默认值
    mineSlider.tag=3;
    [mineSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    mineSlider.thumbTintColor = [UIColor whiteColor];
    mineSlider.minimumTrackTintColor = [UIColor colorWithRed:54 / 256.0 green:148 / 256.0 blue:111 / 256.0 alpha:1];
    [settingView addSubview:mineSlider];
    mine = [[UILabel alloc]initWithFrame:CGRectMake(10,200,100,20)];
    mine.textColor=[UIColor whiteColor];
    mine.text=[NSString stringWithFormat:@"MINES: %d",(int)mineSlider.value];
    [settingView addSubview:mine];
    
    /*Done btn*/
    UIButton* returnBtn=[[UIButton alloc]initWithFrame:CGRectMake(10,30,20,20)];
    [returnBtn setTitle:@"×" forState: UIControlStateNormal];
    returnBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [returnBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [settingView addSubview:returnBtn];
}

    
    
-(void)sliderChanged:(id)sender{
    UISlider* slider=(UISlider*)sender;
    if(slider.tag==1){
        colLabel.text=[NSString stringWithFormat:@"COL: %d",(int)slider.value];
        col=(int)slider.value;
    }
    if(slider.tag==2){
        rowLabel.text=[NSString stringWithFormat:@"ROW: %d",(int)slider.value];
        row=(int)slider.value;
    }
    if(slider.tag==3){
        mine.text=[NSString stringWithFormat:@"MINES: %d",(int)slider.value];
        mines=(int)slider.value;
    }
}

#pragma mark - showResult

-(void)showResult:result{
    [myTimer invalidate];
    
    for(int i=0;i!=[field count];i++){
        UIButton*cell=[field objectAtIndex:i];
        int tag=cell.tag;
        NSNumber*c=[bombs objectAtIndex:tag];
        NSNumber*m=[mask objectAtIndex:tag];
        /*unclicked bomb*/
        if(m.intValue==0&&c.intValue==-1){
            [cell setBackgroundImage:[UIImage imageNamed:@"bomb.jpg"] forState:UIControlStateNormal];
        }
        /*wrong flag*/
        if(m.intValue==2&&c.intValue!=-1){
            [cell setBackgroundImage:[UIImage imageNamed:@"flag0.jpg"] forState:UIControlStateNormal];
            
        }
    }
    resultView=[[UIView alloc]init];
    resultView.frame=self.view.frame;
    resultView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    UIButton* startBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-20, 100, 40)];
    [startBtn setTitle: result forState: UIControlStateNormal];
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [resultView addSubview:startBtn];
    [self.view addSubview:resultView];
}

#pragma mark - flag
-(void)setFlag{
    [self unsetMark];
    setFlag=1;
    flag.alpha=1;
    [flag removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [flag addTarget:self action:@selector(unsetFlag) forControlEvents:UIControlEventTouchUpInside];
}

-(void)unsetFlag{
    setFlag=0;
    flag.alpha=0.5;
    [flag removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [flag addTarget:self action:@selector(setFlag) forControlEvents:UIControlEventTouchUpInside];    
}
    
#pragma mark - mark
-(void)setMark{
    [self unsetFlag];
    setMark=1;
    mark.alpha=1;
    [mark removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [mark addTarget:self action:@selector(unsetMark) forControlEvents:UIControlEventTouchUpInside];
}

-(void)unsetMark{
    setMark=0;
    mark.alpha=0.5;
    [mark removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [mark addTarget:self action:@selector(setMark) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - timer
-(void)timerCount{
    if(clicks==0){
        return;
    }
    if(sec==59){
        min+=1;
        sec=0;
    }
    else{
        sec+=1;
    }
    if(min<10){
        if(sec<10){
            timer.text=[NSString stringWithFormat:@"0%d%@0%d",min,@":",sec];
            
        }
        else{
            timer.text=[NSString stringWithFormat:@"0%d%@%d",min,@":",sec];
        }
    }
    else{
        timer.text=[NSString stringWithFormat:@"%d%@%d",min,@":",sec];
    }
    
}

#pragma mark - startGame
-(void)start{
    
    [[self.view subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIView* navView=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-50,self.view.frame.size.width,50)];
    navView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:navView];
    
    /*number of clicked cells*/
    clicks=0;
    
    /*mark button*/
    mark=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+20+20,5,40,40)];
    mark.layer.borderColor=[UIColor colorWithWhite:0 alpha:0.6].CGColor;
    mark.layer.borderWidth=3.0f;
    [mark setBackgroundImage:[UIImage imageNamed:@"mark.jpg"] forState:UIControlStateNormal];
    [mark addTarget:self action:@selector(setMark) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:mark];
    [self unsetMark];
    
    /*flag button*/
    flags=0;
    flag=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-20-20-40,5,40,40)];
    flag.layer.borderColor=[UIColor colorWithWhite:0 alpha:0.6].CGColor;
    flag.layer.borderWidth=3.0f;
    [flag setBackgroundImage:[UIImage imageNamed:@"flag.jpg"] forState:UIControlStateNormal];
    [flag addTarget:self action:@selector(setFlag) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:flag];
    [self unsetFlag];
    
    /*number of mines*/
    numMines=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20,5,40,40)];
    numMines.textAlignment=NSTextAlignmentCenter;
    numMines.text=[NSString stringWithFormat:@"%d",mines-flags];
    [navView addSubview:numMines];
    
    /*setting*/
    settingBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-20-20-40-20-50,5,50,40)];
    [settingBtn setTitle:@"Menu" forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:settingBtn];
    
    /*timer*/
    timer=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+20+20+40+20,5,100,40)];
    min=0;
    sec=0;
    timer.text=@"00:00";
    timer.textColor=[UIColor whiteColor];
    [navView addSubview:timer];
    [myTimer invalidate];
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    myTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCount)
                                         userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSRunLoopCommonModes];
    
    /*add field*/
    l=MIN((self.view.frame.size.width-(col-1))/(col+2),(self.view.frame.size.height-150-(row-1))/(row+2));
    int temp=mines;//number of mines
    field=[[NSMutableArray alloc] init];
    bombs=[[NSMutableArray alloc] init];
    mask=[[NSMutableArray alloc] init];
    for(int i=0;i!=row;i++){
        for(int j=0;j!=col;j++){//l+(l+1)*j
            UIButton*cell =[[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-col*l-col+1)/2+(l+1)*j,(self.view.frame.size.height-50-row*l-row+1)/2+(l+1)*i, l, l)];
            cell.tag = i*col+j;
            cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
            cell.adjustsImageWhenDisabled = NO;
            [cell setBackgroundImage:[UIImage imageNamed:@"s.jpg"] forState:UIControlStateNormal];
            cell.layer.borderWidth=1.0f;
            [cell addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [field addObject:cell];
            [self.view addSubview:cell];
            
            [bombs addObject:[NSNumber numberWithInt:0]];
            
            [mask addObject:[NSNumber numberWithInt:0]]; //0:space  1:clicked 2:flagged 3:marked
        }
    }
    
    /*add bombs*/
    bool end=false;
    while(1){
        for(int i=0;i!=[field count];i++){
            NSNumber*c=[bombs objectAtIndex:i];
            if(arc4random()%row==0&&c.intValue!=-1){
                mines--;
                [bombs replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:-1]];
            }
            if(mines==0){
                end=true;
                break;
            }
        }
        if(end){
            break;
        }
    }
    mines=temp;

    /*count bombs*/
    for(int i=0;i!=row;i++){
        for(int j=0;j!=col;j++){
            NSNumber*c=[bombs objectAtIndex:i*col+j];
            if(c.integerValue==-1) continue; //this is a boom
            int count=0;
            if(i-1>=0&&j-1>=0){
                NSNumber*c=[bombs objectAtIndex:(i-1)*col+(j-1)];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            if(i-1>=0){
                NSNumber*c=[bombs objectAtIndex:(i-1)*col+j];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            if(i-1>=0&&j+1<col){
                NSNumber*c=[bombs objectAtIndex:(i-1)*col+(j+1)];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            if(j-1>=0){
                NSNumber*c=[bombs objectAtIndex:i*col+(j-1)];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            if(j+1<col){
                NSNumber*c=[bombs objectAtIndex:i*col+(j+1)];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            
            if(i+1<row&&j-1>=0){
                NSNumber*c=[bombs objectAtIndex:(i+1)*col+(j-1)];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            if(i+1<row){
                NSNumber*c=[bombs objectAtIndex:(i+1)*col+j];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            if(i+1<row&&j+1<col){
                NSNumber*c=[bombs objectAtIndex:(i+1)*col+(j+1)];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            
            [bombs replaceObjectAtIndex:i*col+j withObject:[NSNumber numberWithInt:count]];
        }
    }
}

#pragma mark - clickAction
-(void)click:(id)sender{
    UIButton *cell = (UIButton *)sender;
    int tag=(int)cell.tag;
    NSNumber*c=[bombs objectAtIndex:tag];
    NSNumber*m=[mask objectAtIndex:tag];
    
    /*set flag*/
    if(setFlag==1){
        if(m.intValue==2) //flagged->clear flag
        {
            flags--;
            numMines.text=[NSString stringWithFormat:@"%d",mines-flags];
            [mask replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:0]];
            [cell setBackgroundImage:[UIImage imageNamed:@"s.jpg"] forState:UIControlStateNormal];
        }
        else {   //set a flag
            flags+=1;
            numMines.text=[NSString stringWithFormat:@"%d",mines-flags];
            [mask replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:2]];
            [cell setBackgroundImage:[UIImage imageNamed:@"flag.jpg"] forState:UIControlStateNormal];
        }
        return;
    }
    
    /*set mark*/
    if(setMark==1){
        if(m.intValue==3) //flagged->clear flag
        {
            [mask replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:0]];
            [cell setBackgroundImage:[UIImage imageNamed:@"s.jpg"] forState:UIControlStateNormal];
        }
        else {
            [mask replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:3]];
            [cell setBackgroundImage:[UIImage imageNamed:@"mark.jpg"] forState:UIControlStateNormal];
        }
        return;
    }
    
    /*flagged or marked or clicked*/
    if(m.intValue!=0){
        return;
    }
    
    cell.enabled = NO;
    [mask replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:1]];
    /*click a bomb->FAIL*/
    if(c.integerValue==-1){
        [cell setBackgroundImage:[UIImage imageNamed:@"bomb0.jpg"] forState:UIControlStateNormal];
        [self showResult:@"Game Over"];
        return;
    }
    
    /*click a number*/
    NSString *name = [NSString stringWithFormat:@"%d.jpg",c.intValue];
    [cell setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    clicks+=1;
    
    /*find all mines->WIN*/
    if(clicks==row*col-mines){
        [self showResult:@"You Win"];
        return;
    }
    /*click safe space*/ //c.integerValue==0
     if(c.intValue==0){
        if(tag%col!=0&&tag-col-1>=0){
            UIButton*cell1=[field objectAtIndex:tag-col-1];
            [self click:cell1];
        }
        if(tag-col>=0){
            UIButton*cell2=[field objectAtIndex:tag-col];
            [self click:cell2];
        }
        if(tag%col!=col-1&&tag-col+1>=0){
            UIButton*cell3=[field objectAtIndex:tag-col+1];
            [self click:cell3];
        }
        if(tag%col!=0&&tag-1>=0){
            UIButton*cell4=[field objectAtIndex:tag-1];
            [self click:cell4];
        }
        if(tag%col!=col-1&&tag+1<row*col){
            UIButton*cell5=[field objectAtIndex:tag+1];
            [self click:cell5];
        }
        if(tag%col!=0&&tag+col-1<row*col){
            UIButton*cell6=[field objectAtIndex:tag+col-1];
            [self click:cell6];
        }
        if(tag+col<row*col){
            UIButton*cell7=[field objectAtIndex:tag+col];
            [self click:cell7];
        }
        if(tag%col!=col-1&&tag+col+1<row*col){
            UIButton*cell8=[field objectAtIndex:tag+col+1];
            [self click:cell8];
        }
    }
}

@end
