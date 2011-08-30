//
//  NGTreeMapLayout.m
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NGTreeMapLayout.h"
#import <QuartzCore/QuartzCore.h>

@interface NGTreeMapLayout()

@property (nonatomic, strong) NSArray* itemsToLayout;
@property (nonatomic) CGRect layoutFrame;
@property (nonatomic, strong) NSMutableArray *itemRects;

- (CGFloat) aspectRatioForBigSideLength:(CGFloat) bigLength 
						smallSideLength:(CGFloat) smallLength 
				percentValueOfFirstItem:(CGFloat) firstItemValue
				 percentValueOfNextItem:(CGFloat) nextItemValue;

- (CGFloat) normalizedAspectRatioForBigSideLength:(CGFloat) bigLength 
								  smallSideLength:(CGFloat) smallLength 
						  percentValueOfFirstItem:(CGFloat) firstItemValue
						   percentValueOfNextItem:(CGFloat) nextItemValue;

@end

@implementation NGTreeMapLayout
#pragma mark - @synthesize

@synthesize itemsToLayout = itemsToLayout_, itemRects = itemRects_;
@synthesize layoutFrame = layoutFrame_;

#pragma mark - aspectRatio Calculation

- (CGFloat) aspectRatioForBigSideLength:(CGFloat) bigLength 
						smallSideLength:(CGFloat) smallLength 
				percentValueOfFirstItem:(CGFloat) firstItemValue
				 percentValueOfNextItem:(CGFloat) nextItemValue
{
	CGFloat numerator = bigLength * nextItemValue;
	CGFloat denominator = smallLength * firstItemValue / nextItemValue;
	
	return numerator / denominator;
}

- (CGFloat) normalizedAspectRatioForBigSideLength:(CGFloat) bigLength 
								  smallSideLength:(CGFloat) smallLength 
						  percentValueOfFirstItem:(CGFloat) firstItemValue
						   percentValueOfNextItem:(CGFloat) nextItemValue
{
	CGFloat aspectRatio = [self aspectRatioForBigSideLength:bigLength smallSideLength:smallLength percentValueOfFirstItem:firstItemValue percentValueOfNextItem:nextItemValue];
	if (aspectRatio < 1) {
		return 1/aspectRatio;
	}
	
	return aspectRatio;
}

#pragma mark - Utility Functions
- (CGFloat) sum:(NSArray *)item
		atStart:(int) start
		  toEnd:(int) end
{
	CGFloat sum = 0.0;
	for (int i = start; i<=end; i++){
		sum+= [[item objectAtIndex:i] floatValue];
	}
	return sum;
	
}

#pragma mark - layout Creation
- (NSArray *) layoutTreeMapForItems:(NSArray *) items
						  fromIndex:(int) startIndex
							toIndex:(int) endIndex
			 usingTreeMapStackStyle:(NGTreeMapViewStackStyle) style
						 withBounds:(CGRect) bounds
{
	NSMutableArray *treeMapRects = [[NSMutableArray alloc] initWithCapacity:[items count]];
	CGFloat sum = [self sum:items atStart:startIndex toEnd:endIndex];
	if (style == NGTreeMapViewStackStyleTop) {
		CGFloat x = bounds.origin.x;
		CGFloat y = bounds.origin.y;
		CGFloat fixedWidth = bounds.size.width; 
		
		for (int itemIndex = startIndex; itemIndex <= endIndex; itemIndex++) {
			//@todo total Avaiable Area has to vary based on the rect being built....change it
			if (itemIndex<items.count){
				CGFloat b = [[items objectAtIndex:itemIndex] floatValue] / sum;
				
				//CGFloat variableHeight = [[items objectAtIndex:itemIndex] floatValue]  / fixedWidth;
				CGFloat variableHeight = bounds.size.height * b;
				CGRect shapeRect = CGRectMake(x, y, fixedWidth, variableHeight);
				
				//UIBezierPath *shapePath = [UIBezierPath bezierPathWithRect:shapeRect];
				[treeMapRects addObject:[NSValue valueWithCGRect:shapeRect]];
				
				y+=variableHeight;
			}
			
		}
	}
	else if (style == NGTreeMapViewStackStyleNext) {
		CGFloat x = bounds.origin.x;
		CGFloat y = bounds.origin.y;
		CGFloat fixedHeight = bounds.size.height; 
		
		for (int itemIndex = startIndex; itemIndex <= endIndex; itemIndex++) {
			
			//@todo total Avaiable Area has to vary based on the rect being built....change it
			CGFloat b = [[items objectAtIndex:itemIndex] floatValue] / sum;
			//CGFloat variableWidth = [[items objectAtIndex:itemIndex] floatValue]  / fixedHeight;
			CGFloat variableWidth = bounds.size.width * b;
			CGRect shapeRect = CGRectMake(x, y, variableWidth, fixedHeight);
			
			//UIBezierPath *shapePath = [UIBezierPath bezierPathWithRect:shapeRect];
			[treeMapRects addObject:[NSValue valueWithCGRect:shapeRect]];
			x+=variableWidth;
		}
		
	}
	return treeMapRects;
}


- (void) treeMapLayoutForItems:(NSArray *) items
				  atStartIndex:(int) start
					atEndIndex:(int) end
				  withinBounds:(CGRect) bounds
{
	
	/*	Created a Time test to calculate total of all the objects in NSArray of 90 items the options and results are thus
	 -- For whole Array --
	 1. Using KeyPath @"@sum.doubleValue"							- 1.429 milliseconds
	 2. using for enum												- 0.025 ms
	 3. Simple For i													- 0.020 ms
	 -- For sub Arrays --
	 3. extracted subarray and performed for enum					- 0.535 ms
	 4. simple for i = start, i< end and used [array objectAtIndex]	- 0.003 ms
	 
	 clearly for subarrays simple "for i" wins hands down 
	 
	 */
	
	/*	Not using based on the results above
	 Create a subarray for a given start to end range and then sum all the items in that using valueForKeyPath
	 CGFloat sumOfItems = [[[items subarrayWithRange:NSMakeRange(start, end)] valueForKeyPath:@"@sum.doubleValue"] floatValue];
	 */	
	if (start > end) return;
	CGFloat total = [self sum:items atStart:start toEnd:end];
	CGFloat percentValueOfFirstItem = [[items objectAtIndex:start]floatValue]/total;
	CGFloat percentValueOfNextItem = percentValueOfFirstItem;
	
	CGFloat x = bounds.origin.x; 
	CGFloat y = bounds.origin.y; 
	CGFloat w = bounds.size.width; 
	CGFloat h = bounds.size.height;
	
	
	int currentValue = start;
	
	if(w < h){
		while (currentValue <= end) {
			CGFloat aspectRatio = [self normalizedAspectRatioForBigSideLength:h smallSideLength:w percentValueOfFirstItem:percentValueOfFirstItem percentValueOfNextItem:percentValueOfNextItem];
			CGFloat percentValueOfCurrentItem = [[items objectAtIndex:currentValue] floatValue] / total;
			
			if ([self normalizedAspectRatioForBigSideLength:h smallSideLength:w percentValueOfFirstItem:percentValueOfFirstItem percentValueOfNextItem:(percentValueOfCurrentItem + percentValueOfNextItem)] > aspectRatio) break;
			
			currentValue++;
			percentValueOfNextItem += percentValueOfCurrentItem;
		}
		NSArray *layouts = [self layoutTreeMapForItems:items fromIndex:start toIndex:currentValue usingTreeMapStackStyle:NGTreeMapViewStackStyleNext withBounds:CGRectMake(x, y, w, h*percentValueOfNextItem)];
		[self.itemRects addObjectsFromArray:layouts];
		[self treeMapLayoutForItems:items atStartIndex:currentValue+1 atEndIndex:end withinBounds:CGRectMake(x, y + h*percentValueOfNextItem, w, h*(1-percentValueOfNextItem))];
		
	}
	else{
		while (currentValue <= end) {
			CGFloat aspectRatio = [self normalizedAspectRatioForBigSideLength:w smallSideLength:h percentValueOfFirstItem:percentValueOfFirstItem percentValueOfNextItem:percentValueOfNextItem];
			CGFloat percentValueOfCurrentItem = [[items objectAtIndex:currentValue] floatValue] / total;
			
			if ([self normalizedAspectRatioForBigSideLength:w smallSideLength:h percentValueOfFirstItem:percentValueOfFirstItem percentValueOfNextItem:(percentValueOfCurrentItem + percentValueOfNextItem)] > aspectRatio) break;
			
			currentValue++;
			percentValueOfNextItem += percentValueOfCurrentItem;
		}
		NSArray *layouts = [self layoutTreeMapForItems:items fromIndex:start toIndex:currentValue usingTreeMapStackStyle:NGTreeMapViewStackStyleTop withBounds:CGRectMake(x, y, w*percentValueOfNextItem, h)];
		[self.itemRects addObjectsFromArray:layouts];
		
		[self treeMapLayoutForItems:items atStartIndex:currentValue+1 atEndIndex:end withinBounds:CGRectMake(x + w*percentValueOfNextItem, y, w*(1-percentValueOfNextItem), h)];
		
	}

}

- (CALayer *) layoutItems:(NSArray *)treeMapItems inLayer:(CALayer *)layer
{
	CGRect bounds = layer.bounds;
	CGFloat totalAreaInPoints = bounds.size.width * bounds.size.height;
	CGFloat sumOfItems = [self sum:treeMapItems atStart:0 toEnd:treeMapItems.count -1];
	
	NSMutableArray *layoutItemsArray = [[NSMutableArray alloc] initWithCapacity:treeMapItems.count];
	
	NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(compare:)];
	NSArray* sortedArray = [treeMapItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	NSLog(@"------- in LayoutItems -------");
	for (NSNumber *value in sortedArray){
		//		NSLog(@"Item %d",[value intValue]);
		[layoutItemsArray addObject:[NSNumber numberWithFloat:(([value floatValue] * totalAreaInPoints) / sumOfItems)]];
	}
	self.itemRects = [[NSMutableArray alloc] initWithCapacity:5];
	//	NSLog(@"Size %d",self.itemRects.count);
	[self treeMapLayoutForItems:layoutItemsArray atStartIndex:0 atEndIndex:layoutItemsArray.count-1 withinBounds:bounds];
	//return self.itemRects;
	
	if (self.itemRects.count > 0) {
		int c = self.itemRects.count;
		NSLog(@"Total Items Drawn %d", self.itemRects.count);
		NSUInteger index = 0;
		for (NSValue *value in self.itemRects){
			CAShapeLayer *treeMapLayer = [CAShapeLayer layer];
			CGRect rect = [value CGRectValue];
			
			UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
			//			NSLog(@"%f,%f,%f,%f",rect.origin.x, rect.origin.y,rect.size.width,rect.size.height);
			treeMapLayer.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
			NSLog(@"%f",[[sortedArray objectAtIndex:index] doubleValue]);
			treeMapLayer.name =[NSString stringWithFormat:@"%f", [[sortedArray objectAtIndex:index] doubleValue]];
			treeMapLayer.anchorPoint = CGPointZero;
			treeMapLayer.position = rect.origin;//[self convertPoint:rect1.origin toView:self.superview];
			treeMapLayer.path = path.CGPath;
			treeMapLayer.strokeColor = [UIColor darkGrayColor].CGColor;
			treeMapLayer.fillColor = layer.backgroundColor;
			treeMapLayer.lineWidth = 4.0;
			treeMapLayer.backgroundColor  = [UIColor yellowColor].CGColor;
			
			CATextLayer *lbl = [CATextLayer layer];
			//NSString *s= [NSString stringWithFormat:@"Whatever requires todo in there to do"];
			
			lbl.string =treeMapLayer.name;
			lbl.anchorPoint = CGPointZero;
			lbl.foregroundColor = [UIColor whiteColor].CGColor;
			lbl.alignmentMode = kCAAlignmentCenter;
			lbl.wrapped = YES;
			lbl.bounds = CGRectMake(0, 0, rect.size.width, rect.size.height * 0.2);
			lbl.position = CGPointMake(0, rect.size.height/2 - (rect.size.height * 0.1));
			lbl.fontSize = 20;
			[treeMapLayer addSublayer:lbl];

			[layer insertSublayer:treeMapLayer atIndex:index];
			//[layer addSublayer:treeMapLayer];
			index++;
		}
		
	}
	
	return layer;
}
@end
