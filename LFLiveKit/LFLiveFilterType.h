//
//  LFLiveFilterType.h
//  LFLiveKit
//
//  Created by GiapNguyen on 2024.
//  Copyright © 2024 GiapNguyen All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LFLiveFilterType) {
    LFLiveFilterTypeNone = 0,           //< no filter
    LFLiveFilterTypeBeauty = 1,         //< beauty filter
    LFLiveFilterTypeSepia = 2,          //< sepia filter
    LFLiveFilterTypeBlur = 3,           //< blur filter
    LFLiveFilterTypeSharpen = 4,        //< sharpen filter
    LFLiveFilterTypeEmboss = 5,         //< emboss filter
    LFLiveFilterTypeEdgeDetection = 6,  //< edge detection filter
    LFLiveFilterTypeBlackWhite = 7,     //< black white filter
    LFLiveFilterTypeVintage = 8,        //< vintage filter
    LFLiveFilterTypeVivid = 9           //< vivid filter
};
