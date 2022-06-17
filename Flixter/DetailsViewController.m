//
//  DetailsViewController.m
//  Flixter
//
//  Created by Alice Zhang on 6/15/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailsPosterView;
@property (weak, nonatomic) IBOutlet UILabel *movieHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsSynopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //bold the header labels
    [self.movieHeaderLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [self.overviewHeaderLabel setFont:[UIFont boldSystemFontOfSize:16]];

    //setting the movie title, synopsis, and rating
    self.detailsMovieLabel.text = self.detailDict[@"original_title"];
    self.detailsSynopsisLabel.text = self.detailDict[@"overview"];
    
    //[self.detailsMovieLabel sizeToFit];
    [self.detailsSynopsisLabel sizeToFit];
    
    //setting the movie poster and backdrop
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.detailDict[@"backdrop_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    self.detailsPosterView.image = nil; //clear out the previous image
    [self.detailsPosterView setImageWithURL:posterURL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
