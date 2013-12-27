//
//  PhotoView.h
//  iReporter
//
//  Created by lady8844 on 13-12-26.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kThumbSide 90
#define kPadding 10

@protocol PhotoViewDelegate <NSObject>
-(void)didSelectPhoto:(id)sender;
@end

@interface PhotoView:UIButton
@property (assign, nonatomic)id <PhotoViewDelegate> delegate;
-(id)initWithIndex:(int)i andData:(NSDictionary*)data;
@end
