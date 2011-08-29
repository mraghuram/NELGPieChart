//
//  NGTreeMapView.m
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NGTreeMapView.h"
#import "NGTreeMapLayout.h"
#import "NGTreeMapItemRenderer.h"

#import <QuartzCore/QuartzCore.h>

@implementation NGTreeMapView
@synthesize item;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = [UIColor redColor];
    }
	
    return self;
}

- (CGFloat) totalAvailableArea
{
	CGFloat area;
	CGFloat height;
	CGFloat width;
	
	height = self.bounds.size.height;
	width = self.bounds.size.width;
	
	area = height * width;
	return area;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    // Drawing code
	self.contentMode = UIViewContentModeRedraw;
	self.layer.sublayers = nil;
	NGTreeMapItemRenderer *renderer = [[NGTreeMapItemRenderer alloc] initWithLayer:self.layer];
	[item acceptTreeMapItemVisior:renderer];

/*	NSArray *items = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.25],[NSNumber numberWithFloat:0.25],[NSNumber numberWithFloat:0.17],[NSNumber numberWithFloat:0.125],[NSNumber numberWithFloat:0.08],[NSNumber numberWithFloat:0.08],[NSNumber numberWithFloat:0.04], nil];
	//	NSArray *items = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.15],[NSNumber numberWithFloat:0.15],[NSNumber numberWithFloat:0.15],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.09],[NSNumber numberWithFloat:0.06],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.03],[NSNumber numberWithFloat:0.02], nil];
	NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:2];
	
	for (NSNumber *n in items){
		[arr addObject:[NSNumber numberWithFloat:[n floatValue]*[self totalAvailableArea]]];
	}*/
	
/*	
	NGTreeMapLayout *layout = [[NGTreeMapLayout alloc] init];
	NSArray *shapes = [layout layoutItems:arr withinLayer:self.layer];
	NSLog(@"bounds %f,%f,%f,%f",self.bounds.origin.x, self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height);

	if (shapes) {

		for (NSValue *value in shapes){
			CAShapeLayer *treeMapLayer = [CAShapeLayer layer];
			CGRect rect1 = [value CGRectValue];
			
			UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, rect1.size.width, rect1.size.height)];
			NSLog(@"%f,%f,%f,%f",rect1.origin.x, rect1.origin.y,rect1.size.width,rect1.size.height);
			treeMapLayer.bounds = CGRectMake(0, 0, rect1.size.width, rect1.size.height);
			CGPoint p = [self convertPoint:rect1.origin toView:self.superview];
			//
			NSLog(@"p %f,%f",p.x,p.y);
			treeMapLayer.anchorPoint = CGPointZero;
			treeMapLayer.position = rect1.origin;//[self convertPoint:rect1.origin toView:self.superview];
			treeMapLayer.path = path.CGPath;
			treeMapLayer.strokeColor = [UIColor darkGrayColor].CGColor;
			treeMapLayer.fillColor = [UIColor blackColor].CGColor;
			treeMapLayer.lineWidth = 2.0;
			treeMapLayer.backgroundColor  = [UIColor yellowColor].CGColor;
			
			//		NSString *lbl = [NSString stringWithFormat:@"%d %", percent];
//			CATextLayer *lbl = [CATextLayer layer];
//			NSString *s= [NSString stringWithFormat:@"Whatever requires todo in there to do"];
//			
//			lbl.string =s;
//			lbl.anchorPoint = CGPointZero;
//			lbl.foregroundColor = [UIColor blueColor].CGColor;
//			lbl.alignmentMode = kCAAlignmentCenter;
//			lbl.wrapped = YES;
//			lbl.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height * 0.2);
//			lbl.position = CGPointMake(0, rect.size.height/2 - (rect.size.height * 0.1));
//			lbl.fontSize = 14;
//			CGSize siz = [s sizeWithFont:[UIFont systemFontOfSize:50] constrainedToSize:CGSizeMake(rect.size.width, rect.size.height * 0.2)] ;
//			
//			NSLog(@"Siz %f, %f",siz.width, siz.height);
//			[treeMapLayer addSublayer:lbl];
			[self.layer addSublayer:treeMapLayer];
			//	i++;
			
			
			}
		[self setNeedsDisplay];
	}
*/
}


@end
