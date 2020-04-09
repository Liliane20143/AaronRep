({
	doInit : function(cmp, event, helper) {
		helper.setOldTransactionsColumns(cmp);
		helper.getAvailableBatch(cmp,event,helper);
		helper.getBatchData(cmp,helper);
	},
	runBatchHandler : function(cmp, event, helper) {
		helper.runBatch(cmp, helper, cmp.get("v.batchName"));
	},
	stopBatchHandler: function (cmp, event, helper) {
		helper.stopBatch(cmp, helper, cmp.get("v.batchName"));
	},
	refreshStatus : function(cmp, event, helper) {
		helper.getBatchStatus(cmp,helper);
	},
	refreshLastExecutions : function(cmp, event, helper) {
		helper.getOldExecutionsStatuses(cmp,helper);
	},
	showMenuSelect: function (cmp, event, helper) {
		helper.setSelectedBatch(cmp, event, helper);
	},
	hideMenuSelect: function (cmp, event, helper) {
		helper.removeSelectedBatch(cmp, event, helper);
	},
	showSchedulerHandler: function (cmp, event, helper) {
		helper.showScheduler(cmp, event, helper);
	},
	hideSchedulerHandler: function (cmp, event, helper) {
		helper.hideScheduler(cmp, event, helper);
	},
	getSelectedHandler: function (cmp, event, helper) {
		helper.getSelected(cmp, event, helper);
	},
	getSelectedHourHandler: function (cmp, event, helper) {
		helper.getSelectedHour(cmp, event, helper);
	},
	getSelectedDayOfTheMonthHandler: function (cmp, event, helper) {
		helper.getSelectedDayOfTheMonth(cmp, event, helper);
	},
	setJobHandler: function (cmp, event, helper) {
		helper.setJob(cmp, event, helper);
	}
})