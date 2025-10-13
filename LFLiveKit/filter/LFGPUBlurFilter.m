#import "LFGPUBlurFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kLFGPUBlurFragmentShaderString = SHADER_STRING
                                                      (
    varying highp vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform highp float blurRadius;
    uniform highp vec2 imageSize;

    void main(){
    highp vec4 color = vec4(0.0);
    highp float total = 0.0;
    
    // Gaussian blur kernel
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            highp vec2 offset = vec2(float(x), float(y)) * blurRadius / imageSize;
            highp float weight = exp(-(float(x*x + y*y)) / (2.0 * blurRadius * blurRadius));
            color += texture2D(inputImageTexture, textureCoordinate + offset) * weight;
            total += weight;
        }
    }
    
    gl_FragColor = color / total;
}
                                                      );
#else
NSString *const kLFGPUBlurFragmentShaderString = SHADER_STRING
                                                      (
    varying vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform mediump float blurRadius;
    uniform mediump vec2 imageSize;

    void main(){
    vec4 color = vec4(0.0);
    float total = 0.0;
    
    // Gaussian blur kernel
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * blurRadius / imageSize;
            float weight = exp(-(float(x*x + y*y)) / (2.0 * blurRadius * blurRadius));
            color += texture2D(inputImageTexture, textureCoordinate + offset) * weight;
            total += weight;
        }
    }
    
    gl_FragColor = color / total;
}
                                                      );
#endif

@implementation LFGPUBlurFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLFGPUBlurFragmentShaderString])) {
        return nil;
    }

    _blurRadius = 1.0;
    [self setFloat:_blurRadius forUniformName:@"blurRadius"];
    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [super setInputSize:newSize atIndex:textureIndex];
    inputTextureSize = newSize;
    
    GPUVector2 imageSize = {newSize.width, newSize.height};
    [self setFloatVec2:imageSize forUniform:@"imageSize"];
}

- (void)setBlurRadius:(CGFloat)blurRadius {
    _blurRadius = blurRadius;
    [self setFloat:_blurRadius forUniformName:@"blurRadius"];
}

@end
