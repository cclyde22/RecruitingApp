//Define Globals
requestPLURL = @"php/getPLData.php";
requestListURL = @"php/getJSONProspects.php";
requestGroupURL = @"php/getJSONRegions.php";
requestSimilarTradesURL = @"php/getSimilarTrades.php";
detailsURL = @"php/tradeReport.php?group=";
closeTacTradeURL = @"php/closeTacTrade.php";
blankPageURL = @"php/blank.php";

addProspectURL = @"php/addProspect.php";
viewProspectURL = @"php/viewProspect.php";

groupColId = @"Region";
groupColHeaderName = @"groupId";
plHeaderName = @"P&L";

placeHolderString = @"Please Chooes a Closing Day";
naString = @"N/A";

headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"button-bezel-center.png"]]]; 
groupViewColor = @"EBF3F5";
leftViewColor = @"CCDDDD";
calcViewColor = @"BEEDBE";
redColor = @"FF0000";
greenColor = @"189818";
blackColor = @"000000";

calcViewBorderWidth = 2;
calcViewCornerRadius = 5;
calcViewBorderColor = @"BFBFBF";


createFilterBarNoti = @"CreateFilterBarNotification";
showFilterBarNoti = @"ShowFilterBarNotification";
hideFilterBarNoti = @"HideFilterBarNotification";
recalcPLNoti = @"RecalculatePLNotification";
resetNoti = @"ResetNotification";

viewProspect = @"View/Edit Prospect";
editProspect = @"Edit Prospect";
addProspect = @"Add Prospect";
delProspects = @"Delete Prospects";
uploadFile = @"Upload File";

allName = @"All";

addTradeURL = @"php/addTacticalTrade.php";
delTradeURL = @"../delCliTr.php?type=tactical";

minFilterBarGap = 15;
minFilterBarY = 6;

colWidth = 125;
collViewWidth = 950; //this allows 3 columns @ 1280x1024
collViewHeight = 600;
