//
//  MoreController.m
//  CouchSurfing
//
//  Created on 6/9/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "MoreController.h"
#import "CSWebViewController.h"
#import "FlurryAPI.h"

@implementation MoreController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	self.title = NSLocalizedString(@"More", nil);
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"clothBg"]];
	_tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
											  style:UITableViewStyleGrouped] autorelease];
	
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 100)];
	_tableView.tableFooterView = footerView;
	
	UIView *footerContentView = [[[UIView alloc] init] autorelease];
	footerContentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[footerView addSubview:footerContentView];
	UIImageView *iconView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appIconRounded"]] autorelease];
	
	UILabel *appLabel = [[[UILabel alloc] init] autorelease];
	UILabel *companyLabel = [[[UILabel alloc] init] autorelease];
	
	appLabel.text = @"CouchBug";
	appLabel.font = [UIFont boldSystemFontOfSize:18];
	appLabel.backgroundColor = [UIColor clearColor];
	[appLabel sizeToFit];
	
	UILabel *versionLabel = [[[UILabel alloc] init] autorelease];
	versionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	versionLabel.backgroundColor = [UIColor clearColor];
	versionLabel.font = [UIFont systemFontOfSize:18];
	[versionLabel sizeToFit];
	
	companyLabel.text = @"created by tapbug";
	companyLabel.backgroundColor = [UIColor clearColor];
	companyLabel.font = [UIFont systemFontOfSize:18];
	[companyLabel sizeToFit];
	
	CGFloat footerContentWidth = iconView.frame.size.width + companyLabel.frame.size.width + 10;
	CGFloat footerContentHeight = iconView.frame.size.height;
	
	
	footerContentView.frame = CGRectMake((int)(_tableView.frame.size.width - footerContentWidth) / 2,
										 (int)(footerView.frame.size.height - footerContentHeight) / 2,
										 footerContentWidth,
										 footerContentHeight);
	
	appLabel.frame = CGRectMake(iconView.frame.origin.x + iconView.frame.size.width + 10,
								7,
								appLabel.frame.size.width, 
								appLabel.frame.size.height);
	companyLabel.frame = CGRectMake(iconView.frame.origin.x + iconView.frame.size.width + 10,
									27,
									companyLabel.frame.size.width, 
									companyLabel.frame.size.height);
	
	versionLabel.frame = CGRectMake(appLabel.frame.size.width + appLabel.frame.origin.x + 5,
									appLabel.frame.origin.y,
									versionLabel.frame.size.width,
									versionLabel.frame.size.height);
	
	[footerContentView addSubview:iconView];
	[footerContentView addSubview:appLabel];
	[footerContentView addSubview:companyLabel];
	[footerContentView addSubview:versionLabel];
	[footerView addSubview:footerContentView];
	
	[self.view addSubview:_tableView];
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
	NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
	if (indexPath) {
		[_tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma Mark UITableViewDelegate / DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else if (section == 1) {
		return 5;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	}
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(@"ABOUT", nil);
			cell.imageView.image = [UIImage imageNamed:@"LinkAbout"];
		} else if (indexPath.row == 1) {
			cell.textLabel.text = NSLocalizedString(@"FAQ", nil);
			cell.imageView.image = [UIImage imageNamed:@"LinkFAQ"];
		}
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(@"ABOUT", nil);			
			cell.imageView.image = [UIImage imageNamed:@"LinkAbout"];
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"Twitter";
			cell.imageView.image = [UIImage imageNamed:@"LinkTwitter"];
		} else if (indexPath.row == 2) {
			cell.textLabel.text = @"Facebook";
			cell.imageView.image = [UIImage imageNamed:@"LinkFacebook"];
		} else if (indexPath.row == 3) {
			cell.textLabel.text = @"CouchSurfing Group";
			cell.imageView.image = [UIImage imageNamed:@"LinkCouchSurfing"];
	} else if (indexPath.row == 4) {
			cell.textLabel.text = NSLocalizedString(@"REVIEW ON ITUNES", nil);
			cell.imageView.image = [UIImage imageNamed:@"LinkAppStore"];
		}
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"COUCHSURFING", nil);
	} else if (section == 1) {
		return NSLocalizedString(@"COUCHBUG", nil);
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			CSWebViewController *webController = [[[CSWebViewController alloc] init] autorelease];
			webController.urlString = @"http://dl.dropbox.com/u/6223494/CouchBug/AboutCS.html";
			[self.navigationController pushViewController:webController animated:YES];
			[FlurryAPI logEvent:@"LinkClick" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
														 @"About CS", 
														 @"Link", 
														 nil]];
		} else if (indexPath.row == 1) {
			CSWebViewController *webController = [[[CSWebViewController alloc] init] autorelease];
			webController.urlString = @"http://dl.dropbox.com/u/6223494/CouchBug/FAQ.html";
			[self.navigationController pushViewController:webController animated:YES];
			[FlurryAPI logEvent:@"LinkClick" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															 @"FAQ CS", 
															 @"Link", 
															 nil]];
		}
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			CSWebViewController *webController = [[[CSWebViewController alloc] init] autorelease];
			webController.urlString = @"http://dl.dropbox.com/u/6223494/CouchBug/AboutCB.html";
			[self.navigationController pushViewController:webController animated:YES];
		} else if(indexPath.row == 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/CouchBug"]];
			[FlurryAPI logEvent:@"LinkClick" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															 @"Twitter CB", 
															 @"Link", 
															 nil]];
		} else if (indexPath.row == 2) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/CouchBugApp"]];
			[FlurryAPI logEvent:@"LinkClick" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															 @"Facebook CB", 
															 @"Link", 
															 nil]];
		} else if (indexPath.row == 3) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.couchsurfing.org/group.html?gid=44209"]];
			[FlurryAPI logEvent:@"LinkClick" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															 @"Group CB", 
															 @"Link", 
															 nil]];
		} else if (indexPath.row == 4) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=448515181"]];
			[FlurryAPI logEvent:@"LinkClick" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															 @"Review", 
															 @"Link", 
															 nil]];
		}
	}
}

@end
 