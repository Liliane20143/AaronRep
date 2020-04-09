/* eslint-disable no-console */
import { LightningElement, api, track } from 'lwc';
import getAllSerialsByStatusList from '@salesforce/apex/Plc_AvailableStockPercentageWgtCnt.getAllSerialsByStatusList';
import title from '@salesforce/label/c.Plc_LightningComponentAvailableStockPercentageWgtTitle';
import message from '@salesforce/label/c.Plc_AllAllCalculationError';
import reportLabel from '@salesforce/label/c.Plc_LightningComponentAvailableStockPercentageWgtFooter';

export default class Plc_AvailableStockPercentageWgt extends LightningElement { 

    @track percentMap;
    @api label = {title, message, reportLabel}
    @api backgroundColor;
    @api textColor;
    @api developerName;
    @track isValidPercent;
    @track isValidLink;

    connectedCallback() {
        getAllSerialsByStatusList({developerName: this.developerName}).then(result => {
            
            this.percentMap = result;
            if(this.percentMap.percentage){
                if(this.percentMap.percentage !== 'error'){
                    this.isValidPercent = true;
                }
            }

            if(this.percentMap.reportId){
                if(this.percentMap.reportId !== null){
                    this.isValidLink = true;
                }
            }

            this.handleStyle();

        }).catch(error => {
            console.log('result', error);
        })
    }

    reportLink(){
        window.open('/'+this.percentMap.reportId, '_blank');
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