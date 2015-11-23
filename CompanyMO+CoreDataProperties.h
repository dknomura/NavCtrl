//
//  CompanyMO+CoreDataProperties.h
//  NavCtrl
//
//  Created by Daniel Nomura on 11/20/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CompanyMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *stockQuote;
@property (nullable, nonatomic, retain) NSSet<ProductMO *> *products;

@end

@interface CompanyMO (CoreDataGeneratedAccessors)

- (void)addProductsObject:(ProductMO *)value;
- (void)removeProductsObject:(ProductMO *)value;
- (void)addProducts:(NSSet<ProductMO *> *)values;
- (void)removeProducts:(NSSet<ProductMO *> *)values;

@end

NS_ASSUME_NONNULL_END
