//
//  Sample7.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sample7.h"
#import "Sample7ViewController.h"


@implementation Sample7


+(void)runSample:(JSClient *)client parentViewController: (UIViewController *)controller
{
    
    Sample7ViewController *sample7ViewController = [[Sample7ViewController alloc] initWithNibName:@"Sample7ViewController" bundle: nil];
    
    [sample7ViewController setParentController: controller];
    [sample7ViewController setClient: client];
    
    
    [[controller navigationController] pushViewController:sample7ViewController animated:TRUE];
    
}
@end
