/**
 * Created by capasso on 04/02/2019.
 NORMAL WORKING ONW
 */
({

    h_handleFilesChange: function (component, event, helper) {
        var files = event.getSource().get("v.files");
        console.log('FILE LOADED: ', files.length + ' files !!');
        if (files) {
            component.set('v.showTables', true);
        }

        //get the file uploaded and converts it
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var self = this;
        var objFileReader = new FileReader();
        component.set('v.showSpinner', true);
        objFileReader.onload = $A.getCallback(function () {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64);
            fileContents = fileContents.substring(dataStart);
            self.h_CSVToArray(fileContents, ',', component);
            //self.processHelper(component,event,file,fileContents);
        });
        objFileReader.readAsText(file);
    },


    /*This will parse a delimited string into an array of
    arrays. The default delimiter is the comma, but this
    can be overriden in the second argument.*/
    h_CSVToArray: function (strData, strDelimiter, component) {
        // Check to see if the delimiter is defined. If not,
        // then default to comma.
        strDelimiter = (strDelimiter || ",");
        // Create a regular expression to parse the CSV values.
        var objPattern = new RegExp(
            (
                // Delimiters.
                "(\\" + strDelimiter + "|\\r?\\n|\\r|^)" +
                // Quoted fields.
                "(?:\"([^\"]*(?:\"\"[^\"]*)*)\"|" +
                // Standard fields.
                "([^\"\\" + strDelimiter + "\\r\\n]*))"
            ),
            "gi"
        );
        // Create an array to hold our data. Give the array
        // a default empty first row.
        var arrData = [[]];
        // Create an array to hold our individual pattern
        // matching groups.
        var arrMatches = null;
        // Keep looping over the regular expression matches
        // until we can no longer find a match.
        while (arrMatches = objPattern.exec(strData.trim())) {
            // Get the delimiter that was found.
            var strMatchedDelimiter = arrMatches[1];
            // Check to see if the given delimiter has a length
            // (is not the start of string) and if it matches
            // field delimiter. If id does not, then we know
            // that this delimiter is a row delimiter.
            if (
                strMatchedDelimiter.length &&
                (strMatchedDelimiter != strDelimiter)
            ) {
                // Since we have reached a new row of data,
                // add an empty row to our data array.
                arrData.push([]);
            }
            // Now that we have our delimiter out of the way,
            // let's check to see which kind of value we
            // captured (quoted or unquoted).
            if (arrMatches[2]) {
                // We found a quoted value. When we capture
                // this value, unescape any double quotes.
                var strMatchedValue = arrMatches[2].replace(
                    new RegExp("\"\"", "g"),
                    "\""
                );
            } else {
                // We found a non-quoted value.
                var strMatchedValue = arrMatches[3];
            }
            // Now that we have our value string, let's add
            // it to the data array.
            arrData[arrData.length - 1].push(strMatchedValue);
        }
        // Return the parsed data.

        var reorderdArray = this.h_arrayReorder(component, arrData);
        if (reorderdArray === 'error') {
            return;

        }

        return this.h_precheckCsvValue(component, reorderdArray);
    },

    h_arrayReorder: function (component, arrData) {
        var serialNumberPosition = -1;
        var productSkuPosition = -1;
        var manufacturerAliasPosition = -1;

        var reorderdArray = [[]];

        for (var x = 0; x < arrData[0].length; x++) {
            arrData[0][x] = arrData[0][x].replace(/\s/g, '').toUpperCase();
        }

        //FB 20190627 - NEXIPLC-590 [START]
        let technicianWithdrawnManagement = component.get('v.configurationMap').technicianWithdrawnManagement;
        let technicianName = component.get('v.configurationMap').technicianName;
        let technicianPosition = -1;
        //FB 20190627 - NEXIPLC-590 [END]
        
        for (var i = 0; i < arrData[0].length; i++) {
            if (arrData[0][i] === 'SERIALNUMBERS') {
                reorderdArray[0][0] = arrData[0][i];
                serialNumberPosition = i;//3
            }
            if (arrData[0][i] === 'MANUFACTURERALIAS') {
                reorderdArray[0][1] = arrData[0][i];
                manufacturerAliasPosition = i;//1
            }
            if (arrData[0][i] === 'PRODUCTSKU') {
                reorderdArray[0][2] = arrData[0][i];
                productSkuPosition = i;//2
            }
            //FB 20190627 - NEXIPLC-590 [START]
            if (technicianWithdrawnManagement && !technicianName) {
                if (arrData[0][i] === 'TECHNICIAN') {
                    reorderdArray[0][3] = arrData[0][i];
                    technicianPosition = i;//2
                }
            }
            //FB 20190627 - NEXIPLC-590 [END]
        }

        console.log('>>>>>>recordPosition: ' + 'SN: ' + serialNumberPosition + ' sku ' + productSkuPosition
            + ' alias ' + manufacturerAliasPosition);

        for (var k = 1; k < arrData.length; k++) {
            //FB 20190627 - NEXIPLC-590 [START]
            reorderdArray[k] = [arrData[k][serialNumberPosition], arrData[k][manufacturerAliasPosition], arrData[k][productSkuPosition], arrData[k][technicianPosition]];
            //FB 20190627 - NEXIPLC-590 [END]
            //console.log('>>>>>>reorderdArrayNewLine: ', reorderdArray[k]);
        }

        var contactErrors = '';
        var skipMethods = component.get('v.skipOriginalMethods');


        if (skipMethods == true) {
            if (serialNumberPosition === -1) {
                    contactErrors = $A.get("$Label.c.Plc_MandatoryColumnsMissingError") + 'SerialNumbers';
                //FB 20190627 - NEXIPLC-590 [START] 
                if (technicianWithdrawnManagement && !technicianName && technicianPosition === -1) {
                    contactErrors += '\nTechnician'
                }
                //FB 20190627 - NEXIPLC-590 [END] 
            }
            //FB 20190627 - NEXIPLC-590 [START] 
            else if (technicianWithdrawnManagement && !technicianName && technicianPosition === -1) {
                contactErrors = $A.get("$Label.c.Plc_MandatoryColumnsMissingError") + 'Technician';
            }
            //FB 20190627 - NEXIPLC-590 [END]
            
        } else{
            if (serialNumberPosition === -1 || productSkuPosition === -1 || manufacturerAliasPosition === -1) {
                contactErrors = $A.get("$Label.c.Plc_MandatoryColumnsMissingError") + 'SerialNumbers<br>ManufacturerAlias<br>ProductSKU<br></b>';
            }
        }

        if (contactErrors) {
            component.set('v.columnsNotFoundCSV', contactErrors);
            return 'error';
        }


        return reorderdArray;
    },

    h_precheckCsvValue: function (component, arrData) {

        var container = [];// list of object extracted from csv
        var serialNumbers = [];
        var manufacturerAlias = [];
        var productSku = [];
        var errors = {
            serialNumber: 'Serial Number ' + $A.get("$Label.c.Plc_AllAllIsEmpty"),
            manufacturerAlias_productSku: $A.get("$Label.c.Plc_ProductSkuAndManufacturerAliasNotPresentError"),
            generic: $A.get("$Label.c.Plc_CSVFormattingError")
        };


        console.log('CSVToArray lenght ' + arrData.length);

        //FB 20190627 - NEXIPLC-590 [START]
        let technicianWithdrawnManagement = component.get('v.configurationMap').technicianWithdrawnManagement;
        let technicianName = component.get('v.configurationMap').technicianName;
        var technicians = [];
        //FB 20190627 - NEXIPLC-590 [END]
        //populating the arrays
        for (var i = 1; i < arrData.length; i++) {
            serialNumbers.push(arrData[i][0]);
            manufacturerAlias.push(arrData[i][1]);
            productSku.push(arrData[i][2]);
            //FB 20190627 - NEXIPLC-590 [START]
            if (technicianWithdrawnManagement && !technicianName) {
                technicians.push(arrData[i][3]);
            }
            //FB 20190627 - NEXIPLC-590 [END]
        }


        //creating the list of objects to return
        for (var m = 0; m < serialNumbers.length; m++) {
            let item = {
                serialNumbers: serialNumbers[m],
                manufacturerAlias: manufacturerAlias[m],
                productSku: productSku[m],
                error: '',
                processStep: '',
                csvLinePosition: m + 2
            };
            //FB 20190627 - NEXIPLC-590 [START]
            if (technicianWithdrawnManagement && !technicianName.trim()) {
                item.technician = technicians[m].trim();
            }
            //FB 20190627 - NEXIPLC-590 [END]
            container.push(item);
        }

        for (var z = 0; z < container.length; z++) {
            var isSerialNumberPresent = false;

            if (container[z].serialNumbers) {

                isSerialNumberPresent = true;

            } else {
                container[z].error = errors.serialNumber + '\nCSV line: ' + container[z].csvLinePosition;
            }

            //FB 20190627 - NEXIPLC-590 [START]
            if (technicianWithdrawnManagement && !technicianName && !container[z].technician) {
                container[z].error = 'Technician ' + $A.get("$Label.c.Plc_AllAllIsEmpty") + '\nCSV line: ' + container[z].csvLinePosition;
            }
            //FB 20190627 - NEXIPLC-590 [END]

            if ((!container[z].manufacturerAlias && !container[z].productSku) && isSerialNumberPresent) {
                //TO DO L.B
                //container[z].error = errors.manufacturerAlias_productSku + '\nCSV line: ' + container[z].csvLinePosition;

            } else if (!isSerialNumberPresent) {
                container[z].error = errors.generic + '\nCSV line: ' + container[z].csvLinePosition;
            }
        }


        //check for duplicates in CSV
        this.h_checkDuplicates(container);

        //extracting valid data on pre-check
        var validData = [];
        for (var k = 0; k < container.length; k++) {

            //if null\undefined replace with empty string
            if ($A.util.isEmpty(container[k].manufacturerAlias)) {
                container[k].manufacturerAlias = '';
            }
            if ($A.util.isEmpty(container[k].productSku)) {
                container[k].productSku = '';
            }

            if (!container[k].error) {
                let item = {
                    serialNumbers: container[k].serialNumbers,
                    manufacturerAlias: container[k].manufacturerAlias,
                    productSku: container[k].productSku,
                    error: container[k].error,
                    processStep: container[k].processStep,
                    csvLinePosition: container[k].csvLinePosition
                };

                //FB 20190627 - NEXIPLC-590 [START]
                if (technicianWithdrawnManagement && !technicianName) {
                    item.technician = container[k].technician;
                }
                //FB 20190627 - NEXIPLC-590 [END]
                
                validData.push(item);
                
            }
        }

        //preparing string sep. by ',' of SerialNumbers to query on in apex
        var serialNumbers_String = '';
        for (var x = 0; x < validData.length; x++) {
            serialNumbers_String += validData[x].serialNumbers + ',';
        }

        serialNumbers_String = serialNumbers_String.slice(0, -1);

        return this.h_checkCSVRecordsAgainstDatabase(component, serialNumbers_String, validData, container);
    },


    h_checkCSVRecordsAgainstDatabase: function (component, serialNumbers_String, validData, container) {

        var action = component.get('c.checkCSVSerials');
        action.setParams({
            serialsToCheck: JSON.stringify(validData),
            stockSerialStatus: component.get('v.stockSerialStatus'),
            warehouseId: component.get('v.warehouseId'),
            distributionListItemModels: component.get('v.distributionListItemModels'),
            configurationMap: component.get('v.configurationMap')
        });

        console.log('>>stockSerialStatus: ', component.get('v.stockSerialStatus'));
        console.log('>>warehouseId: ', component.get('v.warehouseId'));
        console.log('>>distributionListItemModels: ', component.get('v.distributionListItemModels'));
        //FB 20190627 - NEXIPLC-590 [START]
        component.set('v.showLoadingSpinner', true);
        //FB 20190627 - NEXIPLC-590 [END]
        action.setCallback(this, function (res) {
            if (component.isValid() && res.getState() === "SUCCESS") {
                //FB 20190627 - NEXIPLC-590 [START]
                component.set('v.showLoadingSpinner', false);
                //FB 20190627 - NEXIPLC-590 [END]
                console.log("success callback checkCSVSerials");
                var results = res.getReturnValue();


                console.log('checkCSVSerials results ! ', results);

                var _invalidData = [];
                for (var i = 0; i < results.invalidResults.length; i++) {
                    _invalidData.push(results.invalidResults[i]);
                }

                for (var x = 0; x < container.length; x++) {
                    if (container[x].error) {
                        _invalidData.push({
                            serialNumbers: container[x].serialNumbers,
                            manufacturerAlias: container[x].manufacturerAlias,
                            productSku: container[x].productSku,
                            error: container[x].error,
                            processStep: container[x].processStep,
                            csvLinePosition: container[x].csvLinePosition
                        });
                    }
                }

                component.set("v.validData", results.validResults);
                component.set("v.invalidData", _invalidData);

                component.set("v.invalidDataLenght", _invalidData.length);
                component.set("v.validDataLenght", results.validResults.length);
                component.set("v.dataLenght", (_invalidData.length + results.validResults.length));

                component.set('v.returnMap', results);

                //visual only attributes
                if (_invalidData.length <= 1) {
                    component.set('v.invalidRecordtableHeightcss', 'min-height');
                } else if (_invalidData.length <= 5) {
                    component.set('v.invalidRecordtableHeightcss', 'mid-height');
                } else {
                    component.set('v.invalidRecordtableHeightcss', 'max-height');
                }


                if (results.validResults.length <= 1) {
                    component.set('v.validRecordtableHeightcss', 'min-height');
                } else if (results.validResults.length <= 5) {
                    component.set('v.validRecordtableHeightcss', 'mid-height');
                } else {
                    component.set('v.validRecordtableHeightcss', 'max-height');
                }

                component.set('v.showSpinner', false);

            } else if (component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error in h_checkCSVRecordsAgainstDatabase: " + res.getError()[0].message);

            } else if (component.isValid() && res.getState() === "ERROR") {
                console.log("Unknown error in h_checkCSVRecordsAgainstDatabase: " + res.getError()[0].message);

            }
        });
        component.set('v.showSpinner', true);
        $A.enqueueAction(action);

    },

    h_checkDuplicates: function (array) {
        var hasDuplicates = false;
        for (var i = 0; i < array.length; i++) {
            for (var j = i; j < array.length; j++) {
                if (array[i].serialNumbers && array[j].serialNumbers) {
                    if (i !== j && array[i].serialNumbers === array[j].serialNumbers) {
                        hasDuplicates = true;
                        array[i].error = $A.get("$Label.c.Plc_DuplicateSerialNumberFound") + '\n CSV Line: ' + array[i].csvLinePosition;
                        array[j].error = $A.get("$Label.c.Plc_DuplicateSerialNumberFound") + '\n CSV Line: ' + array[j].csvLinePosition;
                        //console.log('Duplicated records: ', array[i]);
                    }
                }

                /*  if (array[i].productSku && array[j].productSku) {
                      if (i !== j && array[i].productSku === array[j].productSku) {
                          hasDuplicates = true;
                          array[i].error = $A.get("$Label.c.Plc_DuplicateProductSkuFound") + '\n CSV Line: ' + array[i].csvLinePosition;
                          array[j].error = $A.get("$Label.c.Plc_DuplicateProductSkuFound") + '\n CSV Line: ' + array[j].csvLinePosition;
                          console.log('Duplicated records: ', array[i]);
                      }
                  }*/
            }
        }

        if (hasDuplicates) {
            return array;
        }

        console.log('Has duplicates! ' + hasDuplicates);
        return hasDuplicates;
    },

    h_handleButtonAcceptRecords: function (component, event, helper) {
        //event fire when the button 'load valid record' is pressed
        var evt = $A.get("e.c:Plc_FilterEvt");
        evt.setParams({
            "searchResultsEvt": component.get('v.returnMap'),
            "actionType": 'sendCsvResults'
        });
        evt.fire();

    },

    h_hideModal: function (component, event, helper) {
        //event fire when the close\cancel button inside the popup is pressed
        var evt = $A.get("e.c:Plc_FilterEvt");
        evt.setParams({
            "searchResultsEvt": '',
            "actionType": 'hideModal'
        });
        evt.fire();
    }


});