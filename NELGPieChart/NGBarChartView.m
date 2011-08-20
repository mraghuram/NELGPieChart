//
//  NGBarChartView.m
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NGBarChartView.h"
#import <QuartzCore/QuartzCore.h>

#define X_GRIDLINE_OFFSET 20.5
#define Y_GRIDLINE_OFFSET 20.5

//	Barchart paddding is used to calculate the padding for the max bar chart height. If this padding is 0, the bar chart with the max lenght will hug the top of the plot area.
#define BARCHART_X_PADDING  20
#define BARCHART_Y_PADDING  20

#define BAR_ITEM_CORNER_RADIUS_OFFSET 6

@interface NGBarChartView()

-(void) generateGridLines:(CGContextRef)context;
-(CGRect) calculateBarRectForBarItemHeight:(float)barHeight 
					  withNumberOfBarItems:(NSInteger)numberOfItems
							atBarItemIndex:(NSInteger)index;
	

@end

@implementation NGBarChartView

@synthesize dataSource, delegate;
@synthesize barItemRoundedTop;

#pragma mark - intialization
- (void) setup
{
	//Add Tap Gesture recognizer. Press, hold and move event is handled in TouchesMoved method.
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barItemTouched:)];
	[self addGestureRecognizer:tap];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
	[self setup];
}

#pragma mark - touch handling

- (void) barItemTouched:(UITapGestureRecognizer *)recognizer
{
	//Identify the touch point in the recognizers view, which is self.
	CGPoint loc = [recognizer locationInView:recognizer.view];

	//convert the point to superview co-ordinates and then identify the layer using hit test.
	CALayer *layer = [self.layer hitTest:[self convertPoint:loc toView:self.superview]];
	
	//Identify if the delegate responds to didSelect method and if it does, send the didSelect method to the delegate
	if([self.delegate respondsToSelector:@selector(barChartView:didSelectBarAtIndex:)] && layer.name != nil)
		[self.delegate barChartView:self didSelectBarAtIndex:[layer.name integerValue]];

	// if the layer is nil, then the touch has moved away from a bar item. So fire the didDeselect to the delegate
	if([self.delegate respondsToSelector:@selector(barChartView:didDeselectBarAtIndex:)] && layer.name == nil)
		[self.delegate barChartView:self didDeselectBarAtIndex:[layer.name integerValue]];
	

}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	//While the touch is being moved, identify where the touch point is
	UITouch *touch = [touches anyObject];
	CGPoint loc = [touch locationInView:self];

	//convert the touch point to the super view
	CALayer *layer = [self.layer hitTest:[self convertPoint:loc toView:self.superview]];
	
	//if the layer is not nil, fire the baritem didSelect method to the delegate
	if([self.delegate respondsToSelector:@selector(barChartView:didSelectBarAtIndex:)] && layer.name != nil)
		[self.delegate barChartView:self didSelectBarAtIndex:[layer.name integerValue]];
	
	//if the layer is nil, fire the baritem didSelect method to the delegate
	if([self.delegate respondsToSelector:@selector(barChartView:didDeselectBarAtIndex:)] && layer.name == nil)
		[self.delegate barChartView:self didDeselectBarAtIndex:[layer.name integerValue]];



}

#pragma mark - drawRect
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	
	
	//Contentmode is set to redraw to ensure drawRect is called after device rotation
	self.contentMode = UIViewContentModeRedraw;
	self.layer.sublayers = nil;
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	//***draw grild lines
	CGContextSaveGState(ctx);
	
	CGPoint gridYAxisStart;
	CGPoint gridYAxisEnd;
	CGPoint gridXAxisStart;
	CGPoint gridXAxisEnd;
	
	gridYAxisStart.x = X_GRIDLINE_OFFSET;
	gridYAxisStart.y = Y_GRIDLINE_OFFSET;
	gridYAxisEnd.x = X_GRIDLINE_OFFSET;
	gridYAxisEnd.y = self.bounds.size.height - Y_GRIDLINE_OFFSET;
	
	gridXAxisStart.x = X_GRIDLINE_OFFSET - 10;

	//Add 10 more points so that the lines dont really intersect but appear as they are crisross 
	gridXAxisStart.y = self.bounds.size.height - Y_GRIDLINE_OFFSET - 10; 	
	
	gridXAxisEnd.x = self.bounds.size.width - X_GRIDLINE_OFFSET;
	gridXAxisEnd.y = self.bounds.size.height - Y_GRIDLINE_OFFSET - 10; 	
	
	
	UIBezierPath *verticalLine = [UIBezierPath bezierPath];
	[verticalLine moveToPoint:gridYAxisStart];
	[verticalLine addLineToPoint:gridYAxisEnd];
	[[UIColor lightGrayColor] setStroke];
	//verticalLine.usesEvenOddFillRule = YES;
	[verticalLine stroke];
	
	UIBezierPath *horizontalLine = [UIBezierPath bezierPath];
	[horizontalLine moveToPoint:gridXAxisStart];
	[horizontalLine addLineToPoint:gridXAxisEnd];
	[[UIColor lightGrayColor]setStroke];
	[horizontalLine stroke];
	

	
	//***
	
	int numberOfBarItems = [self.dataSource numberOfBarsInBarChartView:self];
	for (int barItemIndex=0; barItemIndex <= numberOfBarItems ; barItemIndex++) {
		
		
		CGRect barItem = [self calculateBarRectForBarItemHeight:[self.dataSource barChartView:self heightForBarAtIndex:barItemIndex] withNumberOfBarItems:numberOfBarItems atBarItemIndex:barItemIndex];
	
		

		CAShapeLayer *shape = [CAShapeLayer layer];

		shape.bounds = CGRectMake(0, 0, barItem.size.width, barItem.size.height);
		shape.anchorPoint = CGPointMake(0, 1);
		shape.position = barItem.origin;
		
		CGRect barItemRect = CGRectMake(0, 0, shape.bounds.size.width, shape.bounds.size.height);
		UIBezierPath *barItemPath;
		if (self.barItemRoundedTop) 
			barItemPath = [UIBezierPath bezierPathWithRoundedRect:barItemRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake((barItemRect.size.width / BAR_ITEM_CORNER_RADIUS_OFFSET), (barItemRect.size.width/BAR_ITEM_CORNER_RADIUS_OFFSET))];
		else
			barItemPath = [UIBezierPath bezierPathWithRect:barItemRect];

		shape.path = barItemPath.CGPath;
		shape.strokeColor = [UIColor whiteColor].CGColor;
		shape.fillColor = [UIColor colorWithRed:0.3*0.2*barItemIndex green:0.3*0.2*barItemIndex blue:0.3*0.2*barItemIndex alpha:1.0].CGColor;
		shape.name = [NSString stringWithFormat:@"%d",barItemIndex];
		[self.layer addSublayer:shape];
	}

	CGContextRestoreGState(ctx);

/*	for (int i = 0; i<6; i++) {
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 30, 100)];
		CAShapeLayer *shape = [CAShapeLayer layer];
		
		shape.bounds = CGRectMake(0, 0, 30, 100);
		shape.position = CGPointMake(20 + 35 * i, self.bounds.size.height - 20);
		shape.path = path.CGPath;
		shape.strokeColor = [UIColor whiteColor].CGColor;
		shape.fillColor = [UIColor grayColor].CGColor;
		shape.name = @"ShapeLayer";
		[self.layer addSublayer:shape];
	}
	*/

	
	/*	UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 50, 100)];
	CAShapeLayer *shape = [CAShapeLayer layer];
	
	shape.bounds = CGRectMake(0, 0, 50, 100);
	shape.position = CGPointMake(80, 50);
	shape.path = path.CGPath;
	shape.strokeColor = [UIColor blackColor].CGColor;
	shape.fillColor = [UIColor grayColor].CGColor;
	shape.name = @"ShapeLayer";
	[self.layer addSublayer:shape];
	
	UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 50)];
	CAShapeLayer *shape1 = [CAShapeLayer layer];
	shape1.bounds = CGRectMake(0, 0, 100, 50);
	shape1.position = CGPointMake(200, 40);
	shape1.path = path1.CGPath;
	shape1.strokeColor = [UIColor blackColor].CGColor;
	shape1.fillColor = [UIColor greenColor].CGColor;
	shape1.name = @"ShapeLayer2";
	[self.layer addSublayer:shape1];	
 */

}

-(CGRect) calculateBarRectForBarItemHeight:(float)barHeight 
					  withNumberOfBarItems:(NSInteger)numberOfItems
							atBarItemIndex:(NSInteger)index
{
	CGRect barRect;
	float convertedBarHeight;
	CGPoint barPosition;
	float barWidth;
	
	//Calculating bar height
	float maxBarHeight = [self.dataSource maximumBarHeightInBarChartView:self];
	float allowableMaxHeight = self.bounds.size.height - Y_GRIDLINE_OFFSET * 2 - BARCHART_Y_PADDING;
	convertedBarHeight = (barHeight * allowableMaxHeight) / maxBarHeight;
	
	//calculataing bar width
	float allowableMaxWidth = self.bounds.size.width - X_GRIDLINE_OFFSET * 4 - BARCHART_X_PADDING;
	barWidth = allowableMaxWidth / numberOfItems;
	
	barPosition.y = self.bounds.size.height - Y_GRIDLINE_OFFSET - 10;
	barPosition.x = X_GRIDLINE_OFFSET + 10 + barWidth * index;
	
	barRect = CGRectMake(barPosition.x, barPosition.y, barWidth, convertedBarHeight);
	
	return barRect;
	
	
}



@end
