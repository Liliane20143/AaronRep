({
	buildApi : function(c) {
    return function(method, params) {
      return new Promise((resolve, reject) => {
        $A.getCallback(function () {
          console.log('docall called');
          let action = c.get('c.' + method);
          if(params) action.setParams(params);
          action.setCallback(c, function (res) {
            if (c.isValid() && res.getState() === 'SUCCESS') {
              resolve(res.getReturnValue())
            } else if (c.isValid() && res.getState() === 'ERROR') {
              let error = 'Si è verificato un errore'
              if (res.getError() && res.getError()[0] && res.getError()[0].pageErrors && res.getError()[0].pageErrors[0]) {
                error = res.getError()[0].pageErrors[0].message
              } else if (res.getError()[0]) {
                error = res.getError()[0].message
              }
              reject(error)
            } else {
              reject(res)
            }
          });
        $A.enqueueAction(action)
        })()
      })
    }
  },
  
  notifyError: function (message) {
    const toastEvent = $A.get('e.force:showToast');
    toastEvent.setParams({
      'title': 'Errore',
      'message': message,
      'type': 'error'
    });
    toastEvent.fire();
  },

  notifySuccess: function (message) {
    const toastEvent = $A.get('e.force:showToast');
    toastEvent.setParams({
      'title': 'Operazione completata',
      'message': message,
      'type': 'success'
     });
    toastEvent.fire();
  },

  scalePercentFields: function(record, multiply) {
    let fieldsList = [
      'BT_Altri_Jcb__c', 'BT_Altri_MaestroCommercial__c',
      'BT_Altri_MaestroConsumerDebit__c', 'BT_Altri_MaestroConsumerPrepaid__c',
      'BT_Altri_MastercardCommercial__c', 'BT_Altri_MastercardConsumerCredit__c',
      'BT_Altri_MastercardConsumerDebit__c', 'BT_Altri_MastercardConsumerPrepaid__c',
      'BT_Altri_Pagobancomat__c', 'BT_Altri_Upi__c',
      'BT_Altri_VisaCommercial__c', 'BT_Altri_VisaConsumerCredit__c',
      'BT_Altri_VisaConsumerDebit__c', 'BT_Altri_VisaConsumerPrepaid__c',
      'BT_Altri_VPayConsumerDebit__c', 'BT_Altri_VPayConsumerPrepaid__c',
      'BT_Costo_Jcb__c', 'BT_Costo_MaestroCommercial__c',
      'BT_Costo_MaestroConsumerDebit__c', 'BT_Costo_MaestroConsumerPrepaid__c',
      'BT_Costo_MastercardCommercial__c', 'BT_Costo_MastercardConsumerCredit__c',
      'BT_Costo_MastercardConsumerDebit__c', 'BT_Costo_MastercardConsumerPrepaid__c',
      'BT_Costo_Pagobancomat__c', 'BT_Costo_Upi__c',
      'BT_Costo_VisaCommercial__c', 'BT_Costo_VisaConsumerCredit__c',
      'BT_Costo_VisaConsumerDebit__c', 'BT_Costo_VisaConsumerPrepaid__c',
      'BT_Costo_VPayConsumerDebit__c', 'BT_Costo_VPayConsumerPrepaid__c',
      'BT_IF_Jcb__c', 'BT_IF_MaestroCommercial__c',
      'BT_IF_MaestroConsumerDebit__c', 'BT_IF_MaestroConsumerPrepaid__c',
      'BT_IF_MastercardCommercial__c', 'BT_IF_MastercardConsumerCredit__c',
      'BT_IF_MastercardConsumerDebit__c', 'BT_IF_MastercardConsumerPrepaid__c',
      'BT_IF_Pagobancomat__c', 'BT_IF_Upi__c',
      'BT_IF_VisaCommercial__c', 'BT_IF_VisaConsumerCredit__c',
      'BT_IF_VisaConsumerDebit__c', 'BT_IF_VisaConsumerPrepaid__c',
      'BT_IF_VPayConsumerDebit__c', 'BT_IF_VPayConsumerPrepaid__c',
      'BT_MarginalitaDesiderataTOTPreventivo__c', 'BT_Oneri_Jcb__c',
      'BT_Oneri_MaestroCommercial__c', 'BT_Oneri_MaestroConsumerDebit__c',
      'BT_Oneri_MaestroConsumerPrepaid__c', 'BT_Oneri_MastercardCommercial__c',
      'BT_Oneri_MastercardConsumerCredit__c', 'BT_Oneri_MastercardConsumerDebit__c',
      'BT_Oneri_MastercardConsumerPrepaid__c', 'BT_Oneri_Pagobancomat__c',
      'BT_Oneri_Upi__c', 'BT_Oneri_VisaCommercial__c',
      'BT_Oneri_VisaConsumerCredit__c', 'BT_Oneri_VisaConsumerDebit__c',
      'BT_Oneri_VisaConsumerPrepaid__c', 'BT_Oneri_VPayConsumerDebit__c',
      'BT_Oneri_VPayConsumerPrepaid__c', 'BT_Altri_MaestroCommercialEEA__c',
      'BT_Altri_MaestroConsumerDebitEEA__c', 'BT_Altri_MaestroConsumerPrepaidEEA__c',
      'BT_Altri_MastercardCommercialEEA__c', 'BT_Altri_MastercardConsumerCreditEEA__c',
      'BT_Altri_MastercardConsumerDebitEEA__c', 'BT_Altri_MastercardConsumerPrepaidEEA__c',
      'BT_Altri_VisaCommercialEEA__c', 'BT_Altri_VisaConsumerCreditEEA__c',
      'BT_Altri_VisaConsumerDebitEEA__c', 'BT_Altri_VisaConsumerPrepaidEEA__c',
      'BT_Altri_VPayConsumerDebitEEA__c', 'BT_Altri_VPayConsumerPrepaidEEA__c',
      'BT_Costo_MaestroCommercialEEA__c',
      'BT_Costo_MaestroConsumerDebitEEA__c', 'BT_Costo_MaestroConsumerPrepaidEEA__c',
      'BT_Costo_MastercardCommercialEEA__c', 'BT_Costo_MastercardConsumerCreditEEA__c',
      'BT_Costo_MastercardConsumerDebitEEA__c', 'BT_Costo_MastercardConsumerPrepaidEEA__c',
      'BT_Costo_VisaCommercialEEA__c', 'BT_Costo_VisaConsumerCreditEEA__c',
      'BT_Costo_VisaConsumerDebitEEA__c', 'BT_Costo_VisaConsumerPrepaidEEA__c',
      'BT_Costo_VPayConsumerDebitEEA__c', 'BT_Costo_VPayConsumerPrepaidEEA__c',
      'BT_IF_MaestroCommercialEEA__c',
      'BT_IF_MaestroConsumerDebitEEA__c', 'BT_IF_MaestroConsumerPrepaidEEA__c',
      'BT_IF_MastercardCommercialEEA__c', 'BT_IF_MastercardConsumerCreditEEA__c',
      'BT_IF_MastercardConsumerDebitEEA__c', 'BT_IF_MastercardConsumerPrepaidEEA__c',
      'BT_IF_VisaCommercialEEA__c', 'BT_IF_VisaConsumerCreditEEA__c',
      'BT_IF_VisaConsumerDebitEEA__c', 'BT_IF_VisaConsumerPrepaidEEA__c',
      'BT_IF_VPayConsumerDebitEEA__c', 'BT_IF_VPayConsumerPrepaidEEA__c',
      'BT_Oneri_MaestroCommercialEEA__c', 'BT_Oneri_MaestroConsumerDebitEEA__c',
      'BT_Oneri_MaestroConsumerPrepaidEEA__c', 'BT_Oneri_MastercardCommercialEEA__c',
      'BT_Oneri_MastercardConsumerCreditEEA__c', 'BT_Oneri_MastercardConsumerDebitEEA__c',
      'BT_Oneri_MastercardConsumerPrepaidEEA__c', 'BT_Oneri_VisaCommercialEEA__c',
      'BT_Oneri_VisaConsumerCreditEEA__c', 'BT_Oneri_VisaConsumerDebitEEA__c',
      'BT_Oneri_VisaConsumerPrepaidEEA__c', 'BT_Oneri_VPayConsumerDebitEEA__c',
      'BT_Oneri_VPayConsumerPrepaidEEA__c',
      'BT_Bench_MaestroCommercial__c', 'BT_Bench_MaestroConsumerDebit__c',
      'BT_Bench_MaestroConsumerPrepaid__c', 'BT_Bench_MastercardCommercial__c',
      'BT_Bench_MastercardConsumerCredit__c', 'BT_Bench_MastercardConsumerDebit__c',
      'BT_Bench_MastercardConsumerPrepaid__c', 'BT_Bench_Pagobancomat__c',
      'BT_Bench_Upi__c', 'BT_Bench_VisaCommercial__c',
      'BT_Bench_VisaConsumerCredit__c', 'BT_Bench_VisaConsumerDebit__c',
      'BT_Bench_VisaConsumerPrepaid__c', 'BT_Bench_VPayConsumerDebit__c',
      'BT_Bench_VPayConsumerPrepaid__c', 'BT_Altri_MaestroCommercialEEA__c',
      'BT_Bench_MaestroCommercialEEA__c', 'BT_Bench_MaestroConsumerDebitEEA__c',
      'BT_Bench_MaestroConsumerPrepaidEEA__c', 'BT_Bench_MastercardCommercialEEA__c',
      'BT_Bench_MastercardConsumerCreditEEA__c', 'BT_Bench_MastercardConsumerDebitEEA__c',
      'BT_Bench_MastercardConsumerPrepaidEEA__c', 'BT_Bench_VisaCommercialEEA__c',
      'BT_Bench_VisaConsumerCreditEEA__c', 'BT_Bench_VisaConsumerDebitEEA__c',
      'BT_Bench_VisaConsumerPrepaidEEA__c', 'BT_Bench_VPayConsumerDebitEEA__c',
      'BT_Bench_VPayConsumerPrepaidEEA__c',
    ];

    fieldsList.forEach(field => {
      if (multiply) {
        record[field] *= 100.0;
      } else {
        record[field] /= 100.0; 
      }
    });
  },
})