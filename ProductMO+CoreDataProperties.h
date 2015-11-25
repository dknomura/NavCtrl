//
//  ProductMO+CoreDataProperties.h
//  NavCtrl
//
//  Created by Aditya Narayan on 11/24/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ProductMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *website;
@property (nullable, nonatomic, retain) NSNumber *index;
@property (nullable, nonatomic, retain) CompanyMO *whoSells;

@end

NS_ASSUME_NONNULL_END
