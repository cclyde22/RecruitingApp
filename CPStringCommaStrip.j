@import <Foundation/CPString.j>

@implementation CPString(CommaStrip)

-(CPInteger)commaStrippedInteger
{
	return parseFloat(self.replace(/,/g,''));
}

@end