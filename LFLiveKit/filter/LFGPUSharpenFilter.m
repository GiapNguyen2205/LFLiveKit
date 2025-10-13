#import "LFGPUSharpenFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kLFGPUSharpenFragmentShaderString = SHADER_STRING
                                                      (
    varying highp vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform highp float sharpness;
    uniform highp vec2 imageSize;

    void main(){
    highp vec2 texelSize = 1.0 / imageSize;
    
    // Lấy màu của pixel hiện tại và các pixel xung quanh
    highp vec4 centerColor = texture2D(inputImageTexture, textureCoordinate);
    highp vec4 leftColor = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, 0.0));
    highp vec4 rightColor = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, 0.0));
    highp vec4 topColor = texture2D(inputImageTexture, textureCoordinate + vec2(0.0, -texelSize.y));
    highp vec4 bottomColor = texture2D(inputImageTexture, textureCoordinate + vec2(0.0, texelSize.y));
    
    // Kernel sharpening
    highp vec4 sharpenedColor = centerColor * (1.0 + 4.0 * sharpness) - 
                               (leftColor + rightColor + topColor + bottomColor) * sharpness;
    
    gl_FragColor = clamp(sharpenedColor, 0.0, 1.0);
}
                                                      );
#else
NSString *const kLFGPUSharpenFragmentShaderString = SHADER_STRING
                                                      (
    varying vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform mediump float sharpness;
    uniform mediump vec2 imageSize;

    void main(){
    vec2 texelSize = 1.0 / imageSize;
    
    // Lấy màu của pixel hiện tại và các pixel xung quanh
    vec4 centerColor = texture2D(inputImageTexture, textureCoordinate);
    vec4 leftColor = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, 0.0));
    vec4 rightColor = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, 0.0));
    vec4 topColor = texture2D(inputImageTexture, textureCoordinate + vec2(0.0, -texelSize.y));
    vec4 bottomColor = texture2D(inputImageTexture, textureCoordinate + vec2(0.0, texelSize.y));
    
    // Kernel sharpening
    vec4 sharpenedColor = centerColor * (1.0 + 4.0 * sharpness) - 
                         (leftColor + rightColor + topColor + bottomColor) * sharpness;
    
    gl_FragColor = clamp(sharpenedColor, 0.0, 1.0);
}
                                                      );
#endif

@implementation LFGPUSharpenFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLFGPUSharpenFragmentShaderString])) {
        return nil;
    }

    _sharpness = 0.5;
    [self setFloat:_sharpness forUniformName:@"sharpness"];
    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [super setInputSize:newSize atIndex:textureIndex];
    inputTextureSize = newSize;
    
    GPUVector2 imageSize = {newSize.width, newSize.height};
    [self setFloatVec2:imageSize forUniform:@"imageSize"];
}

- (void)setSharpness:(CGFloat)sharpness {
    _sharpness = sharpness;
    [self setFloat:_sharpness forUniformName:@"sharpness"];
}

@end
