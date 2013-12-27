//
//  PhotoView.m
//  iReporter
//
//  Created by lady8844 on 13-12-26.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//

#import "PhotoView.h"
#import "API.h"

@implementation PhotoView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithIndex:(int)i andData:(NSDictionary*)data{
    self = [super init];
    if(self != nil){
        self.tag = [[data objectForKey:@"IdPhoto" ] intValue];
        
        int row = i / 3;
        int col = i % 3;
        
        self.frame = CGRectMake(1.5 * kPadding + col * (kThumbSide+kPadding), 1.5 * kPadding+row*(kThumbSide+kPadding), kThumbSide, kThumbSide);
        self.backgroundColor = [UIColor grayColor];
        
        //add the photo caption
        UILabel* caption = [[UILabel alloc] initWithFrame:CGRectMake(0, kThumbSide-16, kThumbSide, 16)];
        
        caption.backgroundColor = [UIColor blackColor];
        caption.textColor = [UIColor whiteColor];
        caption.textAlignment = UITextAlignmentCenter;
        caption.font = [UIFont systemFontOfSize:12];
        caption.text = [NSString stringWithFormat:@"@%@", [data objectForKey:@"username"]];
        [self addSubview:caption];
        
        //step2
        //add touch event
        [self addTarget:delegate action:@selector(didSelectPhoto:) forControlEvents:UIControlEventTouchUpInside];
        
        //load the image
        API* api = [API sharedInstance];
        int IdPhoto = [[data objectForKey:@"IdPhoto"] intValue];
        NSURL *imageURL = [api urlForImageWithId:[NSNumber numberWithInt:IdPhoto] isThumb:YES];
        
        NSLog(@"%@", imageURL);
        AFImageRequestOperation* imageOperation =
        [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:imageURL]
                                                          success:^(UIImage* image){
                                                              //create an image view, and it to the view
                                                              UIImageView* thumbView = [[UIImageView alloc] initWithImage:image];
                                                              thumbView.frame = CGRectMake(0,0,90,90);
                                                              thumbView.contentMode = UIViewContentModeScaleAspectFit;
                                                              [self insertSubview:thumbView belowSubview:caption];
                                                          }];
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        [queue addOperation:imageOperation];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
