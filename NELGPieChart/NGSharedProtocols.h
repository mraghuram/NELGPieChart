//
//  NGSharedProtocol.h
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NGTreeMapItemVisitor;

@protocol NGTreeMapItem <NSObject>

@property (nonatomic, strong) NSString *title;
@property (nonatomic) CGFloat rectSize;
@property (nonatomic) CGFloat colorSize;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, strong) UIColor *color;
//@property (nonatomic, readonly) NSArray *children;
@property (nonatomic, strong) CALayer *itemLayer;
- (void) addItem:(id <NGTreeMapItem>)item;
- (id <NGTreeMapItem>) childItemAtIndex:(NSUInteger) index;
- (CGFloat) sumOfRectSizeForAllChildCells;
- (CGFloat) sumofColorSizeForAllChildCells;
- (CALayer *) itemLayer;
- (NSEnumerator *) enumerator;

- (void) acceptTreeMapItemVisior:(id <NGTreeMapItemVisitor> ) visitor;
@end



@class NGTreeMapItemSection, NGTreeMapItemCell;
@protocol NGTreeMapItemVisitor <NSObject>

@property (nonatomic, strong) CALayer *layerToRender;
- (void) visitTreeMapItem:(id <NGTreeMapItem>) item;
- (CALayer *) visitTreeMapSection:(NGTreeMapItemSection *) section usingLayer:(CALayer *)layer;
- (void) visitTreeMapCell:(NGTreeMapItemCell *) cell;


@end