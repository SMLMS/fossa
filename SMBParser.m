/* ######################################################################
* File Name: SMBParser.m
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
###################################################################### */

#import <Foundation/Foundation.h>
#import "string.h"
#import "ctype.h"
#import "SMBParser.h"

@implementation SMBParser
//initializers
-(id) init
{
	self = [super init];
	if(self){
		[self printInfo];
		_argc = 0;
		_argv = [[NSMutableArray alloc] init];
                _fileName = [[NSMutableString alloc] init];
                _tmax = [[NSNumber alloc] init];
	}
	return self;
}

//mutators
-(NSUInteger) argc
{
	return _argc;
}

-(NSMutableArray*) argv;
{
	return _argv;
}

-(NSString*) fileName
{
	return _fileName;
}

-(NSNumber*) tmax
{
	return _tmax;
}

//special functions
-(void) importCommandLineArguments:(int) size :(const char**) data
{
	_argc = size;
	[_argv removeAllObjects];
	for(NSUInteger i=1; i<_argc; i++){
		[_argv addObject:[NSString stringWithUTF8String: data[i]]];
	}
}

-(bool) searchForHelpRequest
{
	for(NSString* entry in _argv){
        	NSRange range = [entry  rangeOfString:@"--help"];
        	if (range.location != NSNotFound){
            		[self printHelp];
            		return true;
		}
	}
	return false;
}

-(bool) extractFileNameArgument
{
	bool found = false;
	for (NSString* entry in _argv){
        	NSRange range = [entry  rangeOfString:@"--model"];
        	if (range.location != NSNotFound){
            		found = true;
			continue;
		}
		if(found){
			[_fileName release];
			[entry retain];
			_fileName = entry;
			break;
		}
	}
	return found;
}

-(bool) extractTmaxArgument
{
	bool found = false;
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    	formatter.numberStyle = NSNumberFormatterDecimalStyle;
    	[formatter setDecimalSeparator:@"."];
	for (NSString* entry in _argv){
        	NSRange range = [entry  rangeOfString:@"--tmax"];
        	if (range.location != NSNotFound){
            		found = true;
			continue;
		}
		if(found){
			[_tmax release];
			_tmax = [[formatter numberFromString: entry] retain];
                	if(_tmax == nil){
				[self printFalseTmaxArgument];
                    		return false;
                	}
			break;
		}
	}
	return found;
}

-(bool) checkParserLength
{
	bool result = true;
	if ([_argv count] < 4){
		result = false;
	}
	return result;
}

-(bool) extractParserInformation
{
	if(![self checkParserLength]){
		[self printShortParser];
		return false;
	}
	if(![self extractFileNameArgument]){
		[self printMissingFileNameArgument];
		return false;
	}
	if(![self extractTmaxArgument]){
		[self printMissingTmaxArgument];
		return false;
	}
	return true;
}

//print functions
-(void) printInfo
{
	NSMutableString* info = [[NSMutableString alloc] init];
	[info appendString:@"Fossa Info:"];
	[info appendString:@"\nFree Objective-C Stochastic Simulation Algorithm"];
	[info appendString:@"\nSingle Molecule Biophysics"];
	[info appendString:@"\nCopyright © 2019 by Sebastian Malkusch"];
	[info appendString:@"\nmalkusch@chemie.uni-frankfurt.de\n\n"];
	[info appendString:@"Fossa comes with ABSOLUTELY NO WARRANTY\n"];
	[info appendString:@"Fossa is free software, and you are welcome to\n"];
	[info appendString:@"redistribute it under certain conditions\n\n"];
	[info appendString:@"for further details please visit the project page:"]; 
	[info appendString:@"\nhttps://github.com/SMLMS/fossa.git\n\n"];
	NSLog(@"%@",info);
	[info release];
}

-(void) printHelp
{
	NSMutableString* message = [[NSMutableString alloc] init];
	[message appendString:@"Fossa Help Message:"];
	[message appendString:@"\nFossa needs exactly 2 parameters"];
	[message appendString:@"\n--tmax\t(float)\t tmax value"];
	[message appendString:@"\n--model\t(string)\t absolute path to fossa model file"];
	NSLog(@"%@",message);
	[message release];
}

-(void) printFalseTmaxArgument
{
	NSLog(@"Error: Input argument '--tmax' is not a number!\n type '--help' for help");
}

-(void) printMissingTmaxArgument
{
	NSLog(@"Error: Missing '--tmax' argument\ntype '--help' for help");
}

-(void) printMissingFileNameArgument
{
	NSLog(@"Error: Missing '--model' argument\ntype '--help' for help");
}

-(void) printShortParser
{
	NSLog(@"Error: Too few parser arguments passed. Exactly 2 are needed!\ntype '--help' for help");
}


//deallocator
-(void) dealloc
{
	[_argv release];
	_argv = nil;
	[_fileName release];
	_fileName = nil;
	[_tmax release];
	_tmax = nil;
	[super dealloc];
}

@end
