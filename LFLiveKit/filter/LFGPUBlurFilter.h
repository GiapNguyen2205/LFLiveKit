#if __has_include(<GPUImage/GPUImageFramework.h>)
#import <GPUImage/GPUImageFramework.h>
#else
#import "GPUImage.h"
#endif

@interface LFGPUBlurFilter : GPUImageFilter {
}

@property (nonatomic, assign) CGFloat blurRadius;

@end
