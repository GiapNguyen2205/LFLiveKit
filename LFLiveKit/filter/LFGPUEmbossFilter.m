#import "LFGPUEmbossFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kLFGPUEmbossFragmentShaderString = SHADER_STRING
                                                      (
    varying highp vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform highp float intensity;
    uniform highp vec2 imageSize;

    void main(){
    highp vec2 texelSize = 1.0 / imageSize;
    
    // Emboss kernel
    highp vec4 topLeft = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, -texelSize.y));
    highp vec4 topRight = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, -texelSize.y));
    highp vec4 bottomLeft = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, texelSize.y));
    highp vec4 bottomRight = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, texelSize.y));
    
    // Tính toán emboss effect
    highp vec4 embossed = (topLeft - bottomRight) * intensity;
    embossed += 0.5; // Thêm offset để có màu trung tính
    
    gl_FragColor = clamp(embossed, 0.0, 1.0);
}
                                                      );
#else
NSString *const kLFGPUEmbossFragmentShaderString = SHADER_STRING
                                                      (
    varying vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform mediump float intensity;
    uniform mediump vec2 imageSize;

    void main(){
    vec2 texelSize = 1.0 / imageSize;
    
    // Emboss kernel
    vec4 topLeft = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, -texelSize.y));
    vec4 topRight = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, -texelSize.y));
    vec4 bottomLeft = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, texelSize.y));
    vec4 bottomRight = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, texelSize.y));
    
    // Tính toán emboss effect
    vec4 embossed = (topLeft - bottomRight) * intensity;
    embossed += 0.5; // Thêm offset để có màu trung tính
    
    gl_FragColor = clamp(embossed, 0.0, 1.0);
}
                                                      );
#endif

@implementation LFGPUEmbossFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLFGPUEmbossFragmentShaderString])) {
        return nil;
    }

    _intensity = 1.0;
    [self setFloat:_intensity forUniformName:@"intensity"];
    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [super setInputSize:newSize atIndex:textureIndex];
    
    [self setSize:newSize forUniformName:@"imageSize"];
}

- (void)setIntensity:(CGFloat)intensity {
    _intensity = intensity;
    [self setFloat:_intensity forUniformName:@"intensity"];
}

@end
