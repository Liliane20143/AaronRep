/* eslint-disable no-console */
import { LightningElement, api, track } from 'lwc';
import getPercentage from '@salesforce/apex/Plc_OverallStockPercentageWgtCnt.getPercentage';
import title from '@salesforce/label/c.Plc_LightningComponentOverallStockPercentageWgtTitle';
import message from '@salesforce/label/c.Plc_AllAllCalculationError';
import reportLabel from '@salesforce/label/c.Plc_LightningComponentOverallStockPercentageWgtFooter';

export default class Plc_OverallStockPercentageWgt extends LightningElement {    
    
    @api backgroundColor;
    @api textColor;
    @api developerName;
    @track percentMap;
    @track isVAlidPercent;
    @track isValidLink;
    @api label = {title, message, reportLabel};

    connectedCallback(){
        getPercentage({developerName: this.developerName}).then(result => {

            this.percentMap = result;
            console.log('#### result ', JSON.stringify(result));
            if(this.percentMap.percentage){
                if(this.percentMap.percentage !== null){
                    this.isVAlidPercent = true;
                }
            }            

            if(this.percentMap.reportId){
                if(this.percentMap.reportId !== null){
                    this.isValidLink = true;
                }
            } 

            this.handleStyle();
            
        }).catch(error => {
            console.log('#### result error ', error);
        })
    }

    reportLink(){
        window.open('/'+ this.percentMap.reportId, '_blank')
    }

    handleStyle(){
        let container = this.template.querySelector('.container');
            if(this.backgroundColor === 'Light'){
                container.classList.add('container-light');
                let titleText = this.template.querySelector('.txt-title');
                titleText.style.color = '#091a3e';

                let titleLink = this.template.querySelector('.txt-link');
                titleLink.style.color = '#091a3e';
            }else{
                container.classList.add('container-dark');
            }

            let textColorContainer = this.template.querySelector('.div-desc');
            if(this.textColor === 'Red'){
                textColorContainer.classList.add('text-color-red');
            } else {
                textColorContainer.classList.add('text-color-green');
            }
    }
}