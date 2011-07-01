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

#import "CouchRequestFormController.h"
#import "ProfileLocationCell.h"

@interface ProfileController ()

@property (nonatomic, retain) CouchSurfer *surfer;

- (void)sendCouchRequest;

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
	if (_imageObserved) {
		[self.surfer removeObserver:self forKeyPath:@"image"];		
	}
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
	if (self.surfer.couchStatus == CouchSurferHasCouchYes || self.surfer.couchStatus == CouchSurferHasCouchMaybe) {
		UIBarButtonItem *couchRequestBarButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"COUCHREQUEST", nil)
																				   style:UIBarButtonItemStyleBordered
																				  target:self 
																				  action:@selector(sendCouchRequest)] autorelease];
		self.navigationItem.rightBarButtonItem = couchRequestBarButton;
	}
	
    CGRect viewFrame = self.view.frame;
    _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height) style:UITableViewStyleGrouped] autorelease];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	_tableView.delegate = self;
	_tableView.dataSource = self;
    
    UIImage *headerBackgroundImage = [UIImage imageNamed:@"blackBg"];
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   headerBackgroundImage.size.width,
                                                                   headerBackgroundImage.size.height)] autorelease];
	headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
    headerView.backgroundColor = [UIColor colorWithPatternImage:headerBackgroundImage];
    _tableView.tableHeaderView = headerView;
    _photoView = [[[UIImageView alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 18 - 130,
                                                                18,
                                                                130,
                                                                130)] autorelease];
	_photoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	if (self.surfer.image != nil) {
		_photoView.image = [CSImageCropper scaleToSize:CGSizeMake(130, 130) image:self.surfer.image];
	} else {
		[self.surfer addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
		_imageObserved = YES;
	}
    [headerView addSubview:_photoView];
    
    UIImage *photoFrameImage = [UIImage imageNamed:@"photoFrameProfile"];
    UIImageView *photoFrameView = [[[UIImageView alloc] initWithFrame:CGRectMake(headerView.frame.size.width - photoFrameImage.size.width - 8.5,
                                                                                 8.5,
                                                                                 photoFrameImage.size.width,
                                                                                 photoFrameImage.size.height)] autorelease];
	photoFrameView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    photoFrameView.image = photoFrameImage;
    
	CGFloat photoBarViewHeight = 26;
	UIView *photoBarView = [[[UIView alloc] initWithFrame:CGRectMake(_photoView.frame.origin.x,
																	_photoView.frame.origin.y + _photoView.frame.size.height - photoBarViewHeight,
																	_photoView.frame.size.width,
																	photoBarViewHeight)] autorelease];
	
	photoBarView.backgroundColor = [UIColor whiteColor];
	photoBarView.alpha = 0.5;
	[headerView addSubview:photoBarView];

	UIImageView *couchStatusImageView = [[[UIImageView alloc] initWithImage:self.surfer.couchStatusImage] autorelease];
	CGFloat nextIconPosition = photoBarView.frame.origin.x + 4;
	couchStatusImageView.frame = CGRectMake(nextIconPosition, 
											photoBarView.frame.origin.y + 4,
											self.surfer.couchStatusImage.size.width,
											self.surfer.couchStatusImage.size.height);
	
	[headerView addSubview:couchStatusImageView];
	nextIconPosition += couchStatusImageView.frame.size.width + 4;
	
	
	if (self.surfer.vouched) {
		UIImage *vouchedImage = [UIImage imageNamed:@"iconVouched"];
		UIImageView *vouchedImageView = [[[UIImageView alloc] initWithImage:vouchedImage] autorelease];
		vouchedImageView.frame = CGRectMake(nextIconPosition, 
												photoBarView.frame.origin.y + 4,
												vouchedImage.size.width,
												vouchedImage.size.height);
		[headerView addSubview:vouchedImageView];
		nextIconPosition += vouchedImage.size.width + 4;
	}
	
	if (self.surfer.ambassador) {
		UIImage *ambassadorImage = [UIImage imageNamed:@"iconAmbassador"];
		UIImageView *ambassadorImageView = [[[UIImageView alloc] initWithImage:ambassadorImage] autorelease];
		ambassadorImageView.frame = CGRectMake(nextIconPosition, 
											photoBarView.frame.origin.y + 4,
											ambassadorImage.size.width,
											ambassadorImage.size.height);
		[headerView addSubview:ambassadorImageView];
		nextIconPosition += ambassadorImage.size.width + 4;
	}	
	
	if (self.surfer.verified) {
		UIImage *verifiedImage = [UIImage imageNamed:@"verified"];
		UIImageView *verifiedImageView = [[[UIImageView alloc] initWithImage:verifiedImage] autorelease];
		verifiedImageView.frame = CGRectMake(_photoView.frame.origin.x, 
											 _photoView.frame.origin.y,
											 verifiedImage.size.width,
											 verifiedImage.size.height);
		
		[headerView addSubview:verifiedImageView];
	}
	
	[headerView addSubview:photoFrameView];
	
	UIView *infoView = [[[UIView alloc] init] autorelease];
	CGFloat infoViewWidth = (int)headerView.frame.size.width - (photoFrameView.frame.size.width + 2 * 8.5) - 8.5;
	UILabel *nameLabel = [[[UILabel alloc] init] autorelease];
	nameLabel.backgroundColor = [UIColor clearColor];
	nameLabel.textColor = [UIColor whiteColor];
	nameLabel.font = [UIFont boldSystemFontOfSize:17];
	nameLabel.textAlignment = UITextAlignmentCenter;
	nameLabel.text = self.surfer.name;

	UILabel *basicsLabel = [[[UILabel alloc] init] autorelease];
	basicsLabel.backgroundColor = [UIColor clearColor];
	basicsLabel.textColor = [UIColor whiteColor];
	basicsLabel.font = [UIFont systemFontOfSize:17];
	basicsLabel.textAlignment = UITextAlignmentCenter;
	basicsLabel.text = self.surfer.basicsForProfile;
	
	//	Current Mission
	UILabel *currentMissionKeyLabel = [[[UILabel alloc] init] autorelease];
	currentMissionKeyLabel.backgroundColor = [UIColor clearColor];
	currentMissionKeyLabel.textColor = [UIColor whiteColor];
	currentMissionKeyLabel.font = [UIFont systemFontOfSize:10];
	currentMissionKeyLabel.textAlignment = UITextAlignmentCenter;
	currentMissionKeyLabel.text = NSLocalizedString(@"Current mission", nil);

	UILabel *currentMissionValueLabel = [[[UILabel alloc] init] autorelease];
	currentMissionValueLabel.backgroundColor = [UIColor clearColor];
	currentMissionValueLabel.textColor = [UIColor whiteColor];
	currentMissionValueLabel.font = [UIFont italicSystemFontOfSize:15];
	currentMissionValueLabel.textAlignment = UITextAlignmentCenter;
	currentMissionValueLabel.text = self.surfer.mission;
	currentMissionValueLabel.numberOfLines = 4;
		
	CGFloat currentMissionKeyLabelHeight = [currentMissionKeyLabel.text sizeWithFont:currentMissionKeyLabel.font].height;
	CGFloat currentMissionValueLabelHeight = [currentMissionValueLabel.text sizeWithFont:currentMissionValueLabel.font
																	   constrainedToSize:CGSizeMake(infoViewWidth, 80) 
																		   lineBreakMode:currentMissionValueLabel.lineBreakMode].height;
	UIView *currentMissionView = [[[UIView alloc] init] autorelease];
	
	[currentMissionView addSubview:currentMissionKeyLabel];
	[currentMissionView addSubview:currentMissionValueLabel];
	
	CGFloat nameLabelHeight = [self.surfer.name sizeWithFont:nameLabel.font].height;
	CGFloat basicsLabelHeight = [self.surfer.basicsForProfile sizeWithFont:basicsLabel.font].height;
	CGFloat currentMissionViewHeight = currentMissionKeyLabelHeight + currentMissionValueLabelHeight;
	
	CGFloat currentMissionViewPlaceholderHeight = MAX(currentMissionViewHeight, 80);
	currentMissionView.frame = CGRectMake(0,(currentMissionViewPlaceholderHeight - currentMissionViewHeight) / 2, infoView.frame.size.width, currentMissionViewHeight);
	
	CGFloat infoViewHeight = nameLabelHeight + basicsLabelHeight + currentMissionViewPlaceholderHeight;
	
	infoView.frame = CGRectMake(17,
								(int)(headerView.frame.size.height - infoViewHeight) / 2,
								infoViewWidth,
								infoViewHeight);
	
	nameLabel.frame = CGRectMake(0, 0, infoView.frame.size.width, nameLabelHeight);
	basicsLabel.frame = CGRectMake(0, nameLabelHeight, infoView.frame.size.width, basicsLabelHeight);
	currentMissionKeyLabel.frame = CGRectMake(0, 0, infoView.frame.size.width, currentMissionKeyLabelHeight);
	currentMissionValueLabel.frame = CGRectMake(0, currentMissionKeyLabelHeight, infoView.frame.size.width, currentMissionValueLabelHeight);	
		
	UIView *currentMissionViewPlaceholder = [[[UIView alloc] initWithFrame:CGRectMake(0, basicsLabelHeight + basicsLabel.frame.origin.y, infoViewWidth, currentMissionViewPlaceholderHeight)] autorelease];
	[currentMissionViewPlaceholder addSubview:currentMissionView];
	
	[infoView addSubview:nameLabel];
	[infoView addSubview:basicsLabel];
	[infoView addSubview:currentMissionViewPlaceholder];
	
    [headerView addSubview:infoView];
	
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

#pragma Mark UITableViewDelegate / DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1; //3
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else if(section == 1) {
		return 1;
	}
	return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	if (indexPath.section == 0) {
		ProfileLocationCell *customCell = (ProfileLocationCell *)[tableView dequeueReusableCellWithIdentifier:@"locationCell"];
		if (customCell == nil) {
			customCell = [[ProfileLocationCell alloc] initWithStyle:UITableViewCellStyleDefault
													reuseIdentifier:@"locationCell"];
		}		
		if (indexPath.row == 0) {
			customCell.keyLabel.text = NSLocalizedString(@"FROM", nil);
		} else if (indexPath.row == 1) {
			customCell.keyLabel.text = NSLocalizedString(@"LAST LOGIN", nil);
		}
		[customCell makeLayout];
		cell = customCell;
	}
	return cell;
}

#pragma Observing methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (self.surfer.image != nil) {
		_photoView.image = [CSImageCropper scaleToSize:CGSizeMake(130, 130) image:self.surfer.image];
	}
}

#pragma Mark Action methods

- (void)sendCouchRequest {
	CouchRequestFormController *controller = [[[CouchRequestFormController alloc] initWithSurfer:self.surfer] autorelease];
	[self presentModalViewController:controller animated:YES];
}

@end
