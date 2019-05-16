/* ######################################################################
* File Name: main.m
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
#import "SMBFlock.h"
#import "SMBParser.h"

int main(int argc, const char * argv[]) {
    // set up manual reference counting (MRC) environment
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    // set up command line argument parsing class
    SMBParser* parser = [[[SMBParser alloc] init] autorelease];
    // set up flock of molecules
    SMBFlock* flock = [[[SMBFlock alloc] init] autorelease];
    // import and proof all parameters
    [parser importCommandLineArguments:argc :argv];
    if([parser searchForHelpRequest]){
	[pool drain];
	return EXIT_SUCCESS;
    }
    if(![parser extractParserInformation]){
	[pool drain];
        return EXIT_FAILURE;
    }
    [flock parseArguments: [parser tmax] : [parser fileName]];
    if(![flock importModel]){
	[pool drain];
	return EXIT_FAILURE;
    }
    if(![flock checkFlockValidity]){
	[pool drain];
	return EXIT_FAILURE;
    }
    // run simulation
    [flock printFlock];
    //[flock initActions];
    [flock runSimulation];
    [flock logSimulation];
    [pool drain];
    return EXIT_SUCCESS;
}
