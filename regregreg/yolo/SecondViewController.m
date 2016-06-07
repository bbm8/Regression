//
//  SecondViewController.m
//  yolo
//
//  Created by Vikram Mullick on 10/18/15.
//  Copyright © 2015 Vikram Mullick. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "point.h"
@interface SecondViewController ()
@property double currentx;
@property double currenty;

@property (weak, nonatomic) IBOutlet UILabel *eqn;
@property NSMutableArray *pointsOnScreen;
@property (weak, nonatomic) IBOutlet UILabel *rsqrd;
@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *removePointButton;

@property UIColor *graphColor;

@end

@implementation SecondViewController

- (IBAction)removeTouch:(id)sender
{
    for(point *p in _appDelegate.points)
    {
        if(p.x==_currentx && p.y==_currenty)
        {
            [_appDelegate.points removeObject:p];
            break;

        }
    }
    NSString *newPointString=@"";
    for(point *temp in _appDelegate.points)
    {
        double x=temp.x;
        double y=temp.y;
        newPointString = [newPointString stringByAppendingString:[NSString stringWithFormat:@"(%.03f,%.03f)\r",x,y]];
        
    }
    _appDelegate.pointString=newPointString;
    [_pointsOnScreen removeAllObjects];

    
    self.reload;
    
}
- (void)reload
{
    _currentx=0;
    _currenty=0;
    _removePointButton.hidden=YES;
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int screenwidth=[[UIScreen mainScreen] bounds].size.width;
    int screenheight=[[UIScreen mainScreen] bounds].size.height-49;
    UIView *myBox  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
    myBox.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myBox];
    [self.view bringSubviewToFront:self.removePointButton];
    
    [self.view bringSubviewToFront:self.eqn];
    [self.view bringSubviewToFront:self.rsqrd];
    
    self.eqn.text = _appDelegate.finalEquation;
    self.rsqrd.text = _appDelegate.rsquared;
    
    
    double max=0;
    for(int temp=0; temp<[_appDelegate.points count]; temp++)
    {
        point *p = _appDelegate.points[temp];
        double x = p.x;
        double y = p.y;
        x=ABS(x);
        y=ABS(y);
        if(x>max)
            max=x;
        if(y>max)
            max=y;
        if(max==0)
            max=1;
        
    }
    if(max==0)
        max=1;
    UIBezierPath *xaxis = [UIBezierPath bezierPath];
    [xaxis moveToPoint:CGPointMake(10.0, screenheight/2)];
    [xaxis addLineToPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width-10,screenheight/2)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [xaxis CGPath];
    shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:shapeLayer]; //xaxis
    
    UIBezierPath *yaxis = [UIBezierPath bezierPath];
    [yaxis moveToPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width/2,screenheight/2-[[UIScreen mainScreen] bounds].size.width/2+10)];
    [yaxis addLineToPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width/2,screenheight/2+[[UIScreen mainScreen] bounds].size.width/2-10)];
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.path = [yaxis CGPath];
    shapeLayer2.strokeColor = [[UIColor blackColor] CGColor];
    shapeLayer2.lineWidth = 3.0;
    shapeLayer2.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:shapeLayer2];//yaxis
    
    
    for(int temp=0; temp<[_appDelegate.points count]; temp++)
    {
        point *p = _appDelegate.points[temp];
        double x = p.x;
        double y = p.y;
        x=x/max*(screenwidth/2-10);
        y=y/max*(screenwidth/2-10);
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(screenwidth/2+x-7, screenheight/2-y-7, 14, 14)] CGPath]];
        
        [self.view.layer addSublayer:circleLayer];
        CAShapeLayer *circleLayer2 = [CAShapeLayer layer];
        [circleLayer2 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(screenwidth/2+x-15, screenheight/2-y-15, 30, 30)] CGPath]];
        point *pp = [[point alloc] init];
        pp.x=p.x;
        pp.y=p.y;
        pp.detectionShapeLayer=circleLayer2;
        pp.shapeLayer=circleLayer;
        pp.xscreen=screenwidth/2+x-7;
        pp.yscreen=screenheight/2-y-7;
        [_pointsOnScreen addObject:pp];
        
    }
    
    
    if(_appDelegate.power>0)
    {
        if([_appDelegate.calcRegType isEqualToString:@"Polynomial"])
        {
            double x=-max;
            double y=0;
            for(int add=0; add<=_appDelegate.power; add++)
            {
                y+=pow(x,add)*[_appDelegate.coeff[add] doubleValue];
            }
            UIBezierPath *graph = [UIBezierPath bezierPath];
            [graph moveToPoint:CGPointMake(-max/max*(screenwidth/2-10)+screenwidth/2,-y/max*(screenwidth/2-10)+screenheight/2)];
            
            for(double temp=-max+max/100; temp<=max; temp+=max/100)
            {
                x=temp;
                y=0;
                for(int add=0; add<=_appDelegate.power; add++)
                {
                    y+=pow(x,add)*[_appDelegate.coeff[add] doubleValue];
                }
                
                
                
                [graph addLineToPoint:CGPointMake(temp/max*(screenwidth/2-10)+screenwidth/2,-y/max*(screenwidth/2-10)+screenheight/2)];
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                shapeLayer.path = [graph CGPath];
                shapeLayer.strokeColor = [_graphColor CGColor];
                shapeLayer.lineWidth = 2.0;
                shapeLayer.fillColor = [[UIColor clearColor] CGColor];
                [self.view.layer addSublayer:shapeLayer];
                
            }
            
            
        }
        if([_appDelegate.calcRegType isEqualToString:@"Ln"])
        {
            double x=.01;
            double y=0;
            y+=[_appDelegate.coeff[1] doubleValue]*log(x)+[_appDelegate.coeff[0] doubleValue];
            UIBezierPath *graph = [UIBezierPath bezierPath];
            [graph moveToPoint:CGPointMake(.01/max*(screenwidth/2-10)+screenwidth/2,-y/max*(screenwidth/2-10)+screenheight/2)];
            
            for(double temp=.01+max/100; temp<=max; temp+=max/100)
            {
                x=temp;
                y=0;
                y+=[_appDelegate.coeff[1] doubleValue]*log(x)+[_appDelegate.coeff[0] doubleValue];
                
                
                [graph addLineToPoint:CGPointMake(temp/max*(screenwidth/2-10)+screenwidth/2,-y/max*(screenwidth/2-10)+screenheight/2)];
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                shapeLayer.path = [graph CGPath];
                shapeLayer.strokeColor = [_graphColor CGColor];
                shapeLayer.lineWidth = 2.0;
                shapeLayer.fillColor = [[UIColor clearColor] CGColor];
                [self.view.layer addSublayer:shapeLayer];
                
            }
            
        }
        if([_appDelegate.calcRegType isEqualToString:@"Power"])
        {
            double x=.01;
            double y=0;
            y+=pow((M_E),[_appDelegate.coeff[0] doubleValue])*pow((x),([_appDelegate.coeff[1] doubleValue]));
            UIBezierPath *graph = [UIBezierPath bezierPath];
            [graph moveToPoint:CGPointMake(.01/max*(screenwidth/2-10)+screenwidth/2,-y/max*(screenwidth/2-10)+screenheight/2)];
            
            for(double temp=.01+max/100; temp<=max; temp+=max/100)
            {
                x=temp;
                y=0;
                y+=pow((M_E),[_appDelegate.coeff[0] doubleValue])*pow((x),([_appDelegate.coeff[1] doubleValue]));
                
                
                [graph addLineToPoint:CGPointMake(temp/max*(screenwidth/2-10)+screenwidth/2,-y/max*(screenwidth/2-10)+screenheight/2)];
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                shapeLayer.path = [graph CGPath];
                shapeLayer.strokeColor = [_graphColor CGColor];
                shapeLayer.lineWidth = 2.0;
                shapeLayer.fillColor = [[UIColor clearColor] CGColor];
                [self.view.layer addSublayer:shapeLayer];
            }
            
        }
        if([_appDelegate.calcRegType isEqualToString:@"Exponential"])
        {
            
            double x=-max;
            double y=0;
            y+=pow((M_E),[_appDelegate.coeff[0] doubleValue])*pow(pow((M_E),[_appDelegate.coeff[1] doubleValue]),x);
            UIBezierPath *graph = [UIBezierPath bezierPath];
            [graph moveToPoint:CGPointMake(-max/max*(screenwidth/2-10)+screenwidth/2,-y/max*(screenwidth/2-10)+screenheight/2)];
            
            for(double temp=-max+max/100; temp<=max; temp+=max/100)
            {
                x=temp;
                y=0;
                y+=pow((M_E),[_appDelegate.coeff[0] doubleValue])*pow(pow((M_E),[_appDelegate.coeff[1] doubleValue]),x);
                
                
                [graph addLineToPoint:CGPointMake(temp/max*(screenwidth/2-10)+screenwidth/2,-y/max*(screenwidth/2-10)+screenheight/2)];
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                shapeLayer.path = [graph CGPath];
                shapeLayer.strokeColor = [_graphColor CGColor];
                shapeLayer.lineWidth = 2.0;
                shapeLayer.fillColor = [[UIColor clearColor] CGColor];
                [self.view.layer addSublayer:shapeLayer];
            }
            
            
            
            
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInView:self.view];
        Boolean isPoint = NO;
        for (point *p in _pointsOnScreen)
        {
            CAShapeLayer *detectionShapeLayer = p.detectionShapeLayer;

            CAShapeLayer *shapeLayer = p.shapeLayer;
            if (CGPathContainsPoint(detectionShapeLayer.path, 0, touchLocation, YES))
            {
                _currentx=p.x;
                _currenty=p.y;
                p.shapeLayer.fillColor=[_graphColor CGColor];
                _rsqrd.text = [NSString stringWithFormat:@"(%.03f,%.03f)",p.x,p.y];
                isPoint=YES;
            }
            
            
    
        }
        if(isPoint)
        {
            _removePointButton.hidden=NO;

            for (point *p in _pointsOnScreen)
            {
                 CAShapeLayer *detectionShapeLayer = p.detectionShapeLayer;
                CAShapeLayer *shapeLayer = p.shapeLayer;
                if (!CGPathContainsPoint(detectionShapeLayer.path, 0, touchLocation, YES))
                {
                    p.shapeLayer.fillColor=[[UIColor blackColor] CGColor];
                }
                
            }
            
        }
        if(!isPoint)
        {
           
            _rsqrd.text = _appDelegate.rsquared;
            for (point *p in _pointsOnScreen)
            {
                
                CAShapeLayer *shapeLayer = p.shapeLayer;
                p.shapeLayer.fillColor=[[UIColor blackColor] CGColor];
                _removePointButton.hidden=YES;

                
                
            }
        }
        
            
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_pointsOnScreen removeAllObjects];

}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.reload;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pointsOnScreen = [[NSMutableArray alloc] init];
  
    NSMutableArray *colors = [NSMutableArray array];
    
    float INCREMENT = 0.05;
    for (float hue = 0.0; hue < 1.0; hue += INCREMENT) {
        UIColor *color = [UIColor colorWithHue:hue
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colors addObject:color];
    }
    
    UIColor *col = [colors objectAtIndex:arc4random()%[colors count]];
    _graphColor=col;



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
