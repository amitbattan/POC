# Simple iOS Application

### Key feature of this app
- MVVM 
- Swift 3
- Core Data
- Autolayout (with Size Classes / Vary Traits )
- Unit Test for view model
- Pagination
- Custom delegates 

### Application has 2 screens
- Listing (user can search item using olx public API) 
-   ListViewController.swift
-   ListingViewModel.swift
- Detail of item
-   DetailViewController.swift

### How it works
User can search by adding text in searchBar at listing screen. We check respective data in local storage, if we got data locally then show it in a tableview and user can refresh data using pull to refresh. 
Otherwise make web service call to olx API. We load more data once user scroll down and want to see more data.
Error message shown if network issue or any other issue comes, user can retry by taping in error message.  
UI of application is design in Main.storybaord. UI of application is adaptive to portrait and landscape orientations. User can see the difference by rotating there device on both listing and detail screen.
Delegate approach is used in ListingViewModel.swift to notify viewcontroller any changes

### Other important thing
- Unit test cases has written for view model ListingViewModel.swift in file ListingViewModelTests.swift
- Use [Kingfisher](https://github.com/onevcat/Kingfisher) for image cache 

### Improvement Area
- Fine-tune UI
- Further improvement in local storage (coredata)
- Some other edge cases
- Increase test case coverage

### API Detail

- URL http://api-v2.olx.com/items
- request type : GET

Query Parameter

| Nombre | Tipo | Descripción |
| ------ | ------ | ------ |
| location | string | For this exercise use www.olx.com.ar |
| searchTerm | string | (Required) Search term (e.g. "Peugeot", "iphone"). |
| pageSize | integer | (Opcional) Result data size |
| offset | integer | (Opcional) Offset the list of returned business results by this amount. |

