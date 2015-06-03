//
//  ViewController.m
//  PSO
//
//  Created by Claudio Santos on 6/1/15.
//  Copyright (c) 2015 Claudio Santos. All rights reserved.
//

#import "ViewController.h"
#import "PSOCalculator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PSOCalculator * pso = [PSOCalculator new];
    pso.minimunValue = -100;
    pso.maximunValue = 100;
    pso.minimunVelocity = -5;
    pso.maximunVelocity = 5;
    [pso calculate];
    
    NSLog(@"Best value: %f", pso.bestResult);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
