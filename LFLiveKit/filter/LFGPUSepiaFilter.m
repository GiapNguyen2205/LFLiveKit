#import "LFGPUSepiaFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kLFGPUSepiaFragmentShaderString = SHADER_STRING
                                                      (
    varying highp vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform highp float intensity;

    void main(){
    highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    
    // Ma trận sepia
    highp mat3 sepiaMatrix = mat3(
        0.393, 0.769, 0.189,
        0.349, 0.686, 0.168,
        0.272, 0.534, 0.131
    );
    
    highp vec3 sepiaColor = sepiaMatrix * textureColor.rgb;
    highp vec3 finalColor = mix(textureColor.rgb, sepiaColor, intensity);
    
    gl_FragColor = vec4(finalColor, textureColor.a);
}
                                                      );
#else
NSString *const kLFGPUSepiaFragmentShaderString = SHADER_STRING
                                                      (
    varying vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform mediump float intensity;

    void main(){
    vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    
    // Ma trận sepia
    mat3 sepiaMatrix = mat3(
        0.393, 0.769, 0.189,
        0.349, 0.686, 0.168,
        0.272, 0.534, 0.131
    );
    
    vec3 sepiaColor = sepiaMatrix * textureColor.rgb;
    vec3 finalColor = mix(textureColor.rgb, sepiaColor, intensity);
    
    gl_FragColor = vec4(finalColor, textureColor.a);
}
                                                      );
#endif

@implementation LFGPUSepiaFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLFGPUSepiaFragmentShaderString])) {
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
