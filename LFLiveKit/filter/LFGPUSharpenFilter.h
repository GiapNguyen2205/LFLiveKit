#if __has_include(<GPUImage/GPUImageFramework.h>)
#import <GPUImage/GPUImageFramework.h>
#else
#import "GPUImage.h"
#endif

@interface LFGPUSharpenFilter : GPUImageFilter {
}

@property (nonatomic, assign) CGFloat sharpness;

@end
