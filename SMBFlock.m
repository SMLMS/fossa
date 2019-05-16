/* ######################################################################
* File Name: SMBFlock.m
* Project: Fossa
* Version: 19.05
* Creation Date: 19.05.2019
* Created By: Sebastian Malkusch
* Contact: <malkusch@chemie.uni-frankfurt.de>
* Company: Goethe University of Frankfurt
* Institute: Physical and Theoretical Chemistry
* Department: Single Molecule Biophysics
*
* License
* Copyright (C) 2018  Sebastian Malkusch
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
#####################################################################*/

#import <Foundation/Foundation.h>
#import "SMBFlock.h"
#import "SMBModelImporter.h"

@implementation SMBFlock
// initializers
-(id) init
{
    self=[super init];
    if(self){
        _tmax = [[NSNumber alloc] init];
	_t = [[NSNumber alloc] initWithFloat: 0.0];
        _data = [[SMBDataFrame alloc] init];
        _reactionConstants = [[SMBVector alloc] init];
        _stateVector = [[SMBVector alloc] init];
        _eductMatrix = [[SMBMatrix alloc] init];
        _productMatrix = [[SMBMatrix alloc] init];
        _actions = [[SMBActions alloc] init];
        _fileNames = [[SMBFileNames alloc] init]; 
    }
    return self;
}

//import functions
-(void) parseArguments:(NSNumber*) tValue :(NSString*) fileName
{
    [tValue retain];
    [_tmax release];
    _tmax = tValue;
    [_fileNames setParameterFileName: fileName];
    [_fileNames createFileNames];
}

-(bool) importModel
{
    bool success = false;
    SMBModelImporter* mi = [[SMBModelImporter alloc] init];
    [mi setFileName: [_fileNames parameterFileName]];
    if([mi proofIfFileName] & [mi proofIfFileExists]){
        success = true;
    }
    if(success){
        [mi readCsv];
    	@try{
            [_stateVector setData: [mi subModelFrom:@"* start" to:@"* stop"]];
            [_stateVector calculateNumberOfEntries];
            [_reactionConstants setData: [mi subModelFrom:@"§ start" to:@"§ stop"]];
            [_reactionConstants calculateNumberOfEntries];
            [_eductMatrix setNumberOfColumns: [_reactionConstants numberOfEntries]];
            [_eductMatrix setNumberOfRows: [_stateVector numberOfEntries]];
            [_productMatrix setNumberOfColumns: [_reactionConstants numberOfEntries]];
            [_productMatrix setNumberOfRows: [_stateVector numberOfEntries]];
            [_eductMatrix setData: [mi subModelFrom:@"$ start" to:@"$ stop"]];
            [_productMatrix setData: [mi subModelFrom:@"# start" to:@"# stop"]];
        }
        @catch(NSException* exception){
            NSLog(@"Fossa caught an exception:\n %@", exception);
            success = false;
        }
    }
    [mi release];
    return success;
}
// simulation functions
-(void) runSimulation
{
    [_data setNumberOfSpecies: [_stateVector numberOfEntries]];
    [_data growDataFrameWith: [_stateVector data] at :(NSNumber*) _t];
}

//write functions
-(void) logSimulation
{
    [_data setFileName: [_fileNames resultFileName]];
    [_data writeDataFrameToCsv];
}

//proof functions
-(bool) checkFlockValidity
{
    bool success = false;
    if([_eductMatrix proofMatrixDimensions] & [_productMatrix proofMatrixDimensions]){
	success = true;
    }
    return success;
}

//print functions
-(void) printFlock
{
    NSLog(@"ssa Model:");
    NSLog(@"tmax[s]: %.3f", [_tmax floatValue]);
    NSLog(@"state vector:");
    [_stateVector printVectorAsInt];
    NSLog(@"reaction constants:");
    [_reactionConstants printVectorAsFloat];
    NSLog(@"educt matrix:");
    [_eductMatrix printMatrix];
    NSLog(@"product matrix:");
    [_productMatrix printMatrix];
}

//deallocator
-(void)dealloc
{
    [_tmax release];
    _tmax = nil;
    [_t release];
    _t = nil;
    [_data release];
    _data = nil;
    [_reactionConstants release];
    _reactionConstants = nil;
    [_stateVector release];
    _stateVector = nil;
    [_eductMatrix release];
    _eductMatrix = nil;
    [_productMatrix release];
    _productMatrix = nil;
    [_actions release];
    _actions = nil;
    [_fileNames release];
    _fileNames = nil;
    [super dealloc];
}
@end
