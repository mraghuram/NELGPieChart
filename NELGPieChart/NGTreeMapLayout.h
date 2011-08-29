//
//  NGTreeMapLayout.h
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	
	NGTreeMapViewStackStyleTop,
	NGTreeMapViewStackStyleNext
	
}NGTreeMapViewStackStyle;

@interface NGTreeMapLayout : NSObject

- (CALayer *) layoutItems:(NSArray *)treeMapItems inLayer:(CALayer *)layer;

@end
