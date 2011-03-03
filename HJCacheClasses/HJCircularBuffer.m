//
//  HJCircularBuffer.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "HJCircularBuffer.h"


@implementation HJCircularBuffer

+(HJCircularBuffer*)bufferWithCapacity:(int)capacity {
	return [[[HJCircularBuffer alloc] initWithCapacity:capacity] autorelease];
}
	
-(HJCircularBuffer*)initWithCapacity:(int)capacity {
	[super init];
	buffer = [[NSMutableArray arrayWithCapacity:capacity] retain];
	nextIndex=0;
	NSNull* nullObj = [NSNull null];
	for (int i=0; i<capacity; i++) {
		[buffer addObject:nullObj];
	}
	return self;
}
	
-(void)dealloc {
	[buffer release];
	[super dealloc];
}

-(int)length {
	return [buffer count];
}

/**
 * Add object to 'end' of buffer.
 * @return an autoreleased object that had to be removed to make room for the object added. 
 */
-(id)addObject:(id)obj {
	id oldObj = [self swapObject:obj atIndex:nextIndex];
	nextIndex++;
	if (nextIndex>=[buffer count]) { 
		nextIndex=0;
	}
	return oldObj;
}

-(id)swapObject:(id)obj atIndex:(int)i {
	if ([buffer count]==0) { 
		return nil; 
	}
	id oldObj = [buffer objectAtIndex:i];
	if (oldObj!=[NSNull null]) {
		//because when old objObj replaced in the buffer, it will be released and might dealloc:
		[oldObj retain];
		[oldObj autorelease];
	}
	[buffer replaceObjectAtIndex:nextIndex withObject:obj];
	if (oldObj!=[NSNull null]) {
		return oldObj;
	}
	return nil;
}


-(int)findIndexOfObject:(id)key {
	NSNull* nullObj = [NSNull null];
	id obj;
	int i = nextIndex-1; //start looking at the last object
	if (i<0) { i=0; }
	for (int n = [buffer count]-1; n>=0; n--) {
		if (i<0) { 
			i=[buffer count]-1;  //i has to wrap around to the end of the buffer array
		}
		obj = [buffer objectAtIndex:i];
		if (obj!=nullObj) {
			BOOL result = [obj isEqual:key];
			if (result) {
				return i;
			}
		}
		i--; 
	}
	return -1;
}

-(id)findObject:(id)key {
	int i = [self findIndexOfObject:key];
	if (i<0) { 
		return nil;
	}
	return [self objectAtIndex:i];
}

-(id)objectAtIndex:(int)i {
	id obj = [buffer objectAtIndex:i];
	if (obj==[NSNull null]) { 
		return nil; 
	}
	return obj;
}

-(void)removeObjectAtIndex:(int)i {
	[buffer replaceObjectAtIndex:i withObject:[NSNull null]];
}	

-(void)removeObject:(id)key {
	int i = [self findIndexOfObject:key];
	if (i<0) {
		return; 
	}
	//NSLog(@"remove at index %i",i);
	[self removeObjectAtIndex:i];
}

-(NSArray*)allObjects {
	NSMutableArray* all = [NSMutableArray arrayWithCapacity:[buffer count]];
	for (id obj in buffer) {
		if (![obj isKindOfClass:[NSNull class]]) {
			[all addObject:obj];
		}
	}
	return all;
}


+(void)test {
	/*
	HJCircularBuffer* b = [HJCircularBuffer bufferWithCapacity:4];
	
	id o;
	o = [b addObject:@"zero"];
	o = [b addObject:@"one"];
	o = [b addObject:@"two"];
	o = [b addObject:@"three"];
	o = [b addObject:@"andBack"];
	
	int i = [b findIndexOfObjectEqualTo:@"two"];
	o = [b findObjectEqualTo:@"two"];
	NSLog(@"%@",o);
	 */
}


@end
