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
    
    n=12;
    l=(self.view.frame.size.width-(n-1))/(n+2);
    [self start];
}

-(void)showResult:result{
    [myTimer invalidate];
    
    for(int i=0;i!=[field count];i++){
        UIButton*cell=[field objectAtIndex:i];
        int tag=cell.tag;
        NSNumber*c=[booms objectAtIndex:tag];
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
    [startBtn addTarget:self action:@selector(viewDidLoad) forControlEvents:UIControlEventTouchUpInside];
    [resultView addSubview:startBtn];
    [self.view addSubview:resultView];
}

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

-(void)start{
    
    [[self.view subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIView* navView=[[UIView alloc]initWithFrame:CGRectMake(l,50,self.view.frame.size.width-2*l,30)];
    navView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:navView];
    
    /*mark button*/
    setMark=0;
    mark=[[UIButton alloc] initWithFrame:CGRectMake(150,0,30,30)];
    mark.layer.borderWidth=2.0f;
    [mark setBackgroundImage:[UIImage imageNamed:@"mark.jpg"] forState:UIControlStateNormal];
    [mark addTarget:self action:@selector(setMark) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:mark];

    /*number of clicked cells*/
    clicks=0;
    
    /*flag button*/
    flags=0;
    setFlag=0;
    flag=[[UIButton alloc] initWithFrame:CGRectMake(50,0,30,30)];
    flag.layer.borderWidth=2.0f;
    [flag setBackgroundImage:[UIImage imageNamed:@"flag.jpg"] forState:UIControlStateNormal];
    [flag addTarget:self action:@selector(setFlag) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:flag];
    
    /*number of mines*/
    numMines=[[UILabel alloc]initWithFrame:CGRectMake(100,0,30,30)];
    numMines.layer.borderWidth=2.0f;
    numMines.textColor=[UIColor blackColor];
    numMines.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:numMines];
    
    /*timer*/
    timer=[[UILabel alloc]initWithFrame:CGRectMake(200,0,100,30)];
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
    mines=0;//total number of mines
    field=[[NSMutableArray alloc] init];
    booms=[[NSMutableArray alloc] init];
    mask=[[NSMutableArray alloc] init];
    for(int i=0;i!=n;i++){
        for(int j=0;j!=n;j++){
            UIButton*cell =[[UIButton alloc] initWithFrame:CGRectMake(l+(l+1)*j,(self.view.frame.size.height/2-(n*l+(n-1))/2)+(l+1)*i, l, l)];
            cell.tag = i*n+j;
            cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
            cell.adjustsImageWhenDisabled = NO;
            [cell setBackgroundImage:[UIImage imageNamed:@"s.jpg"] forState:UIControlStateNormal];
            cell.layer.borderWidth=1.0f;
            [cell addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [field addObject:cell];
            [self.view addSubview:cell];
            
            /*set bombs*/
            if(arc4random()%10==0){
                mines+=1;
                [booms addObject:[NSNumber numberWithInt:-1]];  //booms
            }
            else{
                [booms addObject:[NSNumber numberWithInt:0]];
            }
            [mask addObject:[NSNumber numberWithInt:0]]; //0:space  1:clicked 2:flagged 3:marked
        }
    }
    
    numMines.text=[NSString stringWithFormat:@"%d",mines-flags];
    
    /*count booms*/
    for(int i=0;i!=n;i++){
        for(int j=0;j!=n;j++){
            NSNumber*c=[booms objectAtIndex:i*n+j];
            if(c.integerValue==-1) continue; //this is a boom
            int count=0;
            if(i-1>=0&&j-1>=0){
                NSNumber*c=[booms objectAtIndex:(i-1)*n+(j-1)];
                if(c.integerValue==-1){
                    count+=1;
                }

            }
            if(i-1>=0){
                NSNumber*c=[booms objectAtIndex:(i-1)*n+j];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            if(i-1>=0&&j+1<n){
                NSNumber*c=[booms objectAtIndex:(i-1)*n+(j+1)];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            if(j-1>=0){
                NSNumber*c=[booms objectAtIndex:i*n+(j-1)];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            if(j+1<n){
                NSNumber*c=[booms objectAtIndex:i*n+(j+1)];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            
            if(i+1<n&&j-1>=0){
                NSNumber*c=[booms objectAtIndex:(i+1)*n+(j-1)];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            if(i+1<n){
                NSNumber*c=[booms objectAtIndex:(i+1)*n+j];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            if(i+1<n&&j+1<n){
                NSNumber*c=[booms objectAtIndex:(i+1)*n+(j+1)];
                if(c.integerValue==-1){
                    count+=1;
                }
                
            }
            
            [booms replaceObjectAtIndex:i*n+j withObject:[NSNumber numberWithInt:count]];
        }
    }
}


-(void)click:(id)sender{
    UIButton *cell = (UIButton *)sender;
    int tag=(int)cell.tag;
    NSNumber*c=[booms objectAtIndex:tag];
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
    
    /*already flagged marked clicked*/
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
    /*click number*/
    NSString *name = [NSString stringWithFormat:@"%d.jpg",c.intValue];
    [cell setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    clicks+=1;
    /*find all mines->WIN*/
    if(clicks==n*n-mines){
        [self showResult:@"You Win"];
        return;
    }
    /*click safe space*/ //c.integerValue==0
     if(c.intValue==0){
        if(tag%n!=0&&tag-n-1>=0){
            UIButton*cell1=[field objectAtIndex:tag-n-1];
            [self click:cell1];
        }
        if(tag-n>=0){
            UIButton*cell2=[field objectAtIndex:tag-n];
            [self click:cell2];
        }
        if(tag%n!=n-1&&tag-n+1>=0){
            UIButton*cell3=[field objectAtIndex:tag-n+1];
            [self click:cell3];
        }
        if(tag%n!=0&&tag-1>=0){
            UIButton*cell4=[field objectAtIndex:tag-1];
            [self click:cell4];
        }
        if(tag%n!=n-1&&tag+1<n*n){
            UIButton*cell5=[field objectAtIndex:tag+1];
            [self click:cell5];
        }
        if(tag%n!=0&&tag+n-1<n*n){
            UIButton*cell6=[field objectAtIndex:tag+n-1];
            [self click:cell6];
        }
        if(tag+n<n*n){
            UIButton*cell7=[field objectAtIndex:tag+n];
            [self click:cell7];
        }
        if(tag%n!=n-1&&tag+n+1<n*n){
            UIButton*cell8=[field objectAtIndex:tag+n+1];
            [self click:cell8];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
