#import <UIKit/UIKit.h>

static NSString *const kPattern = @"device_id=[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}";
static NSString *const kNewId = @"device_id=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";

%hook NSMutableURLRequest

-(void)setURL:(NSURL *)URL {
    if (![[URL host] isEqualToString: @"api.minhaya.com"]) {
        return %orig;
    }

    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:YES];
    NSString *query = components.percentEncodedQuery;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:query options:0 range:NSMakeRange(0, query.length)];
    if (!match) {
        return %orig;
    }
    NSString* newQuery = [query stringByReplacingOccurrencesOfString:kPattern withString:kNewId options:NSRegularExpressionSearch range:NSMakeRange(0, query.length)];
    NSLog(@"Query Replace: %@", newQuery);
    components.percentEncodedQuery = newQuery;
    return %orig(components.URL);
}

- (void)setHTTPBody:(NSData *)body
{
    NSString *httpBody = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    if([httpBody length] == 0) {
        return %orig;
    }

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:httpBody options:0 range:NSMakeRange(0, httpBody.length)];
    if (!match) {
        return %orig;
    }
    NSString* result = [httpBody stringByReplacingOccurrencesOfString:kPattern withString:kNewId options:NSRegularExpressionSearch range:NSMakeRange(0, httpBody.length)];
    NSLog(@"HTTPBody Replace: %@", result);
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    return %orig(data);
}

%end
