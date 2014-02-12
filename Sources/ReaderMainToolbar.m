//
//	ReaderMainToolbar.m
//	Reader v2.6.2
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2013 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ReaderConstants.h"
#import "ReaderMainToolbar.h"
#import "ReaderDocument.h"

#import <MessageUI/MessageUI.h>

@interface ReaderMainToolbar ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation ReaderMainToolbar
{
	UIButton *markButton;

	UIImage *markImageN;
	UIImage *markImageY;
    
    UIButton *doneButton;
    UIButton *thumbsButton;
    UIButton *flagButton;
    UIButton *emailButton;
    UIButton *printButton;
}

#pragma mark Constants

#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f
#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define DONE_BUTTON_WIDTH 56.0f
#define THUMBS_BUTTON_WIDTH 40.0f
#define PRINT_BUTTON_WIDTH 40.0f
#define EMAIL_BUTTON_WIDTH 40.0f
#define MARK_BUTTON_WIDTH 40.0f

#define TITLE_HEIGHT 28.0f

#pragma mark Properties

@synthesize delegate;

#pragma mark ReaderMainToolbar instance methods

- (id)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame document:nil];
}

- (void)setTintColor:(UIColor *)tintColor
{
    super.tintColor = tintColor;
    if (doneButton != nil) {
        [doneButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
    }
    if (thumbsButton != nil) {
        [thumbsButton setImage:[self imageNamed:@"Reader-Thumbs"withColor:self.tintColor] forState:UIControlStateNormal];
    }
    if (flagButton) {
        [self setFlagButtonIos7Image];
    }
    if (emailButton != nil) {
        [emailButton setImage:[self imageNamed:@"Reader-Email" withColor:self.tintColor] forState:UIControlStateNormal];
    }
    if (printButton != nil) {
        [printButton setImage:[self imageNamed:@"Reader-Print"withColor:self.tintColor] forState:UIControlStateNormal];
    }
}

- (id)initWithFrame:(CGRect)frame document:(ReaderDocument *)object
{
	assert(object != nil); // Must have a valid ReaderDocument

	if ((self = [super initWithFrame:frame]))
	{
		CGFloat viewWidth = self.bounds.size.width;

		UIImage *imageH = [UIImage imageNamed:@"Reader-Button-H"];
		UIImage *imageN = [UIImage imageNamed:@"Reader-Button-N"];

		UIImage *buttonH = [imageH stretchableImageWithLeftCapWidth:5 topCapHeight:0];
		UIImage *buttonN = [imageN stretchableImageWithLeftCapWidth:5 topCapHeight:0];

		CGFloat titleX = BUTTON_X; CGFloat titleWidth = (viewWidth - (titleX + titleX));

		CGFloat leftButtonX = BUTTON_X; // Left button start X position

#if (READER_STANDALONE == FALSE) // Option

		doneButton = [UIButton buttonWithType:UIButtonTypeCustom];

		doneButton.frame = CGRectMake(leftButtonX, BUTTON_Y, DONE_BUTTON_WIDTH, BUTTON_HEIGHT);
		[doneButton setTitle:NSLocalizedString(@"Done", @"button") forState:UIControlStateNormal];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            [doneButton setTitleColor:self.tintColor forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
            doneButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        }
        else{
            [doneButton setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
            [doneButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
            [doneButton setBackgroundImage:buttonN forState:UIControlStateNormal];
            doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        }
		[doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		doneButton.autoresizingMask = UIViewAutoresizingNone;
		doneButton.exclusiveTouch = YES;

		[self addSubview:doneButton]; leftButtonX += (DONE_BUTTON_WIDTH + BUTTON_SPACE);

		titleX += (DONE_BUTTON_WIDTH + BUTTON_SPACE); titleWidth -= (DONE_BUTTON_WIDTH + BUTTON_SPACE);

#endif // end of READER_STANDALONE Option

#if (READER_ENABLE_THUMBS == TRUE) // Option

		thumbsButton = [UIButton buttonWithType:UIButtonTypeCustom];

		thumbsButton.frame = CGRectMake(leftButtonX, BUTTON_Y, THUMBS_BUTTON_WIDTH, BUTTON_HEIGHT);
		[thumbsButton addTarget:self action:@selector(thumbsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            [thumbsButton setImage:[self imageNamed:@"Reader-Thumbs"withColor:self.tintColor] forState:UIControlStateNormal];
        }
        else{
            [thumbsButton setImage:[UIImage imageNamed:@"Reader-Thumbs"] forState:UIControlStateNormal];
            [thumbsButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
            [thumbsButton setBackgroundImage:buttonN forState:UIControlStateNormal];
        }
		thumbsButton.autoresizingMask = UIViewAutoresizingNone;
		thumbsButton.exclusiveTouch = YES;

		[self addSubview:thumbsButton]; //leftButtonX += (THUMBS_BUTTON_WIDTH + BUTTON_SPACE);

		titleX += (THUMBS_BUTTON_WIDTH + BUTTON_SPACE); titleWidth -= (THUMBS_BUTTON_WIDTH + BUTTON_SPACE);

#endif // end of READER_ENABLE_THUMBS Option

#if (READER_BOOKMARKS == TRUE || READER_ENABLE_MAIL == TRUE || READER_ENABLE_PRINT == TRUE)

		CGFloat rightButtonX = viewWidth; // Right button start X position

#endif // end of READER_BOOKMARKS || READER_ENABLE_MAIL || READER_ENABLE_PRINT Options

#if (READER_BOOKMARKS == TRUE) // Option

		rightButtonX -= (MARK_BUTTON_WIDTH + BUTTON_SPACE);

		flagButton = [UIButton buttonWithType:UIButtonTypeCustom];

		flagButton.frame = CGRectMake(rightButtonX, BUTTON_Y, MARK_BUTTON_WIDTH, BUTTON_HEIGHT);
		//[flagButton setImage:[UIImage imageNamed:@"Reader-Mark-N"] forState:UIControlStateNormal];
		[flagButton addTarget:self action:@selector(markButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            [self setFlagButtonIos7Image];
        }
        else{
            [flagButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
            [flagButton setBackgroundImage:buttonN forState:UIControlStateNormal];
            markImageN = [UIImage imageNamed:@"Reader-Mark-N"]; // N image
            markImageY = [UIImage imageNamed:@"Reader-Mark-Y"]; // Y image
        }
		flagButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		flagButton.exclusiveTouch = YES;

		[self addSubview:flagButton]; titleWidth -= (MARK_BUTTON_WIDTH + BUTTON_SPACE);

		markButton = flagButton; markButton.enabled = NO; markButton.tag = NSIntegerMin;

#endif // end of READER_BOOKMARKS Option

#if (READER_ENABLE_MAIL == TRUE) // Option

		if ([MFMailComposeViewController canSendMail] == YES) // Can email
		{
			unsigned long long fileSize = [object.fileSize unsignedLongLongValue];

			if (fileSize < (unsigned long long)15728640) // Check attachment size limit (15MB)
			{
				rightButtonX -= (EMAIL_BUTTON_WIDTH + BUTTON_SPACE);

				emailButton = [UIButton buttonWithType:UIButtonTypeCustom];

				emailButton.frame = CGRectMake(rightButtonX, BUTTON_Y, EMAIL_BUTTON_WIDTH, BUTTON_HEIGHT);
				[emailButton addTarget:self action:@selector(emailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
                    [emailButton setImage:[self imageNamed:@"Reader-Email" withColor:self.tintColor] forState:UIControlStateNormal];
                }
                else{
                    [emailButton setImage:[UIImage imageNamed:@"Reader-Email"] forState:UIControlStateNormal];
                    [emailButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
                    [emailButton setBackgroundImage:buttonN forState:UIControlStateNormal];
                }
				emailButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
				emailButton.exclusiveTouch = YES;

				[self addSubview:emailButton]; titleWidth -= (EMAIL_BUTTON_WIDTH + BUTTON_SPACE);
			}
		}

#endif // end of READER_ENABLE_MAIL Option

#if (READER_ENABLE_PRINT == TRUE) // Option

		if (object.password == nil) // We can only print documents without passwords
		{
			Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");

			if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
			{
				rightButtonX -= (PRINT_BUTTON_WIDTH + BUTTON_SPACE);

				printButton = [UIButton buttonWithType:UIButtonTypeCustom];

				printButton.frame = CGRectMake(rightButtonX, BUTTON_Y, PRINT_BUTTON_WIDTH, BUTTON_HEIGHT);
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
                    [printButton setImage:[self imageNamed:@"Reader-Print"withColor:self.tintColor] forState:UIControlStateNormal];
                }
                else{
                    [printButton setImage:[UIImage imageNamed:@"Reader-Print"] forState:UIControlStateNormal];
                    [printButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
                    [printButton setBackgroundImage:buttonN forState:UIControlStateNormal];
                }
				
				[printButton addTarget:self action:@selector(printButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
				printButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
				printButton.exclusiveTouch = YES;

				[self addSubview:printButton]; titleWidth -= (PRINT_BUTTON_WIDTH + BUTTON_SPACE);
			}
		}

#endif // end of READER_ENABLE_PRINT Option

		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
		{
			CGRect titleRect = CGRectMake(titleX, BUTTON_Y, titleWidth, TITLE_HEIGHT);

			UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];

			titleLabel.textAlignment = NSTextAlignmentCenter;
			titleLabel.font = [UIFont systemFontOfSize:19.0f];
			titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
			titleLabel.textColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
//			titleLabel.shadowColor = [UIColor colorWithWhite:0.65f alpha:1.0f];
			titleLabel.backgroundColor = [UIColor clearColor];
//			titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
			titleLabel.adjustsFontSizeToFitWidth = YES;
			titleLabel.minimumScaleFactor = 0.75f;
			titleLabel.text = [object.fileName stringByDeletingPathExtension];
            
            self.titleLabel = titleLabel;
			[self addSubview:self.titleLabel]; 
		}
	}

	return self;
}

-(void)setFlagButtonIos7Image
{
    UIImage *img = [UIImage imageNamed:@"Reader-Mark-Y" ]; // Y image
    
    markImageN = [self imageNamed:@"Reader-Mark-N" withColor:self.tintColor]; // N image
    CGSize size = CGSizeMake(32, 32);
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    float radius = 4.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1, 1, rect.size.width-2, rect.size.height-2) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    [self.tintColor setStroke];
    [path stroke];
    
    CGImageRef maskImage = [img CGImage];
    CGContextClipToMask(context, CGRectMake(size.width/2-img.size.width/2, size.height/2-img.size.height/2, img.size.width, img.size.height), maskImage);
    
    [self.tintColor setFill];
    CGContextFillRect(context, rect);
    
    // generate a new UIImage from the graphics context we drew onto
    markImageY = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color {
    // load the image
    
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 2.0);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGImageRef maskImage = [img CGImage];
    CGContextClipToMask(context, rect, maskImage);
    
    [color setFill];
    CGContextFillRect(context, rect);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

- (void)setBookmarkState:(BOOL)state
{
#if (READER_BOOKMARKS == TRUE) // Option

	if (state != markButton.tag) // Only if different state
	{
		if (self.hidden == NO) // Only if toolbar is visible
		{
			UIImage *image = (state ? markImageY : markImageN);

			[markButton setImage:image forState:UIControlStateNormal];
		}

		markButton.tag = state; // Update bookmarked state tag
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)updateBookmarkImage
{
#if (READER_BOOKMARKS == TRUE) // Option

	if (markButton.tag != NSIntegerMin) // Valid tag
	{
		BOOL state = markButton.tag; // Bookmarked state

		UIImage *image = (state ? markImageY : markImageN);

		[markButton setImage:image forState:UIControlStateNormal];
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of READER_BOOKMARKS Option
}

- (void)hideToolbar
{
	if (self.hidden == NO)
	{
		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.alpha = 0.0f;
			}
			completion:^(BOOL finished)
			{
				self.hidden = YES;
			}
		];
	}
}

- (void)showToolbar
{
	if (self.hidden == YES)
	{
		[self updateBookmarkImage]; // First

		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.hidden = NO;
				self.alpha = 1.0f;
			}
			completion:NULL
		];
	}
}

#pragma mark UIButton action methods

- (void)doneButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self doneButton:button];
}

- (void)thumbsButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self thumbsButton:button];
}

- (void)printButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self printButton:button];
}

- (void)emailButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self emailButton:button];
}

- (void)markButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self markButton:button];
}

@end
