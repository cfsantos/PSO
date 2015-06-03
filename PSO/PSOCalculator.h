//
//  PSOCalculator.h
//  PSO
//
//  Created by Claudio Santos on 6/1/15.
//  Copyright (c) 2015 Claudio Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

//defines the maximun number of particles
#define MAXNUMBEROFPOSITIONS 10

@interface PSOCalculator : NSObject{
    //matrix of positions
    float positions[MAXNUMBEROFPOSITIONS][2];
    
    //helper for defining the best position of a particle
    float bestPositions[MAXNUMBEROFPOSITIONS][2];
    
    //matrix of velocities
    float velocity[MAXNUMBEROFPOSITIONS][2];
}

//input: minimun value of function
@property(nonatomic)float minimunValue;

//input: maximun value of function
@property(nonatomic)float maximunValue;

//input: maximun velocity of a particle
@property(nonatomic)float minimunVelocity;

//input: minimun velocity of a particle
@property(nonatomic)float maximunVelocity;

//output: best result got for this function
@property(nonatomic)float bestResult;

//get the best index of the matrix of particles
@property(nonatomic)int bestIndex;

//init helper
-(instancetype)init;

//do the calculation
-(void)calculate;

@end
