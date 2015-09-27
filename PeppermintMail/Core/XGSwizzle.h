//
//  XGSwizzle.h
//  Peppermint
//
//  Created by Boris Remizov on 15/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#include <objc/objc.h>
#include <sys/cdefs.h>

__BEGIN_DECLS

/** @brief Replaces implementation of method [dst dstName] with
 *         implementation of the [src srcName]
 *  @param dst The class which method to swizzle
 *
 *  @param dstName The method to swizzle
 *
 *  @param src Class this which contains overridin function
 *
 *  @param srcName Overriding methos
 *
 *  @param backupNameOrNull Optional method name to store the dstName,
 *         if NULL dinamic name will be assigned
 *
 *  @return selector name to original dstName implementation,
 *          saved as additional method in the dst class. If the backupNameOrNull
 *          is not NULL return value will be equal to the backupNameOrNull
 */
SEL class_swizzleMethod(Class dst, SEL dstName, Class src, SEL srcName, SEL backupNameOrNull);

BOOL class_unswizzleMethod(Class dst, SEL dstName, SEL swizzleName);

__END_DECLS
