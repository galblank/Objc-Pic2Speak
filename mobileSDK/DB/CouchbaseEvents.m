//
//  CouchbaseEvents.m
//  Pic2Speak
//
//  Created by Gal Blank on 1/8/16.
//  Copyright © 2016 Gal Blank. All rights reserved.
//

#import "CouchbaseEvents.h"
#import "CBObjects.h"

@implementation CouchbaseEvents

// creates the Document
- (NSString *)createDocument: (CBLDatabase *)database {
    NSError *error;
    
    
    // create an object that contains data for the new document
    
    NSDictionary *myDictionary = @{
                                   @"name"     :
                                       @"Big Party",
                                   
                                   @"location" :
                                       @"My House"
                                   
                                   };
    
    
    // Create an empty document
    
    CBLDocument *doc = [database createDocument];
    
    
    // Save the ID of the new document
    
    NSString *docID = doc.documentID;
    
    
    // Write the document to the database
    
    CBLRevision *newRevision = [doc putProperties: myDictionary error:
                                &error];
    if (newRevision) {
        NSLog(@"Document created and written to database, ID = %@", docID);
    }
    return docID;
}

- (BOOL) updateDocument:(CBLDatabase *) database documentId:(NSString *) documentId {
    // 1. Retrieve the document from the database
    CBLDocument *getDocument = [database documentWithID: documentId];
    // 2. Make a mutable copy of the properties from the document we just retrieved
    NSMutableDictionary *docContent = [getDocument.properties mutableCopy];
    // 3. Modify the document properties
    docContent[@"description"] = @"Anyone is invited!";
    docContent[@"address"] = @"123 Elm St.";
    docContent[@"date"] = @"2014";
    // 4. Save the Document revision to the database
    NSError *error;
    CBLSavedRevision *newRev = [getDocument putProperties:docContent error:&error];
    if (!newRev) {
        NSLog(@"Cannot update document. Error message: %@", error.localizedDescription);
    }
    // 5. Display the new revision of the document
    NSLog(@"The new revision of the document contains: %@", newRev.properties);
    return YES;
}

- (BOOL)helloCBL {
    NSString* docID = [self createDocument:CBObjects.sharedInstance.database];
    return NO;
}


@end
