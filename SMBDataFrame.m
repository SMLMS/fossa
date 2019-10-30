/* ######################################################################
 * File Name: SMBDataFrame.m
 * Project: fossa
 * Version: 19.05
 * Creation Date: 14.05.2019
 * Created By: Sebastian Malkusch
 * Contact: <malkusch@chemie.uni-frankfurt.de>
 * Company: Goethe University of Frankfurt
 * Institute: Physical and Theoretical Chemistry
 * Department: Single Molecule Biophysics
 *
 * License
 * Copyright (C) 2019  Sebastian Malkusch
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #######################################################################*/

#import <Foundation/Foundation.h>
#import "SMBDataFrame.h"

@implementation SMBDataFrame
//initializors
-(id) init
{
    self = [super init];
    if(self){
        _fileName = [[NSString alloc] init];
        _numberOfPlaces = 0;
        _places = [[NSMutableArray alloc] init];
        _stateData = [[NSMutableArray alloc] init];
        _timeData = [[NSMutableArray alloc] init];
        _reactionData = [[NSMutableArray alloc] init];
    }
    return self;
}

//properties
-(void) setFileName:(NSString*) value
{
    [value retain];
    [_fileName release];
    _fileName = value;   
}

-(void) setNumberOfPlaces:(NSUInteger) value
{
    _numberOfPlaces = value;
}

-(void) setSeed:(NSUInteger) value
{
    _seed = value;
}

-(NSUInteger) seed;
{
    return _seed;
}

-(void) setPlaces:(NSMutableArray *)value
{
    [value retain];
    [_places release];
    _places = value;
    _numberOfPlaces = [_places count];
}

//special functions
-(void) growDataFrameWith:(NSMutableArray*) stateVector byReaction:(NSString*) reaction at :(double) timePoint
{
    [stateVector retain];
    [reaction retain];
    [_stateData addObject: [[NSMutableArray alloc] initWithArray:stateVector copyItems: YES]];
    [_timeData addObject: [[NSNumber alloc] initWithDouble: timePoint]];
    [_reactionData addObject:[[NSString alloc] initWithString: reaction]];
    [stateVector release];
    [reaction release];
}

-(void) writeDataFrameToCsv
{
    FILE* stream;
    //open file
    if ((stream = fopen([_fileName UTF8String], "w")) != NULL){
    //write header
        fprintf(stream, "#fossa simulation\n#seed; %lu\n", _seed);
        fprintf(stream, "t,transition");
        for (NSUInteger i=0; i<_numberOfPlaces; i++){
            fprintf(stream, ",%s", [[_places objectAtIndex:i] UTF8String]);
        }
        fprintf(stream, "\n");
    //write time and state Data line by line
	for (NSUInteger i=0; i<[_stateData count]; i++){
        fprintf(stream, "%.3f", [[_timeData objectAtIndex:i] floatValue]);
        fprintf(stream, ",%s", [[_reactionData objectAtIndex:i] UTF8String]);
        for (NSNumber* tempData in [_stateData objectAtIndex: i]){
            fprintf(stream, ",%i", [tempData intValue]);
        }
        fprintf(stream, "\n");
    }
	fclose(stream);
	}
	else{
		NSLog(@"Error: Could not write simulation statistics to file %@. Make sure you have the rights to access it.", _fileName);
	}
}

//deallocator
-(void) dealloc
{
    NSLog(@"DataFrame deallocated");
    [_fileName release];
    _fileName = nil;
    [_places release];
    _places = nil;
    [_stateData release];
    _stateData = nil;
    [_timeData release];
    _timeData = nil;
    [_reactionData release];
    _reactionData = nil;
    [super dealloc];
}
@end
