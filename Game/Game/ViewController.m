//
//  ViewController.m
//  Game
//
//  Created by Tang Hana on 2017/2/23.
//  Copyright © 2017年 Tang Hana. All rights reserved.
//

#import "ViewController.h"
#define n 15

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self start];
    
    
}

-(void)GameOver{
    gameOver=[[UIView alloc]init];
    gameOver.frame=self.view.frame;
    gameOver.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    UIButton* startBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-20, 100, 40)];
    [startBtn setTitle: @"RESTART" forState: UIControlStateNormal];
    [startBtn addTarget:self action:@selector(viewDidLoad) forControlEvents:UIControlEventTouchUpInside];
    [gameOver addSubview:startBtn];
    [self.view addSubview:gameOver];
}

-(void)setFlag{
    setFlag=1;
    [flag setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [flag addTarget:self action:@selector(unsetFlag) forControlEvents:UIControlEventTouchUpInside];
}

-(void)unsetFlag{
    setFlag=0;
    [flag setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [flag addTarget:self action:@selector(setFlag) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)btnLong:(UILongPressGestureRecognizer *)guester{
    if ([guester state] == UIGestureRecognizerStateBegan) {
        NSLog(@"长按事件");
        
        UIButton *cell = (UIButton*)guester.view;
        int tag=cell.tag;
        [cell setBackgroundImage:[UIImage imageNamed:@"flag.jpg"] forState:UIControlStateNormal];
    }
}

-(void)start{
    
    [gameOver removeFromSuperview];

    
    /*flag button*/
    flags=0;
    setFlag=0;
    flag_mine=0;
    //flag=[UIButton buttonWithType:UIButtonTypeCustom]; //!!!
    flag=[[UIButton alloc] initWithFrame:CGRectMake(20,50,20,20)];
    flag.layer.borderWidth=2.0f;
    flag.backgroundColor=[UIColor yellowColor];
    [flag setBackgroundImage:[UIImage imageNamed:@"flag.jpg"] forState:UIControlStateNormal];//?????????
    [flag addTarget:self action:@selector(setFlag) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flag];
    
    /*add field*/
    mines=0;//total number of mines
    field=[[NSMutableArray alloc] init];
    booms=[[NSMutableArray alloc] init];
    float l=(self.view.frame.size.width-(n-1))/(n+2);
    for(int i=0;i!=n;i++){
        for(int j=0;j!=n;j++){
            UIButton*cell =[[UIButton alloc] initWithFrame:CGRectMake(l+(l+1)*j, 100+(l+1)*i, l, l)];
            cell.tag = i*n+j;
            cell.layer.borderColor=[UIColor blackColor].CGColor;
            cell.backgroundColor=[UIColor whiteColor];
            cell.layer.borderWidth=2.0f;
            [cell addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            /*long press set flag*/
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
            longPress.minimumPressDuration = 0.5; //定义按的时间
            [cell addGestureRecognizer:longPress];
            
            

            [field addObject:cell];
            [self.view addSubview:cell];
            if(arc4random()%9==0){
                mines+=1;
                [booms addObject:[NSNumber numberWithInt:-1]];  //generate booms
                cell.backgroundColor=[UIColor redColor];
                [cell setBackgroundImage:[UIImage imageNamed:@"bomb0.jpg"] forState:UIControlStateNormal];//????????
            }
            else{
                [booms addObject:[NSNumber numberWithInt:0]];
            }
        }
    }
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
            UIButton*cell=[field objectAtIndex:i*n+j];
            [cell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //[cell setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
            [field replaceObjectAtIndex:i*n+j withObject:cell];
            
        }
    }
    
}
//clear the flag of a flagged mine
-(void)clearFlag:(id)sender{
    UIButton *cell = (UIButton *)sender;
    int tag=(int)cell.tag;
    NSNumber*c=[booms objectAtIndex:tag];
     if(setFlag==1){ //clear a flag
        flags-=1;
         [cell setBackgroundImage:[UIImage imageNamed:@"0.jpg"] forState:UIControlStateNormal];
        [cell addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        if(c.integerValue==-1){
            flag_mine-=1;
        }
    }
}

-(void)click:(id)sender{
    UIButton *cell = (UIButton *)sender;
    int tag=(int)cell.tag;
    NSNumber*c=[booms objectAtIndex:tag];
    if(setFlag==1&&flags<mines){  //set a flag
        flags+=1;
        [cell setBackgroundImage:[UIImage imageNamed:@"flag.jpg"] forState:UIControlStateNormal];
        [cell addTarget:self action:@selector(clearFlag:) forControlEvents:UIControlEventTouchUpInside];
        if(c.integerValue==-1){
            flag_mine+=1;
            if(flag_mine==mines){ //win!****check!
                NSLog(@"WIN");
            }
        }
        return;
    }
    if(cell.backgroundColor==[UIColor yellowColor]){  //flag
        return;
    }
    if(cell.backgroundColor==[UIColor lightGrayColor]){  //already check
        return;
    }
    cell.enabled = NO;
    /*click boom*/
    if(c.integerValue==-1){
        cell.backgroundColor=[UIColor redColor];
        NSLog(@"GAME OVER");
        [self GameOver];
        return;
    }
    /*click number*/
    cell.backgroundColor=[UIColor lightGrayColor];
    if(c.integerValue!=0){
        [cell setTitle:[NSString stringWithFormat:@"%d",c.intValue] forState:UIControlStateNormal];
    }
    /*click safe space*/ //c.integerValue==0
    else{
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
