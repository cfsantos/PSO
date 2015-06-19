//
//  PSOCalculator.m
//  PSO
//
//  Created by Claudio Santos on 6/1/15.
//  Copyright (c) 2015 Claudio Santos. All rights reserved.
//

#import "PSOCalculator.h"
#import "CHCSVParser.h"

@implementation PSOCalculator

#define ARC4RANDOM_MAX      0x100000000

//init defines the learning rate and maximun number of iteractions
-(instancetype)init{
    
    self = [super init] ;
    if (self) {
        self.bestResult = 0;
    }
    return self;
}

//generates a float randon betwwen 2 values
-(float)randonBetweenMinimunValue:(float)minimunValue andMaximunValue:(float)maximunValue{
    return ((float)arc4random() / ARC4RANDOM_MAX * (maximunValue - minimunValue)) + minimunValue;
}

//generates a randon position for each particle
-(void)setPositions{
    for (int counter = 0; counter < MAXNUMBEROFPOSITIONS; counter++) {
        positions[counter][0] = [self randonBetweenMinimunValue:self.minimunValue andMaximunValue:self.maximunValue];
        positions[counter][1] = [self randonBetweenMinimunValue:self.minimunValue andMaximunValue:self.maximunValue];
    }
}

//as we are looking for a minimun value, sets a huge number for the best position
-(void)setBestPositions{
    for (int counter = 0; counter < MAXNUMBEROFPOSITIONS; counter++) {
        positions[counter][0] = 100000000;
        positions[counter][1] = 100000000;
    }
}

//generates a randon velocity for each particle
-(void)setVelocities{
    for (int counter = 0; counter < MAXNUMBEROFPOSITIONS; counter++) {
        velocity[counter][0] = [self randonBetweenMinimunValue:self.minimunVelocity andMaximunValue:self.maximunVelocity];
        velocity[counter][1] = [self randonBetweenMinimunValue:self.minimunVelocity andMaximunValue:self.maximunVelocity];
    }
}


//this is the function defined in the project: (1 - x)^2 + 100*(y - xˆ2)^2
-(float)PSOFunctionForX:(float)xNumber andY:(float)yNumber{
    float firstPart = powf((xNumber - 1), 2);
    
    float internalSecondPart = yNumber - powf(xNumber, 2);
    float externalSecondPart = powf(internalSecondPart, 2);
    float secondPart = 100 * externalSecondPart;

    return firstPart + secondPart;
}

-(void)calculate{
    
    //creates a CSV file for graphs
    NSString * filePath = @"~/testfile.csv";
    filePath = [filePath stringByExpandingTildeInPath];
    
    NSLog(@"filepath = %@", filePath);
    
    CHCSVWriter * csvWriter = [[CHCSVWriter alloc] initForWritingToCSVFile:filePath];
    [self csvWriter:csvWriter writeString:@"X Y Result"];
    
    //initiate main arrays
    [self setBestPositions];
    [self setPositions];
    [self setVelocities];
    
    //defines the number of iteractions
    for (int iteraction = 0; iteraction < 10; iteraction++) {
        //TODO: find out minimun and mediun value of the final iteraction over all particles 
        
        
        //iteracts over all particles
        for (int counter = 0; counter < MAXNUMBEROFPOSITIONS; counter++) {
            
            float xPosition = positions[counter][0];
            float yPosition = positions[counter][1] ;
            
            //gets the best value until now for this particle
            float bestValue = [self PSOFunctionForX:bestPositions[counter][0] andY:bestPositions[counter][1]];
            
            //gets the value for the right position of this particle
            float aValue = [self PSOFunctionForX:positions[counter][0] andY:positions[counter][1] ] ;
            NSString *numbersString = [NSString stringWithFormat:@"%.2f %.2f %.2f ",xPosition, yPosition, aValue];
            //numbersString = [numbersString stringByReplacingOccurrencesOfString:@"." withString:@","];
            [self csvWriter:csvWriter writeString:numbersString];
            
            //if this position is the best ever
            if (aValue < bestValue) {
                
                self.bestResult = bestValue;
                
                //set the position of this particle on the helper of best positions
                bestPositions[counter][0] = positions[counter][0];
                bestPositions[counter][1] = positions[counter][1];
            }
            
            //iteracts over all neighbours
            self.bestIndex = counter;
            for (int secondCounter = 0; secondCounter < MAXNUMBEROFPOSITIONS; secondCounter++) {
                
                //if the neighbour particle is not the same particle we are iteracting
                if (secondCounter != counter) {
                    
                    //gets a value for a neighbour
                    float aValue = [self PSOFunctionForX:positions[secondCounter][0] andY:positions[secondCounter][1]];
                    
                    //if this value is smaller then for the particle we are working on
                    if (aValue < [self PSOFunctionForX:positions[counter][0] andY:positions[counter][1]]) {
                        
                        //tells to the calculator that the position of this particle is better then the particle we are iteracting
                        self.bestIndex = secondCounter;
                    }
                }
            }
            
            //update all positions and velocities
            for (int thirdCounter = 0; thirdCounter < MAXNUMBEROFPOSITIONS; thirdCounter++) {
                [self updateVelocityInIndex:thirdCounter];
                [self updatePositionInIndex:thirdCounter];
            }
            
        }
        
    }
}


//update all velocities
-(void)updateVelocityInIndex:(int)index{
    //update velocity for x
    velocity[index][0] = velocity[index][0] + (bestPositions[index][0] - positions[index][0]) + (positions[self.bestIndex][0] - positions[index][0]) ;
    
    if (velocity[index][0] > self.maximunVelocity)
        velocity[index][0] = self.maximunVelocity;
    
    if (velocity[index][0] < self.minimunVelocity)
        velocity[index][0] = self.minimunVelocity;
    
    
    //update velocity for y
    
    velocity[index][1] = velocity[index][1] + (bestPositions[index][1] - positions[index][1]) + (positions[self.bestIndex][1] - positions[index][1]) ;
    
    if (velocity[index][1] > self.maximunVelocity)
        velocity[index][1] = self.maximunVelocity;
    
    if (velocity[index][1] < self.minimunVelocity)
        velocity[index][1] = self.minimunVelocity;
    
}


//update all positions
-(void)updatePositionInIndex:(int)index{
    positions[index][0] = positions[index][0] + velocity[index][0];
    positions[index][1] = positions[index][1] + velocity[index][1];
}

-(void)csvWriter:(CHCSVWriter *)csvWriter writeString:(NSString *)string{
    [csvWriter writeField:string];
    [csvWriter finishLine];
}

#pragma mark - calculus

-(float)mediunValueOfParticles{
    
    return 0;
}


@end
