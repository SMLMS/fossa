/* ######################################################################
* File Name: SMBParser.h
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

#ifndef SMBParser_h
#define SMBParser_h

#import <Foundation/Foundation.h>

@interface SMBParser: NSObject
{
	NSUInteger _argc;
    NSMutableArray* _argv;
	NSString* _fileName;
    double _tmax;
    NSUInteger _seed;
}

//initializer
-(id) init;

//mutators
-(NSUInteger) argc;
-(NSMutableArray*) argv;
-(NSString*) fileName;
-(double) tmax;
-(NSUInteger) seed;

//special functions
-(void) importCommandLineArguments:(int) size :(const char**) data;

-(bool) searchForHelpRequest;
-(bool) extractFileNameArgument;
-(bool) extractTmaxArgument;
-(bool) extractSeedArgument;
-(bool) checkParserLength;
-(bool) extractParserInformation;

//print functions
-(void) printInfo;
-(void) printHelp;
-(void) printFalseTmaxArgument;
-(void) printFalseSeedArgument;
-(void) printMissingTmaxArgument;
-(void) printMissingSeedArgument;
-(void) printMissingFileNameArgument;
-(void) printShortParser;
//deallocator
-(void) dealloc;

@end
#endif


