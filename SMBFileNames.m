/* ######################################################################
* File Name: SMBFileNames.m
* Project: Fossa
* Version: 19.05
* Creation Date: 16.05.2019
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
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
#####################################################################*/

#import <Foundation/Foundation.h>
#import "SMBFileNames.h"

@implementation SMBFileNames
// initializer
-(id) init
{
	self = [super init];
	if(self){
		_creationTime = [[NSDate alloc] init];
		_baseName = [[NSMutableString alloc] init];
		_parameterFileName = [[NSString alloc] init];
		_resultFileName = [[NSMutableString alloc] init];
	}
	return self;
}

//properties
-(NSMutableString*) baseName
{
	return _baseName;
}

-(NSString*) parameterFileName
{
	return _parameterFileName;
}

-(void) setParameterFileName:(NSString*) value
{
	[value retain];
	[_parameterFileName release];
	_parameterFileName = value;
}

-(NSMutableString*) resultFileName
{
	return _resultFileName;
}

//creation Frunctions
-(void) createFileNames
{
	[self createBaseName];
	[self createResultFileName];
}

-(void) createBaseName
{
	NSMutableString* extension = [[NSMutableString alloc] initWithString:@"."];
	[_baseName deleteCharactersInRange: NSMakeRange(0, [_baseName length])];
	[extension appendString: [_parameterFileName pathExtension]];
	NSRange extRange = [_parameterFileName  rangeOfString:extension];
	NSRange baseRange = NSMakeRange(0, extRange.location);
	[_baseName appendString: [_parameterFileName substringWithRange:baseRange]];
	[extension release];
}

-(void) createResultFileName
{
	NSMutableString* suffix = [[NSMutableString alloc] init];
	[_resultFileName deleteCharactersInRange: NSMakeRange(0, [_resultFileName length])];
	[_resultFileName appendString: _baseName];
	[_resultFileName appendString: @"_"];
	[suffix appendString: @"ssa_at_"];
	[suffix appendString: [_creationTime description]];
	[suffix appendString: @"_results.txt"];
	[suffix replaceCharactersInRange: NSMakeRange(17,1) withString: @"_"];
	[suffix replaceCharactersInRange: NSMakeRange(20,1) withString: @"-"];
	[suffix replaceCharactersInRange: NSMakeRange(23,1) withString: @"-"];
	[suffix replaceCharactersInRange: NSMakeRange(26,7) withString: @"_"];
	[_resultFileName appendString: suffix];
	[suffix release];
}

//print Functions
-(void) printFileNames
{
	NSLog(@"fossa file names:\n");
	[self printBaseName];
	[self printParameterFileName];
	[self printResultFileName];
}

-(void) printBaseName
{
	NSMutableString* message = [[NSMutableString alloc] init];
	[message appendString: @"fossa base name:\n"];
	[message appendFormat: @"%@\n", _baseName];
	NSLog(@"%@", message);
	[message release];
}

-(void) printParameterFileName
{
	NSMutableString* message = [[NSMutableString alloc] init];
	[message appendString: @"fossa parameter file name:\n"];
	[message appendFormat: @"%@\n", _parameterFileName];
	NSLog(@"%@", message);
	[message release];
}

-(void) printResultFileName
{
	NSMutableString* message = [[NSMutableString alloc] init];
	[message appendString: @"fossa result file name:\n"];
	[message appendFormat: @"%@\n", _resultFileName];
	NSLog(@"%@", message);
	[message release];
}

//deallocator
-(void) deallocate
{
	[_creationTime release];
	_creationTime = nil;
	[_baseName release];
	_baseName = nil;
	[_parameterFileName release];
	_parameterFileName = nil;
	[_resultFileName release];
	_resultFileName = nil;
	[super dealloc];
}
@end;
