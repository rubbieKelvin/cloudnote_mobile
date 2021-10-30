// .pragma library

function search(item, listModel, key){
	/**
	 * this function loops through listModel to search for item using key.
	 * this is a linear search inefficient for large ListModels
	 * @param item {Object}
	 * @param listModel {Object}
	 * @param key {Functin}
	 * @result {Object}
	 */

	key = key || (i => i)

	for (let i=0; i<(listModel.count || listModel.length); i++) {
		const element = listModel.get ? listModel.get(i) : listModel[i];
        if (key(element) === item) return element
	}

	return null
}


export function sortDiffrence(listModelA, listModelB, key, twoWay){
	/**
	 * this function will loop through listModelB to scan for diffrence in listModelA
	 * if an item in listModelB is not in listModelA; it will be added to listModelA
	 * if an item in listModelB is in listModelA; the item will be ignored
	 * if twoWay is true, and an item in listModelA is not in listModelB; the item will be removed from listModelA
	 * if twoWay is true, and an item in listModelA is in listModelB; the item will be ignored
	 * key id a function that is used to point to ranking value
	 * ... the ranking value would be used to identify a specific item in the list.
	 * ... the function will take in an argument, which is just the current item we're looping through
	 * ... on default (if key==null) the function just points to the item passed in.
	 * 
	 * @param listModelA {ListModel}
	 * @param listModelB {ListModel}
	 * @param key {Function}
	 * @param twoWay {Boolean}
	 */

	key = key || (i => i)
	twoWay = Boolean(twoWay)

	for (let i=0; i<(listModelB.count || listModelB.length); i++) {
		const itemAtB = listModelB.get ? listModelB.get(i) : listModelB[i]
		const itemAtA = search(key(itemAtB), listModelA, key)

		if (itemAtA === null) {
			if (listModelA.append)
                listModelA.append(itemAtB)
			else
				listModelA.push(itemAtB)
		}
	}

	if (twoWay){
		for (let j=0; j<(listModelA.count || listModelA.length); j++) {
			const itemAtA = listModelA.get ? listModelA.get(j) : listModelA[j]
			const itemAtB = search(key(itemAtA), listModelB, key)
	
			if (itemAtB === null) {
				if (listModelA.remove)
					listModelA.remove(j)
				else
					listModelA = listModelA.filter(_=>_!==itemAtA)
			}
		}
	}
}

