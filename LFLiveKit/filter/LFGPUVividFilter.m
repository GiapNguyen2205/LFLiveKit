#import "LFGPUVividFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kLFGPUVividFragmentShaderString = SHADER_STRING
                                                      (
    varying highp vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform highp float saturation;

    void main(){
    highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    
    // Tính luminance
    highp float luminance = dot(textureColor.rgb, vec3(0.299, 0.587, 0.114));
    
    // Tăng độ bão hòa màu
    highp vec3 saturatedColor = mix(vec3(luminance), textureColor.rgb, saturation);
    
    // Tăng cường màu sắc
    saturatedColor = pow(saturatedColor, vec3(0.9));
    
    // Tăng độ tương phản nhẹ
    saturatedColor = (saturatedColor - 0.5) * 1.1 + 0.5;
    
    gl_FragColor = vec4(clamp(saturatedColor, 0.0, 1.0), textureColor.a);
}
                                                      );
#else
NSString *const kLFGPUVividFragmentShaderString = SHADER_STRING
                                                      (
    varying vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform mediump float saturation;

    void main(){
    vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    
    // Tính luminance
    float luminance = dot(textureColor.rgb, vec3(0.299, 0.587, 0.114));
    
    // Tăng độ bão hòa màu
    vec3 saturatedColor = mix(vec3(luminance), textureColor.rgb, saturation);
    
    // Tăng cường màu sắc
    saturatedColor = pow(saturatedColor, vec3(0.9));
    
    // Tăng độ tương phản nhẹ
    saturatedColor = (saturatedColor - 0.5) * 1.1 + 0.5;
    
    gl_FragColor = vec4(clamp(saturatedColor, 0.0, 1.0), textureColor.a);
}
                                                      );
#endif

@implementation LFGPUVividFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLFGPUVividFragmentShaderString])) {
        return nil;
    }

    _saturation = 1.5;
    [self setFloat:_saturation forUniformName:@"saturation"];
    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [super setInputSize:newSize atIndex:textureIndex];
    inputTextureSize = newSize;
}

- (void)setSaturation:(CGFloat)saturation {
    _saturation = saturation;
    [self setFloat:_saturation forUniformName:@"saturation"];
}

@end
