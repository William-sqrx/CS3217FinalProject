#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "archer" asset catalog image resource.
static NSString * const ACImageNameArcher AC_SWIFT_PRIVATE = @"archer";

/// The "arrow" asset catalog image resource.
static NSString * const ACImageNameArrow AC_SWIFT_PRIVATE = @"arrow";

/// The "enemy-castle" asset catalog image resource.
static NSString * const ACImageNameEnemyCastle AC_SWIFT_PRIVATE = @"enemy-castle";

/// The "monster" asset catalog image resource.
static NSString * const ACImageNameMonster AC_SWIFT_PRIVATE = @"monster";

/// The "player-castle" asset catalog image resource.
static NSString * const ACImageNamePlayerCastle AC_SWIFT_PRIVATE = @"player-castle";

/// The "river" asset catalog image resource.
static NSString * const ACImageNameRiver AC_SWIFT_PRIVATE = @"river";

/// The "swordsman" asset catalog image resource.
static NSString * const ACImageNameSwordsman AC_SWIFT_PRIVATE = @"swordsman";

/// The "tank" asset catalog image resource.
static NSString * const ACImageNameTank AC_SWIFT_PRIVATE = @"tank";

/// The "task" asset catalog image resource.
static NSString * const ACImageNameTask AC_SWIFT_PRIVATE = @"task";

#undef AC_SWIFT_PRIVATE
