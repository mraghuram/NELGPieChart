//
//  NSTreeMapItemCell.m
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NGTreeMapItemCell.h"

@implementation NGTreeMapItemCell
@synthesize title = title_;
@synthesize rectSize = rectSize_;
@synthesize colorSize = colorSize_;
@synthesize color = color_;
@synthesize itemLayer = itemLayer_;

//- (NSArray *) children {return nil;}

- (void) addItem:(id<NGTreeMapItem>)item {}
- (id <NGTreeMapItem>) childItemAtIndex:(NSUInteger) index  { return nil; }

//- (id <Mark>) lastChild { return nil; }
- (NSUInteger) count { return 0; }
- (CGFloat) sumOfRectSizeForAllChildCells { return self.rectSize;}
- (CGFloat) sumofColorSizeForAllChildCells {return  self.colorSize;}
- (NSEnumerator *) enumerator {return  nil;};
- (void) acceptTreeMapItemVisior:(id <NGTreeMapItemVisitor> ) visitor {return;}
//- (UIColor *) color{ return nil;}// [UIColor clearColor];}
@end
