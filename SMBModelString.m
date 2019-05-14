/* ######################################################################
* File Name: SMBModelString.m
* Project: fossa
* Version: 19.05
* Creation Date: 11.05.2019
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
#import "SMBModelString.h"

@implementation SMBModelString
// initializer
-(id)init
{
    self=[super init];
    if(self){
        _fileName = [[NSMutableString alloc] init];;
        _data = [[NSMutableString alloc] init];
    }
    return self;

}
// properties
-(id)initWithFileName:(NSMutableString*) value
{
    [value retain];
    self=[super init];
    if(self){
        _fileName = value;
	_data = [[NSMutableString alloc] init];
    }
    return self;
}

-(NSMutableString*) fileName
{
    return _fileName;
}

-(void) setFileName:(NSMutableString*) value
{
    [value retain];
    [_fileName release];
    _fileName = value;
}

-(NSMutableString*) _data
{
    return _data;
}

//mutators
-(NSMutableString*) substringFrom:(NSString*) startCharacter to:(NSString*) stopCharacter
{
    [startCharacter retain];
    [stopCharacter retain];
    NSMutableString* subString = [[NSMutableString alloc] init];
    NSArray* rows = [_data componentsSeparatedByString:@"\n"];
    bool foundStart = false;
    bool foundStop = false;
    for(NSString* row in rows){
        NSRange range = [row  rangeOfString:startCharacter];
        if (range.location != NSNotFound){
            foundStart = true;
            continue;
        }
        range = [row rangeOfString:stopCharacter];
        if(range.location != NSNotFound){
            foundStop = true;
            break;
        }
        if(foundStart){
// hier geht es weiter append row + append \t
        }
    }
    if(!foundStart){
        NSLog(@"Warning: start character %@ not found", startCharacter);
    }
    if(!foundStop){
        NSLog(@"Warning: stop character %@ not found", stopCharacter);
    }
    [rows release];
    [startCharacter release];
    [stopCharacter release];
    return subString;
}

// load functions
-(void) readCsv
{
    // define error
    NSError* error;
    error = nil;
    // load file
    [_data release];
     _data = [NSString stringWithContentsOfFile: _fileName
                                       encoding:NSUTF8StringEncoding
                                          error:&error];
    if(error != nil){
        NSLog(@"Fossa detected an error:\n%@", error);
    }
    [error release];
    return;
}

//proof functions
-(bool) proofIfFileName
{
    if(![_fileName length]){
        NSLog(@"no file name defined");
	return false;
    }
    return true;
}

-(bool) proofIfFileExists
{
    bool result = true;
    NSFileManager* fm = [[NSFileManager alloc] init];
    if(![fm fileExistsAtPath:_fileName]){
        NSLog(@"No file at path:\n%@", _fileName);
        result = false;
    }
    [fm release];
    return result;
}

//print Methods
-(void) printFileName
{
    NSLog(@"file name is set to:\n%@", _fileName);
}

-(void) printData
{
    NSLog(@"loaded data:\n%@", _data);
}

// deallocator
-(void) dealloc
{
    NSLog(@"Model string deallocated");
    [_fileName release];
    _fileName = nil;
    [_data release];
    _data = nil;
    [super dealloc];
}
@end
