@import <AppKit/CPBox.j>
@import "ListDataSource.j"

@implementation CalcView : CPBox
{
	CPTextField totalPLField @accessors;
	CPTextField losersField @accessors;
	CPTextField winnersField @accessors;
	CPTextField totalPLLabel;
	CPTextField losersLabel;
	CPTextField winnersLabel;
	ListDataSource theList;
}

- (id)initWithFrame:(CGRect)aFrame withList:(ListDataSource)aList
{
    if (self = [super initWithFrame:aFrame])
    {
        theList = aList;
        [self setFillColor: [CPColor colorWithHexString:calcViewColor]];
        [self setBorderType:CPLineBorder];
        [self setBorderColor:[CPColor colorWithHexString:calcViewBorderColor]];
        [self setBorderWidth:calcViewBorderWidth];
        [self setCornerRadius:calcViewCornerRadius];
        
        totalPLLabel = [CPTextField labelWithTitle:@"Total P&L:"];
        [totalPLLabel setFrameOrigin:CGPointMake(10, 8)];
        totalPLField = [[CPTextField alloc] initWithFrame:CGRectMake(70,8,90,20)];
        [totalPLField setStringValue: @"N/A"];

        winnersLabel = [CPTextField labelWithTitle:@"Winners:"];
        [winnersLabel setFrameOrigin:CGPointMake(160, 8)];
        winnersField = [[CPTextField alloc] initWithFrame:CGRectMake(212,8,88,20)];
        [winnersField setStringValue: @"N/A"];
     
        losersLabel = [CPTextField labelWithTitle:@"Losers:"];
        [losersLabel setFrameOrigin:CGPointMake(300, 8)];
        losersField = [[CPTextField alloc] initWithFrame:CGRectMake(345,8,105,20)];
        [losersField setStringValue: @"N/A"];
     
        [self addSubview: totalPLLabel];
        [self addSubview: totalPLField];
        [self addSubview: winnersLabel];
        [self addSubview: winnersField];
        [self addSubview: losersLabel];
        [self addSubview: losersField];
        
    	[[CPNotificationCenter defaultCenter ]
        addObserver:self
           selector:@selector(calcPLInfo:)
               name:recalcPLNoti
             object:nil];
    }
    return self;
}
- (void)getPLData
{
    [totalPLField setStringValue:naString];
    [totalPLField setTextColor:[CPColor colorWithHexString:blackColor]];
    [winnersField setStringValue:naString];
    [losersField setStringValue:naString];

    var trades = [theList objsToDisplay];
    for(var i=0;i < [trades count];i++){
	    var request = [CPURLRequest requestWithURL:requestPLURL + "?" + groupColHeaderName + "=" + [trades[i] objectForKey:groupColHeaderName]] ;
	    [[CPURLConnection alloc] initWithRequest:request delegate:self];
	} 
}
- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data
{
    var plInfo = [data objectFromJSON];
    [theList insertNewDataPoint:[plInfo[1] commaSeperatedString] intoObject:plInfo[0]];
    
    if([totalPLField stringValue] == naString){
        [totalPLField setStringValue:@"0"];
        [winnersField setStringValue:@"0"];
        [losersField setStringValue:@"0"];
    }

    [totalPLField setStringValue: [([[totalPLField stringValue] commaStrippedInteger]+plInfo[1]) commaSeperatedString]];
    if(plInfo[1] < 0){
        [losersField setStringValue: parseInt([losersField stringValue])+1];
        [totalPLField setTextColor:[CPColor colorWithHexString:redColor]];
    }
    else{
        [winnersField setStringValue: parseInt([winnersField stringValue])+1];
        [totalPLField setTextColor:[CPColor colorWithHexString:greenColor]];
    }    
}
- (void)calcPLInfo:(CPNotification)aNotification
{
    var trades = [theList objsToDisplay];
    var pl = win = loss = 0;
    for(var i=0;i < [trades count];i++){
        tempPL = [[trades[i] valueForKey:plHeaderName] commaStrippedInteger];
        if(tempPL != "N/A"){
            pl += tempPL;
            if(tempPL < 0)
                loss++;
            else
                win++;
        }
    }
    if(pl){
        [totalPLField setStringValue:[pl commaSeperatedString]];
        if(pl < 0)
            [totalPLField setTextColor:[CPColor colorWithHexString:redColor]];
        else
            [totalPLField setTextColor:[CPColor colorWithHexString:greenColor]];
        [winnersField setStringValue:win];
        [losersField setStringValue:loss];
    }
    else{
        [totalPLField setStringValue:naString];
        [winnersField setStringValue:naString];
        [losersField setStringValue:naString];
    }
}
- (void)connection:(CPURLConnection)aConnection didFailWithError:(CPString)error
{
    alert(error);
}
