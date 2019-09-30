/* ######################################################################
* File Name: SMBModelImporter.m
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
#import "SMBModelImporter.h"

@implementation SMBModelImporter
// initializer
-(id)init
{
    self=[super init];
    if(self){
        _fileName = [[NSString alloc] init];
        _data = [[NSString alloc] init];
    }
    return self;

}
// properties
-(id)initWithFileName:(NSString*) value
{
    self=[super init];
    if(self){
        [value retain];
        _fileName = value;
	_data = [[NSMutableString alloc] init];
    }
    return self;
}

-(NSString*) fileName
{
    return _fileName;
}

-(void) setFileName:(NSString*) value
{
    [value retain];
    [_fileName release];
    _fileName = value;
}

-(NSString*) _data
{
    return _data;
}

//mutators
-(NSMutableArray*) importCharacterModelItemFrom:(NSString*) startSeq to:(NSString*) stopSeq;
{
    [startSeq retain];
    [stopSeq retain];
    NSException* exceptionCharacter = [[NSException alloc]
                                  initWithName:@"SMBMatrix character error"
                                  reason:@"Fossa found matrix entry of wrong type!"
                                  userInfo:nil];
    NSMutableArray* subModel = [[NSMutableArray alloc] init];
    //NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //formatter.numberStyle = NSNumberFormatterDecimalStyle;
    //[formatter setDecimalSeparator:@"."];
    NSArray* rows = [_data componentsSeparatedByString:@"\n"];
    bool foundStart = false;
    bool foundStop = false;
    for(NSString* row in rows){
        NSRange range = [row  rangeOfString:startSeq];
        if (range.location != NSNotFound){
            foundStart = true;
            continue;
        }
        range = [row rangeOfString:stopSeq];
        if(range.location != NSNotFound){
            foundStop = true;
            break;
        }
        if(foundStart){
            NSArray* columns = [row componentsSeparatedByString:@","];
            for(NSString* stringEntry in columns){
                //NSNumber* numberEntry = [formatter numberFromString:stringEntry];
                if(stringEntry != nil){
                    [subModel addObject: stringEntry];
                }
                else{
                    [exceptionCharacter raise];
                    break;
                }
            }
        }
    }
    if(!foundStart){
        NSLog(@"Warning: start sequence '%@' not found", startSeq);
    }
    if(!foundStop){
        NSLog(@"Warning: stop sequence '%@' not found", stopSeq);
    }
    //[formatter release];
    [startSeq release];
    [stopSeq release];
    [subModel autorelease];
    return subModel;
}

-(NSMutableArray*) importNumericModelItemFrom:(NSString*) startSeq to:(NSString*) stopSeq;
{
    [startSeq retain];
    [stopSeq retain];
    NSException* exceptionCharacter = [[NSException alloc]
                                  initWithName:@"SMBMatrix character error"
                                  reason:@"Fossa found matrix entry of wrong type!"
                                  userInfo:nil];
    NSMutableArray* subModel = [[NSMutableArray alloc] init];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [formatter setDecimalSeparator:@"."];
    NSArray* rows = [_data componentsSeparatedByString:@"\n"];
    bool foundStart = false;
    bool foundStop = false;
    for(NSString* row in rows){
        NSRange range = [row  rangeOfString:startSeq];
        if (range.location != NSNotFound){
            foundStart = true;
            continue;
        }
        range = [row rangeOfString:stopSeq];
        if(range.location != NSNotFound){
            foundStop = true;
            break;
        }
        if(foundStart){
            NSArray* columns = [row componentsSeparatedByString:@","];
            for(NSString* stringEntry in columns){
                NSNumber* numberEntry = [formatter numberFromString:stringEntry];
                if(numberEntry != nil){
                    [subModel addObject: numberEntry];
                }
                else{
                    [exceptionCharacter raise];
                    break;
                }
            }
        }
    }
    if(!foundStart){
        NSLog(@"Warning: start sequence '%@' not found", startSeq);
    }
    if(!foundStop){
        NSLog(@"Warning: stop sequence '%@' not found", stopSeq);
    }
    [exceptionCharacter release];
    [formatter release];
    [startSeq release];
    [stopSeq release];
    [subModel autorelease];
    return subModel;
}

// load functions
-(void) readCsv
{

    // define error
    NSError* error;
    error = nil;
    // load file
    [_data release];
    _data = [[NSString stringWithContentsOfFile: _fileName
                                       encoding:NSUTF8StringEncoding
                                          error:&error] retain];
    if(error != nil){
        NSLog(@"Fossa detected an error:\n%@", error);
    }
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
