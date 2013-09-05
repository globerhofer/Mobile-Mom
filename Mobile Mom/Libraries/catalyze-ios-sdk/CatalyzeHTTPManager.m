/*
 * Copyright (C) 2013 catalyze.io, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#import "CatalyzeHTTPManager.h"
#import "AFNetworking.h"
#import "Catalyze.h"

@interface CatalyzeHTTPManager()

@property BOOL returned401;
@property AFHTTPRequestOperation *operationHolder;
@property NSError *errorHolder;

@end

@implementation CatalyzeHTTPManager
@synthesize operationHolder = _operationHolder;
@synthesize errorHolder = _errorHolder;
@synthesize returned401 = _returned401;

- (void)doGet:(NSString *)urlString block:(CatalyzeHTTPResponseBlock)block {
    NSLog(@"GET - %@ - %@",urlString, [[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]);
    NSURL *url = [NSURL URLWithString:@""];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]]];
    NSLog(@"AUTH HEADER:: %@",[httpClient defaultValueForHeader:@"Authorization"]);
    [httpClient setDefaultHeader:@"X-Api-Key" value:[NSString stringWithFormat:@"ios %@ %@",[[NSBundle mainBundle] bundleIdentifier], [Catalyze applicationKey]]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient getPath:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        //[[NSUserDefaults standardUserDefaults] setValue:[[[[operation response] allHeaderFields] valueForKey:@"Authorization"] substringFromIndex:7] forKey:@"Authorization"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        if (!responseObject) {
            responseObject = [[NSDictionary dictionary] data];
        }
        block([[operation response] statusCode], [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error - %@ - %@", error, [error localizedDescription]);
        if ([[operation response] statusCode] == 401 && !_returned401) {
            NSLog(@"401 returned");
            /*_operationHolder = operation;
            _errorHolder = error;
            _returned401 = YES;
            [self loginWithBlock:^(int status, NSDictionary *response, NSError *error) {
                [self doGet:urlString block:block];
            }];*/
            block([[operation response] statusCode], nil, error);
        } else {
            _returned401 = NO;
            block([[operation response] statusCode], nil, error);
        }
    }];
}

- (void)doPost:(NSString *)urlString withParams:(NSDictionary *)params block:(CatalyzeHTTPResponseBlock)block {
    NSLog(@"POST - %@ - %@ - %@",urlString,params, [[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]);
    NSURL *url = [NSURL URLWithString:@""];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]]];
    NSLog(@"AUTH HEADER:: %@",[httpClient defaultValueForHeader:@"Authorization"]);
    [httpClient setDefaultHeader:@"X-Api-Key" value:[NSString stringWithFormat:@"ios %@ %@",[[NSBundle mainBundle] bundleIdentifier], [Catalyze applicationKey]]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient postPath:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        //[[NSUserDefaults standardUserDefaults] setValue:[[[[operation response] allHeaderFields] valueForKey:@"Authorization"] substringFromIndex:7] forKey:@"Authorization"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        if (!responseObject) {
            responseObject = [[NSDictionary dictionary] data];
        }
        block([[operation response] statusCode], [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error - %@ - %@", error, [error localizedDescription]);
        if ([[operation response] statusCode] == 401 && !_returned401) {
            NSLog(@"401 returned");
            /*_operationHolder = operation;
            _errorHolder = error;
            _returned401 = YES;
            [self loginWithBlock:^(int status, NSDictionary *response, NSError *error) {
                [self doPost:urlString withParams:params block:block];
            }];*/
            block([[operation response] statusCode], nil, error);
        } else {
            _returned401 = NO;
            block([[operation response] statusCode], nil, error);
        }
    }];
}

- (void)doQueryPost:(NSString *)urlString withParams:(NSDictionary *)params block:(CatalyzeHTTPArrayResponseBlock)block {
    NSLog(@"array POST - %@ - %@ - %@",urlString,params, [[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]);
    NSURL *url = [NSURL URLWithString:@""];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]]];
    NSLog(@"AUTH HEADER:: %@",[httpClient defaultValueForHeader:@"Authorization"]);
    [httpClient setDefaultHeader:@"X-Api-Key" value:[NSString stringWithFormat:@"ios %@ %@",[[NSBundle mainBundle] bundleIdentifier], [Catalyze applicationKey]]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient postPath:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success - %@ - %@",responseObject,[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil]);
        //[[NSUserDefaults standardUserDefaults] setValue:[[[[operation response] allHeaderFields] valueForKey:@"Authorization"] substringFromIndex:7] forKey:@"Authorization"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        if (!responseObject) {
            responseObject = [[NSArray array] data];
        }
        block([[operation response] statusCode], [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error - %@ - %@", error, [error localizedDescription]);
        if ([[operation response] statusCode] == 401 && !_returned401) {
            NSLog(@"401 returned");
            /*_operationHolder = operation;
             _errorHolder = error;
             _returned401 = YES;
             [self loginWithBlock:^(int status, NSDictionary *response, NSError *error) {
             [self doPost:urlString withParams:params block:block];
             }];*/
            block([[operation response] statusCode], nil, error);
        } else {
            _returned401 = NO;
            block([[operation response] statusCode], nil, error);
        }
    }];
}

- (void)doPut:(NSString *)urlString withParams:(NSDictionary *)params block:(CatalyzeHTTPResponseBlock)block {
    NSLog(@"PUT - %@ - %@ - %@",urlString, params, [[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]);
    NSURL *url = [NSURL URLWithString:@""];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]]];
    NSLog(@"AUTH HEADER:: %@",[httpClient defaultValueForHeader:@"Authorization"]);
    [httpClient setDefaultHeader:@"X-Api-Key" value:[NSString stringWithFormat:@"ios %@ %@",[[NSBundle mainBundle] bundleIdentifier], [Catalyze applicationKey]]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient putPath:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        //[[NSUserDefaults standardUserDefaults] setValue:[[[[operation response] allHeaderFields] valueForKey:@"Authorization"] substringFromIndex:7] forKey:@"Authorization"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        if (!responseObject) {
            responseObject = [[NSDictionary dictionary] data];
        }
        block([[operation response] statusCode], [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error - %@ - %@", error, [error localizedDescription]);
        if ([[operation response] statusCode] == 401 && !_returned401) {
            NSLog(@"401 returned");
            /*_operationHolder = operation;
            _errorHolder = error;
            _returned401 = YES;
            [self loginWithBlock:^(int status, NSDictionary *response, NSError *error) {
                [self doPut:urlString withParams:params block:block];
            }];*/
            block([[operation response] statusCode], nil, error);
        } else {
            _returned401 = NO;
            block([[operation response] statusCode], nil, error);
        }
    }];
}

- (void)doDelete:(NSString *)urlString block:(CatalyzeHTTPResponseBlock)block {
    NSLog(@"DELETE - %@ - %@",urlString, [[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]);
    NSURL *url = [NSURL URLWithString:@""];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]]];
    NSLog(@"AUTH HEADER:: %@",[httpClient defaultValueForHeader:@"Authorization"]);
    [httpClient setDefaultHeader:@"X-Api-Key" value:[NSString stringWithFormat:@"ios %@ %@",[[NSBundle mainBundle] bundleIdentifier], [Catalyze applicationKey]]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient deletePath:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        //[[NSUserDefaults standardUserDefaults] setValue:[[[[operation response] allHeaderFields] valueForKey:@"Authorization"] substringFromIndex:7] forKey:@"Authorization"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        if (!responseObject) {
            responseObject = [[NSDictionary dictionary] data];
        }
        block([[operation response] statusCode], [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error - %@ - %@", error, [error localizedDescription]);
        if ([[operation response] statusCode] == 401 && !_returned401) {
            NSLog(@"401 returned");
            /*_operationHolder = operation;
            _errorHolder = error;
            _returned401 = YES;
            [self loginWithBlock:^(int status, NSDictionary *response, NSError *error) {
                [self doDelete:urlString block:block];
            }];*/
            block([[operation response] statusCode], nil, error);
        } else {
            _returned401 = NO;
            block([[operation response] statusCode], nil, error);
        }
    }];
}

@end