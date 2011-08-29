//
//  NGTreeMapItemRenderer.m
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NGTreeMapItemRenderer.h"
#import "NGTreeMapItemSection.h"
#import "NGTreeMapLayout.h"
#import "Extension.h"
@interface NGTreeMapItemRenderer ()

@property (nonatomic) CGRect bounds;
@end


@implementation NGTreeMapItemRenderer
@synthesize bounds = bounds_;
@synthesize layerToRender = layer_;

- (id) initWithLayer:(CALayer *)layer
{
	if(self = [super init])
	{
		self.bounds = layer.bounds;
		self.layerToRender = layer;
	}
	return self;
	
}
- (void) visitTreeMapItem:(id<NGTreeMapItem>)item
{
	// Default behaviour
	// @todo: override to provide default funcationality
}

- (CALayer *) visitTreeMapSection:(NGTreeMapItemSection *)section usingLayer:(CALayer *)layer
{
	NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:5];
	NGTreeMapLayout *layout = [[NGTreeMapLayout alloc]init];
	NSUInteger index = 0; // section.count;
	
	id <NGTreeMapItem> childItem;
	while ((childItem = [section childItemAtIndex:index++])) {
		[items addObject:[NSNumber numberWithFloat:[childItem sumOfRectSizeForAllChildCells]]];
	}
	return [layout layoutItems:items inLayer:layer];
	
}

- (void) visitTreeMapCell:(NGTreeMapItemCell *) cell
{
	// To Draw the title of the cell
}

@end
