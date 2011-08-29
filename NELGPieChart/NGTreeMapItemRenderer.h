//
//  NGTreeMapItemRenderer.h
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "NGSharedProtocols.h"
@interface NGTreeMapItemRenderer : NSObject <NGTreeMapItemVisitor> {
	@protected
	//	CALayer *layer_;
	
}
@property (nonatomic, strong) CALayer *layerToRender;

- (id) initWithLayer:(CALayer *) layer;
- (void) visitTreeMapItem:(id <NGTreeMapItem>) item;
- (CALayer *) visitTreeMapSection:(NGTreeMapItemSection *) section usingLayer:(CALayer *)layer;
- (void) visitTreeMapCell:(NGTreeMapItemCell *) cell;


@end
