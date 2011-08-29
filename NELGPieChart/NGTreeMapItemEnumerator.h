//
//  NGTreeMapItemEnumerator.h
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGTreeMapItemEnumerator : NSEnumerator{
	@private
	NSMutableArray *stack_;
}

- (NSArray *) allObjects;
- (id) nextObject;


@end
