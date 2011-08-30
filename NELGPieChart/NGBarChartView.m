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
#define NUM_OF_GRIDLINES  10
#define Y_GRIDLINE_LEGEND_WIDTH (X_GRIDLINE_OFFSET - 5)

//	Barchart paddding is used to calculate the padding for the max bar chart height. If this padding is 0, the bar chart with the max lenght will hug the top of the plot area.
#define BARCHART_X_PADDING  20
#define BARCHART_Y_PADDING  20

#define BAR_ITEM_CORNER_RADIUS_OFFSET 6

@interface NGBarChartView()
@property (nonatomic,strong) CAShapeLayer *previousBarItemTouched;
-(void) drawGridLines:(CGContextRef)context;
-(CGRect) calculateBarRectForBarItemHeight:(float)barHeight 
					  withNumberOfBarItems:(NSInteger)numberOfItems
							atBarItemIndex:(NSInteger)index;

-(void) drawTitleForBarItemAtIndex:(NSInteger) index 
							inRect:(CGRect)rect;
	

@end

@implementation NGBarChartView

@synthesize dataSource = dataSource_, delegate = delegate_;
@synthesize barItemRoundedTop = barItemRoundedTop_;
@synthesize barItemTitleHeight = barItemTitleHeight_;
@synthesize previousBarItemTouched = previousBarItemTouched_;
@synthesize barItemSelectedColor = barItemSelectedColor_, barItemColor = barItemColor_;

#pragma mark - intialization
- (void) setup
{
	//Add Tap Gesture recognizer. Press, hold and move event is handled in TouchesMoved method.
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barItemTouched:)];
	[self addGestureRecognizer:tap];
	
	//set a default height for the barItemTitle. The delegate can override this property
	self.barItemTitleHeight = 10;
	
	self.barItemColor = [UIColor colorWithRed:49.0/255.0 green:123.0/255.0 blue:168.0/255.0 alpha:1.0];
	self.barItemSelectedColor = [UIColor redColor];
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
	if([layer isKindOfClass:[CAShapeLayer class]]){
		CAShapeLayer *currentBarItemTouched = (CAShapeLayer *)layer;
		if(![currentBarItemTouched isEqual:self.previousBarItemTouched]){
			currentBarItemTouched.fillColor = self.barItemSelectedColor.CGColor;
			self.previousBarItemTouched.fillColor = self.barItemColor.CGColor;
			self.previousBarItemTouched = currentBarItemTouched;
		}
	}
	//[self setNeedsDisplayInRect:layer.bounds];

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
	//CAShapeLayer *shape;
	if([layer isKindOfClass:[CAShapeLayer class]]){
		CAShapeLayer *currentBarItemTouched = (CAShapeLayer *)layer;
		
		if(![currentBarItemTouched isEqual:self.previousBarItemTouched]){
			currentBarItemTouched.fillColor = self.barItemSelectedColor.CGColor;
			self.previousBarItemTouched.fillColor = self.barItemColor.CGColor;
			self.previousBarItemTouched = currentBarItemTouched;
		}
	}
	//	[self setNeedsDisplayInRect:layer.bounds];

	//if the layer is not nil, fire the baritem didSelect method to the delegate
	if([self.delegate respondsToSelector:@selector(barChartView:didSelectBarAtIndex:)] && layer.name != nil)
		[self.delegate barChartView:self didSelectBarAtIndex:[layer.name integerValue]];
	
	//if the layer is nil, fire the baritem didSelect method to the delegate
	if([self.delegate respondsToSelector:@selector(barChartView:didDeselectBarAtIndex:)] && layer.name == nil)
		[self.delegate barChartView:self didDeselectBarAtIndex:[layer.name integerValue]];
}
/*- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint loc = [touch locationInView:self];
	
	//convert the touch point to the super view
	CALayer *layer = [self.layer hitTest:[self convertPoint:loc toView:self.superview]];
	if([layer isKindOfClass:[CAShapeLayer class]]){
		CAShapeLayer *shape = (CAShapeLayer *)layer;
		shape.fillColor = [UIColor lightGrayColor].CGColor;
	}

}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint loc = [touch locationInView:self];
	
	//convert the touch point to the super view
	CALayer *layer = [self.layer hitTest:[self convertPoint:loc toView:self.superview]];
	if([layer isKindOfClass:[CAShapeLayer class]]){
		CAShapeLayer *shape = (CAShapeLayer *)layer;
		shape.fillColor = [UIColor lightGrayColor].CGColor;
	}}
*/
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
	gridYAxisEnd.y = self.bounds.size.height - Y_GRIDLINE_OFFSET - self.barItemTitleHeight;
	
	gridXAxisStart.x = X_GRIDLINE_OFFSET - 10;

	//Add 10 more points so that the lines dont really intersect but appear as they are crisross 
	gridXAxisStart.y = self.bounds.size.height - Y_GRIDLINE_OFFSET - self.barItemTitleHeight - 10; 	
	
	gridXAxisEnd.x = self.bounds.size.width - X_GRIDLINE_OFFSET;
	gridXAxisEnd.y = self.bounds.size.height - Y_GRIDLINE_OFFSET - self.barItemTitleHeight - 10; 	
	
	
	//** draw vertical axis
	UIBezierPath *verticalLine = [UIBezierPath bezierPath];
	[verticalLine moveToPoint:gridYAxisStart];
	[verticalLine addLineToPoint:gridYAxisEnd];
	[[UIColor lightGrayColor] setStroke];
	//verticalLine.usesEvenOddFillRule = YES;
	[verticalLine stroke];
	
	//** draw horizontal axis
	UIBezierPath *horizontalLine = [UIBezierPath bezierPath];
	[horizontalLine moveToPoint:gridXAxisStart];
	[horizontalLine addLineToPoint:gridXAxisEnd];
	[[UIColor lightGrayColor]setStroke];
	[horizontalLine stroke];
	
	//**
	
	[self drawGridLines:ctx];
	//**

	
	//***
	
	int numberOfBarItems = [self.dataSource numberOfBarsInBarChartView:self];
	for (int barItemIndex=0; barItemIndex < numberOfBarItems ; barItemIndex++) {
		
		//** Step 1 - getting the overall dimension of the bar at index = barItemIdex
		CGRect overallRectForBarItem = [self calculateBarRectForBarItemHeight:[self.dataSource barChartView:self heightForBarAtIndex:barItemIndex] withNumberOfBarItems:numberOfBarItems atBarItemIndex:barItemIndex];
	
		
		//** step 2 - Creating a new shape layer
		CAShapeLayer *barItemShape = [CAShapeLayer layer];

		//** step 3 - setting up the shape layer
		//** setting bounds of the shape layer = to the width and height recieved above in step 1
		barItemShape.bounds = CGRectMake(0, 0, overallRectForBarItem.size.width, overallRectForBarItem.size.height);
		//** setting the anchor point to the left bottom, so that the reference point for position is bottom left
		barItemShape.anchorPoint = CGPointMake(0, 1);
		//** setting the position to the origin of the rect received in step 1.
		barItemShape.position = overallRectForBarItem.origin;
		
		//** step 4 - define the rect to be used by the bezier path to draw.
		CGRect barItemRect = CGRectMake(0, 0, barItemShape.bounds.size.width, barItemShape.bounds.size.height);
		
		//** step 5 - create a new bezier path.
		UIBezierPath *barItemPath;
		
		//** step 6 - draw the barItem rect
		
		
		if (self.barItemRoundedTop) {
			//** if the barItem should be rounded at the top, draw a bezier path with rounded corners on top left and right. Use the radius offset.
			barItemPath = [UIBezierPath bezierPathWithRoundedRect:barItemRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake((barItemRect.size.width / BAR_ITEM_CORNER_RADIUS_OFFSET), (barItemRect.size.width/BAR_ITEM_CORNER_RADIUS_OFFSET))];
		}
		else{
			//** just draw a plain rect
			barItemPath = [UIBezierPath bezierPathWithRect:barItemRect];
		}

		//** step 7 - Finish setting up the new layer.
		//** set the path for the new shape = the bezier path
		barItemShape.path = barItemPath.CGPath;
		
		//** setup stroke color to white
		//@todo: eventually the delegate should be able to set this.
		barItemShape.strokeColor = [UIColor whiteColor].CGColor;
		
		//** Upon redraw, such as after device rotation. See if any of the barItem was selected. If it was, then after redraw, the color of the selected item should be = barItemSelectedColor
		if(self.previousBarItemTouched!=nil && [self.previousBarItemTouched.name intValue] == barItemIndex){
			//** if there was a previousBarItem then figure out the index of the item and set the color = selected color.
			barItemShape.fillColor = self.barItemSelectedColor.CGColor;
			
			//** now since a new shape has been created, the previous item should be = this new shape
			self.previousBarItemTouched = barItemShape;
		}
		else{
			//** if no bar was selected, set the color to barItemColor
			barItemShape.fillColor = self.barItemColor.CGColor;
		}
		
		//** set the name of the layer to barItemIndex for identification purpose
		barItemShape.name = [NSString stringWithFormat:@"%d",barItemIndex];
		
		//** step 8 - add the new shape as a sublayer to the view's layer.
		[self.layer addSublayer:barItemShape];
		
		//** step 9 - draw the title string		
		[self drawTitleForBarItemAtIndex:barItemIndex inRect:CGRectMake(overallRectForBarItem.origin.x,overallRectForBarItem.origin.y, overallRectForBarItem.size.width,self.barItemTitleHeight)];
		 
	}

	CGContextRestoreGState(ctx);

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
	float allowableMaxHeight = self.bounds.size.height - Y_GRIDLINE_OFFSET * 2 - BARCHART_Y_PADDING - self.barItemTitleHeight;
	convertedBarHeight = (barHeight * allowableMaxHeight) / maxBarHeight;
	
	//calculataing bar width
	float allowableMaxWidth = self.bounds.size.width - X_GRIDLINE_OFFSET * 2 - BARCHART_X_PADDING;
	barWidth = allowableMaxWidth / numberOfItems;
	
	//**** calculating the x & y position of the barItem at index
	
	//10 subtracted so that bar aligns exactly on top of x-axis.
	barPosition.y = self.bounds.size.height - Y_GRIDLINE_OFFSET - self.barItemTitleHeight - 10; 
	
	//adding 10 to offset the bar from the y-axis.
	barPosition.x = X_GRIDLINE_OFFSET + 10 + barWidth * index;
	
	//****
	
	barRect = CGRectMake(barPosition.x, barPosition.y, barWidth, convertedBarHeight);
	
	
	return barRect;
}

-(void) drawTitleForBarItemAtIndex:(NSInteger) index 
						inRect:(CGRect)rect
{
	NSString *barItemTitle =  [self.dataSource barChartView:self titleForBarAtIndex:index];	
	float actualFontSize = 14.0;
	[barItemTitle drawAtPoint:CGPointMake(rect.origin.x,rect.origin.y) forWidth:rect.size.width withFont:[UIFont fontWithName:@"Arial" size:14.0] minFontSize:8.0 actualFontSize:&actualFontSize lineBreakMode:UILineBreakModeCharacterWrap baselineAdjustment:UIBaselineAdjustmentAlignCenters];
	//	[barItemTitle drawInRect:rect withFont:[UIFont fontWithName:@"Arial" size:8] lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
}


-(void)drawGridLines:(CGContextRef)context
{
	float maxBarHeight = [self.dataSource maximumBarHeightInBarChartView:self];
	float allowableMaxHeight = self.bounds.size.height - Y_GRIDLINE_OFFSET * 2 - BARCHART_Y_PADDING - self.barItemTitleHeight;
	
	int gridLineStepValue = rint(maxBarHeight / NUM_OF_GRIDLINES);
	UIBezierPath *gridLinePath = [UIBezierPath bezierPath];
	UIColor *gridColor = [UIColor lightGrayColor];
	[gridColor setStroke];
	
	[gridLinePath moveToPoint:CGPointMake(X_GRIDLINE_OFFSET, self.bounds.size.height - Y_GRIDLINE_OFFSET - self.barItemTitleHeight - 10)];
	[gridLinePath addLineToPoint:CGPointMake(self.bounds.size.width-X_GRIDLINE_OFFSET, self.bounds.size.height - Y_GRIDLINE_OFFSET-self.barItemTitleHeight - 10)];
	gridLinePath.lineWidth = 1.0;
	NSString *barItemYAxisValue = [NSString stringWithFormat:@"%d",0];
	[barItemYAxisValue drawInRect:CGRectMake(0,self.bounds.size.height - Y_GRIDLINE_OFFSET - self.barItemTitleHeight - 10,8,4) withFont:[UIFont fontWithName:@"Arial" size:8] lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentRight];
	CGContextSaveGState(context);

	for (int gridLine = 1; gridLine < NUM_OF_GRIDLINES; gridLine ++) {
				
		CGContextTranslateCTM(context, 0, -rint(allowableMaxHeight/NUM_OF_GRIDLINES));
		[gridLinePath stroke];
		
		//Drawing Y Axis Legend
		barItemYAxisValue = [NSString stringWithFormat:@"%d",gridLineStepValue * gridLine];
		int legendHeight = rint(allowableMaxHeight/NUM_OF_GRIDLINES);
		float yPoint = self.bounds.size.height - Y_GRIDLINE_OFFSET - self.barItemTitleHeight- 10;
		[barItemYAxisValue drawInRect:CGRectMake(0, yPoint, Y_GRIDLINE_LEGEND_WIDTH,legendHeight) withFont:[UIFont fontWithName:@"Arial" size:8] lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentRight];
	}		
	CGContextRestoreGState(context);
	
}
@end
