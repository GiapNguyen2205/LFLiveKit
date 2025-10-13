#if __has_include(<GPUImage/GPUImageFramework.h>)
#import <GPUImage/GPUImageFramework.h>
#else
#import "GPUImage.h"
#endif

@interface LFGPUVintageFilter : GPUImageFilter {
}

@property (nonatomic, assign) CGFloat intensity;

@end
