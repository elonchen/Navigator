//
//  NAVTransition.m
//  NavigationRouter
//

#import <YOLOKit/YOLO.h>
#import "NAVTransition.h"
#import "NAVURLParser.h"
#import "YOLT.h"

@interface NAVTransition ()
@property (strong, nonatomic) NAVAttributesBuilder *attributesBuilder;
@property (strong, nonatomic) NSArray *updates;
@end

@implementation NAVTransition

- (instancetype)init
{
    return [self initWithAttributesBuilder:nil];
}

- (instancetype)initWithAttributesBuilder:(NAVAttributesBuilder *)attributesBuilder
{
    NSParameterAssert(attributesBuilder);
    
    if(self = [super init]) {
        _attributesBuilder = attributesBuilder;
    }
    
    return self;
}

- (void)startWithUrl:(NAVURL *)url
{
    NAVAttributes *attributes = self.attributesBuilder.build(url);
    self.updates = [self updatesFromAttributes:attributes];
}

# pragma mark - Updates

- (NSArray *)updatesFromAttributes:(NAVAttributes *)attributes
{
    NAVURLParsingResults *results = [NAVURLParser parseFromUrl:attributes.source toUrl:attributes.destination];
    
    // first we need create updates for any disabled parameters
    NSArray *updates = results.parametersToDisable.map(^(NAVURLParameter *parameter) {
        return nil;
    });
    
    if(results.componentToReplace) {
        updates = updates.nav_append(nil);
    }
    
    if(results.componentsToPop.count) {
        updates = updates.nav_append(nil);
    }
    
    // add a replace/push for every component between the diverge point and the end of the new components
    updates = updates.concat(results.componentsToPush.map(^(NAVURLComponent *component) {
        return nil;
    }));
    
    // add updates for any parameters being enabled
    updates = updates.concat(results.parametersToEnable.map(^(NAVURLParameter *parameter) {
        return nil;
    }));

    return updates;
}

@end