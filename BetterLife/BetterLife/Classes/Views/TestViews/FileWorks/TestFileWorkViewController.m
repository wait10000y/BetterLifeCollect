//
//  TestFileWorkViewController.m
//  BetterLife
//
//  Created by shiliang.wang on 14/12/25.
//  Copyright (c) 2014年 wsliang. All rights reserved.
//

#import "TestFileWorkViewController.h"

@interface TestFileWorkViewController ()

@end

@implementation TestFileWorkViewController
{
	CALayer *rootLayer;
  CAEmitterLayer *emitter;
  CAEmitterLayer *mortor;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


-(void)createFileItem
{
    //const char* fileName = [[[NSBundle mainBundle] pathForResource:@"tspark" ofType:@"png"] UTF8String];
	id img = (id) [UIImage imageNamed:@"tspark.png"].CGImage;
  
    //Invisible particle representing the rocket before the explosion
	CAEmitterCell *rocket = [CAEmitterCell emitterCell];
	rocket.emissionLongitude = M_PI / 2;
	rocket.emissionLatitude = 0;
	rocket.lifetime = 1.6;
	rocket.birthRate = 1;
	rocket.velocity = 400;
	rocket.velocityRange = 100;
	rocket.yAcceleration = -250;
	rocket.emissionRange = M_PI / 4;
  CGColorRef	color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
	rocket.color = color;
	CGColorRelease(color);
	rocket.redRange = 0.5;
	rocket.greenRange = 0.5;
	rocket.blueRange = 0.5;
  [rocket setName:@"rocket"];
    //Flare particles emitted from the rocket as it flys
	CAEmitterCell *flare = [CAEmitterCell emitterCell];
	flare.contents = img;
	flare.emissionLongitude = (4 * M_PI) / 2;
	flare.scale = 0.4;
	flare.velocity = 100;
	flare.birthRate = 45;
	flare.lifetime = 1.5;
	flare.yAcceleration = -350;
	flare.emissionRange = M_PI / 7;
	flare.alphaSpeed = -0.7;
	flare.scaleSpeed = -0.1;
	flare.scaleRange = 0.1;
	flare.beginTime = 0.01;
	flare.duration = 0.7;
  
    //The particles that make up the explosion
	CAEmitterCell *firework = [CAEmitterCell emitterCell];
	firework.contents = img;
	firework.birthRate = 9999;
	firework.scale = 0.6;
	firework.velocity = 130;
	firework.lifetime = 2;
	firework.alphaSpeed = -0.2;
	firework.yAcceleration = -80;
	firework.beginTime = 1.5;
	firework.duration = 0.1;
	firework.emissionRange = 2 * M_PI;
	firework.scaleSpeed = -0.1;
	firework.spin = 2;
    //preSpark is an invisible particle used to later emit the spark
	CAEmitterCell *preSpark = [CAEmitterCell emitterCell];
	preSpark.birthRate = 80;
	preSpark.velocity = firework.velocity * 0.70;
	preSpark.lifetime = 1.7;
	preSpark.yAcceleration = firework.yAcceleration * 0.85;
	preSpark.beginTime = firework.beginTime - 0.2;
	preSpark.emissionRange = firework.emissionRange;
	preSpark.greenSpeed = 100;
	preSpark.blueSpeed = 100;
	preSpark.redSpeed = 100;
	
    //Name the cell so that it can be animated later using keypath
	[preSpark setName:@"preSpark"];
	
    //The 'sparkle' at the end of a firework
	CAEmitterCell *spark = [CAEmitterCell emitterCell];
	spark.contents = img;
	spark.lifetime = 0.05;
	spark.yAcceleration = -250;
	spark.beginTime = 0.8;
	spark.scale = 0.4;
	spark.birthRate = 10;
	
	preSpark.emitterCells = [NSArray arrayWithObjects:spark, nil];
	rocket.emitterCells = [NSArray arrayWithObjects:flare, firework, preSpark, nil];
	mortor.emitterCells = [NSArray arrayWithObjects:rocket, nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  
	mortor = [CAEmitterLayer layer];
	mortor.emitterPosition = CGPointMake(320, 0);
	mortor.renderMode = kCAEmitterLayerAdditive;
  [self createFileItem];
  
  [self.view.layer addSublayer:mortor];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  float multiplier = 0.25f;
  
  CGPoint pt = [[touches anyObject] locationInView:self.view];
  
    //Create the emitter layer
  emitter = [CAEmitterLayer layer];
  emitter.emitterPosition = pt;
  emitter.emitterMode = kCAEmitterLayerOutline;
  emitter.emitterShape = kCAEmitterLayerLine;
  emitter.renderMode = kCAEmitterLayerAdditive;
  emitter.emitterSize = CGSizeMake(0, 0);
  
    //Create the emitter cell
  CAEmitterCell* particle = [CAEmitterCell emitterCell];
  particle.emissionLongitude = 0;
  particle.birthRate = multiplier * 1000.0;
  particle.lifetime = 1;
  particle.lifetimeRange = multiplier * 0.35;
  particle.velocity = 180;
  particle.velocityRange = 30;
  particle.emissionRange = 1.1;
  particle.scaleSpeed = 0.3; // was 0.3
  particle.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
  particle.contents = (__bridge id)([UIImage imageNamed:@"fire.png"].CGImage);
  particle.name = @"particle";
  
  emitter.emitterCells = [NSArray arrayWithObject:particle];
  [self.view.layer addSublayer:emitter];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint pt = [[touches anyObject] locationInView:self.view];

    // Disable implicit animations
  [CATransaction begin];
  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
  emitter.emitterPosition = pt;
  [CATransaction commit];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [emitter removeFromSuperlayer];
  emitter = nil;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [self touchesEnded:touches withEvent:event];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



@end




