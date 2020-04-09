({
	doInit : function(cmp, evt, hlp) {
		cmp.set('v.lastScrollY', window.scrollY)
		window.addEventListener('scroll', () => {
			if (!cmp.get('v.ticking')) {
				window.requestAnimationFrame(update)
			}
			cmp.set('v.ticking', true)
		})
		function update() {
			// i think that something can be cached for better performance
			cmp.set('v.ticking', false)
			let direction = Math.sign(window.scrollY - cmp.get('v.lastScrollY')); 
			let indicator = cmp.find('indicator')
			let indicatorBottom = 0
			if (!($A.util.isEmpty(indicator) || $A.util.isEmpty(indicator.getElement()))) {
				indicatorBottom = indicator.getElement().getBoundingClientRect().bottom
				let container = cmp.find('scroll_container')
				if (!($A.util.isEmpty(container) || $A.util.isEmpty(container.getElement()))) {
					container = container.getElement()
					let progress = parseFloat(indicator.get('v.progress'))
					let perc = computePercentage(progress, cmp.get('v.useProgress'), container, indicatorBottom, direction)
					cmp.set('v.useProgress', true)
					indicator.set('v.progress', perc)
				}
				function computePercentage(progress, useProgress, container, indicatorBottom, scrollDirection) {
					let progressStep = (100 / (container.childNodes.length))
					let childIdx = 0
					if (useProgress) {
						childIdx = Math.floor(progress / progressStep)
					} else {
						for (; childIdx < container.childNodes.length; childIdx++) {
							if (container.childNodes[childIdx].getBoundingClientRect().bottom - indicatorBottom >= 0) {
								break
							}
						}
					}
 					if (childIdx == container.childNodes.length && scrollDirection == -1) {
						childIdx--
					} else if (childIdx == container.childNodes.length) {
						return 100
					}
					if (childIdx < container.childNodes.length) {
						let thisChildElement = container.childNodes[childIdx]
						let thisDomRect = thisChildElement.getBoundingClientRect()
						let top
						if ((childIdx + 1) == container.childNodes.length) {
							top = thisDomRect.bottom
						} else {
							let nextChildElement = container.childNodes[childIdx + 1]
							let nextDomRect = nextChildElement.getBoundingClientRect()
							top = nextDomRect.top
						}
						let stepPercentage = 1 - ((top - indicatorBottom - 30) / thisDomRect.height)
						return Math.min(100, (childIdx + stepPercentage) * progressStep)
					}
				}
			}
			cmp.set('v.lastScrollY', window.scrollY);		
		}
	},

	goToStep: function(cmp, evt, hlp) {
		let indicator = cmp.find('indicator')
		let container = cmp.find('scroll_container')

		if (!($A.util.isEmpty(indicator) || $A.util.isEmpty(indicator.getElement()) || $A.util.isEmpty(container) || $A.util.isEmpty(container.getElement()))) {
			let children = container.getElement().childNodes
			let top = indicator.getElement().getBoundingClientRect().height
			for (let i = 0; i < children.length; i++) {
				if (children[i].getAttribute('data-step') == evt.currentTarget.getAttribute('data-value')) {
					break
				}
				top += children[i].getBoundingClientRect().height
			}

			console.log(top)

			window.scroll({
				top: top,
				left: 0,
				behavior: 'smooth' 
			})
		}
	},

	handleRecordChangedEvent: function(cmp, evt, hlp) {
		cmp.set('v.simulationOK', false)
	}
})