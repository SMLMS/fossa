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
       _numberOfSpecies = 0;
       _stateData = [[NSMutableArray alloc] init];
       _timeData = [[NSMutableArray alloc] init];
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

-(void) setNumberOfSpecies:(NSUInteger) value
{
    _numberOfSpecies = value;
}

//special functions
-(void) growDataFrameWith:(NSMutableArray*) stateVector at :(double) timePoint
{
    [stateVector retain];
    [_stateData addObject: stateVector];
    [_timeData addObject: [[NSNumber alloc] initWithDouble: timePoint]];
}

-(void) writeDataFrameToCsv
{
    FILE* stream;
    //open file
    if ((stream = fopen([_fileName UTF8String], "w")) != NULL){
    //write header
        fprintf(stream, "#t");
        for (NSUInteger i=0; i<_numberOfSpecies; i++){
            fprintf(stream, ",R%lu", i);
        }
        fprintf(stream, "\n");
    //write time and state Data line by line
	for (NSUInteger i=0; i<[_stateData count]; i++){
            fprintf(stream, "%.3f", [[_timeData objectAtIndex:i] floatValue]);
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
    [_stateData release];
    _stateData = nil;
    [_timeData release];
    _timeData = nil;
    [super dealloc];
}
@end
