//
//  UIColor+ColorUtility.m


#import "UIColor+ColorUtility.h"

@implementation UIColor (ColorUtility)

/**
 *十六进制转RGB
 */
+ (UIColor *)convertHexToRGB:(NSString *)hexString{
    if ([hexString length] < 6) {
        return nil;
    }
    NSString *str;
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        str=[[NSString alloc] initWithFormat:@"%@",hexString];
    }else {
        str=[[NSString alloc] initWithFormat:@"0x%@",hexString];
    }
    
    int rgb;
    sscanf([str cStringUsingEncoding:NSUTF8StringEncoding], "%i", &rgb);
    int red=rgb/(256*256)%256;
    int green=rgb/256%256;
    int blue=rgb%256;
    UIColor *color=[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    return color;
}

/**
 *十六进制转RGB
 */
+ (UIColor *)convertHexToRGB:(NSString *)hexString withAlpha:(CGFloat)alpha{
    if ([hexString length] < 6) {
        return nil;
    }
    NSString *str;
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        str=[[NSString alloc] initWithFormat:@"%@",hexString];
    }else {
        str=[[NSString alloc] initWithFormat:@"0x%@",hexString];
    }
    
    int rgb;
    sscanf([str cStringUsingEncoding:NSUTF8StringEncoding], "%i", &rgb);
    int red=rgb/(256*256)%256;
    int green=rgb/256%256;
    int blue=rgb%256;
    UIColor *color=[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    return color;
}

/*
 *随机颜色
 */
+(UIColor *)randomColor{
    static BOOL	seeded=NO;
    if(!seeded){
        seeded=YES;
        srandom((int)time(NULL));
    }
    CGFloat red=(CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green=(CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue=(CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}


#pragma mark -UIColor Image
+ (UIImage *)createImageWithColor:(UIColor *)color withFrame:(CGRect)frame
{
    CGRect rect = frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



@end
