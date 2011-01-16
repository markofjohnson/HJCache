//
//  HJWeakMutableArray.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "HJWeakMutableArray.h"


@implementation HJWeakMutableArray

+(HJWeakMutableArray*) arrayWithCapacity:(int)capacity {
	return [[[HJWeakMutableArray alloc] initWithCapacity:capacity] autorelease];
}

-(HJWeakMutableArray*) initWithCapacity:(int)capacity {
	[super init];
	array = [[NSMutableArray arrayWithCapacity:capacity] retain];
	return self;
}

-(void) dealloc {
	[array release];
	[super dealloc];
}
	
- (void)addObject:(id)anObject {
	[array addObject:[NSValue valueWithNonretainedObject:anObject]];
}

-(id)objectAtIndex:(int)i {
	return [(NSValue*)[array objectAtIndex:i] nonretainedObjectValue];
}

- (void) removeObject:(id)objToRemove {
	for (int i=0; i<[array count]; i++) {
		NSValue* val = [array objectAtIndex:i];
		id obj = [val nonretainedObjectValue];
		if ([obj isEqual:objToRemove]) {
			[array removeObjectAtIndex:i];
			return;
		}
	}
	return;
}

- (id) findObject:(id)obj {
	for (int i=0; i<[array count]; i++) {
		NSValue* val = [array objectAtIndex:i];
		id objI = [val nonretainedObjectValue];
		if ([objI isEqual:obj]) {
			return objI;
		}
	}
	return nil;
}

-(int)count {
	return [array count];
}

- (NSEnumerator*)objectEnumerator {
	return [[[HJWeakMutableArrayEnumerator alloc] initWithInternalArray:array] autorelease];
}

- (NSString*)description {
	NSMutableString* s = [NSMutableString stringWithCapacity:100];
	[s appendString:@"Weak array {\n"];
	for (NSValue* v in array) {
		[s appendString:[[v nonretainedObjectValue] description]];
		[s appendString:@"  "];
		[s appendFormat:@"%u",[[v nonretainedObjectValue] retainCount]];
		[s appendString:@"\n"];
	}
	[s appendString:@"}"];
	return s;
}

+(void)test {
	/*
	HJWeakMutableArray* array = [HJWeakMutableArray arrayWithCapacity:4];

	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		
	NSString* s = [[NSString stringWithFormat:@"zero"] retain];
	NSUInteger i1 = [s retainCount];
	[array addObject:s];
	NSUInteger i2 = [s retainCount];
	[array addObject:[[NSString stringWithFormat:@"one"] retain]];
	[array addObject:[[NSString stringWithFormat:@"two"] retain]];
	[array addObject:[NSString stringWithFormat:@"three"]];
	
	for (id obj in [array objectEnumerator]) {
		NSLog(@"obj %@  retain count %u",obj,[obj retainCount]);
	}
	
	NSEnumerator* e = [array objectEnumerator];
	id obj = [e nextObject];
	id all = [e allObjects];
	
	[pool drain];
	*/
}


@end


@implementation HJWeakMutableArrayEnumerator 

-(HJWeakMutableArrayEnumerator*)initWithInternalArray:(NSArray*)array {
	arrayEnum = [array objectEnumerator];
	[arrayEnum retain];
	return self;
}

-(void)dealloc {
	[arrayEnum release];
	[super dealloc];
}

-(id)nextObject {
	NSValue* val = (NSValue*)[arrayEnum nextObject];
	return [val nonretainedObjectValue];
}

-(NSArray*)allObjects {
	NSMutableArray* all2 = [NSMutableArray arrayWithCapacity:10];
	for (NSValue* val in [arrayEnum allObjects]) {
		//the value _does_ get retained here
		[all2 addObject:[val nonretainedObjectValue]];
	}
	return all2;
}



@end



