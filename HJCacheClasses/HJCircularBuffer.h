//
//  HJCircularBuffer.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/


#import <Foundation/Foundation.h>


/*
 Fixed size buffer (array) that you can add objects to. When it gets full to the end of the array, 
 it starts again from the front of the array replacing old objects with new ones. 
 Is implemented with an array full of [NSNull null] objects, so putting nulls in is like deleting the object at
 the next available slot. The NSNulls never come out of this data structure, nil is returned instead of NSNull.
*/
@interface HJCircularBuffer : NSObject {
	NSMutableArray* buffer;
	int nextIndex;
}


+(HJCircularBuffer*)bufferWithCapacity:(int)capacity;
-(HJCircularBuffer*)initWithCapacity:(int)capacity;
-(int)length;

/**
 * Add object to 'end' of buffer.
 * @return an autoreleased object that had to be removed to make room for the object added. 
 */
-(id)addObject:(id)obj;
-(id)objectAtIndex:(int)i;
-(void)removeObject:(id)key;
-(void)removeObjectAtIndex:(int)i;
-(id)swapObject:(NSObject*)obj atIndex:(int)i;
-(id)findObject:(id)key;
-(int)findIndexOfObject:(id)key;

-(NSArray*)allObjects;

@end
