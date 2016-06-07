//
//  ViewController.m
//  yolo
//
//  Created by Vikram Mullick on 10/12/15.
//  Copyright © 2015 Vikram Mullick. All rights reserved.
//

#import "ViewController.h"
#import "point.h"
#import "AppDelegate.h"

@import Accelerate;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *Xcoordinate;
@property (weak, nonatomic) IBOutlet UITextField *Ycoordinate;
@property (weak, nonatomic) IBOutlet UIButton *addPoint;
@property (weak, nonatomic) IBOutlet UISegmentedControl *RegressionType;
@property (weak, nonatomic) IBOutlet UILabel *PolynomialPowerText;
@property (weak, nonatomic) IBOutlet UITextField *PolynomialPowerField;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UILabel *output;


@property (weak, nonatomic) IBOutlet UITextView *pointView;

@property (weak, nonatomic) IBOutlet UILabel *rlabel;


@property AppDelegate *appDelegate;
@end

@implementation ViewController
- (IBAction)tapGesture:(id)sender {
    [self.Xcoordinate resignFirstResponder];
    [self.Ycoordinate resignFirstResponder];
    [self.PolynomialPowerField resignFirstResponder];
    

}
- (IBAction)remove:(id)sender {
    NSString *newPointString=@"";
    NSMutableArray *newPoints = [[NSMutableArray alloc] init];
    if([_appDelegate.points count]>0)
    {
        for(int temp=0; temp<[_appDelegate.points count]-1;temp++)
        {
            [newPoints addObject:_appDelegate.points[temp]];
        }
        _appDelegate.points = newPoints;
    }
    
    for(point *temp in _appDelegate.points)
    {
        double x=temp.x;
        double y=temp.y;
        newPointString = [newPointString stringByAppendingString:[NSString stringWithFormat:@"(%.03f,%.03f)\r",x,y]];

    }
    _appDelegate.pointString=newPointString;
    _pointView.text=newPointString;
}


- (IBAction)changed:(id)sender {
    int currentpower = [(self.PolynomialPowerField.text) intValue];
    if(currentpower>5)
    {
        _PolynomialPowerField.text=@"5";
        currentpower=5;

    }
    if([_appDelegate.points count]-1<currentpower)
    {
        _PolynomialPowerField.text = [NSString stringWithFormat:@"%d",[_appDelegate.points count]-1];
    }
    if(currentpower<1)
        _PolynomialPowerField.text=@"1";

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    
    
    
    _pointView.editable=NO;
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _PolynomialPowerField.text=[NSString stringWithFormat:@"%d",_appDelegate.power];
    _pointView.text=_appDelegate.pointString;
    _rlabel.text=_appDelegate.rsquared;
    _output.text = _appDelegate.finalEquation;
    if([_appDelegate.RegType isEqualToString:@"Polynomial"])
    {
        _RegressionType.selectedSegmentIndex=0;
        self.PolynomialPowerText.enabled = YES;
        self.PolynomialPowerField.enabled = YES;

    }
    if([_appDelegate.RegType isEqualToString:@"Ln"])
    {
        _RegressionType.selectedSegmentIndex=1;
        self.PolynomialPowerText.enabled = NO;
        self.PolynomialPowerField.enabled = NO;

    }
    if([_appDelegate.RegType isEqualToString:@"Power"])
    {
        _RegressionType.selectedSegmentIndex=2;
        self.PolynomialPowerText.enabled = NO;
        self.PolynomialPowerField.enabled = NO;

    }
    if([_appDelegate.RegType isEqualToString:@"Exponential"])
    {
        _RegressionType.selectedSegmentIndex=3;
        self.PolynomialPowerText.enabled = NO;
        self.PolynomialPowerField.enabled = NO;

    }
    for(int temp=0; temp<4; temp++)
        [_RegressionType setEnabled:YES forSegmentAtIndex:temp];
    Boolean yneg=NO;
    Boolean xneg=NO;
    for(int temp=0; temp<[_appDelegate.points count]; temp++)
    {
        point *p = _appDelegate.points[temp];
        if(p.x<=0)
            xneg=YES;
        if(p.y<=0)
            yneg=YES;
    }
    if(xneg)
    {
        [_RegressionType setEnabled:NO forSegmentAtIndex:1];
        [_RegressionType setEnabled:NO forSegmentAtIndex:2];
    }
    if(yneg)
    {
        [_RegressionType setEnabled:NO forSegmentAtIndex:3];
        [_RegressionType setEnabled:NO forSegmentAtIndex:2];
    }

}







- (IBAction)xStart:(id)sender {
    self.Xcoordinate.text=@"";
}
- (IBAction)yStart:(id)sender {
    self.Ycoordinate.text=@"";

}
- (IBAction)polyEdit:(id)sender {
    self.PolynomialPowerField.text=@"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)choice:(id)sender {
    switch (self.RegressionType.selectedSegmentIndex)
    {
        
        case 0:
            self.PolynomialPowerText.enabled = YES;
            self.PolynomialPowerField.enabled = YES;
            _appDelegate.RegType = @"Polynomial";
            
            break;
        case 1:
            self.PolynomialPowerText.enabled = NO;
            self.PolynomialPowerField.enabled = NO;
            _appDelegate.RegType = @"Ln";
            break;
        case 2:
            self.PolynomialPowerText.enabled = NO;
            self.PolynomialPowerField.enabled = NO;
            _appDelegate.RegType = @"Power";
            break;
        case 3:
            self.PolynomialPowerText.enabled = NO;
            self.PolynomialPowerField.enabled = NO;
            _appDelegate.RegType = @"Exponential";
            break;
    }
}
- (IBAction)pointAdd:(id)sender {
    double x = [(self.Xcoordinate.text) doubleValue];
    double y = [(self.Ycoordinate.text) doubleValue];
    point *temp = [[point alloc] init];
    [temp setX:x];
    [temp setY:y];
    Boolean isEntered = NO;
    for(int temp=0; temp<[_appDelegate.points count]; temp++)
    {
        point *p = _appDelegate.points[temp];
        if(p.x==x) //&& p.y==y) took this part so that no duplicate x values can exist
        {
            isEntered=true;
        }
    }
    if(!isEntered)
    {
        [_appDelegate.points addObject:temp];
        NSString *str = [NSString stringWithFormat:@"(%.03f,%.03f)\r",x, y];
        _appDelegate.pointString = [_appDelegate.pointString stringByAppendingString: str];
        _pointView.text=_appDelegate.pointString;
    }
    for(int temp=0; temp<4; temp++)
        [_RegressionType setEnabled:YES forSegmentAtIndex:temp];
    
   
    Boolean yneg=NO;
    Boolean xneg=NO;
    for(int temp=0; temp<[_appDelegate.points count]; temp++)
    {
        point *p = _appDelegate.points[temp];
        if(p.x<=0)
            xneg=YES;
        if(p.y<=0)
            yneg=YES;
    }
    if(xneg)
    {
        [_RegressionType setEnabled:NO forSegmentAtIndex:1];
        [_RegressionType setEnabled:NO forSegmentAtIndex:2];
    }
    if(yneg)
    {
        [_RegressionType setEnabled:NO forSegmentAtIndex:3];
        [_RegressionType setEnabled:NO forSegmentAtIndex:2];
    }
    
    
   
    
    self.Xcoordinate.text=@"";
    self.Ycoordinate.text=@"";

}
- (IBAction)clearPoints:(id)sender {
    [_appDelegate.points removeAllObjects];
    _appDelegate.pointString=@"";
    _pointView.text=_appDelegate.pointString;
    
    
    _appDelegate.RegType = @"Polynomial";
    _appDelegate.pointString = @"";
    _appDelegate.points = [[NSMutableArray alloc] init];
    _appDelegate.newpoints =[[NSMutableArray alloc] init];
    
    _appDelegate.finalEquation = @"Equation will go here when complete";
    _appDelegate.calcRegType = @"";
    _appDelegate.coeff = [[NSMutableArray alloc] init];
    _appDelegate.power=0;
    _appDelegate.rsquared =@"r^2 Value";
    _rlabel.text=_appDelegate.rsquared;
    _output.text = _appDelegate.finalEquation;
    _appDelegate.EquationForThirdView =@"Equation will go here";
    _appDelegate.ScrollEquationForThirdView =@"";

    for(int temp=0; temp<4; temp++)
        [_RegressionType setEnabled:YES forSegmentAtIndex:temp];
}
- (IBAction)clearPoints2:(id)sender {
    [_appDelegate.points removeAllObjects];
    _appDelegate.pointString=@"";
    _pointView.text=_appDelegate.pointString;
    
    
    _appDelegate.RegType = @"Polynomial";
    _appDelegate.pointString = @"";
    _appDelegate.points = [[NSMutableArray alloc] init];
    _appDelegate.newpoints =[[NSMutableArray alloc] init];
    
    _appDelegate.finalEquation = @"Equation will go here when complete";
    _appDelegate.calcRegType = @"";
    _appDelegate.coeff = [[NSMutableArray alloc] init];
    _appDelegate.power=0;
    _appDelegate.rsquared =@"r^2 Value";
    _rlabel.text=_appDelegate.rsquared;
    _output.text = _appDelegate.finalEquation;
    _appDelegate.EquationForThirdView =@"Equation will go here";
    _appDelegate.ScrollEquationForThirdView =@"";
    
    for(int temp=0; temp<4; temp++)
        [_RegressionType setEnabled:YES forSegmentAtIndex:temp];
}
- (IBAction)addPoints2:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Regression Calc" message:@"Enter Point" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add",nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:1].secureTextEntry = NO; //Will disable secure text entry for second textfield.
    [alert textFieldAtIndex:0].placeholder = @"x value"; //Will replace "Username"
    [alert textFieldAtIndex:1].placeholder = @"y value"; //Will replace "Password"
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [[alert textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [alert show];
    
    
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( 0 == buttonIndex ){ //cancel button
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else if ( 1 == buttonIndex ){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        double x = [[alertView textFieldAtIndex:0].text doubleValue];
        double y = [[alertView textFieldAtIndex:1].text doubleValue];

        point *temp = [[point alloc] init];
        [temp setX:x];
        [temp setY:y];
        Boolean isEntered = NO;
        for(int temp=0; temp<[_appDelegate.points count]; temp++)
        {
            point *p = _appDelegate.points[temp];
            if(p.x==x) //&& p.y==y) took this part so that no duplicate x values can exist
            {
                isEntered=true;
            }
        }
        if(!isEntered)
        {
            [_appDelegate.points addObject:temp];
            NSString *str = [NSString stringWithFormat:@"(%.03f,%.03f)\r",x, y];
            _appDelegate.pointString = [_appDelegate.pointString stringByAppendingString: str];
            _pointView.text=_appDelegate.pointString;
        }
        for(int temp=0; temp<4; temp++)
            [_RegressionType setEnabled:YES forSegmentAtIndex:temp];
        
        
        Boolean yneg=NO;
        Boolean xneg=NO;
        for(int temp=0; temp<[_appDelegate.points count]; temp++)
        {
            point *p = _appDelegate.points[temp];
            if(p.x<=0)
                xneg=YES;
            if(p.y<=0)
                yneg=YES;
        }
        if(xneg)
        {
            [_RegressionType setEnabled:NO forSegmentAtIndex:1];
            [_RegressionType setEnabled:NO forSegmentAtIndex:2];
        }
        if(yneg)
        {
            [_RegressionType setEnabled:NO forSegmentAtIndex:3];
            [_RegressionType setEnabled:NO forSegmentAtIndex:2];
        }
        
        
    }
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        [_appDelegate.points removeAllObjects];
        _appDelegate.pointString=@"";
        _pointView.text=_appDelegate.pointString;
        
        _appDelegate.RegType = @"Polynomial";
        _appDelegate.pointString = @"";
        _appDelegate.points = [[NSMutableArray alloc] init];
        _appDelegate.newpoints =[[NSMutableArray alloc] init];
        
        _appDelegate.finalEquation = @"Equation will go here when complete";
        _appDelegate.calcRegType = @"";
        _appDelegate.coeff = [[NSMutableArray alloc] init];
        _appDelegate.power=0;
        _appDelegate.rsquared =@"r^2 Value";
        _rlabel.text=_appDelegate.rsquared;
        _output.text = _appDelegate.finalEquation;
        _appDelegate.EquationForThirdView =@"Equation will go here";
        _appDelegate.ScrollEquationForThirdView =@"";

        for(int temp=0; temp<4; temp++)
            [_RegressionType setEnabled:YES forSegmentAtIndex:temp];
    }
}


- (IBAction)CalculateButton:(id)sender {
    int currentpower = [(self.PolynomialPowerField.text) intValue];
    /* if(currentpower>5)
     {
     _PolynomialPowerField.text=@"5";
     currentpower=5;
     
     } Taking out code in order to allow regressions >5th power*/
    if([_appDelegate.points count]-1<currentpower)
    {
        _PolynomialPowerField.text = [NSString stringWithFormat:@"%d",[_appDelegate.points count]-1];
    }
    if(currentpower<1)
        _PolynomialPowerField.text=@"1";
    if([_appDelegate.points count]>0)
    {
    if([_appDelegate.RegType isEqualToString: @"Polynomial"])
    {
        int pwr = [(self.PolynomialPowerField.text) intValue];
        double A[[_appDelegate.points count]*(pwr+1)];
        double ATrans[(pwr+1)*[_appDelegate.points count]];
        double ATrans2[pwr+1][[_appDelegate.points count]];
        double bvec[[_appDelegate.points count]*1];
        int m1 = pwr+1;
        int n1 = pwr+1;
        int k1 = [_appDelegate.points count];
        
        double invATransA[pwr+1][pwr+1];
       
        
        double ATransA[(pwr+1)*(pwr+1)];
        for(int temp=0; temp<(pwr+1)*(pwr+1); temp++)
        {
            ATransA[temp]=0;
        }
        
        double ATransb[(pwr+1)*1];
        for(int temp=0; temp<pwr+1; temp++)
        {
            ATransb[temp]=0;
        }
        if(pwr>=1  /*&& pwr<=5*/ && [_appDelegate.points count]>=pwr+1)
        {
            
            
            
            for(int a=0; a<[_appDelegate.points count]; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    point *p = _appDelegate.points[a];
                    double dx = p.x;
                    A[a*(pwr+1)+b]=pow(dx,b);
                    double dy = p.y;
                    bvec[a]=dy;
                }
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<[_appDelegate.points count]; b++)
                {
                    point *p = _appDelegate.points[b];
                    double dx = p.x;
                    ATrans[a*([_appDelegate.points count])+b]=pow(dx,a);
                    ATrans2[a][b]=pow(dx,a);

                }
            }
           
            cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m1, n1, k1, 1, ATrans, k1, A, n1, 1, ATransA, m1);
           
            for(int a=0; a<pwr+1; a++)
            {
                for(int c=0; c<[_appDelegate.points count]; c++)
                {
                    ATransb[a]=ATransb[a]+ATrans2[a][c]*bvec[c];
                }
            }
            double ATransA2[pwr+1][pwr+1];
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    ATransA2[a][b]=ATransA[a*(pwr+1)+b];
                }
            }
            double rrefMat[pwr+1][2*pwr+2];
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<2*pwr+2; b++)
                {
                    rrefMat[a][b]=0;
                }
            }

            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    rrefMat[a][b]=ATransA2[a][b];
                    rrefMat[a][a+pwr+1]=1;
                }
            }
           
            for(int lead=0; lead<pwr+1; lead++)
            {
                double leadingterm = rrefMat[lead][lead];
                for(int a=lead; a<pwr*2+2; a++)
                {
                    rrefMat[lead][a]=rrefMat[lead][a]/leadingterm;
                }
                for(int b=lead+1; b<pwr+1; b++)
                {
                    double newLead = rrefMat[b][lead];
                    for(int c=0; c<pwr*2+2; c++)
                    {
                        rrefMat[b][c]=rrefMat[b][c]-newLead*rrefMat[lead][c];
                    }
                }
            }
            for(int a=0; a<pwr; a++)
            {
                for(int b=a+1; b<pwr+1; b++)
                {
                    double leadingterm = rrefMat[a][b];
                    for(int c=0; c<pwr*2+2; c++)
                    {
                        rrefMat[a][c]=rrefMat[a][c]-leadingterm*rrefMat[b][c];
                    }
                }
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    invATransA[a][b]=rrefMat[a][b+pwr+1];
                }
            }
            double answer[pwr+1];
            for(int a=0; a<pwr+1;a++)
            {
                answer[a]=0;
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int c=0; c<pwr+1; c++)
                {
                    answer[a]=answer[a]+invATransA[a][c]*ATransb[c];
                }
            }
            
            
            
            NSString *myString = @"y=";
            NSString *str=@"";
            if((round(answer[0]*1000000)/1000000)!=0)
            {
                str = [NSString stringWithFormat:@"%.02f",answer[0]];
                myString = [myString stringByAppendingString: str];
            }
            
            if((round(answer[1]*1000000)/1000000)<0)
            {
                str = [NSString stringWithFormat:@"%.02fx",answer[1]];
                myString = [myString stringByAppendingString: str];
            }
            if((round(answer[1]*1000000)/1000000)>0 && [myString isEqualToString:@"y="])
            {
                str = [NSString stringWithFormat:@"%.02fx",answer[1]];
                myString = [myString stringByAppendingString: str];
            }
            else if((round(answer[1]*10000000)/100000)>0)
            {
                str = [NSString stringWithFormat:@"+%.02fx",answer[1]];
                myString = [myString stringByAppendingString: str];
            }
            
            
            for(int coefficient=2; coefficient<=pwr; coefficient++)
            {
                if((round(answer[coefficient]*1000000)/1000000)>0 && [myString isEqualToString:@"y="])
                {
                    str = [NSString stringWithFormat:@"%.02fx^%d",answer[coefficient], coefficient];
                    
                    myString = [myString stringByAppendingString: str];
                }
                    
                else if ((round(answer[coefficient]*1000000)/1000000)>0)
                {
                    str = [NSString stringWithFormat:@"+%.02fx^%d",answer[coefficient], coefficient];
                    
                    myString = [myString stringByAppendingString: str];
                    
                }
                if((round(answer[coefficient]*1000000)/1000000)<0)
                {
                   str = [NSString stringWithFormat:@"%.02fx^%d",answer[coefficient], coefficient];
                    
                    myString = [myString stringByAppendingString: str];
                }
                
                
             
            }
            if([myString isEqualToString:@"y="])
            {
                myString = @"y=0";

            }
            if(pwr>5)
            {
                myString = @"Equation too long to display";
            }
            
            self.output.text = myString;
           
            _appDelegate.finalEquation = myString;
            _appDelegate.calcRegType = @"Polynomial";
            _appDelegate.power=pwr;
            [_appDelegate.coeff removeAllObjects];
            for(int a=0; a<pwr+1; a++)
            {
                [_appDelegate.coeff addObject:[NSString stringWithFormat:@"%f",answer[a]]];
            }
            
            _appDelegate.newpoints=_appDelegate.points;
            
            
            
            double yhat=0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                yhat += p.y;
            }
            yhat/=[_appDelegate.points count];
            
            double yvariance=0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                yvariance+=pow((p.y-yhat),2);
            }
            double top = 0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                double yval=0;
                for(int temp2=0; temp2<pwr+1; temp2++)
                {
                    yval+=answer[temp2]*pow(p.x,temp2);
                }
                top+=pow((p.y-yval),2);
            }
            
            double rsqrd = 1-top/yvariance;
            NSString *r = [NSString stringWithFormat:@"r^2: %f",rsqrd];
            if([myString isEqualToString:@"y=0"])
            {
                r=[NSString stringWithFormat:@"r^2: %f",1.0];
            }
            self.rlabel.text=r;
            _appDelegate.rsquared=r;
            
            if(pwr==1)
            {
                _appDelegate.EquationForThirdView=@"y=a+bx";
            }
            if(pwr==2)
            {
                _appDelegate.EquationForThirdView=@"y=a+bx+cx^2";

            }
            
            if(pwr==3)
            {
                _appDelegate.EquationForThirdView=@"y=a+bx+cx^2+dx^3";

            }
            
            if(pwr>3)
            {
                _appDelegate.EquationForThirdView=@"y=a+bx+cx^2+dx^3+...";

            }
            NSString *coeff=@"";
            for (char c = 'a'; c <= 'a'+pwr; c++)
            {
                int temp=c-'a';
                coeff=[coeff stringByAppendingString:[NSString stringWithFormat:@"%c = %.09f\r",c,answer[temp]]];
            }
            
            _appDelegate.ScrollEquationForThirdView=coeff;
            
        }
        else
        {
            //self.output.text = @"Error";
        }
        
    }
    else if([_appDelegate.RegType isEqualToString:@"Ln"])
    {
        int pwr = 1;
        double A[[_appDelegate.points count]*(pwr+1)];
        double ATrans[(pwr+1)*[_appDelegate.points count]];
        double ATrans2[pwr+1][[_appDelegate.points count]];
        double bvec[[_appDelegate.points count]*1];
        int m1 = pwr+1;
        int n1 = pwr+1;
        int k1 = [_appDelegate.points count];
        
        double invATransA[pwr+1][pwr+1];
        
        
        double ATransA[(pwr+1)*(pwr+1)];
        for(int temp=0; temp<(pwr+1)*(pwr+1); temp++)
        {
            ATransA[temp]=0;
        }
        
        double ATransb[(pwr+1)*1];
        for(int temp=0; temp<pwr+1; temp++)
        {
            ATransb[temp]=0;
        }
        if(pwr>=1 && pwr<=5)
        {
            
            
            for(int a=0; a<[_appDelegate.points count]; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    point *p = _appDelegate.points[a];
                    double dx = log(p.x);
                    A[a*(pwr+1)+b]=pow(dx,b);
                    double dy = p.y;
                    bvec[a]=dy;
                }
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<[_appDelegate.points count]; b++)
                {
                    point *p = _appDelegate.points[b];
                    double dx = log(p.x);
                    ATrans[a*([_appDelegate.points count])+b]=pow(dx,a);
                    ATrans2[a][b]=pow(dx,a);
                    
                }
            }
            
            cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m1, n1, k1, 1, ATrans, k1, A, n1, 1, ATransA, m1);
            
            for(int a=0; a<pwr+1; a++)
            {
                for(int c=0; c<[_appDelegate.points count]; c++)
                {
                    ATransb[a]=ATransb[a]+ATrans2[a][c]*bvec[c];
                }
            }
            double ATransA2[pwr+1][pwr+1];
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    ATransA2[a][b]=ATransA[a*(pwr+1)+b];
                }
            }
            double rrefMat[pwr+1][2*pwr+2];
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<2*pwr+2; b++)
                {
                    rrefMat[a][b]=0;
                }
            }
            
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    rrefMat[a][b]=ATransA2[a][b];
                    rrefMat[a][a+pwr+1]=1;
                }
            }
            
            for(int lead=0; lead<pwr+1; lead++)
            {
                double leadingterm = rrefMat[lead][lead];
                for(int a=lead; a<pwr*2+2; a++)
                {
                    rrefMat[lead][a]=rrefMat[lead][a]/leadingterm;
                }
                for(int b=lead+1; b<pwr+1; b++)
                {
                    double newLead = rrefMat[b][lead];
                    for(int c=0; c<pwr*2+2; c++)
                    {
                        rrefMat[b][c]=rrefMat[b][c]-newLead*rrefMat[lead][c];
                    }
                }
            }
            for(int a=0; a<pwr; a++)
            {
                for(int b=a+1; b<pwr+1; b++)
                {
                    double leadingterm = rrefMat[a][b];
                    for(int c=0; c<pwr*2+2; c++)
                    {
                        rrefMat[a][c]=rrefMat[a][c]-leadingterm*rrefMat[b][c];
                    }
                }
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    invATransA[a][b]=rrefMat[a][b+pwr+1];
                }
            }
            double answer[pwr+1];
            for(int a=0; a<pwr+1;a++)
            {
                answer[a]=0;
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int c=0; c<pwr+1; c++)
                {
                    answer[a]=answer[a]+invATransA[a][c]*ATransb[c];
                }
            }
            
            
            NSString *myString = @"y=";
            NSString *str=@"";
            if((round(answer[0]*10000)/10000)!=0)
            {
                str = [NSString stringWithFormat:@"%.02f",answer[0]];
                myString = [myString stringByAppendingString: str];
            }
            if(answer[1]>0 && [myString isEqualToString:@"y="])
            {
                str = [NSString stringWithFormat:@"%.02flnx",answer[1]];
                myString = [myString stringByAppendingString: str];
            }
            else if(answer[1]>0)
            {
                str = [NSString stringWithFormat:@"+%.02flnx",answer[1]];
                myString = [myString stringByAppendingString: str];
            }
            if(answer[1]<0)
            {
                str = [NSString stringWithFormat:@"%.02flnx",answer[1]];
                myString = [myString stringByAppendingString: str];
            }
            
            
          
            
            
            
            
            self.output.text = myString;
            _appDelegate.finalEquation = myString;
            _appDelegate.calcRegType = @"Ln";
            _appDelegate.power=pwr;
            [_appDelegate.coeff removeAllObjects];
            for(int a=0; a<pwr+1; a++)
            {
                [_appDelegate.coeff addObject:[NSString stringWithFormat:@"%f",answer[a]]];
            }
            _appDelegate.newpoints=_appDelegate.points;
            
            double yhat=0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                yhat += p.y;
            }
            yhat/=[_appDelegate.points count];
            
            double yvariance=0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                yvariance+=pow((p.y-yhat),2);
            }
            double top = 0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                double yval=answer[0]+answer[1]*log(p.x);
                top+=pow((p.y-yval),2);
            }
            
            double rsqrd = 1-top/yvariance;
            NSString *r = [NSString stringWithFormat:@"r^2: %f",rsqrd];
            self.rlabel.text=r;
            _appDelegate.rsquared=r;
            
            _appDelegate.EquationForThirdView=@"y=a+blnx";

            _appDelegate.ScrollEquationForThirdView=[NSString stringWithFormat:@"a = %.09f\rb = %.09f",answer[0],answer[1]];



        }
        else
        {
           // self.output.text = @"Error";
        }
     
    }
    else if([_appDelegate.RegType isEqualToString:@"Power"])
    {
        int pwr = 1;
        double A[[_appDelegate.points count]*(pwr+1)];
        double ATrans[(pwr+1)*[_appDelegate.points count]];
        double ATrans2[pwr+1][[_appDelegate.points count]];
        double bvec[[_appDelegate.points count]*1];
        int m1 = pwr+1;
        int n1 = pwr+1;
        int k1 = [_appDelegate.points count];
        
        double invATransA[pwr+1][pwr+1];
        
        
        double ATransA[(pwr+1)*(pwr+1)];
        for(int temp=0; temp<(pwr+1)*(pwr+1); temp++)
        {
            ATransA[temp]=0;
        }
        
        double ATransb[(pwr+1)*1];
        for(int temp=0; temp<pwr+1; temp++)
        {
            ATransb[temp]=0;
        }
        if(pwr>=1 && pwr<=5)
        {
            
            
            for(int a=0; a<[_appDelegate.points count]; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    point *p = _appDelegate.points[a];
                    double dx = log(p.x);
                    A[a*(pwr+1)+b]=pow(dx,b);
                    double dy = log(p.y);
                    bvec[a]=dy;
                }
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<[_appDelegate.points count]; b++)
                {
                    point *p = _appDelegate.points[b];
                    double dx = log(p.x);
                    ATrans[a*([_appDelegate.points count])+b]=pow(dx,a);
                    ATrans2[a][b]=pow(dx,a);
                    
                }
            }
            
            cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m1, n1, k1, 1, ATrans, k1, A, n1, 1, ATransA, m1);
            
            for(int a=0; a<pwr+1; a++)
            {
                for(int c=0; c<[_appDelegate.points count]; c++)
                {
                    ATransb[a]=ATransb[a]+ATrans2[a][c]*bvec[c];
                }
            }
            double ATransA2[pwr+1][pwr+1];
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    ATransA2[a][b]=ATransA[a*(pwr+1)+b];
                }
            }
            double rrefMat[pwr+1][2*pwr+2];
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<2*pwr+2; b++)
                {
                    rrefMat[a][b]=0;
                }
            }
            
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    rrefMat[a][b]=ATransA2[a][b];
                    rrefMat[a][a+pwr+1]=1;
                }
            }
            
            for(int lead=0; lead<pwr+1; lead++)
            {
                double leadingterm = rrefMat[lead][lead];
                for(int a=lead; a<pwr*2+2; a++)
                {
                    rrefMat[lead][a]=rrefMat[lead][a]/leadingterm;
                }
                for(int b=lead+1; b<pwr+1; b++)
                {
                    double newLead = rrefMat[b][lead];
                    for(int c=0; c<pwr*2+2; c++)
                    {
                        rrefMat[b][c]=rrefMat[b][c]-newLead*rrefMat[lead][c];
                    }
                }
            }
            for(int a=0; a<pwr; a++)
            {
                for(int b=a+1; b<pwr+1; b++)
                {
                    double leadingterm = rrefMat[a][b];
                    for(int c=0; c<pwr*2+2; c++)
                    {
                        rrefMat[a][c]=rrefMat[a][c]-leadingterm*rrefMat[b][c];
                    }
                }
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    invATransA[a][b]=rrefMat[a][b+pwr+1];
                }
            }
            double answer[pwr+1];
            for(int a=0; a<pwr+1;a++)
            {
                answer[a]=0;
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int c=0; c<pwr+1; c++)
                {
                    answer[a]=answer[a]+invATransA[a][c]*ATransb[c];
                }
            }
            
            
            
            NSString *myString = [NSString stringWithFormat: @"y=%.02f*x^%.02f",pow(M_E,answer[0]),answer[1]];
            self.output.text = myString;
            _appDelegate.finalEquation = myString;
            _appDelegate.calcRegType = @"Power";
            _appDelegate.power=pwr;
            [_appDelegate.coeff removeAllObjects];
            for(int a=0; a<pwr+1; a++)
            {
                [_appDelegate.coeff addObject:[NSString stringWithFormat:@"%f",answer[a]]];
            }
            _appDelegate.newpoints=_appDelegate.points;
          
            
            double yhat=0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                yhat += log(p.y);
            }
            yhat/=[_appDelegate.points count];
            
            double yvariance=0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                yvariance+=pow((log(p.y)-yhat),2);
            }
            double top = 0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                double yval=answer[0]+answer[1]*log(p.x);
                top+=pow((log(p.y)-yval),2);
            }
            
            double rsqrd = 1-top/yvariance;
            NSString *r = [NSString stringWithFormat:@"r^2: %f",rsqrd];
            self.rlabel.text=r;
            _appDelegate.rsquared=r;
            
            _appDelegate.EquationForThirdView=@"y=a*x^b";
            _appDelegate.ScrollEquationForThirdView=[NSString stringWithFormat:@"a = %.09f\rb = %.09f",pow(M_E,answer[0]),answer[1]];

        }
        else
        {
         //   self.output.text = @"Error";
        }
        
    }
    else if([_appDelegate.RegType isEqualToString:@"Exponential"])
    {
        int pwr = 1;
        double A[[_appDelegate.points count]*(pwr+1)];
        double ATrans[(pwr+1)*[_appDelegate.points count]];
        double ATrans2[pwr+1][[_appDelegate.points count]];
        double bvec[[_appDelegate.points count]*1];
        int m1 = pwr+1;
        int n1 = pwr+1;
        int k1 = [_appDelegate.points count];
        
        double invATransA[pwr+1][pwr+1];
        
        
        double ATransA[(pwr+1)*(pwr+1)];
        for(int temp=0; temp<(pwr+1)*(pwr+1); temp++)
        {
            ATransA[temp]=0;
        }
        
        double ATransb[(pwr+1)*1];
        for(int temp=0; temp<pwr+1; temp++)
        {
            ATransb[temp]=0;
        }
        if(pwr>=1 && pwr<=5)
        {
            
            
            for(int a=0; a<[_appDelegate.points count]; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    point *p = _appDelegate.points[a];
                    double dx = p.x;
                    A[a*(pwr+1)+b]=pow(dx,b);
                    double dy = log(p.y);
                    bvec[a]=dy;
                }
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<[_appDelegate.points count]; b++)
                {
                    point *p = _appDelegate.points[b];
                    double dx = p.x;
                    ATrans[a*([_appDelegate.points count])+b]=pow(dx,a);
                    ATrans2[a][b]=pow(dx,a);
                    
                }
            }
            
            cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m1, n1, k1, 1, ATrans, k1, A, n1, 1, ATransA, m1);
            
            for(int a=0; a<pwr+1; a++)
            {
                for(int c=0; c<[_appDelegate.points count]; c++)
                {
                    ATransb[a]=ATransb[a]+ATrans2[a][c]*bvec[c];
                }
            }
            double ATransA2[pwr+1][pwr+1];
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    ATransA2[a][b]=ATransA[a*(pwr+1)+b];
                }
            }
            double rrefMat[pwr+1][2*pwr+2];
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<2*pwr+2; b++)
                {
                    rrefMat[a][b]=0;
                }
            }
            
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    rrefMat[a][b]=ATransA2[a][b];
                    rrefMat[a][a+pwr+1]=1;
                }
            }
            
            for(int lead=0; lead<pwr+1; lead++)
            {
                double leadingterm = rrefMat[lead][lead];
                for(int a=lead; a<pwr*2+2; a++)
                {
                    rrefMat[lead][a]=rrefMat[lead][a]/leadingterm;
                }
                for(int b=lead+1; b<pwr+1; b++)
                {
                    double newLead = rrefMat[b][lead];
                    for(int c=0; c<pwr*2+2; c++)
                    {
                        rrefMat[b][c]=rrefMat[b][c]-newLead*rrefMat[lead][c];
                    }
                }
            }
            for(int a=0; a<pwr; a++)
            {
                for(int b=a+1; b<pwr+1; b++)
                {
                    double leadingterm = rrefMat[a][b];
                    for(int c=0; c<pwr*2+2; c++)
                    {
                        rrefMat[a][c]=rrefMat[a][c]-leadingterm*rrefMat[b][c];
                    }
                }
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int b=0; b<pwr+1; b++)
                {
                    invATransA[a][b]=rrefMat[a][b+pwr+1];
                }
            }
            double answer[pwr+1];
            for(int a=0; a<pwr+1;a++)
            {
                answer[a]=0;
            }
            for(int a=0; a<pwr+1; a++)
            {
                for(int c=0; c<pwr+1; c++)
                {
                    answer[a]=answer[a]+invATransA[a][c]*ATransb[c];
                }
            }
            
            
            
            NSString *myString = [NSString stringWithFormat: @"y=%.02f*%.02f^x",pow(M_E,answer[0]),pow(M_E,answer[1])];
            self.output.text = myString;
            
            _appDelegate.finalEquation = myString;
            _appDelegate.calcRegType = @"Exponential";
            _appDelegate.power=pwr;
            [_appDelegate.coeff removeAllObjects];
            for(int a=0; a<pwr+1; a++)
            {
                [_appDelegate.coeff addObject:[NSString stringWithFormat:@"%f",answer[a]]];
            }
            _appDelegate.newpoints=_appDelegate.points;
            double yhat=0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                yhat += log(p.y);
            }
            yhat/=[_appDelegate.points count];
            
            double yvariance=0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                yvariance+=pow((log(p.y)-yhat),2);
            }
            double top = 0;
            for(int temp=0; temp<[_appDelegate.points count]; temp++)
            {
                point *p = _appDelegate.points[temp];
                double yval=answer[0]+answer[1]*p.x;
                top+=pow((log(p.y)-yval),2);
            }
            
            double rsqrd = 1-top/yvariance;
            NSString *r = [NSString stringWithFormat:@"r^2: %f",rsqrd];
            self.rlabel.text=r;
            _appDelegate.rsquared=r;
            
            _appDelegate.EquationForThirdView=@"y=a*b^x";
            _appDelegate.ScrollEquationForThirdView=[NSString stringWithFormat:@"a = %.09f\rb = %.09f",pow(M_E,answer[0]),pow(M_E,answer[1])];

        }
        else
        {
           // self.output.text = @"Error";
        }
        

    }
    }
    
}

@end



