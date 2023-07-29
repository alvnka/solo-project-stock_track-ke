# stock_track-ke -> My Campus Project

This is an application that scrapes the NSE to get company data that is the trading symbol, closing and change. I have also created the User interface using Flutter that show cases this data in a more informative and helpful way.

Final intention is to use the app to notify you if a listed company hits a certain target price. this has not yet been done though so maybe in the near future.

Since the application was developed using Flutter, the android and web page are pretty much similar because  so I will just show the android screenshots and explain the user journey.

- The user may sign up to the app using their email and password. or they may use their google account to sign in.

  - ![sign up page](/stock-track-ke/project%20screenshots/Android/android%20sign_up.jpg "sign up page")

- Alternatively if the user already has an account they may sign in using their email and password or their google account.

  - ![login page](/stock-track-ke/project%20screenshots/Android/android%20login%20page.jpg "Login page")

- Signing in or logging in with google provides a google accounts pop up that shows the account signed up on your phone and gives you the option to sign in with any of them. once you sign up once with an account the application will always automatically login on for you from there on.

  - ![google account pop up menu](/stock-track-ke/project%20screenshots/Android/android%20google%20login%20popup.jpg "Google account pop up")

- Once logged in the user is taken to the home page where they can see the list of companies and their data. The data is currently updated with every reload but I will make it reload after an appropriate interval.

  - ![home page](/stock-track-ke/project%20screenshots/Android/android%20home_page.jpg "Home page")

- the Hamburger icon shows a sidebar menu that the user can use to navigate between the home page, Trading symbols, Active Tracks, and settings.

  - ![sidebar menu](/stock-track-ke/project%20screenshots/Android/android%20side%20bar.jpg "Sidebar menu")

- The sorting icon allows the user to sort the companies by their closing price. The user can also sort the companies in ascending or descending order. I intend to add the option to sort by change as well.

  - ![sorting menu](/stock-track-ke/project%20screenshots/Android/android%20sorting%20options.jpg "Sorting menu")

- upon clicking the a card the user is taken to the company page where they can see more data about the company. Currently the data is shown in form of a graph so the user can see the trend of the stock prices over time. As I have not collected enough data yet the graph is not very informative but over time the data will gradually increase and will be more informative.

  - ![company page](/stock-track-ke/project%20screenshots/Android/android%20graph%20page.jpg "Company page")

- The user can then click the "set track" button to set a track at whatever price they want. The user will be provided with a pop up where they can insert the targetted price. The pop up enables the user see the graph at the same time so that it can be their reference point as well.

  - ![set track pop up](/stock-track-ke/project%20screenshots/Android/android%20set%20tracking%20pop%20up.jpg "Set track pop up")

- once the user sets the track they are taken back to the active tracks page where they can see the track they just set and the ones they had set before if the haven't been reached yet. The user can also delete the track if they want to by swiping left, I intend to add a page that will show the previously tracked prices that have been hit so as to be a reference to the user.

  - ![active tracks page](/stock-track-ke/project%20screenshots/Android/active%20tracks%20page.jpg "Active tracks page")

- The user can also see the trading symbols of the companies by clicking the trading symbols option in the sidebar menu. This page shows the trading symbols and the company names. It has a search function that allows the user to search through the names and symbols.

  - ![trading symbols page](/stock-track-ke/project%20screenshots/Android/android%20index%20definitions.jpg "Trading symbols page")
- The last item on the menu is the Settings page where the user can perform functions such as log out, change password, and change username. .

  - ![settings page](/stock-track-ke/project%20screenshots/Android/android%20profile%20settings%20page.jpg "Settings page")
  - clicking on the change details button reveals the change username and change password buttons. 
  - ![change details page](/stock-track-ke/project%20screenshots/Android/android%20setting%20options%20page.jpg "Change details page")
  - I intend to add more functions to this page such as changing the theme of the app and deleting the account.

- The application still has a long way to go like reliable triggers for the notifications, more informative graphs, and more informative company pages, prettier pages as well. I will be working on these in the future.