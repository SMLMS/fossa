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
#import <math.h>
#import "SMBFlock.h"
#import "SMBModelImporter.h"

@implementation SMBFlock
// initializers
-(id) init
{
    self=[super init];
    if(self){
        _tmax = 0.0;
        _t = 0.0;
        _seed = 0;
        _r1 = 0.0;
        _r2 = 0.0;
        _reactionIndex = 0;
        _data = [[SMBDataFrame alloc] init];
        _places = [[SMBCharacterVector alloc] init];
        _transitions = [[SMBCharacterVector alloc] init];
        _reactionConstants = [[SMBNumericVector alloc] init];
        _reactionPDF = [[SMBNumericVector alloc] init];
        _reactionCDF = [[SMBNumericVector alloc] init];
        _stateVector = [[SMBNumericVector alloc] init];
        _eductMatrix = [[SMBMatrix alloc] init];
        _productMatrix = [[SMBMatrix alloc] init];
        _actions = [[SMBActions alloc] init];
        _fileNames = [[SMBFileNames alloc] init]; 
    }
    return self;
}

//import functions
-(void) parseArguments:(double) tValue :(NSUInteger) sValue :(NSString*) fileName
{
    _tmax = tValue;
    _seed = sValue;
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
            [_places setData: [mi importCharacterModelItemFrom:@"begin(places)" to:@"end(places)"]];
            [_places calculateNumberOfEntries];
            [_transitions setData: [mi importCharacterModelItemFrom:@"begin(transitions)" to:@"end(transitions)"]];
            [_transitions calculateNumberOfEntries];
            [_stateVector setData: [mi importNumericModelItemFrom:@"begin(initState)" to:@"end(initState)"]];
            [_stateVector calculateNumberOfEntries];
            [_reactionConstants setData: [mi importNumericModelItemFrom:@"begin(reactionConstants)" to:@"end(reactionConstants)"]];
            [_reactionConstants calculateNumberOfEntries];
            [_reactionPDF initWithSize:[_reactionConstants numberOfEntries]];
            [_reactionCDF initWithSize:[_reactionConstants numberOfEntries]];
            [_eductMatrix setNumberOfColumns: [_stateVector numberOfEntries]];
            [_eductMatrix setNumberOfRows: [_reactionConstants numberOfEntries]];
            [_productMatrix setNumberOfColumns: [_stateVector numberOfEntries]];
            [_productMatrix setNumberOfRows: [_reactionConstants numberOfEntries]];
            [_eductMatrix setData: [mi importNumericModelItemFrom:@"begin(eductMatrix)" to:@"end(eductMatrix)"]];
            [_productMatrix setData: [mi importNumericModelItemFrom:@"begin(productMatrix)" to:@"end(productMatrix)"]];
        }
        @catch(NSException* exception){
            NSLog(@"Fossa caught an exception:\n %@", exception);
            success = false;
        }
        if([_places numberOfEntries] != [_stateVector numberOfEntries]){
            NSLog(@"Fossa model error: species and initStates need to be of the same length!");
            success = false;
        }
        if([_transitions numberOfEntries] != [_reactionConstants numberOfEntries]){
            NSLog(@"Fossa model error: transitions and reactionConstants need to be of the same length!");
            success = false;
        }
    }
    [mi release];
    return success;
}

// search functions
-(NSUInteger) binarySearchCDF:(double) data
{
    NSUInteger l = 0;
    NSUInteger r = (unsigned int)[_reactionCDF numberOfEntries]-1;
    NSUInteger m = 0;
    while (l<r){
        m = floor((l+r)/2);
        if ([[_reactionCDF objectAtIndex: m] doubleValue] <= data){
            l = m + 1;
        }
        else{
            r = m;
        }
    }
    return l;
}

// simulation functions
-(void) initActions
{
    [_actions setSeed:_seed];
    [_actions runActions];
}

-(void) claculateReactionPDF
{
    double pdfEntry = 0.0;
    NSUInteger eductEntry;
    for (NSUInteger i=0; i<[_reactionConstants numberOfEntries]; i++) {
        pdfEntry = [[_reactionConstants objectAtIndex:i] doubleValue];
        for (NSUInteger j=0; j<[_stateVector numberOfEntries]; j++) {
            eductEntry = [[_eductMatrix objectAtIndex:i :j] unsignedLongValue];
            if (eductEntry == 1) {
                pdfEntry *= [[_stateVector objectAtIndex:j] doubleValue];
                continue;
            }
            else if (eductEntry == 2){
                pdfEntry *= 0.5 * [[_stateVector objectAtIndex:j] unsignedLongValue] * ([[_stateVector objectAtIndex:j] unsignedLongValue] -1);
                break;
            }
        }
        [_reactionPDF replaceObjectAtIndex:i with:[NSNumber numberWithDouble: pdfEntry]];
    }
}

-(void) calculateReactionCDF
{
    double cdfEntry = 0.0;
    for (NSUInteger i=0; i<[_reactionCDF numberOfEntries]; i++){
        cdfEntry += [[_reactionPDF objectAtIndex: i] doubleValue];
        [_reactionCDF replaceObjectAtIndex:i with:[NSNumber numberWithDouble: cdfEntry]];
    }
}

-(void) updateTimeStep
{
    _t += -log(_r1)/[[_reactionCDF objectAtIndex:[_reactionCDF numberOfEntries]-1] doubleValue];
}

-(void) updateStateVectorByReactionIndex
{
    //state vector -= educt matrix row
    //state vector += product matrix row
    NSUInteger updatedEntry;
    for (NSUInteger i=0; i<[_stateVector numberOfEntries]; i++){
        updatedEntry = [[_stateVector objectAtIndex:i] integerValue] -
        [[_eductMatrix objectAtIndex:_reactionIndex :i] integerValue] +
        [[_productMatrix objectAtIndex:_reactionIndex :i] integerValue];
        [_stateVector replaceObjectAtIndex:i with:[[NSNumber alloc]initWithInteger:updatedEntry]];
    }
}

-(NSUInteger) estimateReactionType
{
    NSUInteger reactionType = 0;
    // binary search smallest value in cdf > r2*sum(pdf)
    reactionType = [self binarySearchCDF:_r2*[[_reactionCDF objectAtIndex:[_reactionCDF numberOfEntries]-1] doubleValue]];
    return reactionType;
}

-(void) runSimulation
{
    // init simulation
    [_data setSeed:_seed];
    [_data setPlaces:[_places data]];
    [_data growDataFrameWith:[_stateVector data] byReaction:[[NSString alloc] initWithString:@"init"] at:_t];
    while (_t < _tmax) {
        // calculate Reaction Probabilities
        [self claculateReactionPDF];
        [self calculateReactionCDF];
	//NSLog(@"reaction Prpbabilies");
        //[_reactionPDF printVector];
        //[_reactionCDF printVector];
        // draw random numbers
        _r1 = [_actions drawRandomNumber];
        _r2 = [_actions drawRandomNumber];
	//NSLog(@"random numbers\nseed: %lu\nR1: %.5f\nR2: %.5f", [_actions seed],_r1, _r2);
        // estimate next event time
        [self updateTimeStep];
	//NSLog(@"next time step:\n%.3f", _t);
        // estimate index of next event type
        _reactionIndex = [self estimateReactionType];
	//NSLog(@"next reaction at idx %lu is of type %@", _reactionIndex, [_transitions objectAtIndex:_reactionIndex]);
        // update state vector
        [self updateStateVectorByReactionIndex];
        // grow data frame
        [_data growDataFrameWith:[_stateVector data] byReaction:[_transitions objectAtIndex:_reactionIndex] at:_t];
    }
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

-(bool) checkEductMatrixValidity
{
    bool success = true;
    NSUInteger rSum = 0;
    for (unsigned i=0; i<[_eductMatrix numberOfRows]; i++){
        rSum = 0;
        for (unsigned j=0; j<[_eductMatrix numberOfColumns]; j++){
            rSum += [[_eductMatrix objectAtIndex:i :j] unsignedIntValue];
        }
        if (rSum > 2){
            success = false;
        }
    }
    if (!success){
        NSLog(@"Error: The entries of the educt matrix do not correspond to the requirements of a stochastic petri net.");
    }
    return success;
}

//print functions
-(void) printFlock
{
    NSMutableString* message = [[NSMutableString alloc] init];
    [message appendString:@"\n"];
    [message appendString:@"fossa model:\n\n"];
    [message appendFormat:@"tmax[s]: %.3f\n\n", _tmax];
    [message appendFormat:@"places:\n%@\n", [_places vectorString]];
    [message appendFormat:@"system state:\n%@\n", [_stateVector vectorString]];
    [message appendFormat:@"transitions:\n%@\n", [_transitions vectorString]];
    [message appendFormat:@"reaction constants:\n%@\n", [_reactionConstants vectorString]];
    [message appendFormat:@"educt matrix:\n%@\n", [_eductMatrix matrixString]];
    [message appendFormat:@"product matrix:\n%@\n", [_productMatrix matrixString]];
    [message appendFormat:@"seed: %lu\n", (unsigned long)_seed];
    [message appendString:@"\n\n"];
    NSLog(@"%@", message);
    [message release];
}

//deallocator
-(void)dealloc
{
    [_data release];
    _data = nil;
    [_places release];
    _places = nil;
    [_transitions release];
    _transitions = nil;
    [_reactionConstants release];
    _reactionConstants = nil;
    [_reactionPDF release];
    _reactionPDF = nil;
    [_reactionCDF release];
    _reactionCDF = nil;
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
