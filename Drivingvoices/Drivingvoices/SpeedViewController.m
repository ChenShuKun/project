//
//  SpeedViewController.m
//  Drivingvoices
//
//  Created by ChenShuKun on 2019/8/12.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "SpeedViewController.h"
#import <CoreLocation/CoreLocation.h>      //添加定位服务头文件（不可缺少）

#define RGBColor(r,g,b) [UIColor colorWithRed:r green:g  blue:b  alpha:1]

@interface SpeedViewController ()<CLLocationManagerDelegate>{//添加代理协议 CLLocationManagerDelegate
    CLLocationManager *_locationManager;//定位服务管理类
    CGFloat aggregateDistance;
    CGPoint centers;
}
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (assign,nonatomic ) double speed;

@property (nonatomic, strong) CLLocation *lastAccurateLocation;
@end

@implementation SpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeLocationService];
    
    
//    [self initSubViews];
}



- (void)initSubViews {
    
    CGFloat rad = self.view.frame.size.height - 100;
    centers = CGPointMake(self.view.frame.size.width /2, self.view.frame.size.height -20);
    UIBezierPath *cicrle     = [UIBezierPath bezierPathWithArcCenter:centers
                                                              radius:rad
                                                          startAngle:- M_PI
                                                            endAngle: 0
                                                           clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth     = 5.f;
    shapeLayer.fillColor     = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor   = [UIColor redColor].CGColor;//RGBColor(185,243,110).CGColor;
    shapeLayer.path          = cicrle.CGPath;
    
    [self.view.layer addSublayer:shapeLayer];
 
    CGFloat perAngle = M_PI / 50;
    //我们需要计算出每段弧线的起始角度和结束角度
    //这里我们从- M_PI 开始，我们需要理解与明白的是我们画的弧线与内侧弧线是同一个圆心
    for (int i = 0; i < 51; i++) {

        CGFloat startAngel = (-M_PI + perAngle * i);
        CGFloat endAngel   = startAngel + perAngle/5;

        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:centers radius:rad + 20 startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];

        if (i % 5 == 0) {

            perLayer.strokeColor = [UIColor colorWithRed:0.62 green:0.84 blue:0.93 alpha:1.0].CGColor;
            perLayer.lineWidth   = 10.f;

        }else{
            perLayer.strokeColor = [UIColor colorWithRed:0.22 green:0.66 blue:0.87 alpha:1.0].CGColor;
            perLayer.lineWidth   = 5;

        }

        perLayer.path = tickPath.CGPath;
        [self.view.layer addSublayer:perLayer];

        
        CGFloat textAngel = 90;
        CGPoint point      = [self calculateTextPositonWithArcCenter:centers Angle:textAngel];
        NSString *tickText = [NSString stringWithFormat:@"%d",i * 2];
        
        //默认label的大小14 * 14
        UILabel *text      = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 5, point.y - 5, 14, 14)];
        text.text          = tickText;
        text.font          = [UIFont systemFontOfSize:16];
        text.textColor     = [UIColor colorWithRed:0.54 green:0.78 blue:0.91 alpha:1.0];
        text.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:text];
    }

   
//
}


//默认计算半径135
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel
{
    CGFloat x = 135 * cosf(angel);
    CGFloat y = 135 * sinf(angel);
    
    return CGPointMake(center.x + x, center.y - y);
}




- (void)drawRect:(CGRect)rect
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [@"km/h" drawInRect:CGRectMake(centers.x - 15, centers.y, 60, 20) withAttributes:attributes];
}

//提供一个外部的接口，通过重写setter方法来改变进度
- (void)setSpeed:(double)speed
{
    _speed = speed;
//    progressLayer.strokeEnd = _speed? _speed/100:0;
    self.speedLabel.text = [NSString stringWithFormat:@"%.f",speed];
}



- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    //[_locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];//开始定位之后会不断的执行代理方法更新位置会比较费电所以建议获取完位置即时关闭更新位置服务

}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation

{
    
    if (newLocation.horizontalAccuracy<kCLLocationAccuracyHundredMeters)
    {
        if(self.lastAccurateLocation){
            
            NSTimeInterval dTime = [newLocation.timestamp timeIntervalSinceDate:self.lastAccurateLocation.timestamp]; //计算和上次的时间差
            
            float distance = [newLocation getDistanceFrom:self.lastAccurateLocation]; // 获取相比上次，已经移动的距离
            
            if(distance<1.0f)return;
            
            
            aggregateDistance += distance;
            
            
            
            float speed = 2.23693629*distance / dTime; //计算出速度
            
            NSString *reportString = [NSString stringWithFormat:@"Speed: %0.1f miles per hour. Distance: %0.1f meters.",speed, aggregateDistance];
            
            NSLog(@"---%@",reportString);
            
            self.speedLabel.text = reportString;
        }
        
        self.lastAccurateLocation = newLocation;
        
    }
}





@end
