function ControllaCF(fiscalCode)
{   

var result;

if(  fiscalCode.length == 0  || fiscalCode.length < 11 || (11 < fiscalCode.length && fiscalCode.length < 16) || fiscalCode.length > 16) {
	
	//return result = "Invalid Fiscal Code length";
	result =1;
	return result;
	
}else{
	if(fiscalCode.length == 11){
		return checkPIVA(fiscalCode);
		   
    }
	
	if(fiscalCode.length == 16){
		  return checkCF(fiscalCode);
		
	}

}

return result;
}


function checkPIVA(partitaIva)
{   
    // the variable 'zero' identifies the unicode of number 0
	var zero = 48;
	// the variable 'nine' identifies the unicode of number 9
	var nine = 57;
	var i = 0, c = 0, s = 0;
	var result;
	
	
	for (i = 0;i<11;i++){
		if (partitaIva.charCodeAt(i) < zero || partitaIva.charCodeAt(i) > nine){				
		   //result 	= "Rilevati caratteri non validi";
		   result =2;
		   return result;
			}
		}

		s = 0;
		for (i = 0; i <= 9; i += 2)
			s += partitaIva.charCodeAt(i) - zero;
		for (i = 1; i <= 9; i += 2){
			c = 2 * (partitaIva.charCodeAt(i) - zero);
			if (c > 9) c = c - 9;
			s += c;
		}

		var a1 = 10 -(s%10);
		var a2 = a1%10;
		
		if (a2 != partitaIva.charCodeAt(10) - zero){
			
			//result= "PIVA is not valid, the control code does not correspond";
			result=3;
			return result;
		}
	return result;
}

function checkCF(codiceFiscale){
	
  var result;
  codiceFiscale = codiceFiscale.toUpperCase();
  
  
  var map = [1, 0, 5, 7, 9, 13, 15, 17, 19, 21, 1, 0, 5, 7, 9, 13, 15, 17,
		19, 21, 2, 4, 18, 20, 11, 3, 6, 8, 12, 14, 16, 10, 22, 25, 24, 23];
	var s = 0;
	for(var i = 0; i < 15; i++){
		var c = codiceFiscale.charCodeAt(i);
		if( c < 65 )
			c = c - 48;
		else
			c = c - 55;
		if( i % 2 == 0 )
			s += map[c];
		else
			s += c < 10? c : c - 10;
	}
	var atteso = String.fromCharCode(65 + s % 26);
	if( atteso != codiceFiscale.charAt(15) ){
		//result = "Fiscal Code is not valid, the control code does not correspond\n"
		result =3;
    }
   return result;
}





