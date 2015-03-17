#ifndef DEBUG

#define weakself(ARGS) \
"weakself should be called as @weakself" @"" ? \
({  __weak typeof(self) _private_weakSelf = self; \
    ARGS { \
        __strong typeof(_private_weakSelf) self __attribute__((unused)) = _private_weakSelf; \
        return ^ (void) {

#define weakselfnotnil(ARGS) \
"weakself should be called as @weakself" @"" ? \
({  __weak typeof(self) _private_weakSelf = self; \
    ARGS { \
        __strong typeof(_private_weakSelf) self __attribute__((unused)) = _private_weakSelf; \
        return ^ (void) { if (self)

#else // DEBUG

struct RefCountCheckerData {
    CFTypeRef weakSelf;
    NSUInteger refCountBefore;
};

static inline void vbr_CheckRefCountForWeakSelf(struct RefCountCheckerData *data) {
    const NSUInteger refCountAfter = CFGetRetainCount(data->weakSelf);
    const NSUInteger countOfSelfRefInBlock = refCountAfter - data->refCountBefore;
    assert(countOfSelfRefInBlock == 0);
}

#define weakself(ARGS) \
"weakself should be called as @weakself" @"" ? \
({  __weak typeof(self) _private_weakSelf = self; \
    __attribute__((cleanup(vbr_CheckRefCountForWeakSelf), unused)) \
    struct RefCountCheckerData _private_refCountCheckerData = { \
        .weakSelf = (__bridge CFTypeRef)self, \
        .refCountBefore = CFGetRetainCount((__bridge CFTypeRef)self), \
    };\
    ARGS { \
        __strong typeof(_private_weakSelf) self __attribute__((unused)) = _private_weakSelf; \
        return ^ (void) {

#define weakselfnotnil(ARGS) \
"weakself should be called as @weakself" @"" ? \
({  __weak typeof(self) _private_weakSelf = self; \
    __attribute__((cleanup(vbr_CheckRefCountForWeakSelf), unused)) \
    struct RefCountCheckerData _private_refCountCheckerData = { \
        .weakSelf = (__bridge CFTypeRef)self, \
        .refCountBefore = CFGetRetainCount((__bridge CFTypeRef)self), \
    };\
    ARGS { \
        __strong typeof(_private_weakSelf) self __attribute__((unused)) = _private_weakSelf; \
        return ^ (void) { if (self)


#endif // DEBUG

#define weakselfend \
    try {} @finally {} } (); }; \
}) : nil
