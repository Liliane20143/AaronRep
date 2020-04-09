({
	drawChart : function(cmp, evt, hlp) {
		let plotCanvas = cmp.find('plot').getElement();
		if (!$A.util.isEmpty(plotCanvas)) {
			let type = cmp.get('v.type');
			hlp.aggregateData(cmp, type);

			let plotContainer = cmp.find('plotContainer').getElement();
			if (type == 'bar') {
				plotCanvas.height = plotContainer.clientHeight - (cmp.get('v.total') > 1 ? 115 : 60);
			} else {
				plotCanvas.height = plotContainer.clientHeight;
			}
			plotCanvas.width = plotContainer.clientWidth;

			var ctx = cmp.find('plot').getElement().getContext('2d');
			let data = cmp.get('v.dataset');
			let tooltipMode = cmp.get('v.tooltipMode');
			let showLegend = cmp.get('v.showLegend');

			hlp.drawChart(cmp, ctx, data, type, tooltipMode, showLegend);
		}
	},

	updateDataset : function(cmp, evt, hlp) {
		let type = cmp.get('v.type')
		let chart = cmp.get('v.chart')
		hlp.aggregateData(cmp, type)

		if (!$A.util.isEmpty(chart)) {
			chart.data.datasets = cmp.get('v.dataset').datasets
			chart.update()
		}
	}
})