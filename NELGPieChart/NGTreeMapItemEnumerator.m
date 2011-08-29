//
//  NGTreeMapItemEnumerator.m
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NGTreeMapItemEnumerator.h"
#import "NGSharedProtocols.h"
#import "NSMutableArray+Stack.h"
#import "NGTreeMapItemEnumerator+Private.h"
@implementation NGTreeMapItemEnumerator

- (id) initWithTreeMapItem:(id<NGTreeMapItem>)item
{
	if (self = [super init])
	{
		stack_ = [[NSMutableArray alloc] initWithCapacity:[item count]];
		
		[self traverseAndBuildStackWithTreeMapItem:item];
	}
	return self;
}

-(void) traverseAndBuildStackWithTreeMapItem:(id<NGTreeMapItem>)item
{
	if (item == nil) return;
	
	[stack_ push:item];
	NSUInteger index = [item count];
	
	id <NGTreeMapItem> childItem;
	while ((childItem = [item childItemAtIndex:--index])) {
		[self traverseAndBuildStackWithTreeMapItem:childItem];
	}
}
- (NSArray *) allObjects
{
	return [[stack_ reverseObjectEnumerator] allObjects];
}

- (id) nextObject
{
	return [stack_ pop];
}
@end
