//
//  RootViewController.m
//  MobileEmergency
//
//  Created by Seung Woon Lee on 11. 2. 11..
//  Copyright 2011 Soongsil. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize tableViewCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *deleteAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Download All" style:UIBarButtonItemStylePlain target:self action:@selector(downloadAll:)];          
	self.navigationItem.rightBarButtonItem = deleteAllButton;
	[deleteAllButton release];
	
	fininshed = TRUE;
	aDictionary = nil;
	tableData = [[NSMutableArray alloc] init];
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"StringResource" ofType:@"plist"];
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];		

	[self loadFromXML:[NSURL URLWithString:[dic objectForKey:@"xml_url"]]]; 
}

#pragma mark -
#pragma mark custom Funcs

- (void)loadFromXML:(NSURL *)xmlUrl {
	xParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlUrl];
	[xParser setDelegate:self];
	if ( ![xParser parse] ) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Check your internet connection or URL" delegate:nil cancelButtonTitle:@"Alright" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	[xParser release];
}

- (void)playTheMovie:(int)index {

	NSString *theMovie;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOCUMENTS_FOLDER error:nil];
	for (id fileName in files)
	{
		int count = [[fileName componentsSeparatedByString:@"."] count];
		if ( [[[fileName componentsSeparatedByString:@"."] objectAtIndex:count - 2] isEqualToString:[NSString stringWithFormat:@"%d",index]] ) {
			theMovie = fileName;
			break;
		} else {
			theMovie = nil;
		}
	}
	
	if ( theMovie == nil) 
		return;
	
	NSString *moviePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:theMovie];
	NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
		
	playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
	MPMoviePlayerController* moviePlayer = [playerController moviePlayer];
				
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
		
	[self presentMoviePlayerViewControllerAnimated:playerController];
	[playerController release];
}
	
- (void) playbackDidFinish:(NSNotification *)noti {
	
	MPMoviePlayerController *player = [noti object];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
	
	[player stop];
	[self dismissMoviePlayerViewControllerAnimated];	
}

- (void)downloadAll:(id)sender {
	[self.navigationItem.rightBarButtonItem setTitle:@"Downloading.."];
	[self.navigationItem.rightBarButtonItem setEnabled:NO];
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(downloadSeq:) userInfo:nil repeats:YES];
}

- (void)downloadSeq:(id)sender {
	static int index = 0;
	
	[self downloadMovie:index++];
	if (index == [tableData count]) {
		index = 0;
		[self.navigationItem.rightBarButtonItem setTitle:@"Download All"];
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
		[timer invalidate];
	}
}
- (void)downloadMovie:(int)index {
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOCUMENTS_FOLDER error:nil];
	for (id fileName in files)
	{
		int count = [[fileName componentsSeparatedByString:@"."] count];
		if ( [[[fileName componentsSeparatedByString:@"."] objectAtIndex:count - 2] isEqualToString:[NSString stringWithFormat:@"%d",index]] ) {
			return;
		} 
	}
	
	progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(255, 45 + 70 * index, 50, 20)]; 
	[progressBar setProgressViewStyle:UIProgressViewStyleBar];
	[progressBar setProgress:0];
	[self.view addSubview:progressBar]; 
	
	NSURL *movieURL = [NSURL URLWithString:[[tableData objectAtIndex:index] objectForKey:@"link"]];
	//NSURL *movieURL = [NSURL URLWithString:@"http://km.support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1211/sample_iTunes.mov"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:movieURL];
	[request setDelegate:self];
	[request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.%@",index,[[[movieURL absoluteString] componentsSeparatedByString:@"."] lastObject]]]];
	[request setDownloadProgressDelegate:progressBar];
	[request setShowAccurateProgress:YES];
	[request startAsynchronous];
}
	
- (void)requestFinished:(ASIHTTPRequest *)request
{
	[[self tableView] reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Download Failed" message:@"Check your internet connection or URL of the file" delegate:nil cancelButtonTitle:@"Alright" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	fininshed = YES;
}

#pragma mark -
#pragma mark NSXMLParser Delete

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	nextKey = elementName;
	[nextKey retain];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ( [elementName isEqualToString:@"item"] ) {
		[tableData addObject:aDictionary];
		[aDictionary release];
		aDictionary = [[NSMutableDictionary alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ( [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 )
		return;
	string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ( aDictionary == nil) {
		aDictionary = [[NSMutableDictionary alloc] init];
	}
	[aDictionary setObject:string forKey:nextKey];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Check your internet connection or URL" delegate:nil cancelButtonTitle:@"Alright" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[[self tableView] reloadData];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"movieListCell";
    
    movieListCell *cell = (movieListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
		cell = tableViewCell;
    }
    
	[cell setMovieListData:[tableData objectAtIndex:indexPath.row]];
	[[cell downloadButton] setTag:indexPath.row];
	
	NSString *theMovie;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOCUMENTS_FOLDER error:nil];
	for (id fileName in files)
	{
		int count = [[fileName componentsSeparatedByString:@"."] count];
		if ( [[[fileName componentsSeparatedByString:@"."] objectAtIndex:count - 2] isEqualToString:[NSString stringWithFormat:@"%d",indexPath.row]] ) {
			theMovie = fileName;
			break;
		} else {
			theMovie = nil;
		}
	}
	
	if ( theMovie != nil) {
		[[cell downloadButton] setEnabled:FALSE];
		[[cell downloadButton] setTitle:@"Play" forState:UIControlStateDisabled];
		[[cell downloadButton] setTitleColor:[UIColor orangeColor] forState:UIControlStateDisabled];
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // if download is complete for the cell  
	[self playTheMovie:indexPath.row];
}

#pragma mark -
#pragma mark Button Event

- (IBAction)onClickSubmitButton:(id)sender {
	selectedButton = sender;
	[self downloadMovie:[selectedButton tag]];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

