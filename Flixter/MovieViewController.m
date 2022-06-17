//
//  MovieViewController.m
//  Flixter
//
//  Created by Alice Zhang on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl; //pull down and refresh the page
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner; //spinner while waiting for API

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting up TableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.spinner.hidesWhenStopped = YES; //when the data retrival is finished, the spinner will disappear
    [self.spinner startAnimating];
    
    [self fetchMovies];
    
    //refresh functionality
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row]; //get the movie of interest
    
    //set title and synopsis
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    [cell.synopsisLabel sizeToFit];
    
    //set movie poster
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil; //clear out the previous image
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
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
               [self.tableView reloadData];
               //stops the loading spinner
               [self.spinner stopAnimating];
           }
        
        [self.refreshControl endRefreshing];
       }];
    
    //starts the task
    [task resume];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

 #pragma mark - Navigation
 
   //sender: the object that fired the event, which in this case would be cell that was touched
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     //get the new view controller using [segue destinationViewController]
     //pass the selected object to the new view controller.
     NSIndexPath *myIndexPath = [self.tableView indexPathForCell: (MovieCell*) sender];
     NSDictionary *dataToPass = self.movies[myIndexPath.row];
     DetailsViewController *detailVC = [segue destinationViewController];
     detailVC.detailDict = dataToPass;
 }
 
@end
