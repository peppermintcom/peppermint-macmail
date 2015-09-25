/*
 *     Generated by class-dump 3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2012 by Steve Nygard.
 */

#import "Mail/ImageResizerDelegate.h"
#import "Mail/MCActivityTarget.h"
#import "Mail/MCMessageHeaders.h"

@import Cocoa;

@class DOMNode, EditableWebMessageDocument, MCInvocationQueue, MCParsedMessage, MFMailAccount, MFMailbox, NSArray, NSInputStream, NSMutableArray, NSMutableData, NSMutableDictionary, NSMutableSet, NSNumber, NSOutputStream, NSPort, NSString, NSURL, NSUUID, NSUndoManager, NSUserActivity, StationeryController;

@interface ComposeBackEnd : NSObject <ImageResizerDelegate, MCActivityTarget, NSStreamDelegate, NSUserActivityDelegate>
{
    id _delegate;
    StationeryController *_stationeryController;
    NSArray *_originalMessages;
    NSMutableDictionary *_originalMessageHeaders;
    NSMutableDictionary *_originalMessageBodies;
    NSMutableDictionary *_cleanHeaders;
    NSMutableDictionary *_extraRecipients;
    NSMutableDictionary *_directoriesByAttachment;
    NSMutableSet *_knownMessageIds;
    unsigned long long _type;
    BOOL _hasChanges;
    BOOL _shouldDownloadRemoteAttachments;
    BOOL _overrideRemoteAttachmentsPreference;
    NSMutableDictionary *_contentsByMessage;
    NSMutableDictionary *_attachmentMimeBodiesByURL;
    NSMutableArray *_resizers;
    NSMutableArray *_composeDataToStream;
    BOOL _includeHeaders;
    BOOL _signIfPossible;
    BOOL _encryptIfPossible;
    BOOL _isUndeliverable;
    BOOL _isDeliveringMessage;
    BOOL _willCloseEditor;
    BOOL _saveThreadCancelFlag;
    BOOL _editorHasInitialized;
    BOOL _hadChangesBeforeSave;
    BOOL _contentsWasEditedByUser;
    BOOL _isSettingSenderFromGetter;
    BOOL _delegateRespondsToDidChange;
    BOOL _delegateRespondsToSenderDidChange;
    BOOL _delegateRespondsToDidAppendMessage;
    BOOL _delegateRespondsToDidSaveMessage;
    BOOL _delegateRespondsToDidBeginLoad;
    BOOL _delegateRespondsToDidEndLoad;
    BOOL _delegateRespondsToWillCreateMessageWithHeaders;
    BOOL _delegateRespondsToShouldSaveMessage;
    BOOL _delegateRespondsToShouldDeliverMessage;
    BOOL _delegateRespondsToDidCancelMessageDeliveryForMissingCertificatesForRecipients;
    BOOL _delegateRespondsToDidCancelMessageDeliveryForEncryptionError;
    BOOL _delegateRespondsToDidCancelMessageDeliveryForError;
    BOOL _delegateRespondsToDidCancelMessageDeliveryForAttachmentError;
    BOOL _knowsCanSign;
    BOOL _canSign;
    BOOL _isEditing;
    BOOL _isSendFormatInitialized;
    BOOL _isAppleScriptMessage;
    BOOL _sendAttachmentsViaMailDrop;
    BOOL _attachmentUploadFailed;
    NSString *_contentForContactsUpdate;
    NSNumber *_uniqueID;
    NSURL *_vcardFileForContactsUpdate;
    NSString *_saveThreadMessageId;
    MFMailbox *_saveThreadMailbox;
    NSURL *_originalMessageBaseURL;
    MCParsedMessage *_originalMessageParsedMessage;
    EditableWebMessageDocument *_document;
    NSUUID *_documentID;
    NSUndoManager *_undoManager;
    long long _composeMode;
    MCParsedMessage *_initialParsedMessage;
    NSArray *_generatedParsedMessages;
    DOMNode *_stationerySignatureNode;
    NSPort *_initializationPort;
    MCInvocationQueue *_saveQueue;
    MCParsedMessage *_restoredParsedMessage;
    long long _windowsFriendliness;
    unsigned long long _encodingHint;
    NSUserActivity *_activity;
    unsigned long long _composeDataOffset;
    unsigned long long _imagesToResize;
    NSPort *_resizePort;
    unsigned long long _imageArchiveSize;
    NSOutputStream *_outputStream;
    NSInputStream *_inputStream;
    unsigned long long _replyBytesRead;
    NSMutableData *_replyData;
    NSUUID *_placeholderMessageID;
}

+ (id)keyPathsForValuesAffectingAccount;
+ (id)supportedMailboxTypes;
+ (void)initialize;
+ (id)composeBackEndsByUniqueID;
+ (id)_messageEditorForComposeBackEnd:(id)arg1 window:(id *)arg2;
+ (void)unregisterComposeBackEnd:(id)arg1;
+ (void)registerComposeBackEnd:(id)arg1;
+ (id)composeBackEndForUniqueID:(id)arg1;
@property(retain, nonatomic) NSUUID *placeholderMessageID; // @synthesize placeholderMessageID=_placeholderMessageID;
@property(retain, nonatomic) NSMutableData *replyData; // @synthesize replyData=_replyData;
@property(nonatomic) unsigned long long replyBytesRead; // @synthesize replyBytesRead=_replyBytesRead;
@property __weak NSInputStream *inputStream; // @synthesize inputStream=_inputStream;
@property __weak NSOutputStream *outputStream; // @synthesize outputStream=_outputStream;
@property(nonatomic) BOOL attachmentUploadFailed; // @synthesize attachmentUploadFailed=_attachmentUploadFailed;
@property(nonatomic) unsigned long long imageArchiveSize; // @synthesize imageArchiveSize=_imageArchiveSize;
@property(readonly, nonatomic) NSPort *resizePort; // @synthesize resizePort=_resizePort;
@property unsigned long long imagesToResize; // @synthesize imagesToResize=_imagesToResize;
@property(nonatomic) unsigned long long composeDataOffset; // @synthesize composeDataOffset=_composeDataOffset;
@property(retain, nonatomic) NSUserActivity *activity; // @synthesize activity=_activity;
@property(nonatomic) BOOL sendAttachmentsViaMailDrop; // @synthesize sendAttachmentsViaMailDrop=_sendAttachmentsViaMailDrop;
@property(nonatomic) unsigned long long encodingHint; // @synthesize encodingHint=_encodingHint;
@property(nonatomic) BOOL isAppleScriptMessage; // @synthesize isAppleScriptMessage=_isAppleScriptMessage;
@property(nonatomic) BOOL isSendFormatInitialized; // @synthesize isSendFormatInitialized=_isSendFormatInitialized;
@property(nonatomic) BOOL isEditing; // @synthesize isEditing=_isEditing;
@property(nonatomic) BOOL canSign; // @synthesize canSign=_canSign;
@property(nonatomic) BOOL knowsCanSign; // @synthesize knowsCanSign=_knowsCanSign;
@property(nonatomic) BOOL delegateRespondsToDidCancelMessageDeliveryForAttachmentError; // @synthesize delegateRespondsToDidCancelMessageDeliveryForAttachmentError=_delegateRespondsToDidCancelMessageDeliveryForAttachmentError;
@property(nonatomic) BOOL delegateRespondsToDidCancelMessageDeliveryForError; // @synthesize delegateRespondsToDidCancelMessageDeliveryForError=_delegateRespondsToDidCancelMessageDeliveryForError;
@property(nonatomic) BOOL delegateRespondsToDidCancelMessageDeliveryForEncryptionError; // @synthesize delegateRespondsToDidCancelMessageDeliveryForEncryptionError=_delegateRespondsToDidCancelMessageDeliveryForEncryptionError;
@property(nonatomic) BOOL delegateRespondsToDidCancelMessageDeliveryForMissingCertificatesForRecipients; // @synthesize delegateRespondsToDidCancelMessageDeliveryForMissingCertificatesForRecipients=_delegateRespondsToDidCancelMessageDeliveryForMissingCertificatesForRecipients;
@property(nonatomic) BOOL delegateRespondsToShouldDeliverMessage; // @synthesize delegateRespondsToShouldDeliverMessage=_delegateRespondsToShouldDeliverMessage;
@property(nonatomic) BOOL delegateRespondsToShouldSaveMessage; // @synthesize delegateRespondsToShouldSaveMessage=_delegateRespondsToShouldSaveMessage;
@property(nonatomic) BOOL delegateRespondsToWillCreateMessageWithHeaders; // @synthesize delegateRespondsToWillCreateMessageWithHeaders=_delegateRespondsToWillCreateMessageWithHeaders;
@property(nonatomic) BOOL delegateRespondsToDidEndLoad; // @synthesize delegateRespondsToDidEndLoad=_delegateRespondsToDidEndLoad;
@property(nonatomic) BOOL delegateRespondsToDidBeginLoad; // @synthesize delegateRespondsToDidBeginLoad=_delegateRespondsToDidBeginLoad;
@property(nonatomic) BOOL delegateRespondsToDidSaveMessage; // @synthesize delegateRespondsToDidSaveMessage=_delegateRespondsToDidSaveMessage;
@property(nonatomic) BOOL delegateRespondsToDidAppendMessage; // @synthesize delegateRespondsToDidAppendMessage=_delegateRespondsToDidAppendMessage;
@property(nonatomic) BOOL delegateRespondsToSenderDidChange; // @synthesize delegateRespondsToSenderDidChange=_delegateRespondsToSenderDidChange;
@property(nonatomic) BOOL delegateRespondsToDidChange; // @synthesize delegateRespondsToDidChange=_delegateRespondsToDidChange;
@property(nonatomic) long long windowsFriendliness; // @synthesize windowsFriendliness=_windowsFriendliness;
@property(nonatomic) BOOL isSettingSenderFromGetter; // @synthesize isSettingSenderFromGetter=_isSettingSenderFromGetter;
@property(retain, nonatomic) MCParsedMessage *restoredParsedMessage; // @synthesize restoredParsedMessage=_restoredParsedMessage;
@property(nonatomic) BOOL contentsWasEditedByUser; // @synthesize contentsWasEditedByUser=_contentsWasEditedByUser;
@property(nonatomic) BOOL hadChangesBeforeSave; // @synthesize hadChangesBeforeSave=_hadChangesBeforeSave;
@property(readonly, nonatomic) MCInvocationQueue *saveQueue; // @synthesize saveQueue=_saveQueue;
@property(nonatomic) BOOL editorHasInitialized; // @synthesize editorHasInitialized=_editorHasInitialized;
@property(readonly, nonatomic) NSPort *initializationPort; // @synthesize initializationPort=_initializationPort;
@property(retain, nonatomic) DOMNode *stationerySignatureNode; // @synthesize stationerySignatureNode=_stationerySignatureNode;
@property(copy, nonatomic) NSArray *generatedParsedMessages; // @synthesize generatedParsedMessages=_generatedParsedMessages;
@property(retain, nonatomic) MCParsedMessage *initialParsedMessage; // @synthesize initialParsedMessage=_initialParsedMessage;
@property(nonatomic) long long composeMode; // @synthesize composeMode=_composeMode;
@property(retain, nonatomic) NSUndoManager *undoManager; // @synthesize undoManager=_undoManager;
@property(retain, nonatomic) NSUUID *documentID; // @synthesize documentID=_documentID;
@property(retain, nonatomic) EditableWebMessageDocument *document; // @synthesize document=_document;
@property(retain, nonatomic) MCParsedMessage *originalMessageParsedMessage; // @synthesize originalMessageParsedMessage=_originalMessageParsedMessage;
@property(retain, nonatomic) NSURL *originalMessageBaseURL; // @synthesize originalMessageBaseURL=_originalMessageBaseURL;
@property(retain) MFMailbox *saveThreadMailbox; // @synthesize saveThreadMailbox=_saveThreadMailbox;
@property(copy) NSString *saveThreadMessageId; // @synthesize saveThreadMessageId=_saveThreadMessageId;
@property BOOL saveThreadCancelFlag; // @synthesize saveThreadCancelFlag=_saveThreadCancelFlag;
@property(nonatomic) BOOL willCloseEditor; // @synthesize willCloseEditor=_willCloseEditor;
@property(nonatomic) BOOL isDeliveringMessage; // @synthesize isDeliveringMessage=_isDeliveringMessage;
@property(nonatomic) BOOL isUndeliverable; // @synthesize isUndeliverable=_isUndeliverable;
@property(nonatomic) BOOL encryptIfPossible; // @synthesize encryptIfPossible=_encryptIfPossible;
@property(nonatomic) BOOL signIfPossible; // @synthesize signIfPossible=_signIfPossible;
@property(nonatomic) BOOL includeHeaders; // @synthesize includeHeaders=_includeHeaders;
@property(retain, nonatomic) NSURL *vcardFileForContactsUpdate; // @synthesize vcardFileForContactsUpdate=_vcardFileForContactsUpdate;
@property(retain, nonatomic) NSNumber *uniqueID; // @synthesize uniqueID=_uniqueID;
@property(copy, nonatomic) NSString *contentForContactsUpdate; // @synthesize contentForContactsUpdate=_contentForContactsUpdate;
//- (void).cxx_destruct;
- (void)stream:(id)arg1 handleEvent:(unsigned long long)arg2;
- (void)userActivity:(id)arg1 didReceiveInputStream:(id)arg2 outputStream:(id)arg3;
- (void)_markForOverwrite:(id)arg1;
- (void)_saveThreadSaveContents;
- (void)_saveThreadRemoveLastSave;
- (void)_saveThreadSetMessageId:(id)arg1 mailbox:(id)arg2 overwrite:(id)arg3;
- (void)_saveThreadUpdateAccount:(id)arg1 mailbox:(id)arg2;
- (BOOL)_saveThreadShouldCancel;
- (BOOL)isContentSignificant;
@property(readonly, nonatomic) BOOL isSavingMessage;
- (unsigned int)_convertSaveOrSendResultFromResultCodeT:(long long)arg1;
- (id)mailboxCreateIfNeeded:(BOOL)arg1;
- (id)_formattedAddressMatchingRawAddress:(id)arg1 inAccount:(id)arg2;
- (id)replyAddressForMessage:(id)arg1;
- (void)_saveRecipients;
- (void)_setupDefaultRecipientsFirstTime:(BOOL)arg1;
- (void)_ccOrBccMyselfGivenOriginalMessage:(id)arg1 uniquedRecipientsTable:(id)arg2;
- (BOOL)containsAttachmentsThatCouldConfuseWindowsClients;
- (BOOL)containsAttachments;
- (BOOL)attachmentCanBeSentInline:(id)arg1;
- (id)copyOfContentsForDraft:(BOOL)arg1 shouldBePlainText:(BOOL)arg2 isOkayToForceRichText:(BOOL)arg3 isMailDropPlaceholderMessage:(BOOL)arg4;
- (id)htmlDocumentForSave;
- (void)getContentsForMessage:(id)arg1 body:(id)arg2;
- (void)_recursivelyURLifyNode:(id)arg1;
- (void)addBaseURLTagToNode:(id)arg1;
- (id)_newPlainTextRepresentationIncludeAttachments:(BOOL)arg1;
- (id)htmlStringFromRange:(id)arg1 htmlDocument:(id)arg2 removeCustomAttributes:(BOOL)arg3 convertObjectsToImages:(BOOL)arg4 convertEditableElements:(BOOL)arg5;
- (id)newOutgoingMessageUsingWriter:(id)arg1 contents:(id)arg2 headers:(id)arg3 isDraft:(BOOL)arg4 shouldBePlainText:(BOOL)arg5;
- (id)userDefaultMessageFont;
- (BOOL)containsRichText;
- (BOOL)hasContents;
- (void)generateMessageParsedMessages;
- (void)fetchAndCacheMessages;
- (void)_notifyDelegateMonitor:(id)arg1 alreadyDone:(char *)arg2;
- (void)finishPreparingContentWithEditorSettings:(id)arg1;
- (void)updateSaveDestinationAccount:(id)arg1 mailbox:(id)arg2;
- (void)updateDocumentReference:(id)arg1;
- (void)_configureLastDraftInformationFromHeaders:(id)arg1 overwrite:(BOOL)arg2;
- (BOOL)_isValidSaveDestination:(id)arg1;
- (BOOL)canEncryptForRecipients:(id)arg1 sender:(id)arg2;
- (BOOL)canSignFromAddress:(id)arg1;
- (id)recipientsThatHaveNoKeyForEncryption;
- (id)allRecipients;
- (BOOL)isEditingMessage:(id)arg1;
- (void)removeLastDraft;
- (id)defaultMessageStore;
- (BOOL)saveMessage;
- (id)saveTaskName;
- (void)_backgroundSaveDidChangeMessageId:(id)arg1;
- (void)backgroundSaveEnded:(id)arg1;
- (void)_backgroundAppendEnded:(id)arg1;
- (void)_synchronouslyAppendMessageToOutboxWithContents:(id)arg1;
- (BOOL)deliverMessage;
- (void)imageResizer:(id)arg1 didFinishResizingWithResultCode:(long long)arg2;
- (void)_beginResizeOfImageAttachment:(id)arg1;
- (id)_createImageAttachmentRecordWithZoneID:(id)arg1 images:(id)arg2 error:(id *)arg3;
- (id)_createAttachmentRecordWithZoneID:(id)arg1 data:(id)arg2 filename:(id)arg3 mimeType:(id)arg4 error:(id *)arg5;
- (void)_recordZoneIDInDatabase:(id)arg1 completionHandler:(id)arg2;
- (void)_revertAttachments:(id)arg1 andExecuteBlock:(id)arg2 withError:(void)arg3;
- (void)_uploadAttachments:(id)arg1 completionBlock:(id)arg2;
- (BOOL)isAddressHeaderKey:(id)arg1;
- (void)removeAddressForHeader:(id)arg1 atIndex:(unsigned long long)arg2;
- (void)insertAddress:(id)arg1 forHeader:(id)arg2 atIndex:(unsigned long long)arg3;
- (void)setAddressList:(id)arg1 forHeader:(id)arg2;
- (id)addressListForHeader:(id)arg1;
- (void)_setStructuredList:(id)arg1 forHeader:(id)arg2;
- (id)_structuredListForHeader:(id)arg1;
- (void)addHeaders:(id)arg1;
- (long long)displayableMessagePriority;
- (void)setMessagePriority:(long long)arg1;
- (id)htmlStringForSignature:(id)arg1;
- (void)getSignatureElement:(id *)arg1 parent:(id *)arg2 nextSibling:(id *)arg3;
- (void)setSignature:(id)arg1;
- (id)signature;
- (id)signatureId;
- (BOOL)okToLetUserAddSignature;
- (BOOL)okToAddSignatureAutomatically;
- (id)messageID;
@property(retain, nonatomic) NSString *subject;
- (void)_setCleanHeaders:(id)arg1;
- (id)cleanHeaders;
@property(retain, nonatomic) NSString *sender;
- (void)setDeliveryAccount:(id)arg1;
- (id)deliveryAccount;
@property(retain, nonatomic) MFMailAccount *account;
- (id)message;
- (id)plainTextMessage;
- (id)_makeMessageWithContents:(id)arg1 isDraft:(BOOL)arg2 shouldSign:(BOOL)arg3 shouldEncrypt:(BOOL)arg4 shouldSkipSignature:(BOOL)arg5 shouldBePlainText:(BOOL)arg6;
- (unsigned long long)_encodingHint;
- (id)mimeBodyForAttachmentWithURL:(id)arg1;
- (id)_parsedMessageForMessage:(id)arg1;
- (void)_continueToSetupContentsForView:(id)arg1 withParsedMessages:(id)arg2;
@property(readonly, nonatomic) BOOL defaultFormatIsRich;
- (void)setupContentsForView:(id)arg1;
- (void)setTypeAndConfigureLoadingOfRemoteAttachments:(unsigned long long)arg1;
- (void)_configureLoadingOfRemoteAttachments;
- (void)_generateParsedMessageFromOriginalMessages;
- (BOOL)preserveAddedArchiveBody;
- (id)directoryForAttachment:(id)arg1;
- (id)attachments;
- (void)setOriginalMessages:(id)arg1;
- (id)_knownMessageIds;
- (id)originalMessageBody;
- (MCMessageHeaders*)originalMessageHeaders;
- (void)setOriginalMessage:(id)arg1;
- (id)originalMessage;
- (void)setSendWindowsFriendlyAttachments:(BOOL)arg1;
- (BOOL)sendWindowsFriendlyAttachments;
- (void)setShouldDownloadRemoteAttachments:(BOOL)arg1;
- (BOOL)isRedirecting;
- (void)setType:(unsigned long long)arg1;
- (unsigned long long)type;
- (void)setHasChanges:(BOOL)arg1;
- (BOOL)hasChanges;
- (id)stationeryController;
- (BOOL)hasStationery;
@property(nonatomic) __weak id delegate;
@property(readonly, copy) NSString *description;
- (void)_editorHasInitialized:(id)arg1;
- (void)setStateFromBackEnd:(id)arg1;
- (void)_createUniqueID;
- (id)init;
- (id)initCreatingDocumentEditor:(BOOL)arg1;
- (void)dealloc;
- (void)setVcardFile:(id)arg1;
- (void)setHtmlContent:(id)arg1;
- (id)objectSpecifier;
- (id)handleCloseScriptCommand:(id)arg1;
- (id)handleSendMessageCommand:(id)arg1;
- (id)handleSaveMessageCommand:(id)arg1;
- (void)replaceFormattedAddress:(id)arg1 withAddress:(id)arg2 forKey:(id)arg3;
- (void)removeFromBccRecipientsAtIndex:(unsigned long long)arg1;
- (void)removeFromCcRecipientsAtIndex:(unsigned long long)arg1;
- (void)removeFromToRecipientsAtIndex:(unsigned long long)arg1;
- (void)insertInBccRecipients:(id)arg1;
- (void)insertInBccRecipients:(id)arg1 atIndex:(unsigned long long)arg2;
- (void)insertInCcRecipients:(id)arg1;
- (void)insertInCcRecipients:(id)arg1 atIndex:(unsigned long long)arg2;
- (void)insertInToRecipients:(id)arg1;
- (void)insertInToRecipients:(id)arg1 atIndex:(unsigned long long)arg2;
- (void)insertRecipient:(id)arg1 atIndex:(unsigned long long)arg2 inHeaderWithKey:(id)arg3;
- (id)bccRecipients;
- (id)ccRecipients;
- (id)toRecipients;
- (id)recipients;
- (void)_addRecipientsForKey:(id)arg1 toArray:(id)arg2;
- (void)setMessageSignature:(id)arg1;
- (id)messageSignature;
- (void)setContent:(id)arg1;
- (id)content;
- (void)setAppleScriptSubject:(id)arg1;
- (id)appleScriptSubject;
- (void)setAppleScriptSender:(id)arg1;
- (id)appleScriptSender;
- (void)setIsVisible:(BOOL)arg1;
- (BOOL)isVisible;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

