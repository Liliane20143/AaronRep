declare module "@salesforce/apex/Plc_BatchRunnerCnt.getBatchStatus" {
  export default function getBatchStatus(param: {schedulerName: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_BatchRunnerCnt.getBatchExecutionsStatuses" {
  export default function getBatchExecutionsStatuses(param: {schedulerName: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_BatchRunnerCnt.runBatchByName" {
  export default function runBatchByName(param: {batchName: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_BatchRunnerCnt.stopBatch" {
  export default function stopBatch(param: {schedulerName: any}): Promise<any>;
}
declare module "@salesforce/apex/Plc_BatchRunnerCnt.getBatchAvailable" {
  export default function getBatchAvailable(): Promise<any>;
}
declare module "@salesforce/apex/Plc_BatchRunnerCnt.retrieveTranslationMap" {
  export default function retrieveTranslationMap(): Promise<any>;
}
declare module "@salesforce/apex/Plc_BatchRunnerCnt.setSchedulable" {
  export default function setSchedulable(param: {schedulerName: any, cronoTime: any}): Promise<any>;
}
