//
//  GridViewController.m
//  Flixter
//
//  Created by Alice Zhang on 6/16/22.
//

#import "GridViewController.h"
#import "AllMoviesCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface GridViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *allMoviesSpinner;

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    
    self.allMoviesSpinner.hidesWhenStopped = YES; //when the data retrival is finished, the spinner will disappear
    [self.allMoviesSpinner startAnimating];
    
    [self fetchMovies];
}

- (void)fetchMovies {
    //identify the network resource
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    //create a request to the source
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    //create a session that will manage communication with the server
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    //execute and handle the result in separate thread
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               //if there was a network issue
               if([[error localizedDescription] rangeOfString:@"offline"].location != 0) {
                   //alert the user of this issue and ask them to try again
                   UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot get movies" message:@"The internet connection appears to be offline." preferredStyle:UIAlertControllerStyleAlert];
                   
                   UIAlertAction* tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                       handler:^(UIAlertAction * action) {[self fetchMovies];}];
                   
                   [alert addAction:tryAgainAction];
                   [self presentViewController:alert animated:YES completion:nil];
               }
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               //get the array of movies
               self.movies = dataDictionary[@"results"];
               //reload table view data
               [self.collectionView reloadData];
               //stops the loading spinner
               [self.allMoviesSpinner stopAnimating];
           }
       }];
    
    //starts the task
    [task resume];
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AllMoviesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllMoviesCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.row]; //get the movie of interest

    //set movie poster
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    cell.allMoviesPoster.image = nil; //clear out the previous image
    [cell.allMoviesPoster setImageWithURL:posterURL];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController]
    // Pass the selected object to the new view controller.

    NSIndexPath *myIndexPath = [self.collectionView indexPathForCell: (AllMoviesCell*) sender];
    NSDictionary *dataToPass = self.movies[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}


@end
