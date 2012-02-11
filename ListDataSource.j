@implementation ListDataSource : CPObject
{
  id delegate @accessors;
	CPString searchFilter;
	JSObject selFilter;
	JSObject objs;
	JSObject objsToDisplay @accessors;
	CPArray columnHeaders @accessors;
	CPTableView theTable;
}
- (id)initWithTable:(CPTableView)aTable
{
	if(self = [super init])
	{
		searchFilter = nil;
		selFilter = 0;
		objs = [];
		objsToDisplay = [];
		theTable = aTable;
	}
	return self;
}
- (void)getList:(CPString)aURL
{
	var request = [CPURLRequest requestWithURL:aURL];
	[[CPURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data
{
	objs = [];
    var JSONLists = [data objectFromJSON];
    // loop through everything and create a dictionary in place of the JSObject adding it to the array
    for (var i = 0; i < JSONLists.length; i++)
        objs[i] = [CPDictionary dictionaryWithJSObject:JSONLists[i] recursively:NO];
		
	objsToDisplay = objs;
	
	if([objs count] && !columnHeaders){
		columnHeaders = [objs[0] allKeys];
        [self addColumns];
	}
	else
		[theTable reloadData];
}
- (void)addColumns
{
	for(var i=0;i < [columnHeaders count];i++){
		var headerKey = [columnHeaders objectAtIndex:i];
		var desc = [CPSortDescriptor sortDescriptorWithKey:headerKey ascending:NO];
		var column = [[CPTableColumn alloc] initWithIdentifier:headerKey];
		[[column headerView] setStringValue:headerKey];
		[column setWidth:colWidth];
		[column setEditable:YES];
		[column setSortDescriptorPrototype:desc];
		[[column headerView] setBackgroundColor:headerColor];
		[theTable addTableColumn:column];
	}

    [delegate columnsReady];

	//[[CPNotificationCenter defaultCenter]
		//postNotificationName:createFilterBarNoti object:theTable];	
	
	[theTable reloadData];
}
- (void)connection:(CPURLConnection)aConnection didFailWithError:(CPString)error
{
    alert(error);
}
- (void)insertNewDataPoint:(CPString)aPoint intoObject:(CPString)aObject
{
    var i=0;
    while(i < [objsToDisplay count] && ![objsToDisplay[i] objectForKey:groupColHeaderName].match(aObject))
        i++;
    if(i < [objsToDisplay count]){
        [objsToDisplay[i] setValue:aPoint forKey:plHeaderName];
		[theTable reloadData];
    }
}
- (int)numberOfRowsInTableView:(CPTableView)tableView
{
	return [objsToDisplay count];
}
- (id)tableView:(CPTableView)tableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
	var key = [tableColumn identifier];
	return [objsToDisplay[row] objectForKey:key];
}
- (void)tableView:(CPTableView)aTableView sortDescriptorsDidChange:(CPArray)oldDescriptors
{
    // first we figure out how we're suppose to sort, then sort the data array
    var newDescriptors = [aTableView sortDescriptors];
    [objsToDisplay sortUsingDescriptors:newDescriptors];

	[aTableView reloadData];
}
- (BOOL)matchFound:(CPDictionary)aDict withString:(CPString)aString
{
	var isFound = NO;
	if(selFilter){
		if([aDict objectForKey:[columnHeaders objectAtIndex:selFilter-1]] != [CPNull null])
			if([[aDict objectForKey:[columnHeaders objectAtIndex:selFilter-1]].toString() lowercaseString].match(aString))
				isFound = YES;
	}
	else
		for(var i=0;i < [aDict count];i++)
			if([[aDict allValues] objectAtIndex:i] != [CPNull null])
				if([[[aDict allValues] objectAtIndex:i].toString() lowercaseString].match(aString))
					isFound = YES;
	return isFound;
}
- (void)searchChanged:(id)sender
{
    if (sender)
        searchString = [[sender stringValue]  lowercaseString];

	if(searchString){		
		objsToDisplay = [];
		var count = 0;
		for(var i=0;i < [objs count];i++)
			if([self matchFound:objs[i] withString:searchString]){
				objsToDisplay[count] = objs[i];
				count++;
			}
		[[CPNotificationCenter defaultCenter]
			postNotificationName:showFilterBarNoti object:nil];	
	}
	else{
		objsToDisplay = objs;
		[[CPNotificationCenter defaultCenter]
			postNotificationName:hideFilterBarNoti object:nil];	
	}
	
	[theTable deselectAll];
	[theTable reloadData];
	[[CPNotificationCenter defaultCenter]
			postNotificationName:recalcPLNoti object:nil];
}
- (void) filterBarSelectionDidChange:(id)sender
{
	selFilter = [sender selectedFilter];
	[self searchChanged:nil];
}
@end
