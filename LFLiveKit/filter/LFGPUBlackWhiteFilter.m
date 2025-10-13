#import "LFGPUBlackWhiteFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kLFGPUBlackWhiteFragmentShaderString = SHADER_STRING
                                                      (
    varying highp vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform highp float intensity;

    void main(){
    highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    
    // Chuyển đổi sang grayscale bằng luminance
    highp float gray = dot(textureColor.rgb, vec3(0.299, 0.587, 0.114));
    
    // Mix giữa màu gốc và màu đen trắng
    highp vec3 blackWhiteColor = vec3(gray);
    highp vec3 finalColor = mix(textureColor.rgb, blackWhiteColor, intensity);
    
    gl_FragColor = vec4(finalColor, textureColor.a);
}
                                                      );
#else
NSString *const kLFGPUBlackWhiteFragmentShaderString = SHADER_STRING
                                                      (
    varying vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform mediump float intensity;

    void main(){
    vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    
    // Chuyển đổi sang grayscale bằng luminance
    float gray = dot(textureColor.rgb, vec3(0.299, 0.587, 0.114));
    
    // Mix giữa màu gốc và màu đen trắng
    vec3 blackWhiteColor = vec3(gray);
    vec3 finalColor = mix(textureColor.rgb, blackWhiteColor, intensity);
    
    gl_FragColor = vec4(finalColor, textureColor.a);
}
                                                      );
#endif

@implementation LFGPUBlackWhiteFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLFGPUBlackWhiteFragmentShaderString])) {
        return nil;
    }

    _intensity = 1.0;
    [self setFloat:_intensity forUniformName:@"intensity"];
    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [super setInputSize:newSize atIndex:textureIndex];
    inputTextureSize = newSize;
}

- (void)setIntensity:(CGFloat)intensity {
    _intensity = intensity;
    [self setFloat:_intensity forUniformName:@"intensity"];
}

@end
