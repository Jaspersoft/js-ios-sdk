//
//  JaspersoftAppDelegate.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 4/9/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JaspersoftAppDelegate.h"
#import "JSUIBaseRepositoryViewController.h"


@implementation JaspersoftAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize settingsController;
@synthesize searchController;
@synthesize samplesController;
@synthesize tabBarController;
@synthesize servers;
@synthesize client; // the active client

static JaspersoftAppDelegate *sharedInstance = nil;


+ (JaspersoftAppDelegate *)sharedInstance {
    return sharedInstance;
}


/*
- (IBAction)configureServers:(id)sender {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:window cache:YES];
	
	[navigationController.view removeFromSuperview];
	[window addSubview:settingsController.view];
	[UIView commitAnimations];
}
*/

- (IBAction)configureServersDone:(id)sender {
	

	[navigationController popToRootViewControllerAnimated:NO];
    [(JSUIBaseRepositoryViewController *)navigationController.topViewController clear];
    [(JSUIBaseRepositoryViewController *)navigationController.topViewController setClient: self.client];
    if ([searchController.topViewController respondsToSelector:@selector(clear)])
    {
        [searchController.topViewController performSelector:@selector(clear)];
    }
    [(JSUIBaseRepositoryViewController *)searchController.topViewController setClient: self.client];
    
    
    [tabBarController setSelectedIndex:0];
    
    [navigationController.topViewController performSelector:@selector(updateTableContent) withObject:nil afterDelay:0.0];
	
}


-(void)loadServers {
	
	if (servers == nil)
	{
		servers = [[NSMutableArray alloc] initWithCapacity:1];
	}
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
    NSInteger count = [prefs  integerForKey:@"jaspersoft.server.count"];
	
    NSInteger firstRun = [prefs  integerForKey:@"jaspersoft.mobile.firstRun"];
    
    if (count == 0)
    {
        //If this is the first time we are using this application, we should load a special demo configuration...
        if (firstRun == 0) // First run has never been set...
        {
            JSClient *tmpClient = [[JSClient alloc] initWithAlias: @"Jaspersoft Mobile Demo"
                                                         Username: @"joeuser"
                                                         Password: @"joeuser"
                                                     Organization: @""
                                                              Url: @"http://mobiledemo.jaspersoft.com/jasperserver-pro"];
            [servers addObject: tmpClient];
            [tmpClient release];
        }
    }
    
    
	for (NSInteger i=0; i<count; ++i) {
		
		JSClient *tmpClient = [[JSClient alloc] initWithAlias: [prefs objectForKey:[NSString stringWithFormat: @"jaspersoft.server.alias.%d",i]]
													 Username: [prefs objectForKey:[NSString stringWithFormat: @"jaspersoft.server.username.%d",i]]
													 Password: [prefs objectForKey:[NSString stringWithFormat: @"jaspersoft.server.password.%d",i]]
												 Organization: [prefs objectForKey:[NSString stringWithFormat: @"jaspersoft.server.organization.%d",i]]
														  Url: [prefs objectForKey:[NSString stringWithFormat: @"jaspersoft.server.baseUrl.%d",i]]];
		[servers addObject: tmpClient];
		[tmpClient release];
		
	}
	
	if (count > 0)
	{
		NSInteger activeServerIndex = [prefs integerForKey:@"jaspersoft.server.active"];
		if (activeServerIndex < 0 || activeServerIndex >= count) activeServerIndex = 0;
		
		client = (JSClient *)[servers objectAtIndex:activeServerIndex];
	}
    
}

-(void)setClient:(JSClient *)cl
{
	client = cl;
	NSInteger index = [servers indexOfObject:cl];
	
	if (index >= 0)
	{
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setInteger:index forKey:@"jaspersoft.server.active"];
	}
}


-(void)saveServers {
	if (servers == nil) return;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	for (NSInteger i=0; i< [servers count]; ++i)
	{
		JSClient *tmpClient = [servers objectAtIndex:i];
		
	    [prefs setObject: [tmpClient alias] forKey:[NSString stringWithFormat: @"jaspersoft.server.alias.%d",i]];
		[prefs setObject: [tmpClient baseUrl] forKey:[NSString stringWithFormat: @"jaspersoft.server.baseUrl.%d",i]];
		[prefs setObject: [tmpClient organization] forKey:[NSString stringWithFormat: @"jaspersoft.server.organization.%d",i]];
		
		// TODO: make store of password safe using SFHF....
		[prefs setObject: [tmpClient username] forKey:[NSString stringWithFormat: @"jaspersoft.server.username.%d",i]];
		[prefs setObject: [tmpClient password] forKey:[NSString stringWithFormat: @"jaspersoft.server.password.%d",i]];
	}
	[prefs setInteger: [servers count] forKey: @"jaspersoft.server.count"];
	[prefs synchronize];
	
	
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    sharedInstance = self;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger firstRun = [prefs  integerForKey:@"jaspersoft.mobile.firstRun"];
    
    
	[self loadServers];
    
    if (self.client != nil)
    {
        // Set the client to the repository view...
        [(JSUIBaseRepositoryViewController *)(navigationController.topViewController) setClient: self.client];
        [(JSUIBaseRepositoryViewController *)(searchController.topViewController) setClient: self.client];
    }
	
    NSArray* controllers = [NSArray arrayWithObjects:navigationController, searchController, samplesController, settingsController, nil];
    tabBarController.viewControllers = controllers;
    
    
    [self.window addSubview:tabBarController.view];
    
    if (firstRun == 0 || [servers count] == 0)
	{
        [tabBarController setSelectedIndex:3];
        
        if (firstRun == 0)
        {
            [self saveServers];
            [prefs setInteger:1 forKey:@"jaspersoft.mobile.firstRun"];
            [prefs synchronize];
        }
    }
	else
	{
        [tabBarController setSelectedIndex:0];
		
		[navigationController.topViewController performSelector:@selector(updateTableContent) withObject:nil afterDelay:0.0];
		
	}
    
    // Add the navigation controller's view to the window and display.
    

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	
	NSLog(@"Memory warning!!!");
}





- (void)dealloc {
    [tabBarController release];
	[navigationController release];
    [searchController release];
	[settingsController release];
    [samplesController release];
	[window release];
	[super dealloc];
}


@end

