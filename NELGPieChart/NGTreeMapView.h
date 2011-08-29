//
//  NGTreeMapView.h
//  NELGPieChart
//
//  Created by Murali Raghuram on 8/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGSharedProtocols.h"
/* Decided to use NSIndexPath instead 
 typedef struct{
	//0 based number that defines the depth of the treemap
	//0 = highest level
	int zNumber;
	
	//0 based number that defines the element at a given depth zNumber;
	int xNumber;
	
	 //0 based number that defines the element at a given depth zNumber;
	 int yNumber;
   }NGTreeMapIndexPath; 
*/

typedef struct{
	CGFloat rectData;
	CGFloat colorData;
}NGTreeMapViewCell;

typedef enum{
	NGTreeMapViewStyleLevel1,
	NGTreeMapViewStyleLevel2
}NGTreeMapViewStyle;


@class NGTreeMapView;

@protocol NGTreeMapViewDataSource <NSObject>

//Root Section index is 0. Number > 0 indicates the number of the subsection under root.
- (id<NGTreeMapItem>) treeMapView:(NGTreeMapView *)treeMapView subSectionsInSectionAtIndex:(NSInteger) index;


//indexPath.section defines the section number under root
//indexPath.row defines the section number for each indexpath.section
//both are 0 based index
- (NSArray *) treeMapView:(NGTreeMapView *)treeMapView cellItemsAtIndexPath:(NSIndexPath *)indexPath;

@optional


@end

/*
 @protocol NGPieTreeMapDelegate <NSObject>

@optional
- (void) pieChartView:(NGPieChartView *)pieChartView willSelectSliceAtIndex:(NSInteger)index;
- (void) pieChartView:(NGPieChartView *)pieChartView didSelectSliceAtIndex:(NSInteger)index;
- (void) pieChartView:(NGPieChartView *)pieChartView willDeselectSliceAtIndex:(NSInteger)index;
- (void) pieChartView:(NGPieChartView *)pieChartView didDeselectSliceAtIndex:(NSInteger)index;

@end
*/

@interface NGTreeMapView : UIView
//@todo, remove item and make it a datasource
@property (nonatomic, strong) id <NGTreeMapItem> item;
- (id) initWithFrame:(CGRect)frame style:(NGTreeMapViewStyle) style;

@end
