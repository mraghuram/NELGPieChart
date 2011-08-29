//
//  NSMutableArray+Stack.m
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

- (void) push:(id)object
{
	[self addObject:object];
}

- (id) pop
{
	if([self count]==0) return nil;
	
	id object = [self lastObject];
	[self removeLastObject];
	return object;
	
}
@end
