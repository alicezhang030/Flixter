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

//properties
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
//@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

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
    
    NSDictionary *movie = self.movies[indexPath.row]; //the movie of interest
    
    //set title and synopsis
    cell.titleLabel.text = movie[@"title"];
    cell.titleLabel.adjustsFontSizeToFitWidth = NO;
    cell.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    cell.synopsisLabel.text = movie[@"overview"];
    
    //[cell.titleLabel sizeToFit];
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
               } else {
                   //only stop spinning if there is no (longer) a network issue
                   [self.spinner stopAnimating];
               }
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               //Get the array of movies
               self.movies = dataDictionary[@"results"];
               
               //Reload table view data
               [self.tableView reloadData];
               [self.spinner stopAnimating];
           }
        
        [self.refreshControl endRefreshing];
       }];
    [task resume];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

 #pragma mark - Navigation
 
   //sender: the object that fired the event, which in this case would be cell that was touched
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     NSIndexPath *myIndexPath = [self.tableView indexPathForCell: (MovieCell*) sender];
     NSDictionary *dataToPass = self.movies[myIndexPath.row];
     DetailsViewController *detailVC = [segue destinationViewController];
     detailVC.detailDict = dataToPass;
 }
 
@end
