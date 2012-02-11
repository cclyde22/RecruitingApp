/*
 * AppController.j
 * ChartPlotter
 *
 * Created by ofosho on November 10, 2010.
 * Copyright 2010, OTech Engineering Inc All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <AppKit/CPView.j>
@import "FilterBar.j"
@import "ListDataSource.j"
@import "GroupDataSource.j"
@import "globals.j"
@import "CPNumberCommas.j"
@import "CPStringCommaStrip.j"

@implementation AppController : CPObject
{
	CPSplitView verticalSplitter;
	CPView scrollParentView;
	CPView leftView;
	CPView rightView;
	CPSearchField searchField;
	CPTableView tableView;
	CPTableView groupView;
	CPScrollView scrollView;
	CPScrollView groupScrollView;
	ListDataSource listDS;
	GroupDataSource groupDS;
	JSObject headerColor;
	FilterBar filterBar;
}
- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
		contentView = [theWindow contentView];

	[[CPNotificationCenter defaultCenter ]
		addObserver:self
		selector:@selector(reloadData:)
		name:resetNoti
		object:nil];	

	[self splitPage:[contentView bounds]];
	[self createGroupView];
	[self createListView];
	[self createSearchField];

	[self combineViews];

	// add vertical splitter (entire page) to contentview
	[contentView addSubview:verticalSplitter];

	[self createMenu];
	[theWindow orderFront:self];
	
}

- (@action)createPopup:(id)sender withURL:(CPString)aURL
{
	var success = true;
	var theURL;
	if([sender title] == "Add Prospect"){
		theURL = @"php/addProspect.php";
	}
	else if([sender title] == "View/Edit Prospect"){
		var i = [[tableView selectedRowIndexes] firstIndex];
	//[webViewWin setMainFrameURL:detailsURL+[row objectForKey:groupColHeaderName]];
		if(i != -1){
			var row = [[listDS objsToDisplay] objectAtIndex:i];
			theURL = viewProspectURL + "?name=" + encodeURI([row objectForKey:"Name"]);
		}
		else
			success = false;
		console.log(theURL);
	}
	else if([sender title] == "Add Contact"){
		var i = [[firmView selectedRowIndexes] firstIndex];
		if(i != -1)
			theURL = addContactURL + "?firm=" + [[firmDS objs] objectAtIndex:i];
		else
			success = false;
	}
	else if([sender title] == "Add Note"){
		var i = [[firmView selectedRowIndexes] firstIndex];
		var j = [[fundView selectedRowIndexes] firstIndex];
		if(i != -1 && j != -1)
			theURL = addNoteURL + "?firm=" + [[firmDS objs] objectAtIndex:i] + "&fund=" + [[fundDS objs] objectAtIndex:j];
		else
			success = false;
	}
	else if([sender title] == "Add Bberg Info"){
		var i = [[firmView selectedRowIndexes] firstIndex];
		var j = [[fundView selectedRowIndexes] firstIndex];
		if(i != -1 && j != -1)
			theURL = addBbergInfoURL + "?fund=" + [[fundDS objs] objectAtIndex:j];
		else
			success = false;
	}
	if(success){
		var newWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(250, 70, 850, 500) styleMask:CPClosableWindowMask | CPResizableWindowMask];
		[newWindow orderFront:self];
		[newWindow setDelegate:self];
		var contentView = [newWindow contentView],
		bounds = [contentView bounds];

		[contentView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];

		var newWebView = [[CPWebView alloc] initWithFrame:bounds];
		[newWebView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
		[newWebView setMainFrameURL:theURL];

		[contentView addSubview:newWebView];
	}
	else{
		var theAlert = [[CPAlert alloc] init];
		[theAlert setMessageText:@"You Need to Select a Prospect"];
		[theAlert setTitle:@"Error"];
		[theAlert addButtonWithTitle:@"OK"];
		[theAlert runModal];
	}
	
}

- (void)reloadData:(CPNotification)aNotification
{
	[listDS getList:requestListURL + "?" + groupColId + "=" + [[groupDS objs] objectAtIndex:[groupView selectedRow]]];
	[searchField setStringValue:@""];
	[filterBar hideFilterBar:nil];

  [tableView deselectAll];
}
- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
	var i = [[[aNotification object] selectedRowIndexes] firstIndex];
	if(groupView === [aNotification object]){
	    [self reloadData:nil];
	}
}
- (void)openLink:(id)sender
{
    window.location = "/";
}

- (void)createMenu
{
	[CPMenu setMenuBarVisible:YES];
	var theMenu = [[CPApplication sharedApplication] mainMenu];

	var mainMenuItem = [[CPMenuItem alloc] initWithTitle:@"" action:@selector(openLink:) keyEquivalent:nil]; 
	[mainMenuItem setImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"home.png"] size:CGSizeMake(15,15)]];
	var viewProspectMenuItem = [[CPMenuItem alloc] initWithTitle:viewProspect action:@selector(createPopup:withURL:) keyEquivalent:nil];
	//var editProspectMenuItem = [[CPMenuItem alloc] initWithTitle:editProspect action:@selector(createPopup:withURL:) keyEquivalent:nil];
	var addProspectMenuItem = [[CPMenuItem alloc] initWithTitle:addProspect action:@selector(createPopup:withURL:) keyEquivalent:nil];
	var delProspectsMenuItem = [[CPMenuItem alloc] initWithTitle:delProspects action:@selector(createPopup:withURL:) keyEquivalent:nil];
	var uploadFileMenuItem = [[CPMenuItem alloc] initWithTitle:uploadFile action:@selector(createPopup:withURL:) keyEquivalent:nil];

	[theMenu removeItemAtIndex:[theMenu indexOfItemWithTitle: @"New" ]];
	[theMenu removeItemAtIndex:[theMenu indexOfItemWithTitle: @"Open"]];
	[theMenu removeItemAtIndex:[theMenu indexOfItemWithTitle: @"Save"]];

	[theMenu insertItem:mainMenuItem atIndex: 0];
	//[theMenu insertItem:editProspectMenuItem atIndex: 2];
	[theMenu insertItem:addProspectMenuItem atIndex: 1];
	[theMenu insertItem:viewProspectMenuItem atIndex: 2];
	[theMenu insertItem:delProspectsMenuItem atIndex: 3];
	[theMenu insertItem:uploadFileMenuItem atIndex: 4];
}
- (void)createGroupView
{
	groupScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth([leftView bounds]), CGRectGetHeight([leftView bounds])-50)];
	[groupScrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[groupScrollView setAutohidesScrollers:YES];

	groupView = [[CPTableView alloc] initWithFrame:[groupScrollView bounds]];
	groupDS = [[GroupDataSource alloc] initWithTable:groupView selectIndex:0];
	[groupDS getGroups:requestGroupURL];
	[groupView setIntercellSpacing:CGSizeMakeZero()];
	[groupView setHeaderView:nil];
	[groupView setCornerView:nil];
	[groupView setDelegate:self];
	[groupView setDataSource:groupDS];
	[groupView setAllowsEmptySelection:NO];
	[groupView setBackgroundColor:[CPColor colorWithHexString:groupViewColor]];

	var column = [[CPTableColumn alloc] initWithIdentifier:groupColId];
	[column setWidth:220.0];
	[column setMinWidth:50.0];

	[groupView addTableColumn:column];
	[groupView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
	[groupView setRowHeight:26.0];

	[groupScrollView setDocumentView:groupView];
}
- (void)createListView
{
	//create view to hold scrollView and filterBar
	scrollParentView = [[CPView alloc] initWithFrame:[rightView bounds]];
	// create a CPScrollView that will contain the CPTableView
	scrollView = [[CPScrollView alloc] initWithFrame:[scrollParentView bounds]];
	[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable]; 
	[scrollView setAutohidesScrollers:YES];
	// create the CPTableView
	tableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
	listDS = [[ListDataSource alloc] initWithTable:tableView];
	[listDS setDelegate:self];
	[tableView setDataSource:listDS];
	[tableView setAllowsEmptySelection:NO];
	[tableView setUsesAlternatingRowBackgroundColors:YES];
	[tableView setAllowsMultipleSelection:YES];
	[tableView setDelegate:self];
	[tableView setTarget:self];
	//[tableView setDoubleAction:@selector(createPopup:withURL:)]; 
	[tableView setCornerView:nil];
}

- (void)createSearchField
{
  searchField = [[CPSearchField alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
	[searchField setEditable:YES];
	[searchField setPlaceholderString:@"search and hit enter"];
	[searchField setBordered:YES];
	[searchField setBezeled:YES];
	[searchField setFont:[CPFont systemFontOfSize:12.0]];
	[searchField setTarget:listDS];
	[searchField setAction:@selector(searchChanged:)];
	[searchField setSendsWholeSearchString:NO]; 
}
- (void)columnsReady
{
	filterBar = [[FilterBar alloc] initWithFrame:CGRectMake(0, 0, 400, 32) 
	colHeaders:[listDS columnHeaders] 
	container:scrollParentView adjust:scrollView];
	[filterBar setAutoresizingMask:CPViewWidthSizable];
	[filterBar setDelegate:listDS];

	[scrollView setDocumentView:tableView]; 
}
- (void)splitPage:(CGRect)aBounds
{
	// create a view to split the page by left/right
	verticalSplitter = [[CPSplitView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(aBounds), CGRectGetHeight(aBounds))];
	[verticalSplitter setDelegate:self];
	[verticalSplitter setVertical:YES]; 
	[verticalSplitter setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];
	[verticalSplitter setIsPaneSplitter:YES]; //1px splitter line	

	//create left/right views
	leftView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 200, CGRectGetHeight([verticalSplitter bounds]))];
	[leftView setBackgroundColor:[CPColor colorWithHexString:leftViewColor]];
	rightView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([verticalSplitter bounds])-CGRectGetWidth([leftView bounds]), CGRectGetHeight([verticalSplitter bounds]) - 28)];
	[rightView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];

}
- (void)combineViews
{
	// add search bar/groups to leftview
	[leftView addSubview:searchField];
	[leftView addSubview:groupScrollView];

	// add scrollView/webView to right side of page
	[scrollParentView addSubview:scrollView];
	[rightView addSubview:scrollParentView];

	// add the left/right view to the veritcalview
	[verticalSplitter addSubview:leftView];
	[verticalSplitter addSubview:rightView];
}
@end
