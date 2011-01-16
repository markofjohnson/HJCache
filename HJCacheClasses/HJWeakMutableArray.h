//
//  HJWeakMutableArray.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import <Foundation/Foundation.h>


/*
 A mutable array of weak references. Used so that we can hold 'back references' to objects
 without preventing those objects from getting deallocated by normal memory management.
 */
@interface HJWeakMutableArray : NSObject {
	NSMutableArray* array;
}

+(HJWeakMutableArray*) arrayWithCapacity:(int)capacity;
-(HJWeakMutableArray*) initWithCapacity:(int)capacity;

- (void) addObject:(id)anObject;
- (id) objectAtIndex:(int)i;
- (id) findObject:(id)obj;
- (void) removeObject:(id)obj;
- (int) count;
- (NSEnumerator*) objectEnumerator;

@end


@interface HJWeakMutableArrayEnumerator : NSEnumerator {
	NSEnumerator* arrayEnum;
}

-(HJWeakMutableArrayEnumerator*)initWithInternalArray:(NSArray*)array;

@end

