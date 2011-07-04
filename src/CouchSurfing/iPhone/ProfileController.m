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
#import "ProfileDetailController.h"

#import "ProfileLocationCell.h"
#import "CSSelectedValueCell.h"
#import "TouchXML.h"

@interface ProfileController ()

@property (nonatomic, retain) CouchSurfer *surfer;
@property (nonatomic, retain) ProfileRequest *profileRequest;

@property (nonatomic, retain) NSArray *sections;

@property (nonatomic, retain) CXMLDocument *doc;
@property (nonatomic, retain) NSArray *couchInfoValues;

- (void)sendCouchRequest;

- (void)loadProfile;

@end

@implementation ProfileController

@synthesize surfer = _surfer;
@synthesize profileRequest = _profileRequest;
@synthesize sections = _sections;
@synthesize doc = _doc;
@synthesize couchInfoValues = _couchInfoValues;

- (id)initWithSurfer:(CouchSurfer *)surfer {
	if ((self = [super init])) {
		self.surfer = surfer;
	}
	return self;
}

- (void)dealloc {
	self.profileRequest.delegate = nil;
	self.profileRequest = nil;
	if (_imageObserved) {
		[self.surfer removeObserver:self forKeyPath:@"image"];		
	}
	self.surfer = nil;
	self.sections = nil;
	self.couchInfoValues = nil;
	self.doc = nil;
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
	
	NSMutableArray *sections = [NSMutableArray array];
	[sections addObject:@"LOCATIONS"];
	if (self.surfer.about != nil) {
		[sections addObject:@"PERSONAL DESCRIPTION"];
	}
	
	[self loadProfile];
	[sections addObject:@"LOADING PROFILE"];
	
	self.sections = sections;
	
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
	photoBarView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	photoBarView.backgroundColor = [UIColor whiteColor];
	photoBarView.alpha = 0.5;
	[headerView addSubview:photoBarView];

	UIImageView *couchStatusImageView = [[[UIImageView alloc] initWithImage:self.surfer.couchStatusImage] autorelease];
	CGFloat nextIconPosition = photoBarView.frame.origin.x + 4;
	couchStatusImageView.frame = CGRectMake(nextIconPosition, 
											photoBarView.frame.origin.y + 4,
											self.surfer.couchStatusImage.size.width,
											self.surfer.couchStatusImage.size.height);
	couchStatusImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[headerView addSubview:couchStatusImageView];
	nextIconPosition += couchStatusImageView.frame.size.width + 4;
	
	
	if (self.surfer.vouched) {
		UIImage *vouchedImage = [UIImage imageNamed:@"iconVouched"];
		UIImageView *vouchedImageView = [[[UIImageView alloc] initWithImage:vouchedImage] autorelease];
		vouchedImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
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
		ambassadorImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
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
		verifiedImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		verifiedImageView.frame = CGRectMake(_photoView.frame.origin.x, 
											 _photoView.frame.origin.y,
											 verifiedImage.size.width,
											 verifiedImage.size.height);
		
		[headerView addSubview:verifiedImageView];
	}
	
	[headerView addSubview:photoFrameView];
	
	UIView *infoView = [[[UIView alloc] init] autorelease];
	infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	CGFloat infoViewWidth = (int)headerView.frame.size.width - (photoFrameView.frame.size.width + 2 * 8.5) - 8.5;
	UILabel *nameLabel = [[[UILabel alloc] init] autorelease];
	nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	nameLabel.backgroundColor = [UIColor clearColor];
	nameLabel.textColor = [UIColor whiteColor];
	nameLabel.font = [UIFont boldSystemFontOfSize:17];
	nameLabel.textAlignment = UITextAlignmentCenter;
	nameLabel.text = self.surfer.name;

	UILabel *basicsLabel = [[[UILabel alloc] init] autorelease];
	basicsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	basicsLabel.backgroundColor = [UIColor clearColor];
	basicsLabel.textColor = [UIColor whiteColor];
	basicsLabel.font = [UIFont systemFontOfSize:17];
	basicsLabel.textAlignment = UITextAlignmentCenter;
	basicsLabel.text = self.surfer.basicsForProfile;
	
	//	Current Mission
	UILabel *currentMissionKeyLabel = [[[UILabel alloc] init] autorelease];
	currentMissionKeyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	currentMissionKeyLabel.backgroundColor = [UIColor clearColor];
	currentMissionKeyLabel.textColor = [UIColor whiteColor];
	currentMissionKeyLabel.font = [UIFont systemFontOfSize:10];
	currentMissionKeyLabel.textAlignment = UITextAlignmentCenter;
	currentMissionKeyLabel.text = NSLocalizedString(@"Current mission", nil);

	_currentMissionValueLabel = [[[UILabel alloc] init] autorelease];
	_currentMissionValueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_currentMissionValueLabel.backgroundColor = [UIColor clearColor];
	_currentMissionValueLabel.textColor = [UIColor whiteColor];
	_currentMissionValueLabel.font = [UIFont italicSystemFontOfSize:15];
	_currentMissionValueLabel.textAlignment = UITextAlignmentCenter;
	_currentMissionValueLabel.text = self.surfer.mission;
	_currentMissionValueLabel.numberOfLines = 4;
		
	CGFloat currentMissionKeyLabelHeight = [currentMissionKeyLabel.text sizeWithFont:currentMissionKeyLabel.font].height;
	CGFloat currentMissionValueLabelHeight = [_currentMissionValueLabel.text sizeWithFont:_currentMissionValueLabel.font
																	   constrainedToSize:CGSizeMake(infoViewWidth, 80) 
																		   lineBreakMode:_currentMissionValueLabel.lineBreakMode].height;
	_currentMissionView = [[[UIView alloc] init] autorelease];
	_currentMissionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[_currentMissionView addSubview:currentMissionKeyLabel];
	[_currentMissionView addSubview:_currentMissionValueLabel];
	
	CGFloat nameLabelHeight = [self.surfer.name sizeWithFont:nameLabel.font].height;
	CGFloat basicsLabelHeight = [self.surfer.basicsForProfile sizeWithFont:basicsLabel.font].height;
	CGFloat currentMissionViewHeight = currentMissionKeyLabelHeight + currentMissionValueLabelHeight;
	
	CGFloat currentMissionViewPlaceholderHeight = 0;
	if (self.surfer.mission != nil) {
		currentMissionViewPlaceholderHeight = MAX(currentMissionViewHeight, 80);		
	}
	_currentMissionView.frame = CGRectMake(0,(int)(currentMissionViewPlaceholderHeight - currentMissionViewHeight) / 2, infoView.frame.size.width, currentMissionViewHeight);
	
	CGFloat infoViewHeight = nameLabelHeight + basicsLabelHeight + currentMissionViewPlaceholderHeight;
	
	infoView.frame = CGRectMake(17,
								(int)(headerView.frame.size.height - infoViewHeight) / 2,
								infoViewWidth,
								infoViewHeight);
	
	nameLabel.frame = CGRectMake(0, 0, infoView.frame.size.width, nameLabelHeight);
	basicsLabel.frame = CGRectMake(0, nameLabelHeight, infoView.frame.size.width, basicsLabelHeight);
	currentMissionKeyLabel.frame = CGRectMake(0, 0, infoView.frame.size.width, currentMissionKeyLabelHeight);
	_currentMissionValueLabel.frame = CGRectMake(0, currentMissionKeyLabelHeight, infoView.frame.size.width, currentMissionValueLabelHeight);	
		
	_currentMissionViewPlaceholder = [[[UIView alloc] initWithFrame:CGRectMake(0, basicsLabelHeight + basicsLabel.frame.origin.y, infoViewWidth, currentMissionViewPlaceholderHeight)] autorelease];
	_currentMissionViewPlaceholder.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_currentMissionViewPlaceholder addSubview:_currentMissionView];
	
	[infoView addSubview:nameLabel];
	[infoView addSubview:basicsLabel];
	if (self.surfer.mission != nil) {
		[infoView addSubview:_currentMissionViewPlaceholder];		
	}
	
    [headerView addSubview:infoView];
	
    [self.view addSubview:_tableView];
	
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	[UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"clothBg"]];
}

- (void)viewDidAppear:(BOOL)animated {
	if ([_tableView indexPathForSelectedRow] != nil) {
		[_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[_tableView reloadData];
	
}

#pragma Mark UITableViewDelegate / DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *sectionName = [self.sections objectAtIndex:section];
	if ([sectionName isEqualToString:@"LOCATIONS"]) {
		if (self.surfer.lastLoginLocation == nil) {
			return 1;
		}
		return 2;
	} else if([sectionName isEqualToString:@"PERSONAL DESCRIPTION"]) {
		return 1;
	} else if([sectionName isEqualToString:@"COUCH INFORMATION"]) {
		NSInteger num = [self.couchInfoValues count];
		if (self.surfer.couchInfoShort != nil) {
			num++;
		}
		return num;
	} else if ([sectionName isEqualToString:@"LOADING PROFILE"]) {
		return 1;
	}
	return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
	UITableViewCell *cell;
	
	if ([sectionName isEqualToString:@"LOCATIONS"]) {
		ProfileLocationCell *customCell = (ProfileLocationCell *)[tableView dequeueReusableCellWithIdentifier:@"locationCell"];
		if (customCell == nil) {
			customCell = [[[ProfileLocationCell alloc] initWithStyle:UITableViewCellStyleDefault
													reuseIdentifier:@"locationCell"] autorelease];
			customCell.selectionStyle = UITableViewCellSelectionStyleNone;
		}		
		if (indexPath.row == 0) {
			customCell.keyLabel.text = NSLocalizedString(@"FROM", nil);
			customCell.valueLabel.text = self.surfer.livesIn;
		} else if (indexPath.row == 1) {
			customCell.keyLabel.text = NSLocalizedString(@"LAST LOGIN", nil);
			customCell.valueLabel.text = self.surfer.lastLoginLocation;
			customCell.dateLabel.text = self.surfer.lastLoginDate;
		}
		[customCell makeLayout];
		cell = customCell;
	} else if ([sectionName isEqualToString:@"PERSONAL DESCRIPTION"]) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textCell"] autorelease];			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			UILabel *textLabel = [[[UILabel alloc] init] autorelease];
			textLabel.font = [UIFont systemFontOfSize:12];
			textLabel.numberOfLines = 0;
			textLabel.tag = 1;
			[cell.contentView addSubview:textLabel];
		}

		UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1];
		textLabel.text = self.surfer.about;
		CGFloat tableViewWidth = _tableView.frame.size.width;
		textLabel.frame = CGRectMake(7,
									 7,
									 tableViewWidth - 50,
									 [self.surfer.about sizeWithFont:[UIFont systemFontOfSize:12]
												   constrainedToSize:CGSizeMake(tableViewWidth - 50, 120)].height);
	} else if ([sectionName isEqualToString:@"COUCH INFORMATION"]) {
		if ([self.couchInfoValues count] > indexPath.row) {
			NSArray *pair = [self.couchInfoValues objectAtIndex:indexPath.row];
			CSSelectedValueCell *customCell = (CSSelectedValueCell *)[tableView dequeueReusableCellWithIdentifier:@"couchInfoCell"];
			if (customCell == nil) {
				customCell = [[[CSSelectedValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"couchInfoCell"] autorelease];
			}
			customCell.keyLabel.text = [pair objectAtIndex:1];
			customCell.selectedValueLabel.text = [pair objectAtIndex:0];
			customCell.selectionStyle = UITableViewCellEditingStyleNone;
			[customCell makeLayout];
			cell = customCell;
		} else if (indexPath.row - [self.couchInfoValues count] == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textCell"] autorelease];			
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				UILabel *textLabel = [[[UILabel alloc] init] autorelease];
				textLabel.font = [UIFont systemFontOfSize:12];
				textLabel.numberOfLines = 0;
				textLabel.tag = 1;
				[cell.contentView addSubview:textLabel];
			}
			
			UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1];
			textLabel.text = self.surfer.couchInfoShort;
			CGFloat tableViewWidth = _tableView.frame.size.width;
			textLabel.frame = CGRectMake(7,
										 7,
										 tableViewWidth - 50,
										 [self.surfer.couchInfoShort sizeWithFont:[UIFont systemFontOfSize:12]
													   constrainedToSize:CGSizeMake(tableViewWidth - 50, 120)].height);			
		}
	} else if([sectionName isEqualToString:@"LOADING PROFILE"]) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"loadingMoreCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadingMoreCell"] autorelease];
			//Setup indicator view
			UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
			activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
			[activityView startAnimating];
			
			//setup label
			UILabel *loadingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(activityView.frame.size.width + 5, 0, 0, 0)] autorelease];
			loadingLabel.backgroundColor = [UIColor clearColor];
			loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
			loadingLabel.text = NSLocalizedString(@"LOADING MORE", nil);
			[loadingLabel sizeToFit];
			
			//setup containing view
			CGFloat loadingViewWidth = loadingLabel.frame.origin.x + loadingLabel.frame.size.width;
			CGFloat loadingViewHeight = loadingLabel.frame.size.height;
			UIView *loadingView = [[[UIView alloc] initWithFrame:CGRectMake((int)(cell.contentView.frame.size.width - loadingViewWidth) / 2, (int)(cell.contentView.frame.size.height - loadingViewHeight) / 2, loadingViewWidth, loadingViewHeight)] autorelease];
			loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
			[loadingView addSubview:activityView];
			[loadingView addSubview:loadingLabel];
			
			[cell.contentView addSubview:loadingView];
		}
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
	
	if ([sectionName isEqualToString:@"PERSONAL DESCRIPTION"] || ([sectionName isEqualToString:@"COUCH INFORMATION"] && indexPath.row - [self.couchInfoValues count] == 0)) {
		CGFloat tableViewWidth = _tableView.frame.size.width;
		CGSize size = CGSizeMake(tableViewWidth - 50, 120);
		NSString *forText = nil;
		if ([sectionName isEqualToString:@"PERSONAL DESCRIPTION"]) {
			forText = self.surfer.about;
		} else if ([sectionName isEqualToString:@"COUCH INFORMATION"] && indexPath.row - [self.couchInfoValues count] == 0) {
			forText = self.surfer.couchInfoShort;
		}
		return [forText sizeWithFont:[UIFont systemFontOfSize:12]
							 constrainedToSize:CGSizeMake(size.width, size.height)].height + 14;
	}
	
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *sectionName = [self.sections objectAtIndex:section];
	if ([sectionName isEqualToString:@"PERSONAL DESCRIPTION"] || [sectionName isEqualToString:@"LOADING PROFILE"]) {
		return @"";
	}
	
	return NSLocalizedString(sectionName, nil);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
	if ([sectionName isEqualToString:@"PERSONAL DESCRIPTION"]) {
		ProfileDetailController *controller;
		if (self.doc != nil) {
			if (self.surfer.personalDescription == nil) {
				self.surfer.personalDescription = [ProfileRequest parsePersonalDescription:self.doc];
			}
			controller = [[[ProfileDetailController alloc] initWithHtmlString:self.surfer.personalDescription] autorelease];
		} else {
			_parsePersonalDescriptionAfterProfileDidLoad = YES;
			controller = [[[ProfileDetailController alloc] initWithSurfer:self.surfer property:@"personalDescription"] autorelease];			
		}
		
		[self.navigationController pushViewController:controller animated:YES];
	} else if ([sectionName isEqualToString:@"COUCH INFORMATION"] && indexPath.row == [self.couchInfoValues count]) {
		ProfileDetailController *controller = [[[ProfileDetailController alloc] initWithHtmlString:self.surfer.couchInfoHtml] autorelease];
		[self.navigationController pushViewController:controller animated:YES];
	}
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

#pragma Mark ProfileRequestDelegate methods

- (void)profileRequestDidFillSurfer:(ProfileRequest *)request withResultDocument:(CXMLDocument *)doc {
	
	self.doc = doc;
	
	NSMutableArray *couchInfoValues = [NSMutableArray array];
	if (self.surfer.couchStatusName != nil) {
		[couchInfoValues addObject:[NSArray arrayWithObjects:self.surfer.couchStatusName, NSLocalizedString(@"COUCH STATUS", nil), nil]];
	}
	if (self.surfer.preferredGender != nil) {
		[couchInfoValues addObject:[NSArray arrayWithObjects:self.surfer.preferredGender, NSLocalizedString(@"PREFERRED GENDER", nil), nil]];
	}
	 if (self.surfer.maxSurfersPerNight != nil) {
		 [couchInfoValues addObject:[NSArray arrayWithObjects:self.surfer.maxSurfersPerNight, NSLocalizedString(@"MAX SURFERS PER NIGHT", nil), nil]];
	 }
	if (self.surfer.sharedSleepSurface != nil) {
		[couchInfoValues addObject:[NSArray arrayWithObjects:self.surfer.sharedSleepSurface, NSLocalizedString(@"SHARED SLEEP SURFACE", nil), nil]];
	}
	if (self.surfer.sharedRoom != nil) {
		[couchInfoValues addObject:[NSArray arrayWithObjects:self.surfer.sharedRoom, NSLocalizedString(@"SHARED ROOM", nil), nil]];
	}
	
	self.couchInfoValues = couchInfoValues;
	if ([self.surfer hasSomeCouchInfo]) {
		NSMutableArray *sections = [[self.sections mutableCopy] autorelease];
		[sections removeLastObject];
		[sections addObject:@"COUCH INFORMATION"];
		self.sections = sections;
	}
	
	if (_parsePersonalDescriptionAfterProfileDidLoad) {
		self.surfer.personalDescription = [ProfileRequest parsePersonalDescription:self.doc];
	}
	
	[_tableView reloadData];
}

#pragma Mark Private methods

- (void)loadProfile {
	self.profileRequest = [[[ProfileRequest alloc] init] autorelease];
	self.profileRequest.delegate = self;
	self.profileRequest.surfer = self.surfer;
	[self.profileRequest sendProfileRequest];
}

@end
