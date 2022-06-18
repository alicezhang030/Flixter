# Project 1 - *Flixter*

**Flixter** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **12** hours spent in total

## User Stories

The following **required** functionality is complete:

- User sees an app icon on the home screen and a styled launch screen.
- User can view a list of movies currently playing in theaters from The Movie Database.
- Poster images are loaded using the UIImageView category in the AFNetworking library.
- User sees a loading state while waiting for the movies API.
- User can pull to refresh the movie list.
- User sees an error message when there's a networking error.
- User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- User can tap a poster in the collection view to see a detail screen of that movie
- User can search for a movie.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Implementing filter and sort functionalities for the movies
2. Allowing users to leave reviews of the movies 

## Video Walkthrough

Here's a walkthrough of the implemented features:

App icon on the home screen, styled launch screen, and loading state while waiting for the movies API:
![](https://github.com/alicezhang030/Flixter/blob/main/Showcase%20vids/very%20bad%20network%20showcase.gif)
Error message when there's a networking error:
![](https://github.com/alicezhang030/Flixter/blob/main/Showcase%20vids/no%20network.gif)
All other features:
![](https://github.com/alicezhang030/Flixter/blob/main/Showcase%20vids/Showcase%20vid%201.gif)


GIF created with [Kap](https://getkap.co/).

## Notes

1. Since I've never used Objective-C before, understanding the syntax and learning how to debug Objective-C code was hard at first. 
2. I also found it hard at first to use storyboard. While I've used design tools like Figma before, I've never used something that connects design with code so directly.

## Credits

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright [2022] [Jinyang (Alice) Zhang]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
