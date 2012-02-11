function preg_quote( str ) {
    // http://kevin.vanzonneveld.net
    // +   original by: booeyOH
    // +   improved by: Ates Goral (http://magnetiq.com)
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   bugfixed by: Onno Marsman
    // *     example 1: preg_quote("$40");
    // *     returns 1: '\$40'
    // *     example 2: preg_quote("*RRRING* Hello?");
    // *     returns 2: '\*RRRING\* Hello\?'
    // *     example 3: preg_quote("\\.+*?[^]$(){}=!<>|:");
    // *     returns 3: '\\\.\+\*\?\[\^\]\$\(\)\{\}\=\!\<\>\|\:'

    return (str+'').replace(/([\\\.\+\*\?\[\^\]\$\(\)\{\}\=\!\<\>\|\:])/g, "\\$1");
}
$(document).ready(function(){
/*!
	@file searchHighlights.js
 
  	@brief Highlights searchfield entires
 	
  	Takes in a term from notes.php and then uses RegExp and replace to 
	add highlight formatting to each case insensitive instance of that expression

	@author Casey Clyde and Omar Chanouha 
	@date 5/20/2011
*/
	var term = $('#term').val();
	if(term!=""){
		var n = "0"
		term = preg_quote(term);
		//adds formatting to every instance of new term
		$('.entry').each(function(){
			var regex = new RegExp('(' + term + ')', 'gi' );
			$(this).html($(this).html().replace(regex, '<span class = "highlight">$1</span>'));
		});
	}
});
