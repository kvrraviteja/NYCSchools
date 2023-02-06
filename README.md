## NYCSchools
* NYCSchools is an iOS app, displays all schools in NYC.
* Selecting a school, displays SAT scores, including math, writing, and reading.

Key components:
* NYCNetworkManager - Implements NetworkManager protocol. Provide APIs to fetch schools, and SAT scores. 
* NYCRouteProvider - Implements RouteProvider protocol. Provide routes to all supported APIs.
* NYCSchool - Implements School protocol. A model objects for school data.
* NYCSATScore - Implements SATScore protocol. A model objects for SAT score data.
* NYCSchoolsViewModel - Implements SchoolsViewModel protocol. A view model, to facilitate data for the school table view.
* NYCSchoolDetailsViewModel -  A view model, to facilitate data for the SAT scores.
* SchoolsViewController - View controller displaying schools data.
* SchoolDetailsViewController - View controller displaying SAT scores for selected school.

## NYCSchoolsTests
* Includes test cases for APIManager.
* Includes positive, and negative test case for NetworkManager's getSATScores API.
