({
    handleCloseModal: function (component, event, helper) {

        let fireEvent = component.get('v.fireEvent');
        let redirectTo = component.get('v.redirectTo');
        /** [START MOD 28/03/2019 11:19]@Author:francesco.bigoni@/webresults.it @Description: Navigate back attribute **/
        let redirectBack = component.get('v.redirectBack');
        /** [END MOD 28/03/2019 11:19]@Author:francesco.bigoni@/webresults.it @Description: Navigate back attribute **/

        if(fireEvent) {
            helper.fireEvent(component);
        }

        if (redirectTo && redirectTo !== '') {
            helper.redirectTo(component, redirectTo);

        }
        /** [START MOD 28/03/2019 11:19]@Author:francesco.bigoni@/webresults.it @Description: Goes back whether redirectBack is true **/ 
        else if (redirectBack) {
            history.back();
        }
        /** [END MOD 28/03/2019 11:19]@Author:francesco.bigoni@/webresults.it @Description: Goes back whether redirectBack is true **/
        component.set('v.showModal', false);
    }
})