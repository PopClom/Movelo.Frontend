async function getLocationPredictions(filter, sessionToken) {
    var sessionTokenObject = new google.maps.places.AutocompleteSessionToken();
    sessionTokenObject.Yg = sessionToken;

    const options = {
        input: filter,

        sessionToken: sessionTokenObject,
        //fields: ["formatted_address", "geometry", "name"],
        language: "es_ES",
        location: new google.maps.LatLng(-34.581834427449245, -58.37982525831364),
        radius: 1000000,
        strictBounds: true,
        //TODO types: ["address","establishment"],
        componentRestrictions: {country: 'ar'},
    };

    //var autocomplete = new google.maps.places.Autocomplete(filter, options);

    //TODO no instanciar en cada llamado!
    var autocompleteService = new google.maps.places.AutocompleteService();

    var result = await autocompleteService.getPlacePredictions(options);

    return JSON.stringify(result);
}

async function getPlacesDetails(placeId, sessionToken) {
    var sessionTokenObject = new google.maps.places.AutocompleteSessionToken();
    sessionTokenObject.Yg = sessionToken;

    const request = {
        sessionToken: sessionTokenObject,
        placeId: placeId,
        fields: ["name", "geometry", "formatted_address"],
    };
    
    const service = new google.maps.places.PlacesService(document.createElement('div'));

    const promise = new Promise((resolve, reject) => {
        service.getDetails(request, (place, status) => {
            resolve(place);
        });
    });

    var result = await promise;

    return JSON.stringify(result);
}