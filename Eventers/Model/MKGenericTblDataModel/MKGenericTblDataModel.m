#import "MKGenericTblDataModel.h"

@implementation MKGenericTblDataModel

- (void)encodeWithCoder:(NSCoder *) coder
{
    [coder encodeObject:self.pCustom1 forKey:@"pCustom1"];
    [coder encodeObject:self.pCustom2 forKey:@"pCustom2"];
    [coder encodeObject:self.pCustom3 forKey:@"pCustom3"];
}
- (instancetype)initWithCoder:(NSCoder *)decoder {
    
    if ((self=[super init])) {
        _pCustom1=[decoder decodeObjectForKey:@"pCustom1"];
        _pCustom2=[decoder decodeObjectForKey:@"pCustom2"];
        _pCustom3=[decoder decodeObjectForKey:@"pCustom3"];
   
    }
    return self;
}

@end
