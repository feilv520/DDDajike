//
//  MyMD5.m
//  GoodLectures
//
//  Created by yangshangqing on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyMD5.h"
#import "CommonCrypto/CommonDigest.h"
#import "commonTools.h"

//#define CHUNK_SIZE 32

@implementation MyMD5

+(NSString *) md5: (NSString *) inPutText 
{
    if ([commonTools isNull:inPutText]) {
        return @"";
    }
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

//+(NSString*)fileMD5:(NSString*)path
//{
//    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
//    if( handle== nil ) return @"ERROR GETTING FILE MD5"; // file didnt exist
//    
//    CC_MD5_CTX md5;
//    
//    CC_MD5_Init(&md5);
//    
//    BOOL done = NO;
//    while(!done)
//    {
//        NSData* fileData = [handle readDataOfLength: CHUNK_SIZE ];
//        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
//        if( [fileData length] == 0 ) done = YES;
//    }
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5_Final(digest, &md5);
//    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                   digest[0], digest[1],
//                   digest[2], digest[3],
//                   digest[4], digest[5],
//                   digest[6], digest[7],
//                   digest[8], digest[9],
//                   digest[10], digest[11],
//                   digest[12], digest[13],
//                   digest[14], digest[15]];
//    return s;
//}
@end
