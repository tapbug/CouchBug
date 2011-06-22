//
//  ProfileController.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileController.h"
#import "CSImageCropper.h"

#import "CouchSurfer.h"

@interface ProfileController ()

@property (nonatomic, retain) CouchSurfer *surfer;

@end

@implementation ProfileController

@synthesize surfer = _surfer;

- (id)initWithSurfer:(CouchSurfer *)surfer {
	if ((self = [super init])) {
		self.surfer = surfer;
	}
	return self;
}

- (void)dealloc {
	[self.surfer removeObserver:self forKeyPath:@"image"];
	self.surfer = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	self.navigationItem.title = self.surfer.name;
	
    CGRect viewFrame = self.view.frame;
    _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height)] autorelease];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *headerBackgroundImage = [UIImage imageNamed:@"blackBg"];
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   headerBackgroundImage.size.width,
                                                                   headerBackgroundImage.size.height)] autorelease];
    headerView.backgroundColor = [UIColor colorWithPatternImage:headerBackgroundImage];
    _tableView.tableHeaderView = headerView;
    _photoView = [[[UIImageView alloc] initWithFrame:CGRectMake(18,
                                                                18,
                                                                130,
                                                                130)] autorelease];
	if (self.surfer.image != nil) {
		_photoView.image = [CSImageCropper scaleToSize:CGSizeMake(130, 130) image:self.surfer.image];		
	} else {
		[self.surfer addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
	}
    [headerView addSubview:_photoView];
    
    UIImage *photoFrameImage = [UIImage imageNamed:@"photoFrameProfile"];
    UIImageView *photoFrameView = [[[UIImageView alloc] initWithFrame:CGRectMake(8.5,
                                                                                 8.5,
                                                                                 photoFrameImage.size.width,
                                                                                 photoFrameImage.size.height)] autorelease];
    photoFrameView.image = photoFrameImage;
    [headerView addSubview:photoFrameView];
    
    
    [self.view addSubview:_tableView];
	
	
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma Observing methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (self.surfer.image != nil) {
		_photoView.image = [CSImageCropper scaleToSize:CGSizeMake(130, 130) image:self.surfer.image];
	}
}

@end
