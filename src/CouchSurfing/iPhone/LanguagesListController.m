//
//  LanguagesListController.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LanguagesListController.h"
#import "CouchSearchFilter.h"

@interface LanguagesListController ()

@property (nonatomic, retain) NSMutableArray *languagesGroups;
@property (nonatomic, retain) NSMutableArray *alphabet;
@property (nonatomic, retain) NSMutableDictionary *languageToIdDictionary;

- (void)chooseAnyLanguage;

@end

@implementation LanguagesListController

@synthesize languagesGroups = _languagesGroups;
@synthesize alphabet = _alphabet;
@synthesize languageToIdDictionary = _languageToIdDictionary;

@synthesize delegate = _delegate;

- (id)initWithFilter:(CouchSearchFilter *)filter {
	if ((self = [super init])) {
		_filter = filter;
	}
	
	return self;
}

- (void)dealloc {
	self.languagesGroups = nil;
	self.alphabet = nil;
	self.languageToIdDictionary = nil;
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
	UIBarButtonItem *anyLanguageItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ANY LANGUAGE", nil)
																		style:UIBarButtonItemStyleBordered
																	   target:self action:@selector(chooseAnyLanguage)] autorelease];
	self.navigationItem.rightBarButtonItem = anyLanguageItem;
	
	NSIndexPath *selectedIndexPath = nil;
	
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSString *languagesFilePath = [mainBundle pathForResource:@"Languages" ofType:@"plist"];
	NSArray *languagesData = [[NSArray alloc] initWithContentsOfFile:languagesFilePath];
	
	self.alphabet = [NSMutableArray array];
	self.languageToIdDictionary = [NSMutableDictionary dictionary];
	self.languagesGroups = [NSMutableArray array];
	
	NSString *currentAlpha = nil;
	NSMutableArray *currentGroup = nil;
	for (NSDictionary *languagePair in languagesData) {
		NSString *keyId = [[languagePair allKeys] lastObject];
		NSString *language = [[languagePair allValues] lastObject];
		NSString *alpha = [[language substringToIndex:1] uppercaseString];
		
		[self.languageToIdDictionary setObject:keyId forKey:language];
		if (![currentAlpha isEqualToString:alpha]) {
			[self.alphabet addObject:alpha];
			
			if (currentGroup != nil) {
				[self.languagesGroups addObject:currentGroup];				
			}
			
			[currentGroup release];
			currentGroup = [[NSMutableArray alloc] initWithObjects:language, nil];
			
			currentAlpha = alpha;
		} else {
			[currentGroup addObject:language];
		}

		if ([_filter.languageId isEqualToString:keyId]) {
			selectedIndexPath = [NSIndexPath indexPathForRow:[currentGroup count] - 1 inSection:[self.languagesGroups count]];
		}

	}
	
	[self.languagesGroups addObject:currentGroup];
	[currentGroup release]; currentGroup = nil;	
	[languagesData release];languagesData = nil;
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
											  style:UITableViewStylePlain];
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[_tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
	[self.view addSubview:_tableView];

    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Mark UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.alphabet count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self.languagesGroups objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"languageCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"languageCell"] autorelease];
	}
	NSString *language = [[self.languagesGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	cell.textLabel.text = language;
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.alphabet objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return self.alphabet;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *language = [[self.languagesGroups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString *languageId = [self.languageToIdDictionary objectForKey:language];
	_filter.languageId = languageId;
	_filter.languageName = language;
	if ([self.delegate respondsToSelector:@selector(languagesListDidSelectLanguage:)]) {
		[self.delegate languagesListDidSelectLanguage:self];
	}
}

#pragma Mark Action methods

- (void)chooseAnyLanguage {
	_filter.languageId = nil;
	if ([self.delegate respondsToSelector:@selector(languagesListDidSelectLanguage:)]) {
		[self.delegate languagesListDidSelectLanguage:self];
	}
}

@end
