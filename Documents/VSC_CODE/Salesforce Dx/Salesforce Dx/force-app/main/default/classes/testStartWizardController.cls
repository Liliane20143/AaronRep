public class testStartWizardController {
    public String accID{get;set;}
    public String ordID{get;set;}
    
    public testStartWizardController(){
        accID = apexpages.currentpage().getparameters().get('accId');
        ordID = apexpages.currentpage().getparameters().get('ordID');
    }

}