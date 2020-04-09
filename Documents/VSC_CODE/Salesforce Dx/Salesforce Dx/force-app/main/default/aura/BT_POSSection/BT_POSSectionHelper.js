({
	computeAggregate : function(record, fieldsList, isPercent, aggregateFunc) {
		let sum = 0
		let atLeastOneDefined = false
		let aFunc = aggregateFunc || function(i, f, v) { return Number(v); }
		for (let fieldIdx in fieldsList) {
			let field = fieldsList[fieldIdx]
			let defined = !$A.util.isEmpty(record[field])
			if (defined) {
				sum += aFunc(fieldIdx, field, record[field])
			}
			atLeastOneDefined = atLeastOneDefined || defined
		}
		console.log(sum)
		return atLeastOneDefined ? (isPercent ? (sum * 100).toFixed(2) : sum) : null
	}
})