export default MovieScheduler = {
	mounted() {		
		// Grab asset action (then allows place asset action).
		this.handleEvent("phx:grab_asset", (payload) => {
			document.body.style.cursor = 'grabbing'

			const changeCursorToGrab = () => {
				document.body.style.cursor = 'grab'
				window.removeEventListener("click", changeCursorToGrab)
			}

			// Place asset action, with logic to prevent placement in areas where
			// 1. placed asset intersects with already-placed object
			// 2. placed asset instersects with bottom of row (day)
			// Eventual TODO: allow overflow into next row (day).
			const placeAsset = () => {
				payload["x"] = event.target.dataset.x
				payload["y"] = event.target.dataset.y
				payload["grid_id"] = event.target.dataset.gridid
				payload["schedule_id"] = event.target.dataset.scheduleid
				payload["relative_row_id"] = event.target.dataset.relativerowid

				let currentElem = event.target.nextSibling
				const targetScheduleId = event.target.dataset?.scheduleid

				let following_grids_are_available = true

				for (let i = 0; i < (payload["length"] * 2) - 1; i++){
					const assetId = currentElem.dataset?.assetid 
					const currentScheduleId = currentElem.dataset?.scheduleid

					if (assetId !== undefined) {
						if (assetId !== null) {
							following_grids_are_available = false
						}
					}
					if (currentScheduleId != undefined) {
						if (currentScheduleId !== targetScheduleId) {
							following_grids_are_available = false
						}
					}
					currentElem = currentElem.nextSibling
				}

				if (following_grids_are_available) {
					this.pushEvent("js:place_asset", payload)
				}

				schedulerMain.removeEventListener("click", placeAsset)
			}
	
			window.addEventListener("click", changeCursorToGrab);

			const schedulerMain = document.querySelector("#scheduler-main")
			schedulerMain.addEventListener("click", placeAsset);
	    });
	    
	}
}