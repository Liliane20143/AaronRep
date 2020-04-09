({
	
	test : function () {
		console.log('test');
	},
ControllaCF : function (fiscalCode,fieldsContol)
{  


var result;

if(fiscalCode == "00000000000")
{
	result = 3;
	return result;
}


if(  fiscalCode.length == 0  || fiscalCode.length < 11 || (11 < fiscalCode.length && fiscalCode.length < 16) || fiscalCode.length > 16) {
	
	//return result = "Invalid Fiscal Code length";
	result =1;
	return result;
	
}else{
	if(fiscalCode.length == 11){
		return this.checkPIVA(fiscalCode);
		   
    }
	
	if(fiscalCode.length == 16){
		if(this.checkCF(fiscalCode) !=null){
		  return this.checkCF(fiscalCode);
		}else if(fieldsContol.size > 0){
				return controlAnagrafica(fiscalCode,fieldsContol);
			
		}else{
			  return null;
		}
		
	
	}

}

return result;
},


checkPIVA : function (partitaIva)
{   
    // the variable 'zero' identifies the unicode of number 0
	var zero = 48;
	// the variable 'nine' identifies the unicode of number 9
	var nine = 57;
	var i = 0, c = 0, s = 0;
	var result;
	
	if(partitaIva == "00000000000")
	{
		result = 3;
		return result;
	}
	
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
},

checkCF : function (codiceFiscale){
	
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
},

controlAnagrafica : function (fiscalCode,fieldsContol){
	var result ;
	var sex =fieldsContol.get("sex");
	var giorno =fieldsContol.get("giorno");
	var mese =fieldsContol.get("mese");
	var anno=fieldsContol.get("anno");
	var cognome=fieldsContol.get("cognome");
	var nome=fieldsContol.get("nome");
	fiscalCode = fiscalCode.toUpperCase();
	

	
    if(anno != null){
		if (fiscalCode.substr(6,2) != anno.substr(2,3)){
			result = "Il codice fiscale non corrisponde all' anno di nascita";
			return result;
		}
	}
	
	if(mese !=null){
	switch(mese) {

	case "01": Mese = "A";break;
	case "02": Mese = "B";break;
	case "03": Mese = "C";break;
	case "04": Mese = "D";break;
	case "05": Mese = "E";break;
	case "06": Mese = "H";break;
	case "07": Mese = "L";break;
	case "08": Mese = "M";break;
	case "09": Mese = "P";break;
	case "10": Mese = "R";break;
	case "11": Mese = "S";break;
	case "12": Mese = "T";break;}
    
	
		if (fiscalCode.substr(8,1) != Mese ){
			result = "Il codice fiscale non corrisponde al mese di nascita";
			return result;
		} 
	}
	
	if(sex != null){
		if (sex == "M") {
			giorno = giorno;
		}else if (sex == "F"){
//controllo perchÃ¨ non funziona il parseInt su un numero che inizia con 0.
			if (parseInt(giorno) == 0){
				giorno = parseInt(giorno.substr(1,1)) + 40;
			}else{
				giorno = parseInt(giorno) + 40;
			}
		}
	}
	
	if(giorno !=null){
		if (fiscalCode.substr(9,2) != giorno ){
			result = "Il codice fiscale non corrisponde ai dati inseriti";
			return result;
		}
	}
	
	if(cognome != null){
		if(fiscalCode.substr(0,3) != controlla_cognome(cognome)){
			result = "Il codice fiscale non corrisponde al cognome inserito";
			return result;
		}
	}
	
	if(nome !=null){
		if(fiscalCode.substr(3,3) != controlla_nome(nome)){
			result = "Il codice fiscale non corrisponde al nome inserito";
			return result;
		}
	}
	

	
	return result;
},


estrai_consonanti : function (parola){
	var pattern_vocali=/[^AEIOU ]/;
	parola=parola.toUpperCase();
	var risultato="";
	for (i=0; i<parola.length; i++) 
		if (parola.charAt(i).match(pattern_vocali)) risultato+=parola.charAt(i);
				return risultato;
},//estrai_consonanti


estrai_vocali : function  (parola){
	parola=parola.toUpperCase();
	var risultato="";
	for (i=0; i<parola.length; i++) 
		if (parola.charAt(i).match(/[AEIOU]/)) risultato+=parola.charAt(i);
			return risultato;
},// estrai_vocali


controlla_cognome : function (cognome){
	var parola=estrai_consonanti(cognome.toUpperCase());
		if (parola.length>3) 
			return parola.charAt(0)+parola.charAt(1)+parola.charAt(2);
		if (parola.length<3){
			var vocali_cognome=estrai_vocali(cognome.toUpperCase());
			var v=0;
			while (parola.length<3) {
				parola+=vocali_cognome.charAt(v)||'X';
				v++;
			}//while
		}//if
		return parola;
},//controlla_lunghezza



controlla_nome : function (nome){
	var parola=estrai_consonanti(nome.toUpperCase());
	if (parola.length>3) {
//si prende 1 4 5
		parola=parola.charAt(0)+parola.charAt(2)+parola.charAt(3);
	}
	if (parola.length<3){
		var vocali_nome=estrai_vocali(nome.toUpperCase());
		var v=0;
		while(parola.length<3) {
			parola+=vocali_nome.charAt(v)||'X';
			v++;
		}//while
	}//if
	return parola;
},//controlla_lunghezza

 emailControl : function  (email){
	var result='ERROR';
	

	/*if(!/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email))*/

	if(!/^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,4})|(aero|coop|info|museum|name))$$/.test(email))//giovanni spinelli 01/07/2019 change email regex to allow email like test@test.abcd
	{
		return result;
	}else
	{
		return null;
	}
},
//FUNCTION TO CONTROL ONLY NUMBER
onlyNumber : function (inputValue)
{
	var result='ERROR';
	if(!/^[0-9]+$/.test(inputValue))
	{
		return result;
	}
	else
	{
		return null;
	}
},
//FUNCTION TO CONTROL PHONE NUMBER MIN 5 MAX 10
onlyNumberPhone : function (inputPhone)
{
	var result2='ERROR';
	if(!/^[0-9]{5,14}$/.test(inputPhone))
	{
		return result2;
	}
	else
	{
		return null;
	}
},


removeMandatoryMessage : function (messageId)
{
	try{
        //GET THE CURRENT ID FROM INPUT
        console.log('messageId: ' + document.getElementById(messageId));
        if(document.getElementById(messageId)!=null)
        {
        
          document.getElementById(messageId).remove();
        } 
        //var currentId = event.target.id; 
        
       }
       catch(err)
       {
        console.log('err.message: ' + err.message);
       }
        //RECREATE THE SAME ID OF ERROR MESSAGE
        //var errorId = 'errorId'+ messageId;
        //var changeClass = component.find(errorId);
        //REMOVE RED BORDER
        //REMOVE ERROR MESSAGE
        
},
//CUSTOM CONTROL ABOUT SPECIFIC FIELDS
specialCharacter:function (inputFromField)
{
	var result='ERROR';
	// new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
	var re = new RegExp('^[a-zA-Z0-9()\"?!&% $£ \" \\ =^ °\/\'.;]+$');
	if(  !re.test(inputFromField)    )
	{
		return result;
	}
	else
	{
		return null;
	}
},
//Control cciaa
controlCCIA : function(cciaa){
	var result='ERROR';
	if(  /^[A-Za-z0-9]{0,50}$/.test(cciaa)    )
	{
		return null;
	}
	else
	{
		return result;
	}
}

})