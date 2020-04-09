({
	onCalculateClicked: function(cmp, evt, hlp) {
        let simulationSaveEvent = cmp.getEvent('simulationSaveEvent')
        simulationSaveEvent.fire();
    }
})