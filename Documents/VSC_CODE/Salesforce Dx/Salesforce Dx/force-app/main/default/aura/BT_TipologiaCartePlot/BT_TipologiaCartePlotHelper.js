({
	drawChart: function(cmp, ctx, data, type, tooltipMode, showLegend) {
		const myChart = new Chart(ctx, {
			type: type,
			data: data,
			options: {
				legend: {
		            display: showLegend
		        },
				animation: false,
				tooltips: {
					enabled: !$A.util.isEmpty(tooltipMode),
					mode: tooltipMode,
					insersect: false,
					callbacks: {
						label: (tooltipItem, data) => {
							let label = data.datasets[tooltipItem.datasetIndex].label || '';
							let value;
							switch (type) {
								case 'bar': value = tooltipItem.yLabel; break;
								case 'horizontalBar': value = tooltipItem.xLabel; break;
								default: value = tooltipItem.yLabel;
							}
							if (label) {
								return label += ': ' + value + '%';
							}

							return label;
						}
					},
					itemSort: function(left, right) {
						return right.datasetIndex - left.datasetIndex;
					}
				},
				responsive: false,
				maintainAspectRatio: false,
				plugins: {
					datalabels: {
						color: 'white',
						display: context => {
							return context.dataset.data[context.dataIndex] > 2;
						},
						font: {
							weight: 'bold'
						},
						formatter: (value, context) => {
							if (value % 1 == 0) {
								return parseInt(value) + '%';
							}
							return value + '%';
						}
					}
				},
				scales: {
					xAxes: [{
						stacked: true
					}],
					yAxes: [{
						stacked: true,
						ticks: {
							suggestedMax: 100,
							callback: (value) => {
								return value + '%';
							}
						}
					}]
				}
			}
		});
		cmp.set('v.chart', myChart)
	},

	aggregateData: function(cmp, type) {
		let valueAsian = cmp.get('v.valueAsian');
		let valueBancomat = cmp.get('v.valueBancomat');
		let valueCommExtraUE = cmp.get('v.valueCommExtraUE');
		let valueComm = cmp.get('v.valueComm');
		let valueCDPExtraUE = cmp.get('v.valueCDPExtraUE');
		let valueCDP = cmp.get('v.valueCDP');
		let dataset = {}
		let asian = {
			label: $A.get('$Label.c.BT_CircuitiAsiatici'),
			backgroundColor: cmp.get('v.colorAsian'),
			data: [
				valueAsian
			]
		}
		let bancomat = {
			label: $A.get('$Label.c.BT_PagoBancomat'),
			backgroundColor: cmp.get('v.colorBancomat'),
			data: [
				valueBancomat
			]
		}
		let comm = {
			label: $A.get('$Label.c.BT_Commercial'),
			backgroundColor: cmp.get('v.colorComm'),
			data: [
				valueComm
			]
		}
		let commExtraUE = {
			label: $A.get('$Label.c.BT_Commercial')+' ('+$A.get('$Label.c.BT_AreaNoEuro') + ')',
			backgroundColor: cmp.get('v.colorCommExtraUE'),
			data: [
				valueCommExtraUE
			]
		}
		let cdpExraUE = {
			label: $A.get('$Label.c.BT_CreditoDebitoPrepagate')+' ('+$A.get('$Label.c.BT_AreaNoEuro') + ')',
			backgroundColor: cmp.get('v.colorCDPExtraUE'),
			data: [
				valueCDPExtraUE
			]
		}
		let cdp = {
			label: $A.get('$Label.c.BT_CreditoDebitoPrepagate'),
			backgroundColor: cmp.get('v.colorCDP'),
			data: [
				valueCDP
			]
		}
		switch (type) {
			case 'bar': {
				dataset = {
					datasets: [ asian, bancomat, commExtraUE, comm, cdpExraUE, cdp ] 
				};
				break;
			};
			case 'horizontalBar': {
				dataset = {
					datasets: [ cdp, comm, cdpExraUE, commExtraUE, bancomat, asian ] 
				};
				break;
			}
		}
		console.log(dataset)
		cmp.set('v.dataset', dataset);
		cmp.set('v.total', ((Number(valueAsian) + Number(valueBancomat) + Number(valueComm) + Number(valueCommExtraUE) + Number(valueCDP) + Number(valueCDPExtraUE)) / 100.0).toFixed(4));
	}
})