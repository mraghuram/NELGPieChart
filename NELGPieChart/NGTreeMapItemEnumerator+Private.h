

@interface NGTreeMapItemEnumerator()

- (id) initWithTreeMapItem:(id <NGTreeMapItem>) item;
- (void) traverseAndBuildStackWithTreeMapItem:(id <NGTreeMapItem>) item;

@end