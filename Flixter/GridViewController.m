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

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    
    [self fetchMovies];
}

- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    //Handle the result in separate thread
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               if([[error localizedDescription] rangeOfString:@"offline"].location != 0) { //network issue
                   UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot get movies" message:@"The internet connection appears to be offline." preferredStyle:UIAlertControllerStyleAlert];
                   
                   UIAlertAction* tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                       handler:^(UIAlertAction * action) {[self fetchMovies];}];
                   
                   [alert addAction:tryAgainAction];
                   [self presentViewController:alert animated:YES completion:nil];
               }
               
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               //Get the array of movies
               self.movies = dataDictionary[@"results"];
               
               //Reload table view data
               [self.collectionView reloadData];
           }
       }];
    [task resume];
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AllMoviesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllMoviesCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.row]; //the movie of interest

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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *myIndexPath = [self.collectionView indexPathForCell: (AllMoviesCell*) sender];
    NSDictionary *dataToPass = self.movies[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}


@end
