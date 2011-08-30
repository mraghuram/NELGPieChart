//
//  NSTreeMapItemSection.m
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NGTreeMapItemSection.h"
#import "NGTreeMapItemEnumerator.h"
#import "NGTreeMapItemEnumerator+Private.h"
#import <QuartzCore/QuartzCore.h>

@interface NGTreeMapItemSection()


@end

@implementation NGTreeMapItemSection
@synthesize title = title_;
@synthesize rectSize =rectSize_, colorSize = colorSize_; 
@synthesize color = color_;
@synthesize itemLayer = itemLayer_;
#pragma mark - initialization
- (id) init {
	if (self = [super init]) {
		children_ = [[NSMutableArray alloc] initWithCapacity:5]; }
	return self;
}

#pragma mark - getters

- (CGFloat) rectSize { return 0.0;}
- (CGFloat) colorSize {return 0.0;}
#pragma mark - child management

- (void) addItem:(id <NGTreeMapItem>)item
{
	[children_ addObject:item];
}

- (id <NGTreeMapItem>) childItemAtIndex:(NSUInteger) index 
{
	if (index >= [children_ count]) return nil;
	return [children_ objectAtIndex:index]; 
}

- (NSUInteger) count
{
	return [children_ count];
}

//- (NSArray *) children 
//{
//	return children_;
//
//}

- (CGFloat) sumOfRectSizeForAllChildCells
{
	CGFloat sum = 0.0;
	NSEnumerator *enumerator = [self enumerator];
//	for (id<NGTreeMapItem> item in enumerator){
//		NSLog(@"title %@ with total %f",item.title, item.rectSize);
//	}
//	enumerator = [self enumerator];

	for (id<NGTreeMapItem> item in enumerator){
		sum += item.rectSize;
	}
	return sum;

}
- (CGFloat) sumofColorSizeForAllItems
{
	CGFloat sum = 0.0;
	NSEnumerator *enumerator = [self enumerator];
	
	for (id<NGTreeMapItem> item in enumerator){
		sum += item.colorSize;
	}
	return sum;
}

#pragma mark - visitor

- (void) acceptTreeMapItemVisior:(id <NGTreeMapItemVisitor> ) visitor
{
	CGRect b = visitor.layerToRender.bounds;
//	NSLog(@"layer bounds %f,%f,%f,%f",b.origin.x, b.origin.y, b.size.width, b.size.height);
//	NSLog(@"name %@",self.title);
	NSLog(@"-------In Accept Item Visitor-------");

	//	NSLog(@"-------Layer to Render %@-------",self.itemLayer.name);

	CALayer *layer= [visitor visitTreeMapSection:self usingLayer:self.itemLayer];
	
	NSUInteger index = 0;
	for (id<NGTreeMapItem> child in children_){
		CALayer *cl = [layer.sublayers objectAtIndex:index];
		cl.backgroundColor = child.color.CGColor;

		//		NSLog(@"sublayer name = %@", cl.name);
		child.itemLayer = cl;
		index++;
	}
	for (id<NGTreeMapItem> child in children_){
//		CALayer *sublayer = [layer.sublayers objectAtIndex:index];
//		child.itemLayer = sublayer;
//		sublayer.backgroundColor = child.color.CGColor;
		//	NSLog(@"sub layer name %@",sublayer.name);

		//	visitor.layerToRender = sublayer;
		//		NSLog(@"Layer to Render %@ for Section %@",self.itemLayer.name, child.title);

		//@todo: sending the layer into the message seems redundant, since we are setting the propoerty on visitor anyway
		//visitor should be able to use this internally.
		[child acceptTreeMapItemVisior:visitor];
	}
	
}

#pragma mark - enumerator method
- (NSEnumerator *) enumerator {
	return [[NGTreeMapItemEnumerator alloc] initWithTreeMapItem:self] ; 
}

@end
