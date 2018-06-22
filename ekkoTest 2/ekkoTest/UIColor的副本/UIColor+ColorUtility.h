//
//  UIColor+ColorUtility.h


#import <UIKit/UIKit.h>

@interface UIColor (ColorUtility)

+ (UIColor *)convertHexToRGB:(NSString *)hexString;

+ (UIColor *)convertHexToRGB:(NSString *)hexString withAlpha:(CGFloat)alpha;

+ (UIColor *)randomColor;

+ (UIImage *)createImageWithColor:(UIColor *)color withFrame:(CGRect)frame;

@end
