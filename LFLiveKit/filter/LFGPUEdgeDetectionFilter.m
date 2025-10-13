#import "LFGPUEdgeDetectionFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kLFGPUEdgeDetectionFragmentShaderString = SHADER_STRING
                                                      (
    varying highp vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform highp float threshold;
    uniform highp vec2 imageSize;

    void main(){
    highp vec2 texelSize = 1.0 / imageSize;
    
    // Sobel edge detection kernel
    highp vec4 topLeft = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, -texelSize.y));
    highp vec4 top = texture2D(inputImageTexture, textureCoordinate + vec2(0.0, -texelSize.y));
    highp vec4 topRight = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, -texelSize.y));
    highp vec4 left = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, 0.0));
    highp vec4 right = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, 0.0));
    highp vec4 bottomLeft = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, texelSize.y));
    highp vec4 bottom = texture2D(inputImageTexture, textureCoordinate + vec2(0.0, texelSize.y));
    highp vec4 bottomRight = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, texelSize.y));
    
    // Sobel X kernel
    highp vec4 sobelX = topLeft + 2.0 * left + bottomLeft - topRight - 2.0 * right - bottomRight;
    
    // Sobel Y kernel  
    highp vec4 sobelY = topLeft + 2.0 * top + topRight - bottomLeft - 2.0 * bottom - bottomRight;
    
    // Tính magnitude của gradient
    highp float magnitude = length(vec2(sobelX.r, sobelY.r));
    
    // Áp dụng threshold
    highp float edge = step(threshold, magnitude);
    
    gl_FragColor = vec4(edge, edge, edge, 1.0);
}
                                                      );
#else
NSString *const kLFGPUEdgeDetectionFragmentShaderString = SHADER_STRING
                                                      (
    varying vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform mediump float threshold;
    uniform mediump vec2 imageSize;

    void main(){
    vec2 texelSize = 1.0 / imageSize;
    
    // Sobel edge detection kernel
    vec4 topLeft = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, -texelSize.y));
    vec4 top = texture2D(inputImageTexture, textureCoordinate + vec2(0.0, -texelSize.y));
    vec4 topRight = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, -texelSize.y));
    vec4 left = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, 0.0));
    vec4 right = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, 0.0));
    vec4 bottomLeft = texture2D(inputImageTexture, textureCoordinate + vec2(-texelSize.x, texelSize.y));
    vec4 bottom = texture2D(inputImageTexture, textureCoordinate + vec2(0.0, texelSize.y));
    vec4 bottomRight = texture2D(inputImageTexture, textureCoordinate + vec2(texelSize.x, texelSize.y));
    
    // Sobel X kernel
    vec4 sobelX = topLeft + 2.0 * left + bottomLeft - topRight - 2.0 * right - bottomRight;
    
    // Sobel Y kernel  
    vec4 sobelY = topLeft + 2.0 * top + topRight - bottomLeft - 2.0 * bottom - bottomRight;
    
    // Tính magnitude của gradient
    float magnitude = length(vec2(sobelX.r, sobelY.r));
    
    // Áp dụng threshold
    float edge = step(threshold, magnitude);
    
    gl_FragColor = vec4(edge, edge, edge, 1.0);
}
                                                      );
#endif

@implementation LFGPUEdgeDetectionFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLFGPUEdgeDetectionFragmentShaderString])) {
        return nil;
    }

    _threshold = 0.3;
    [self setFloat:_threshold forUniformName:@"threshold"];
    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [super setInputSize:newSize atIndex:textureIndex];
    inputTextureSize = newSize;
    
    [self setSize:inputTextureSize forUniformName:@"imageSize"];
}

- (void)setThreshold:(CGFloat)threshold {
    _threshold = threshold;
    [self setFloat:_threshold forUniformName:@"threshold"];
}

@end
