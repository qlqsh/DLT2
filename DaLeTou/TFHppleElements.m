//
//  TFHppleElements.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/22.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "TFHppleElements.h"

@implementation TFHppleElements

+ (NSArray *)search:(NSString *)search specificContent:(NSString *)content {
	// 空搜索、空内容，数组返回nil
	if (nil == search || [@"" isEqualToString:search]) {
		return nil;
	}

	if (nil == content || [@"" isEqualToString:content]) {
		return nil;
	}

	NSData *htmlData = [content dataUsingEncoding:NSUTF8StringEncoding];
	TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
	NSArray *elements = [doc searchWithXPathQuery:search];

	return [elements copy];
}

@end
