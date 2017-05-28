//
//  CCSSlipLineChart.m
//  CocoaChartsSample
//
//  Created by limc on 12/6/13.
//  Copyright (c) 2013 limc. All rights reserved.
//

#import "CCSSlipLineChart.h"
#import "CCSTitledLine.h"
#import "CCSLineData.h"

@interface CCSSlipLineChart () {
    float _startDistance1;
    float _minDistance1;
    int _flag;
    float _firstX;
}
@end

@implementation CCSSlipLineChart
@synthesize displayNumber = _displayNumber;
@synthesize displayFrom = _displayFrom;
@synthesize minDisplayNumber = _minDisplayNumber;
@synthesize zoomBaseLine = _zoomBaseLine;
@synthesize noneDisplayValue = _noneDisplayValue;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _startDistance1 = 0;
        _minDistance1 = 8;
        _flag = 1;
        _firstX = 0;
    }
    return self;
}

- (void)initProperty {
    //初始化父类的熟悉
    [super initProperty];
    
    self.displayFrom = 0;
    self.displayNumber = 10;
    self.minDisplayNumber = 20;
    self.zoomBaseLine = CCSLineZoomBaseLineCenter;
    self.noneDisplayValue = 0;
}


- (void)calcValueRange {
    //调用父类
    //[super calcDataValueRange];
    @try {
        
        
        double maxValue = -NSIntegerMax;
        double minValue = NSIntegerMax;
        
        for (NSInteger i = [self.linesData count] - 1; i >= 0; i--) {
            CCSTitledLine *line = [self.linesData objectAtIndex:i];
            
            //获取线条数据
            NSArray *lineDatas = line.data;
            for (NSUInteger j = self.displayFrom; j < self.displayFrom + self.displayNumber; j++) {
                CCSLineData *lineData = [lineDatas objectAtIndex:j];
                
                //忽略不显示值的情况
                if (lineData.value - self.noneDisplayValue == 0) {
                    
                }else {
                    if (lineData.value < minValue) {
                        minValue = lineData.value;
                    }
                    
                    if (lineData.value > maxValue) {
                        maxValue = lineData.value;
                    }
                }
            }
            
        }
        
        if (self.minValue > minValue) {
            self.minValue = minValue;
        }
        
        if (self.maxValue < maxValue) {
            self.maxValue = maxValue;
        }
        
        if (self.axisYPosition==CCSGridChartYAxisPositionLR) {
            
            float max=fabs(self.maxValue-self.closeValue);
            float min=fabs(self.minValue-self.closeValue);
            float sub=0;
            if (max>min) {
                sub=max;
            }else
            {
                sub=min;
            }
            
            self.maxValue=self.closeValue+sub;
            self.minValue=self.closeValue-sub;
            
        }
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)drawRect:(CGRect)rect {
    
    //初始化XY轴
    [self initAxisY];
    [self initAxisX];
    
    [super drawRect:rect];
    
    //绘制数据
    [self drawData:rect];
}

- (void)drawData:(CGRect)rect {
    
    // 起始位置
    @try {
        float startX;
        float lastY = 0;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, .5f);
        CGContextSetAllowsAntialiasing(context, YES);
        
        if (self.linesData != NULL) {
            //逐条输出MA线
            for (NSUInteger i = 0; i < [self.linesData count]; i++) {
                
                CCSTitledLine *line = [self.linesData objectAtIndex:i];
                
                if (line != NULL) {
                    //设置线条颜色
                    CGContextSetStrokeColorWithColor(context, line.color.CGColor);
                    CGContextSetFillColorWithColor(context,  line.color.CGColor);
                    //获取线条数据
                    NSArray *lineDatas = line.data;
                    //判断Y轴的位置设置从左往右还是从右往左绘制
                    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
                        //TODO:自左向右绘图未对应
                        // 点线距离
                        float lineLength = ((rect.size.width - self.axisMarginLeft) / self.displayNumber);
                        //起始点
                        startX = super.axisMarginLeft + lineLength / 2;
                        //遍历并绘制线条
                        for (NSUInteger j = self.displayFrom; j < self.displayFrom + self.displayNumber; j++) {
                            
                            
                            if (j>[lineDatas count]-1) {
                                CGContextStrokePath(context);
                                return;
                            }
                            CCSLineData *lineData = [lineDatas objectAtIndex:j];
                            
                            if ([lineData.date isEqualToString:@"xxxx-xxxx-xxxx"]) {
                                continue;
                            }
                            
                            //获取终点Y坐标
                            float valueY;
                            if ((self.maxValue - self.minValue)!=0) {
                                valueY= ((1 - (lineData.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                            }else
                            {
                                valueY=0;
                            }
                            
                            
                            //绘制线条路径
                            if (j == self.displayFrom) {
                                CGContextMoveToPoint(context, startX, valueY);
                                lastY = valueY;
                            } else {
                                if (lineData.value - self.noneDisplayValue == 0) {
                                    CGContextMoveToPoint(context, startX, lastY);
                                } else {
                                    CGContextAddLineToPoint(context, startX, valueY);
                                    lastY = valueY;
                                }
                            }
                            //X位移
                            startX = startX + lineLength;
                        }
                    }
                    else if (self.axisYPosition == CCSGridChartYAxisPositionLR) {
                        //TODO:自左向右绘图未对应
                        // 点线距离
                        float lineLength = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) / self.displayNumber);
                        //起始点
                        startX = super.axisMarginLeft + lineLength / 2;
                        //遍历并绘制线条
                        for (NSUInteger j = self.displayFrom; j < self.displayFrom + self.displayNumber; j++)
                        {
                            if (j>[lineDatas count]-1) {
                                CGContextStrokePath(context);
                                return;
                            }
                            CCSLineData *lineData = [lineDatas objectAtIndex:j];
                            //获取终点Y坐标
                            float valueY;
                            if ((self.maxValue - self.minValue)!=0) {
                                valueY= ((1 - (lineData.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                            }else
                            {
                                valueY=0;
                            }
                            
                            
                            //绘制线条路径
                            if (j == self.displayFrom) {
                                CGContextMoveToPoint(context, startX, valueY);
                                lastY = valueY;
                            } else {
                                if (lineData.value - self.noneDisplayValue == 0) {
                                    CGContextMoveToPoint(context, startX, lastY);
                                    
                                }
                                else {
                                    
                                    
                                    
                                    //                                if ([line.title isEqualToString:@"chartLine"]) {
                                    //
                                    //                                   CGRect strokeRect=CGRectMake(startX-lineLength, valueY+1, lineLength, rect.size.height-valueY-self.axisMarginBottom);
                                    //
                                    //                                   CGContextFillRect(context,strokeRect);
                                    //
                                    //                                }
                                    
                                    CGContextAddLineToPoint(context, startX, valueY);
                                    lastY = valueY;
                                }
                            }
                            //X位移
                            startX = startX + lineLength;
                        }
                    }
                    else {
                        
                        // 点线距离
                        float lineLength = ((rect.size.width - 2 * self.axisMarginLeft - self.axisMarginRight) / self.displayNumber);
                        //起始点
                        startX = rect.size.width - self.axisMarginRight - self.axisMarginLeft - lineLength / 2;
                        
                        //判断点的多少
                        if ([lineDatas count] == 0) {
                            //0根则返回
                            return;
                        } else if ([lineDatas count] == 1) {
                            //1根则绘制一条直线
                            CCSLineData *lineData = [lineDatas objectAtIndex:0];
                            //获取终点Y坐标
                            float valueY = ((1 - (lineData.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                            
                            CGContextMoveToPoint(context, startX, valueY);
                            CGContextAddLineToPoint(context, self.axisMarginLeft, valueY);
                            
                        } else {
                            //遍历并绘制线条
                            for (NSUInteger j = 0; j < self.displayNumber; j++) {
                                NSUInteger index = self.displayFrom + self.displayNumber - 1 - j;
                                if (index>[lineDatas count]-1) {
                                    CGContextStrokePath(context);
                                    return;
                                }
                                CCSLineData *lineData = [lineDatas objectAtIndex:index];
                                //获取终点Y坐标
                                float valueY = ((1 - (lineData.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                                //绘制线条路径
                                if (index == self.displayFrom + self.displayNumber - 1) {
                                    CGContextMoveToPoint(context, startX, valueY);
                                    lastY = valueY;
                                } else {
                                    if (lineData.value - self.noneDisplayValue == 0) {
                                        CGContextMoveToPoint(context, startX, lastY);
                                    } else {
                                        CGContextAddLineToPoint(context, startX, valueY);
                                        lastY = valueY;
                                    }
                                }
                                //X位移
                                startX = startX - lineLength;
                            }
                        }
                    }
                    
                    // CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
                    
                    CGContextStrokePath(context);
                    
                    //   CGContextFillPath(context);
                    //绘制路径
                    
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (void)initAxisX {
    @try {
#if __has_feature(objc_arc)
        NSMutableArray *TitleX = [[NSMutableArray alloc] init];
#else
        NSMutableArray *TitleX = [[[NSMutableArray alloc] init] autorelease];
#endif
        
        if (self.linesData != NULL && [self.linesData count] > 0) {
            //以第1条线作为X轴的标示
            CCSTitledLine *line = [self.linesData objectAtIndex:0];
            if ([line.data count] > 0) {
                float average =  self.displayNumber/ self.longitudeNum;
                
                //处理刻度
                for (NSUInteger i = 0; i < self.longitudeNum; i++) {
                    NSUInteger index = self.displayFrom + (NSUInteger) floor(i * average);
                    if (index > self.displayFrom + self.displayNumber - 1) {
                        index = self.displayFrom + self.displayNumber - 1;
                    }
                    if(index<line.data.count)
                    {
                        CCSLineData *lineData = [line.data objectAtIndex:index];
                        //追加标题
                        [TitleX addObject:[NSString stringWithFormat:@"%@", lineData.date]];
                    }
                }
                
                CCSLineData *lineData = [line.data objectAtIndex:self.displayFrom + self.displayNumber-1];
                //追加标题
                [TitleX addObject:[NSString stringWithFormat:@"%@", lineData.date]];
            }
        }
        self.longitudeTitles = TitleX;
        
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //调用父类的触摸事件
    //[super touchesBegan:touches withEvent:event];
    
    
    NSArray *allTouches = [touches allObjects];
    //处理点击事件
    if ([allTouches count] == 1) {
        CGPoint pt1 = [[allTouches objectAtIndex:0] locationInView:self];
        
        if (_flag == 0) {
            _firstX = pt1.x;
        } else {
            if (fabs(pt1.x - self.singleTouchPoint.x) > 15) {
                //                    self.displayCrossXOnTouch = YES;
                //                    self.displayCrossYOnTouch = YES;
                [self setNeedsDisplay];
                self.singleTouchPoint = CGPointZero;
                _flag = 0;
                
            } else {
                //获取选中点
                self.singleTouchPoint = [[allTouches objectAtIndex:0] locationInView:self];
                //重绘
                //                    self.displayCrossXOnTouch = YES;
                //                    self.displayCrossYOnTouch = YES;
                [self setNeedsDisplay];
                
                _flag = 1;
            }
        }
        
    } else if ([allTouches count] == 2) {
        CGPoint pt1 = [[allTouches objectAtIndex:0] locationInView:self];
        CGPoint pt2 = [[allTouches objectAtIndex:1] locationInView:self];
        
        _startDistance1 = fabsf(pt1.x - pt2.x);
    } else {
        
    }
    [super touchesBegan:touches withEvent:event];
    
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //
    
    
    
    NSArray *allTouches = [touches allObjects];
    //处理点击事件
    if ([allTouches count] == 1) {
        if (_flag == 0) {
            
            CGPoint pt1 = [[allTouches objectAtIndex:0] locationInView:self];
            if (self.tag!=1234567890) {
                float stickWidth = ((self.frame.size.width - self.axisMarginLeft - self.axisMarginRight) / self.displayNumber) - 1;
                
                if (pt1.x - _firstX > stickWidth) {
                    if (self.displayFrom > 1) {
                        self.displayFrom = self.displayFrom - 2;
                    }
                } else if (pt1.x - _firstX < -stickWidth) {
                    
                    CCSTitledLine *line = [self.linesData objectAtIndex:0];
                    if (self.displayFrom + self.displayNumber+2< [line.data count]) {
                        self.displayFrom = self.displayFrom + 2;
                    }
                }
            }
            _firstX = pt1.x;
            
            [self setNeedsDisplay];
            //设置可滚动
            [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0];
            
        } else {
            //获取选中点
            self.singleTouchPoint = [[allTouches objectAtIndex:0] locationInView:self];
            //设置可滚动
            [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0];
        }
        //        }
    } else if ([allTouches count] == 2) {
        if (self.tag!=1234567890) {
            CGPoint pt1 = [[allTouches objectAtIndex:0] locationInView:self];
            CGPoint pt2 = [[allTouches objectAtIndex:1] locationInView:self];
            
            float endDistance = fabsf(pt1.x - pt2.x);
            //放大
            if (endDistance - _startDistance1 > _minDistance1) {
                [self zoomOut];
                _startDistance1 = endDistance;
                
                [self setNeedsDisplay];
            } else if (endDistance - _startDistance1 < -_minDistance1) {
                [self zoomIn];
                _startDistance1 = endDistance;
                
                [self setNeedsDisplay];
            }
        }
        
    } else {
        
    }
    
    //调用父类的触摸事件
    [super touchesMoved:touches withEvent:event];
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //调用父类的触摸事件
    //if (self.tag!=1234567890) {
    [super touchesEnded:touches withEvent:event];
    
    _startDistance1 = 0;
    
    _flag = 1;
    
    [self setNeedsDisplay];
    //}
}


- (void)zoomOut {
    if (self.displayNumber > self.minDisplayNumber) {
        
        CCSTitledLine *line = [self.linesData objectAtIndex:0];
        
        //区分缩放方向
        if (self.zoomBaseLine == CCSLineZoomBaseLineCenter) {
            self.displayNumber = self.displayNumber - 2;
            self.displayFrom = self.displayFrom + 1;
        } else if (self.zoomBaseLine == CCSLineZoomBaseLineLeft) {
            self.displayNumber = self.displayNumber - 2;
        } else if (self.zoomBaseLine == CCSLineZoomBaseLineRight) {
            self.displayNumber = self.displayNumber - 2;
            self.displayFrom = self.displayFrom + 2;
        }
        
        //处理displayNumber越界
        if (self.displayNumber < self.minDisplayNumber) {
            self.displayNumber = self.minDisplayNumber;
        }
        
        //处理displayFrom越界
        if (self.displayFrom + self.displayNumber >= [line.data count]) {
            self.displayFrom = [line.data count] - self.displayNumber;
        }
        
    }
}

- (void)zoomIn {
    CCSTitledLine *line = [self.linesData objectAtIndex:0];
    
    if (self.displayNumber < [line.data count] - 1) {
        if (self.displayNumber + 2 > [line.data count] - 1) {
            self.displayNumber = [line.data count] - 1;
            self.displayFrom = 0;
        } else {
            //区分缩放方向
            if (self.zoomBaseLine == CCSLineZoomBaseLineCenter) {
                self.displayNumber = self.displayNumber + 2;
                if (self.displayFrom > 1) {
                    self.displayFrom = self.displayFrom - 1;
                } else {
                    self.displayFrom = 0;
                }
            } else if (self.zoomBaseLine == CCSLineZoomBaseLineLeft) {
                self.displayNumber = self.displayNumber + 2;
            } else if (self.zoomBaseLine == CCSLineZoomBaseLineRight) {
                self.displayNumber = self.displayNumber + 2;
                if (self.displayFrom > 2) {
                    self.displayFrom = self.displayFrom - 2;
                } else {
                    self.displayFrom = 0;
                }
            }
        }
        
        if (self.displayFrom + self.displayNumber >= [line.data count]) {
            self.displayNumber = [line.data count] - self.displayFrom;
        }
    }
}


- (void) setSingleTouchPoint:(CGPoint) point
{
    @try {
        _singleTouchPoint = point;
        
        [self calcSelectedIndex];
        
        if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(CCSChartBeTouchedOn:indexAt:)]) {
            [self.chartDelegate CCSChartBeTouchedOn:point indexAt:self.selectedIndex];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

-(void) calcSelectedIndex
{
    //X在系统范围内、进行计算
    if(self.singleTouchPoint.x > self.axisMarginLeft
       && self.singleTouchPoint.x < self.frame.size.width)
    {
        float stickWidth = ((self.frame.size.width - self.axisMarginLeft -self.axisMarginRight))/self.displayNumber;
        float valueWidth = self.singleTouchPoint.x - self.axisMarginLeft;
        if(valueWidth > 0)
        {
            
            int index = round(valueWidth / stickWidth);
            
            //如果超过则设置位最大
            //            if (index >= 20)
            //            {
            //                index = 19;
            //            }
            //设置选中的index
            self.selectedIndex = self.displayFrom+index;
            // NSLog(@"%d",self.selectedIndex);
        }
    }
}


@end
