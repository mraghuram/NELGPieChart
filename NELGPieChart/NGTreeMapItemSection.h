//
//  NSTreeMapItemSection.h
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGSharedProtocols.h"
@interface NGTreeMapItemSection : NSObject <NGTreeMapItem>
{
	@private
	NSMutableArray *children_;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic) CGFloat rectSize;
@property (nonatomic) CGFloat colorSize;
@property (nonatomic, readonly) NSUInteger count;
//@property (nonatomic, readonly) NSArray *children;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) CALayer *itemLayer;
- (void) addItem:(id <NGTreeMapItem>)item;
- (id <NGTreeMapItem>) childItemAtIndex:(NSUInteger) index;
- (CGFloat) sumOfRectSizeForAllChildCells;
- (CGFloat) sumofColorSizeForAllChildCells;

- (NSEnumerator *) enumerator;

- (void) acceptTreeMapItemVisior:(id <NGTreeMapItemVisitor> ) visitor;

@end
