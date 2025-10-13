#import "LFGPUVintageFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kLFGPUVintageFragmentShaderString = SHADER_STRING
                                                      (
    varying highp vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform highp float intensity;

    void main(){
    highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    
    // Màu nâu vàng cổ điển
    highp vec3 vintageColor = textureColor.rgb;
    
    // Tăng màu đỏ và vàng, giảm màu xanh
    vintageColor.r = pow(vintageColor.r, 0.8);
    vintageColor.g = pow(vintageColor.g, 0.9);
    vintageColor.b = pow(vintageColor.b, 1.2);
    
    // Thêm tông màu nâu vàng
    vintageColor.r *= 1.1;
    vintageColor.g *= 1.05;
    vintageColor.b *= 0.8;
    
    // Thêm độ ấm
    vintageColor.r += 0.05;
    vintageColor.g += 0.02;
    
    // Mix với màu gốc
    highp vec3 finalColor = mix(textureColor.rgb, vintageColor, intensity);
    
    gl_FragColor = vec4(clamp(finalColor, 0.0, 1.0), textureColor.a);
}
                                                      );
#else
NSString *const kLFGPUVintageFragmentShaderString = SHADER_STRING
                                                      (
    varying vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform mediump float intensity;

    void main(){
    vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    
    // Màu nâu vàng cổ điển
    vec3 vintageColor = textureColor.rgb;
    
    // Tăng màu đỏ và vàng, giảm màu xanh
    vintageColor.r = pow(vintageColor.r, 0.8);
    vintageColor.g = pow(vintageColor.g, 0.9);
    vintageColor.b = pow(vintageColor.b, 1.2);
    
    // Thêm tông màu nâu vàng
    vintageColor.r *= 1.1;
    vintageColor.g *= 1.05;
    vintageColor.b *= 0.8;
    
    // Thêm độ ấm
    vintageColor.r += 0.05;
    vintageColor.g += 0.02;
    
    // Mix với màu gốc
    vec3 finalColor = mix(textureColor.rgb, vintageColor, intensity);
    
    gl_FragColor = vec4(clamp(finalColor, 0.0, 1.0), textureColor.a);
}
                                                      );
#endif

@implementation LFGPUVintageFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLFGPUVintageFragmentShaderString])) {
        return nil;
    }

    _intensity = 1.0;
    [self setFloat:_intensity forUniformName:@"intensity"];
    return self;
}

- (void)setIntensity:(CGFloat)intensity {
    _intensity = intensity;
    [self setFloat:_intensity forUniformName:@"intensity"];
}

@end
