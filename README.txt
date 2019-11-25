NearbyEvents README

This app shows the user nearby events pulled from the eventful.com API. No Eventful account is required.

BUILDING

This app uses Alamofire via CocoaPods, so open the project using the .xcworkspace file rather than the .xcodeproj file.

USING

There are two tabs: a map and a list of favorite events. The list of favorite events starts empty.

At first launch, the app will request access to your location. If you decline, it will default to the area around New York City.

The main first view is a map. An activity indicator at the bottom will inidicate that the app is fetching data from the server. Once it finishes, the map will be populated with pins, each representing an upcoming event.

The search bar can be used to specify the kind of events you want. New events will be fetched when you enter a new search term or scroll the map area. Note that not all events may be displayed; there are limits both to the API and the map view.

You can tap a pin to get some info about the event in a callout. You can then hit the info button to get more information on a separate view.

The event details view has various information, including a URL which will open a webpage with even more information. Note that not all events have all the information which can be displayed here.

The event details view has a button to add an even to your favorites, or remove it if it's already there. Favorites persist until manually removed. There's also a back button to return to the previous view.

The favorites tab will display a simple list of favorites. You can tap to bring up the event in the details view. You can also delete them directly from the favorites tab using the standard delete gesture.