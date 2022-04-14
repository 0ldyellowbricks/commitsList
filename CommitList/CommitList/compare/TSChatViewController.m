//
//  TSChatViewController.m
//  TeamSpaceApp
//
//  Created by Adrian Aisemberg on 9/4/15.
//  Copyright © Microsoft Corporation. All rights reserved.
//

#import "AXSlideshowData.h"
#import "TeamsAppSDKManager.h"
#import "TSAlertViewModel.h"
#import "TSAudioAttachmentView.h"
#import "TSBBackwardCompatibleCardsGenerator.h"
#import "TSBadgeCountManager.h"
#import "TSBotDataBagManager.h"
#import "TSBotCardButton.h"
#import "TSCAdaptiveCardsActionHandler.h"
#import "TSCallBannerView.h"
#import "TSCallEndViewController.h"
#import "TSCallManager.h"
#import "TSCallNavigationUtilities+TeamSpaceApp.h"
#import "TSCallTransferBannerViewManager.h"
#import "TSCallUIUtilities.h"
#import "TSCallUtilities+TeamSpaceApp.h"
#import "TSCallingNavigationController.h"
#import "TSChatBannerView.h"
#import "TSChatBubbleMeetingCardView.h"
#import "TSChatCallingMessageViewCell.h"
#import "TSChatConnectorViewCell.h"
#import "TSChatGroupTimestampCell.h"
#import "TSChatImageAttachmentView.h"
#import "TSChatMeetingCardViewCell.h"
#import "TSChatMessageViewCell.h"
#import "TSChatMultiViewController.h"
#import "TSChatMuteStatusChangeBannerView.h"
#import "TSChatReadStatusViewController.h"
#import "TSChatRecordingCardViewCell.h"
#import "TSChatViewController.h"
#import "TSChatViewFetchEngine.h"
#import "TSCustomUITableView.h"
#import "TSDlpViewModel.h"
#import <AXPCommonUI/TSDropdownWithPresenceTitleView.h>
#import "TSEmptyStateConfigurationFactoryProtocol.h"
#import "TSEnableNotificationPromptManager.h"
#import "TSEnableReviewPromptManager.h"
#import "TSFMRestrictionHelper.h"
#import "TSMessageAttachmentView.h"
#import "TSHTMLViewController.h"
#import "TSLastReadWatermarkCell.h"
#import "TSNativeFederationChatCell.h"
#import "TSListBotCardView.h"
#import "TSMeetingBannerView.h"
#import "TSMeetingChickletHelper.h"
#import "TSMeetingItemViewData.h"
#import <TeamsKit/TSMobilityPolicySettingsManager.h>
#import "TSMultiCallSwitchBannerViewManager.h"
#import "TSIndicatorView.h"
#import "TSRevealableLabel.h"
#import "TSSemanticListModel.h"
#import "TSThumbnailBotCardView.h"
#import "TSThumbnailStripeViewController.h"
#import "TSURLUtilityProtocol.h"
#import "TSUserActionsManager.h"
#import "TSUtilities+TeamsApp.h"
#import "TSMessageInfo+Cards.h"
#import <AXPCommonUI/TSViewController+BrandIcon.h>
#import <TeamsAppCoreUtility/TeamsAppCoreUtility-Swift.h>
#import "TeamSpaceApp+Settings.h"
#import "UITextView+QuoteIndicator.h"
#import "TSCompanionBannerViewManager.h"
#import "TSComposeViewController.h"
#import "TSCompactComposeViewController.h"
#import "TSMessageReplyViewModel.h"
#import "TSMessageReplyView.h"
#import "TSUxUtils.h"
#import "TSUniversalLinkManager.h"
#import "TSMessageAttachmentHelper.h"
#import "TSFileUploadComposer+Telemetry.h"
#import "TSSharedStringsResolver.h"
#import "TSChatViewController+SmartReplies.h"
#import "TSChatViewController+Cards.h"
#import "TSChatViewController+FederatedChat.h"
#import "TSInviteUtility.h"
#import "TSSlideshowViewController.h"
#import <TeamsKit/TSSmartReply.h>
#import "TSSmartReplyCell.h"
#import "TSChatViewController+Welcome.h"
#import "TSSFCInteropOrTFLChatBlockAcceptViewController.h"
#import "TSMeetingCallDetailsProvider.h"
#import "TSPeopleUtils.h"
#import "TSChatViewController+TSFluidTablePreviewCell.h"
#import "TSChatTypingIndicatorView.h"
#import "TSDLPPolicyProtocol.h"
#import "TSPlatformBotsAuthManager.h"
#import "ACRView+Refresh.h"
#import "TeamSpaceApp-Swift.h"
#import <AXPCommon/TSEmptyStateConstants.h>
#import "TSEmptyStateConfigurationFactoryProtocol.h"
#import "TSMessageReactionView.h"
#import "TSAllReactionsViewController.h"
#import "TSCAdaptiveCardCache.h"
#import "TSMeetingTabbedUXUtilities.h"
#import <TeamsAppCoreUtility/NSDictionary+DataBagValues.h>
#import "SDKModuleUtilities.h"
#import "TSBaseComposeViewController+Mentions.h"
#import "TSMeetingCoordinator.h"
#import "TSChatViewController+ConsumptionHorizon.h"
#import "TSCalendarEventOperationsHelper.h"
#import "TSChatAttributedStringProcessor.h"
#import "TSSlideshowHandlerInMessages.h"
#import "TSChatMessageContextOptionsProviderDelegate.h"
#import "TSChatMessageContextOptionsHandler.h"
#import "TSFluidTablePreviewCellHandlerInChat.h"
#import "TSMessageLongPressHandler.h"
#import "TSChatMessageLongPressHandler.h"
#import "TSChatMessageLongPressProviderDelegate.h"
#import "TSMessageLikersPopupController.h"
#import <TeamsAppCoreUtility/UIView+Subview.h>

#import <CallingKit/TSCallConsultTransferSession.h>
#import <CallingKit/TSMeetingCallDetails.h>
#import <CallingKit/CallingKit-Swift.h>

#import <SkyLibKit/SkyLibKit-Swift.h>

#import <Location/Location-Swift.h>
#import <Vault/Vault-Swift.h>
#import <VideoMessaging/VideoMessaging-Swift.h>
#import <Feedback/Feedback-Swift.h>
#import <MemeGen/GMMemeGenViewController.h>
#import <SharedStrings/SharedStrings-Swift.h>
#import <SafariServices/SafariServices.h>
#import <SearchCore/TSPeoplePickerSearchProvider.h>
#import <TeamsKit/TeamsKit-Swift.h>
#import <GroupTemplates/GroupTemplates-Swift.h>
#import <MsgAnimations/MsgAnimations-Swift.h>
#import <TeamsKit/TSDLPEnums.h>
#import <TeamsKit/TSDetailedBotCard.h>
#import <TeamsKit/TSFileUploadManager.h>
#import <TeamsKit/TSNAResetConsumptionHorizonBookmark.h>
#import <TeamsKit/TSNASearchUsersResultItem.h>
#import <TeamsKit/TSNAUpdateConsumptionHorizon.h>
#import <TeamsAppCommon/TSNAUserComposingMessage.h>
#import <TeamsKit/TSSyncEngine.h>
#import <TeamsKit/TSTableTextAttachment.h>
#import <TeamsKit/TSMRUCache.h>
#import <TeamsKit/TSComposeActionUtils.h>
#import <TeamsKit/TSConnectorCard.h>
#import <TeamsKit/TSCAdaptiveCard.h>
#import <TeamsKit/TSLiveLocationCardData.h>
#import <TeamsKit/TSVaultItemCardData.h>
#import <TeamsKit/TSVaultAccessCardData.h>
#import <TeamsKit/TSTasksItemCardData.h>
#import <TeamsKit/TSAACreateMessage.h>
#import <TeamsKit/TSAAFindContainerForRecipients.h>
#import <TeamsKit/TSAnimatedTextAttachment.h>
#import <TeamsKit/TSAppDefinitionManager.h>
#import <TeamsKit/TSAuthManager.h>
#import <TeamsKit/TSDocumentAttachment.h>
#import <TeamsKit/TSPhotoManager.h>
#import <TeamsKit/TSPresenceService.h>
#import <TeamsKit/TSUserPresence.h>
#import <TeamsKit/TSCollageTextAttachment.h>
#import <TeamsKit/NSAttributedString+Collage.h>
#import <TeamsKit/TSSMessage.h>
#import <TeamsKit/TeamsKit-Swift.h>

#import <TeamsAppCommon/TSNALeaveGroupChat.h>
#import <TeamsAppCommon/TSNAUpdateThreadProperty.h>

#import "TSQuickReactPromptManager.h"
#import <SVGIcons/TSTypingIndicator+AXPSVG.h>

#import <TeamsUI/TeamsUI-Swift.h>
#import <TeamsUIGlyph/TeamsUIGlyph-Swift.h>
#import <TeamsUIIconAppBundle/TeamsUIIconAppBundle-Swift.h>
#import <TeamsUIIconCoreBundle/TeamsUIIconCoreBundle-Swift.h>
#import <TeamsUICore/TeamsUICore-Swift.h>

#import <TeamsKitLegacyUI/TSColor.h>
#import <TeamsKitLegacyUI/TSPaletteDefault.h>
#import <TeamsKitLegacyUI/TSPaletteDark.h>
#import <TeamsUICore/TeamsUICore-Swift.h>

static NSString * const TSkSeguePushChatDetails = @"pushChatDetails";
static NSString * const TSkSeguePushMeetingChatDetails = @"pushMeetingChatDetails";
static NSString * const TSkChatStatusMessageBannerMutedKey = @"chatStatusMessageBannerMutedKey";
// delivery state
static NSString * const TSkMessageDeliveryStateDeclinedCodeOne = @"603/52090";
static NSString * const TSkMessageDeliveryStateDeclinedCodeTwo = @"480/24023";
static NSString * const TSkMessageDeliveryStateDeclinedCodeThree = @"408/52090";
static NSString * const TSkMessageDeliveryStateDoNotDisturbCodeOne = @"480/52018";
static NSString * const TSkMessageDeliveryStateDoNotDisturbCodeTwo = @"480/24115";
static NSString * const TSkMessageDeliveryStateUnavailableOne = @"480/13012";
static NSString * const TSkMessageDeliveryStateUnavailableTwo = @"480/1034";
static NSString * const TSkMessageDeliveryStateUnavailableThree = @"486/52067";
static NSString * const TSkMessageDeliveryStateNotSupported = @"488/52091";
static NSString * const TSkMessageDeliveryStateNonePreferredEndpoint = @"408/24116";
static NSString * const TSkMessageDeliveryStateTenantNotSupportInterop = @"488/13028";
static NSString * const TSkMessageDeliveryStateUserNotFoundInBVD = @"488/16829";
static NSString * const TSkMessageDeliveryStateSMSInfraNoHandlerError = @"2001";
static NSString * const TSkMessageDeliveryStateSMSInfraInsufficientFundsError = @"2002";
static NSString * const TSkMessageDeliveryStateSMSInfraBrokenDeliveryReportError = @"2003";
static NSString * const TSkMessageDeliveryStateSMSInfraMessageExpiredError = @"2004";
static NSString * const TSkMessageDeliveryStateSMSInfraConnectionError = @"2005";
static NSString * const TSkMessageDeliveryStateSMSInfraInternalError = @"2006";
static NSString * const TSkMessageDeliveryStateSMSInfraNoRouteError = @"2007";
static NSString * const TSkMessageDeliveryStateSMSBillingPriceNotFoundError = @"2008";
static NSString * const TSkMessageDeliveryStateSMSFraudUserAccountBlockedError = @"3001";
static NSString * const TSkMessageDeliveryStateSMSFraudRecipientBlockedError = @"3002";
static NSString * const TSkMessageDeliveryStateSMSFraudSenderBlockedByReceipientError = @"3003";
static NSString * const TSkMessageDeliveryStateSMSFraudSenderBlockedError = @"3004";
static NSString * const TSkMessageDeliveryStateSMSFraudSpamDetectedError = @"3005";
static NSString * const TSkMessageDeliveryStateSMSFraudSMSVelocityReachedError = @"3006";
static NSString * const TSkMessageDeliveryStateSMSNumberInvalidFormatSourceAddressError = @"4001";
static NSString * const TSkMessageDeliveryStateSMSNumberInvalidFormatDestinationAddressError = @"4002";
static NSString * const TSkMessageDeliveryStateSMSNumberDestinationNotSupportedError = @"4003";
static NSString * const TSkMessageDeliveryStateSMSNumberDoesNotExistError = @"4004";
static NSString * const TSkMessageDeliveryStateSMSNumberBlockedError = @"4005";
static NSString * const TSkMessageDeliveryStateSMSNumberUnreachableError = @"4006";
static NSString * const TSkMessageDeliveryStateSMSNoSourceAddressError = @"4007";
static NSString * const TSkMessageDeliveryStateSMSAggregatorTransientServiceError = @"5001";
static NSString * const TSkMessageDeliveryStateSMSAggregatorPermanentServiceError = @"5002";
static NSString * const TSkMessageDeliveryStateSMSAggregatorMessageExpiredError = @"5003";
static NSString * const TSkMessageDeliveryStateSMSAggregatorSpamBlockedError = @"5004";
static NSString * const TSkMessageDeliveryStateSMSAggregatorMiscError = @"5555";
static NSString * const TSkMessageDeliveryStateSMSUncategorizedError = @"6666";
static NSString * const TSkOffNetworkActionButtonLabelKey = @"TSkOffNetworkActionButtonLabelKey";
// Composer actions keys
static NSString * const TSkComposerActionImage = @"image";
static NSString * const TSkComposerActionAttachment = @"attachment";
static NSString * const TSkComposerActionGif = @"gif";
static NSString * const TSkComposerActionMemes = @"memes";
static NSString * const TSkComposerActionStickers = @"stickers";
static NSString * const TSkComposerActionImportant = @"important";
static NSString * const TSkComposerActionFormat = @"format";
static NSString * const TSkComposerActionMention = @"mention";
static NSString * const TSkComposerActionVault = @"vault";
static NSString * const TSkComposerActionTasks = @"tasks";
static NSString * const TSkComposerActionMore = @"more";
static NSString * const TSkComposerActionLocation = @"location";
static const CGFloat TSkChatMessageCollapsingTimeInterval = 720.0f;
static NSString * const TSkCorrelationTagOpenChatRefresh = @"OpenChatRefresh:";
static NSString * const TSkCorrelationTagCreateGroup = @"CreateGroup:";
static NSString * const TSkCorrelationTagGetMemberConsumptionHorizon = @"GetMemberConsHorizon:%@";
static NSString * const TSkCorrelationTagUserSyncTypingIndicator = @"UserSyncTypingIndicator:";
static NSString * const TSkCorrelationTagUpdateGroupTemplateProperty = @"updateGroupTemplateProperty:";
static NSString * const TSkChatMutedBannerUserHandledKey = @"chatMutedBannerUserHandled";
static NSString * const TSkGroupCallingEnabledUpdated = @"TSkGroupCallingEnabledUpdated";
static const CGFloat TSkLargeCornerRadius = 12.0f;
static NSString * const TSkHasCustomNameKey = @"hasCustomName";
static NSString * const TSkDeviceContactsSelectedKey = @"deviceContactsSelected";
static NSString * const TSkSuggestedContactsSelectedKey = @"suggestedContactsSelected";
static NSString * const TSkTotalContactsSelectedKey = @"totalContactsSelected";

static NSString * const TSkRedDotMetaDataKey = @"Databag_messagetraydot";

@class TSBotExecuteActionResponseHandler;

CGFloat const TSkBotChatCellEmptySpaceWidth = 48.0f;
CGFloat const TSkChatViewControllerEstimatedRowHeight = 44.0f;
CGFloat const TSkChatViewControllerFederatedBannerHeight = 60.0f;
CGFloat const TSkTypingIndicatorViewMaximumHeight = 44.0f;
CGFloat const TSkTypingIndicatorViewFinalHeight = 44.0f;
CGFloat const TSkTypingIndicatorViewMinimumHeight = 0.0f;
CGFloat const TSkTypingIndicatorPushDownAnimationDuration = 0.3f;
CGFloat const TSkTypingIndicatorPushDownAnimationDelay = 0.2f;
CGFloat const TSkTypingIndicatorAnimationSpringDamping = 0.85f;
CGFloat const TSkTypingIndicatorAnimationSpeedAmount = 0.4f;
NSInteger const TSkTypingIndicatorDisplayDurationInMilliSeconds = 7000;
CGFloat const TSkMessageReplyTextViewHorizontalInset = -2.0f;
CGFloat const TSkMessageReplyTextViewVerticalInset = 2.0f;

CGFloat const TSkChatBadgeBackButtonWidth = 66.0f;
CGFloat const TSkChatBadgeBackButtonHeight = 22.0f;
CGFloat const TSkChatBadgeBackButtonBarStylingL2Width = 38.0f;
CGFloat const TSkChatBadgeBackButtonLeftInset = -8.0f;

CGFloat const TSkNavigationBarItemWidth = 26.0f;
CGFloat const TSkNavigationBarItemHeight = 30.0f;
CGFloat const TSkNavigationBarItemPadding = 8.0f;

CGFloat const TSkLocationBannerViewHeight = 50.0f;

CGFloat const TSkCodeSnippetEdgePadding = 2.5f;

CGFloat const TSkFileAttachmentShadowBorderWidth = 1.0f;
CGFloat const TSkFileAttachmentShadowOffsetY = 1.0f;
CGFloat const TSkFileAttachmentShadowRadius = 2.0f;

CGFloat const TSkComposeViewShadowScrollThreshold = 100.0f;
CGFloat const TSkComposeViewShadowRadius = 1.1f;
CGFloat const TSkComposeViewShadowEdgePadding = 8.0f;
CGFloat const TSkComposeViewShadowVerticalOffset = 1.0f;
CGFloat const TSkComposeViewShadowCornerRadius = 4.0f;

CGFloat const TSkDisabledChatVerticalContentInset = 8.0f;
CGFloat const TSkStatusMessageVerticalContentInset = 8.0f;

CGFloat const TSkToAndNewGroupChatContainerHeight = 100.0f;
CGFloat const TSkToSearchBarContainerHeight = 56.0f;

CGFloat const TSkTaggingByShiftsTooltipPointerX = 32.0f;
CGFloat const TSkTaggingByShiftsTooltipLeadingConstraint = 8.0f;
CGFloat const TSkTaggingByShiftsTooltipTopConstraint = 40.0f;
CGFloat const TSkTaggingByShiftsTooltipWidth = 250.0f;

CGFloat const TSkWaitForGroupTemplateCreationPadding = 40.0f;
CGFloat const TSkWaitForGroupTemplateCreationImageSize = 144.0f;
CGFloat const TSkWaitForGroupTemplateCreationVerticalRatio = 0.1f;

CGFloat const TSkEncryptionViewMessageHeight = 51.0f;

NSTimeInterval const TSkSessionGroupingTimeoutMinutes = 60;
NSString const *TSkIsGroupSeparator = @"isGroupSeparator";

NSString const *TSkChatMsgSendTypeAudio = @"voice";
NSString const *TSkChatMsgSendTypeRegular = @"regular";
NSString * const TSkWaveEmojiKey = @"hi";

NSString* TSkEmptyStatePanelType = @"chatCreationEmptyState";
NSString* TSkEmptyStatePanelUri = @"app.chatCreationEmptyState";

NSString* TSkSMBPrivacyAlertShownKey = @"isSMBPrivacyAlertShown";

static const int TSkChatMutedBannerShowMaxCount = 3;
static const int TSkDisabledStateViewLabelLineCount = 2;

// Nib names
NSString *const TSkNibNameRevealableLabel = @"TSRevealableLabel";
NSString *const TSkNibNameChatMessageCellLeft = @"TSChatMessageViewCellLeft";
NSString *const TSkNibNameChatMessageCellRight = @"TSChatMessageViewCellRight";
NSString *const TSkNibNameChatCallingMessageViewCell = @"TSChatCallingMessageViewCell";
NSString *const TSkNibNameChatMeetingCardViewCell = @"TSChatMeetingCardViewCell";
NSString *const kNibNameLastReadWatermarkCellChat = @"TSLastReadWatermarkCell";
NSString *const kNibNameNativeFederationChatCell = @"TSNativeFederationChatCell";
NSString *const TSkConnectorCellViewCell = @"TSChatConnectorViewCell";
NSString *const TSkNibNameChatRecordingCardViewCell = @"TSChatRecordingCardViewCell";
NSString *const TSkNibNameChatGroupTimestampCell = @"TSChatGroupTimestampCell";
NSString *const TSkNibNameAudioAttachmentView = @"TSChatAudioAttachmentView";
NSString *const TSkNibNameSmartReplyCell = @"TSSmartReplyCell";
NSString *const TSkNibNameConsumptionHorizonCell = @"TSChatConsumptionHorizonUsersCell";

// Message to Task support action message dictionary keys
NSString const *TSkMessageToTaskThreadId = @"threadId";
NSString const *TSkMessageToTaskThreadName = @"threadName";
NSString const *TSkMessageToTaskMessageId = @"messageId";
NSString const *TSkMessageToTaskTaskTitle = @"taskTitle";
NSString const *TSkMessageToTaskMessageCreatorName = @"messageCreatorName";

static NSString * const TSkNewFlagAppsKey = @"areThereNewApps";
static NSString * const TSkRedDotScenarioID = @"ShowRedDotTTR";

static NSString * const TSkOverflowMenuAdaptiveCard = @"overflowMenuAdaptiveCard";
static NSString * const TSkLaunchOverflowActionSheet = @"launchOverflowActionSheet";
static NSString * const TSkCardLongPress = @"cardLongPress";

static const NSUInteger TSkTaskTitleNumberOfCharacters = 256;

static const NSTimeInterval TSkTooltipShowHideTime = 0.5;
static const NSTimeInterval TSkTooltipAutoHideDelay = 6.0;

@interface TSChatViewController () <TSMessageFetchEngineDelegate, TSChatBannerViewDelegate,
    TSMobilityPolicyDelegate, TSLocationBannerDelegate, TSDLPPolicyProtocol,
    TSPlatformAuthManagerProtocol, GMMemeGenViewControllerDelegate, GroupTemplateCoordinatorProvider,
    LensSDKHelperDelegate, EncryptionMessageViewDelegate, PersonalAppDeeplinkedScreen, TSChatAttributedStringProcessorDelegate, TSChatMessageContextOptionsProviderDelegate, TSFluidTablePreviewCellInChatProviderDelegate, TSChatMessageLongPressProviderDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (strong, nonatomic) TSBaseComposeViewController *composeViewController;
@property (strong, nonatomic) IBOutlet UIView *composeView;
@property (strong, nonatomic) IBOutlet TBMBotMenuAccessibilityContainer *botMenuAccessibilityContainer;
@property (strong, nonatomic) IBOutlet UIView *disabledStateView;
@property (strong, nonatomic) IBOutlet UIView *disabledStateViewSeparator;
@property (strong, nonatomic) IBOutlet UILabel *disabledStateViewLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewTopConstraint;
@property (strong, nonatomic) IBOutlet EncryptionMessageView *encryptionMessageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightEncryptionView;

@property (nonatomic) BOOL shouldHideChatHeaderContainer;
@property (strong, nonatomic) TSChatHeaderCoordinator *chatHeaderCoordinator;
@property (strong, nonatomic) UIStackView *waitForGroupTemplateCreationContainer;
@property (strong, nonatomic) UIImageView *groupTemplateImage;
@property (strong, nonatomic) UILabel *groupTemplatePreparingLabel;

@property (strong, nonatomic) AvatarPickerPopup *avatarPopup;

// tsIDs of all chat members except signed-in user.
@property (strong, nonatomic) TSMeetingItemViewData *calendarEventDetailsViewData;
@property (strong, nonatomic) TSEntitySearch *entitySearch;
@property (strong, nonatomic) TSPeoplePickerSearchProvider *peoplePickerSearchProvider;
@property (strong, nonatomic) TSFluidPreviewCellPopUpActionsViewController *fluidPopupViewController;
@property (strong, nonatomic) TSMessageLikersPopupController *messageLikersPopup;
@property (nonatomic, strong) UIView *messagesView;
@property (nonatomic) BOOL loadedWithViewPreservation;
@property (nonatomic) BOOL errorContainerNotFound;
@property (nonatomic) BOOL hasAppeared;
@property (nonatomic) BOOL shouldShowPresenceOnTitle;
@property (nonatomic) BOOL hideCallOptions;
@property (nonatomic) BOOL groupNameRequiredPromptShown;
@property (nonatomic, readonly) BOOL shouldShowDropdownOnTitle;
@property (nonatomic, readonly) BOOL shouldOpenTitleDropdown;
@property (nonatomic) TSPresenceStatus currentPresenceStatus;
@property (nonatomic, strong) NSDate *currentPresenceSeenAt;
@property (nonatomic, strong) NSNumber *initiateChatWithTBot;
@property (nonatomic, strong) NSNumber *chatWithTBot;
@property (strong, nonatomic) TSEntitySearchResultItem *userSearchResultItem;
@property (strong, nonatomic) TextInputAlertController *textInputAlertController;
@property (strong, nonatomic) UIImpactFeedbackGenerator *longPressImpact;

@property (strong, nonatomic) NSDate *latestMessageArrivalTime;

@property (strong, nonatomic) TSChatViewFetchEngine *messageFetchEngine;
@property (strong, nonatomic) NSNumber *lastMessageDate;
@property (nonatomic) NSUInteger lastViewItemCount;

@property (strong, nonatomic) NSLock *dataLock;
@property (strong, nonatomic) NSString *biThreadType;
@property (strong, nonatomic) NSString *biChatType;

@property (nonatomic) BOOL userPresenceObservationStarted;

@property (strong, nonatomic) NSDate *lastPostTimeForUserComposingMessage;

@property (nonatomic) NSInteger meetingJoinButtonCount;
@property (strong, nonatomic) NSMutableDictionary *userIdDict;
@property (strong, nonatomic) IBOutlet TSChatBannerView *chatBannerView;
@property (strong, nonatomic) TSChatMuteStatusChangeBannerView *chatMuteStateBannerView;

@property (strong, nonatomic) IBOutlet UIView *locationBannerViewContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationBannerContainerHeightConstraint;
@property (strong, nonatomic) UIView *locationBannerView;

@property (strong, nonatomic) AXPPanelInfo *currentPanelInfo;

@property (nonatomic, assign) TSThreadType threadTypeFromThreadProperties;

@property (nonatomic, strong) NSNumber *initialHorizonTime;
@property (nonatomic) BOOL freezeConsumptionHorizonBookmarkReset;

@property (nonatomic) BOOL isTypingIndicatorCollapseAnimationInProgress;

@property (nonatomic) BOOL needToRegisterForNotifications;

@property (nonatomic) BOOL didDismissLocationBanner;

@property (nonatomic, nullable) NSString *initialLocationSharingAction;
@property (nonatomic, nullable) NSString *initialLocationSharingActionUserIdentifier;
@property (nonatomic, nullable) NSString *initialLocationSharingActionPlaceIdentifier;

@property (nonatomic) NSString *onEntryAction;

@property (nonatomic, weak) UIButton *voiceCallButton;
@property (nonatomic) BOOL isChatDisable;
@property (nonatomic) NSDictionary *disabledReason;

@property (strong, nonatomic) NSString *sourceSegueId;
@property (nonatomic) BOOL isTabBarHidden;
@property (nonatomic) BOOL forceShowBackButton;
@property (nonatomic) BOOL createChatWithRecipientIDs;
@property (strong, nonatomic) NSString *nativeFederationThreadID;
@property (strong, nonatomic) NSString *previousFederationThreadID;
@property (strong, nonatomic) NSString *navScenarioID;
@property (strong, nonatomic) NSString *chatWithMeetingParticipantsScenarioID;
@property (strong, nonatomic) NSString *chatCreateScenarioID;
@property (strong, nonatomic) NSString *chatCreateDraftKey;
@property (strong, nonatomic) NSString *scrollToMessageScenarioID;
@property (strong, nonatomic) NSString *createGroupPerformanceScenarioID;
@property (nonatomic) BOOL isScrollingToTop;

@property (nonatomic) BOOL shouldShowAccAwareToast;
@property (nonatomic) BOOL didAnonJoinCallEnd;
@property (strong, nonatomic) id<SkyLibCall> call;
@property (nonatomic) BOOL hideVideoCallButton;
@property (nonatomic) BOOL isConsultTransferConversation;
@property (nonatomic) BOOL shouldShowKeyboard;
@property (strong, nonatomic) NSAttributedString *consultTransferPrepopulatedMessage;
@property (strong, nonatomic) TSMultiCallSwitchBannerViewManager *multiCallBannerViewManager;
@property (strong, nonatomic) TSCallTransferBannerViewManager *transferBannerViewManager;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *customBannerViewHeightConstraint;
@property (strong, nonatomic) NSAttributedString *lateToMeetingPrepopulatedMessage;

@property (nonatomic) BOOL isNewFederatedUser;
@property (nonatomic) BOOL federatedUserSynced;
@property (strong, nonatomic) NSString *federatedUserDisplayName;
@property (nonatomic) BOOL isFederatedBannerCancelled;
@property (nonatomic) BOOL isV2Thread;
@property (nonatomic) BOOL isNativeFedChatEnabled;
@property (nonatomic) BOOL retriedForThreadNotFound;
@property (nonatomic) BOOL threadNotFound;
@property (nonatomic) BOOL shouldShowEcryptionMessage;
@property (nonatomic) BOOL isGuardiansChat;
@property (nonatomic) BOOL isChatWithSelf;
@property (nonatomic) BOOL isCreatingChatWithSelfThread;
@property (nonatomic, strong) NSString *guardiansAadGroupId;
@property (nonatomic, strong) NSString *guardiansUserId;
@property (nonatomic, strong) NSArray<NSString *> *guardiansRecipientEmails;
@property (nonatomic, strong) NSArray<NSString *> *guardiansRecipientPhones;

@property (nonatomic) BOOL hasUnreadMessages;

// Flag to indicate whether we should send AddContactRequest
@property (nonatomic) BOOL shouldSendAddContactRequest;

@property (strong, nonatomic) NSDictionary *searchHighlightAttributes;
@property (strong, nonatomic) NSDictionary *msgAnimationsHighlightAttributes;
@property (strong, nonatomic) NSDictionary<NSString *, NSNumber *> *allRecipientsConsumptionHorizons;
@property (strong, nonatomic) NSDate *recipientLastSentMsgTime; // used for lastSeenAt for 1:1 chats

@property (strong, nonatomic) AXPObserver *composeLocationObserver;
@property (strong, nonatomic) UITapGestureRecognizer* tappedOnCellGesture;
@property (strong, nonatomic) UITapGestureRecognizer* doubleTappedOnCellGesture;
@property (strong, nonatomic) UITapGestureRecognizer* tripleTappedOnCellGesture;
@property (strong, nonatomic) UITapGestureRecognizer *tappedOnEmptyStateGesture;
@property (strong, nonatomic) UILongPressGestureRecognizer* longPressedOnCellGesture;
@property (assign, nonatomic) CGPoint scrollLastContentOffset;
@property (copy, nonatomic) NSString *textForDeepLinkedInitialization;
@property (strong, nonatomic) NSString *fileShareUrl;
@property (strong, nonatomic) NSArray<UIImage *> *forwardImages;
@property (copy, nonatomic) NSString *fromThreadID; //helps in files link sharing for x-tenant scenarios
@property (nonatomic) BOOL needAcknowledgementForVisibleCells;

@property (strong, nonatomic) NSNumber *lastMessageID;
@property (nonatomic) BOOL hasPromptedUserLessThanLimit;
@property (nonatomic) BOOL isShowingQuickReactPrompt;

// disables navigation of chatVC title click and shows overflow menu for meeting chat
@property (nonatomic) BOOL shouldConfigureForMeetings;
@property (strong, nonatomic) TSEmptyState * emptyStateForMeetings;

// NSInteger representing fanout value for group chat features
@property (nonatomic) NSInteger maxGroupChatParticipantsForFanout;

// NSUInteger representing fanout value for group chat read receipts
@property (nonatomic) NSUInteger readReceiptsMaxParticipants;

// NSUInteger respresenting max number of users in chat for calling to be enabled
@property (nonatomic) NSUInteger maxGroupChatParticipantsForGroupCall;

// Banner Dismissal
@property (nonatomic) NSUInteger oneOnOneChatBannerDismissTimeFrameInDays;
@property (nonatomic) NSUInteger groupChatBannerDismissTimeFrameInDays;
@property (nonatomic) NSUInteger bannerDismissDictMaxCount;

@property (nonatomic, strong) TSDlpViewModel *dlpViewModel;

@property (nonatomic) BOOL shouldCollapseComposeToolbar;
@property (nonatomic) id<TSMessageAttachmentCacheProtocol> attachmentCacheHelper;
@property (strong, nonatomic) TSChatGallerySlideshowCoordinatorBridge *gallerySlideshowCoordinator;
@property (strong, nonatomic) id<MessageLocationLiveCoordinatorBridge> liveLocationCoordinator;
@property (strong, nonatomic) id<MessageStaticLocationCoordinatorBridge> staticLocationCoordinator;
@property (strong, nonatomic) id<ChatLocationBannerCoordinatorBridge> locationBannerCoordinator;
@property (strong, nonatomic) id<GroupLocationsLiveCoordinatorBridge> groupLocationsCoordinator;
@property (strong, nonatomic) id<MAAnimationCoordinatorBridge> mAnimationCoordinator;
@property (strong, nonatomic) TSMessageVaultItemCoordinatorBridge *vaultCoordinator;
@property (strong, nonatomic) TSVideoMessagingCoordinatorBridge *videoMessagingCoordinator;
@property (strong, nonatomic) TSMessageTasksItemCoordinatorBridge *tasksCoordinator;
@property (strong, nonatomic) TSExternalVideoMessagingCoordinatorBridge *externalVideoMessagingCoordinator;
@property (strong, nonatomic) StubGroupTemplateCoordinator *groupTemplateCoordinator;
@property (strong, nonatomic) TSTranslationIntelligentSuggestionsCoordinatorBridge *translationIntelligentSuggestionsCoordinator;
@property (strong, nonatomic) TSTranscriptDetailCoordinatorBridge* transcriptDetailCoordinator;

// Semantic/Fluid Object
@property (nonatomic) BOOL isFluidObjectEnabled;
@property (nonatomic) BOOL isFluidObject;//11235813
@property (strong, nonatomic) NSMutableDictionary<NSString *, TSSemanticListModel *> *semanticObjectListModels;
@property (strong, nonatomic) TSFluidComponentService *fluidService;

// SfC Interop block/accept view
@property (strong, nonatomic) TSSFCInteropOrTFLChatBlockAcceptViewController *sfcInteropChatBlockViewController;

@property (nonatomic) BOOL canRemoveConsultTransferCallSession;

@property (nonatomic, readonly, strong) NSSet *messageDeliveryStateErrorCodesSendFailed;
@property (nonatomic, readonly, strong) NSSet *messageDeliveryStateErrorCodesContactAdmin;

@property (strong, nonatomic) TSMeetingChickletHelper *meetingChickletHelper;

@property (nonatomic) TSGroupChatCreationState groupChatCreationState;
@property (strong, nonatomic) NSString* initialGroupTemplateType;
@property (nonatomic) BOOL didShowGroupTemplatePicker;
@property (nonatomic) BOOL forceEnableChat;

@property (strong, nonatomic) TSSearchParameters *searchParams;

@property (strong, nonatomic) NSString *activationOrigin;
@property (strong, nonatomic) NSString *activationPillar;

@property (strong, nonatomic) NSString *chatViewSource;
@property (strong, nonatomic) NSString *chatJoinUrl;
@property (strong, nonatomic) TSPlatformBotsAuthManager *ssoAuthManager;

@property (nonatomic) CGFloat emptyStateTopYoffset;

// Navigation bar handling
@property (strong, nonatomic) NSString *onUpdateNavItemNotificationName;

@property (assign, nonatomic) BOOL initialItemsHasBeenLoaded;
@property (copy, nonatomic) NSDate* loadStartTime;

@property (strong, nonatomic) NSString *selectedFileSmartReplyID;
@property (strong, nonatomic) NSString *browseFileSmartReplyID;
@property (nonatomic) NSInteger selectedSuggestedFileIndex;
@property (nonatomic) NSInteger selectedSuggestedFileProvider;
@property (nonatomic) long long suggestedFileButtonClickTime;
@property (nonatomic) long long suggestedFileAttachedTime;
@property (nonatomic) BOOL isLoadingFileSuggestion;
@property (strong, nonatomic) SubstrateTraceInfoAdapter *traceInfoAdapter;

// Giphy picker coachmark
@property (strong, nonatomic) TSTooltipView *funPickerTooltipView;
@property (strong, nonatomic) TSPlatformTelemetryLogger *platformTelemetryLogger;

// new app coachmark
@property (strong, nonatomic) TSTooltipView *plusNewTooltipView;

/// Sometimes the recipient information is not available by `-viewDidLoad`
/// Hence, the telemetry is not logged. So we need to wait till `-willNavigateToView:`
@property (nonatomic) BOOL isTelemetryLoggedForBotChat;

@property (nonatomic) BOOL isMultiSelectParticipantsInProgress;

@property (strong, nonatomic) TSTooltipView *taggingByShiftsToolTipView;
@property (strong, nonatomic) NSString *activeScheduledTagName;
@property (strong, nonatomic) NSString *fallbackDisplayName;

// Current status of the right bar button items being available.
@property (strong, atomic) NSNumber *rightBarButtonItemsEnabled;

@property (strong, nonatomic) TSBotmenuProvider *botMenuProvider;

// Message ID list to start translation spinner.
@property (strong, nonatomic) NSMutableSet<NSNumber *> *messageIDListToStartTranslationSpinner;

@property (nonatomic) BOOL shouldMultiSelectParticipants;
@property (nonatomic) BOOL shouldUseFlowV2;

@property (nonatomic) BOOL shouldHideBackBadgeCount;

@property (strong, nonatomic) NotificationBanner *inactiveGuardiansBannerView;

@property (nonatomic) TSTranslationModeSettingType translationMode;
@property (nonatomic) BOOL isTranslationInProgress;
@property (nonatomic) BOOL isAutomaticTranslationButtonTapped;
@property (assign, nonatomic) DynamicDecorationType dynamicDecorationType;

@property (nonatomic, strong) NSString *chatCreatorTenantName;
@property (nonatomic) BOOL isFedRosterCreatedOnTfL;
@property (nonatomic, strong) FederationInfoUtils *federationInfoUtil;
@property (nonatomic) BOOL shouldLimitComposeOptnInFedChat;
@property (nonatomic, strong) TSFederationUtils *federationUtils;
@property (nonatomic) BOOL hasCancelledFedInfoBanner;

@property (nonatomic) BOOL isSMBPrivacyAlertShown;

@property (strong, nonatomic) TSCalendarEventOperationsHelper *eventOperationsHelper;
@property (strong, nonatomic) TSSmartReplyCell *smartReplyCell;

@property (strong, nonatomic) NSString *chatRenderScenarioId;
@property (strong, nonatomic) GradientObject *bubbleGradient;

@property (strong, nonatomic) TSChatTranscriptViewModel *transcriptViewModel;
@property (strong, nonatomic) TSFluidTablePreviewCellHandlerInChat *fluidTablePreviewCellHandler;

@property (nonatomic, strong) id<MessageExtensionDiscoverabilityService> discoverabilityService;
// loading indicator flag
@property (nonatomic, assign) BOOL isLoadingIndicatorInChatEnabled;
@end

@implementation TSChatViewController

@synthesize keyboardHeight = _keyboardHeight;
@synthesize messagesView = _messagesView;
@synthesize thread = _thread;

- (SubstrateTraceInfoAdapter *)traceInfoAdapter
{
    if (!_traceInfoAdapter)
    {
        _traceInfoAdapter = [[SubstrateTraceInfoAdapter alloc] init];
        _traceInfoAdapter.searchSession = [TSSubstrateSearchUtility getSessionForSubstrateTelemetryWithAccountHandle:self.accountHandle scenarioName:TSkEventApiScenarioSmartReply];
        [_traceInfoAdapter createConversation:YES needReset:NO];
    }

    return _traceInfoAdapter;
}

- (TSPlatformBotsAuthManager *)ssoAuthManager
{
    if (!_ssoAuthManager)
    {
        _ssoAuthManager = [[TSPlatformBotsAuthManager alloc] initWithAccountHandle:self.accountHandle authManager:TSSharedManagers.authManager];
        _ssoAuthManager.delegate = self;
    }
    return _ssoAuthManager;
}

- (TSPlatformTelemetryLogger *) platformTelemetryLogger
{
    if (_platformTelemetryLogger == nil)
    {
        _platformTelemetryLogger = [[TSPlatformTelemetryLogger alloc] initWithAccountHandle:self.accountHandle threadId:self.threadID];
    }
    return _platformTelemetryLogger;
}

- (FederationInfoUtils *)federationInfoUtil
{
    if (!_federationInfoUtil)
    {
        _federationInfoUtil = [[FederationInfoUtils alloc] init];
    }
    return _federationInfoUtil;
}

- (TSFederationUtils *)federationUtils
{
    if(!_federationUtils)
    {
        _federationUtils = [[TSFederationUtils alloc] init];
    }
    return _federationUtils;
}

- (NSString*)panelType
{
    return TSkPanelTypeChat;
}

- (TSFluidTablePreviewCellHandlerInChat *)fluidTablePreviewCellHandler
{
    if (!_fluidTablePreviewCellHandler)
    {
        _fluidTablePreviewCellHandler = [[TSFluidTablePreviewCellHandlerInChat alloc] initWithAccountHandle:self.accountHandle providerDelegate:self];
    }
    return _fluidTablePreviewCellHandler;
}

- (TSCalendarEventOperationsHelper *)eventOperationsHelper
{
    //lazy initialization
    if (!_eventOperationsHelper)
    {
        _eventOperationsHelper = [[TSCalendarEventOperationsHelper alloc] init];
    }
    return _eventOperationsHelper;
}

- (TSAttributedStringProcessor *)createAttributedStringProcessor
{
   return [[TSChatAttributedStringProcessor alloc] initWithAccountHandle:self.accountHandle
                                                               tableView:self.tableView
                                                                delagate:self];
}

#pragma mark - Navigate and load

- (void)setShouldShowJoinMeetingBar:(BOOL)shouldShowJoinMeetingBar
{
    _shouldShowJoinMeetingBar = shouldShowJoinMeetingBar;
    __weak typeof (self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if ([strongSelf shouldShowMeetingOrGroupCallJoinBannerView])
        {
            [strongSelf constructAndShowMeetingJoinBannerView];
        }
        else
        {
            if (strongSelf.meetingBannerView)
            {
                [strongSelf.meetingBannerView removeFromSuperview];
            }
        }
    }];
}

- (void) dealloc
{
    LogInfoAH(self.accountHandle.logger, @"dealloc %@", self.threadID);

    if (self.chatDropdown)
    {
        [self.chatDropdown removeFromParentViewController];
        [self.chatDropdown didMoveToParentViewController:nil];
        self.chatDropdown = nil;
    }
    
    if (self.toViewController)
    {
        [self.toViewController removeFromParentViewController];
        [self.toViewController didMoveToParentViewController:nil];
        self.toViewController = nil;
    }
    
    if (self.registeredForIdleProcessing)
    {
        [[AXPIdleProcessor sharedIdleProcessor] unregisterDelegate:[self keyForIdleProcessing]];
        self.registeredForIdleProcessing = NO;
    }
    
    [self.customBannerViewContainer removeObserver:self forKeyPath:@"hidden"];
    
    self.transcriptDetailCoordinator = nil;
    self.locationBannerCoordinator = nil;
    self.liveLocationCoordinator = nil;
    self.staticLocationCoordinator = nil;
    self.groupLocationsCoordinator = nil;
    self.vaultCoordinator = nil;
    self.videoMessagingCoordinator = nil;
    self.messageFetchEngine = nil;
    self.tasksCoordinator = nil;
    if (self.isLoadingIndicatorInChatEnabled)
    {
        self.activitySpinnerWithText.hidden = YES;
        [self.activitySpinnerWithText removeFromSuperview];
        self.activitySpinnerWithText = nil;
    }
    self.mAnimationCoordinator = nil;
    
    self.translationIntelligentSuggestionsCoordinator = nil;
    
    if (self.isFluidObjectEnabled)
    {
        [self.fluidService cleanUp];
    }
    
    if (self.composeLocationObserver)
    {
        [self.composeLocationObserver removeAllListeners];
        self.composeLocationObserver = nil;
    }

    if (_traceInfoAdapter.searchSession)
    {
        [_traceInfoAdapter.searchSession closeConversation];
    }
}

- (void) performSegue:(NSString *)identifier withViewInfo:(NSDictionary *)viewInfo
{
    if ([identifier compareString:TSkSeguePushChatMultiView] && [[self threadID] compareString:[viewInfo objectForKey:TSkThreadID]])
    {
        // skip navigation because they are the same chat view
        return;
    }
    
    NSMutableDictionary *viewInfoDict  = viewInfo.mutableCopy;
    viewInfoDict[TSkHostViewContollerKey] = self;
    
    [super performSegue:identifier withViewInfo:viewInfoDict];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier compareString:TSkSeguePushSlideshow])
    {
        if ([segue.destinationViewController isKindOfClass:[TSSlideshowViewController class]])
        {
            TSSlideshowViewController *slideShowViewController = segue.destinationViewController;
            slideShowViewController.composeViewController = self.composeViewController;
        }
        else if ([segue.destinationViewController isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *navigationController
                = (UINavigationController *) segue.destinationViewController;

            if ([[navigationController.viewControllers firstObject]
                    isKindOfClass:[TSSlideshowViewController class]])
            {
                TSSlideshowViewController *slideShowViewController = (TSSlideshowViewController *)
                    [navigationController.viewControllers firstObject];
                slideShowViewController.composeViewController = self.composeViewController;
            }
        }
    }
}

- (void)willNavigateToSelf:(NSDictionary *)viewInfo
{
    [super willNavigateToSelf:viewInfo];
    [self willNavigateToView:viewInfo];
}

- (void)willNavigateToView:(NSDictionary *)viewInfo
{
    [self startChatRenderScenarioMarker];
    
    BOOL navigatingWithNoThreadAndParticipants = NO;
    
    [super willNavigateToView:viewInfo];
    // Needed this flag to make the title same as previous navigation item title for meetings
    // where threadID is not present
    if([viewInfo count])
    {
        self.shouldConfigureForMeetings = [viewInfo[TSkMeetingChatShouldConfigureForMeetings] boolValue];
    }
    self.shouldShowPresenceOnTitle = NO;
    self.hasAppeared = NO;
    
    TSExperimentGroupTemplateCreate groupTemplateExperimentType = self.accountHandle.policyManager.groupCreationWithTemplateExperimentationValue;
    if (groupTemplateExperimentType != TSExperimentGroupTemplateCreateDisabled)
    {
        self.initialGroupTemplateType = viewInfo[TSkGroupTemplateTypeKey];
    }
    self.isChatDisable = NO;
    self.disabledReason = nil;
    self.lastMessageDate = @0;
    self.dataLock = [NSLock new];
    self.viewItems = NSArray.array;
    self.messageDictionary = NSDictionary.dictionary;
    [self.messageFetchEngine setDelegate:nil];
    self.messageFetchEngine = nil;
    self.currentPresenceStatus = TSPresenceStatusUnknown;
    self.composeViewController.delegate = self;
    self.composeViewController.entityType = [TSThread class];
    self.maxGroupChatParticipantsForFanout = [self.accountHandle.ecsManager maxGroupChatParticipantsForFanout];
    self.maxGroupChatParticipantsForGroupCall = self.accountHandle.policyManager.maxGroupChatParticipantsForGroupCall;
    self.oneOnOneChatBannerDismissTimeFrameInDays = [self.accountHandle.ecsManager oneOnOneChatBannerDismissTimeFrameInDays];
    self.groupChatBannerDismissTimeFrameInDays = [self.accountHandle.ecsManager groupChatBannerDismissTimeFrameInDays];
    self.bannerDismissDictMaxCount = [self.accountHandle.ecsManager bannerDismissDictMaxCount];
    self.isNativeFedChatEnabled = self.accountHandle.policyManager.isNativeFedChatEnabled;
    self.isFluidObjectEnabled = [TSFluidComponentService isFluidEnabledForAccount:self.accountHandle];
    self.topicName = viewInfo[TSkTopicName];
    self.recipientIDs = nil;
    self.threadID = nil;
    self.groupChatCreationState = TSGroupChatCreationStateNoOp;
    self.shouldCollapseComposeToolbar = NO;
    self.chatViewSource = viewInfo[@"source"];
    self.fallbackDisplayName = nil;
    self.shouldShowEcryptionMessage = [self.accountHandle.policyManager isEndToEndEncryptionEnabled] ? [viewInfo[@"isEncrypted"] boolValue] : NO;
    self.messageIDListToStartTranslationSpinner = [NSMutableSet set];
    
    NSArray *recipientIDs = nil;
    
    if ([viewInfo count])
    {
        NSMutableDictionary *segueViewInfo = viewInfo.mutableCopy;
        [segueViewInfo removeObjectForKey:TSkMeetingItemViewData];
        [segueViewInfo removeObjectForKey:TSkCall];
        segueViewInfo[TSkSegueIdentifier] = TSkSeguePushChatMultiView;
        self.viewRestorationInfo = segueViewInfo;
        
        self.restoringViewState = [viewInfo[TSkRestoringViewState] boolValue];
        self.initiateChatWithTBot = viewInfo[@"initiateChatWithTBot"];
        self.chatWithTBot = viewInfo[@"chatWithTBot"];
        self.groupChatCreationState = [viewInfo[TSkGroupChatCreationStateKey] intValue] ?: TSGroupChatCreationStateNoOp;
        self.createChatWithRecipientIDs = [viewInfo[TSkCreateChatWithRecipientIDs] boolValue];
        self.isMultiSelectParticipantsInProgress = NO;
        self.userSearchResultItem = viewInfo[@"TSEntitySearchResultItem"];
        self.hideCallOptions = [self.accountHandle.policyManager isCallingAllowed] ? [viewInfo[@"hideCallOptions"] boolValue] : YES;
        self.isTabBarHidden = [viewInfo[TSkIsTabBarHidden] boolValue];
        self.isInCallRightPanel = [viewInfo[TSkIsInCallRightPanel] boolValue];
        self.viewBottomOffset = viewInfo[TSkInCallViewBottomOffset] ? [viewInfo[TSkInCallViewBottomOffset] floatValue] : 0;
        self.forceShowBackButton = [viewInfo[TSkForceShowBackButton] boolValue];
        self.navScenarioID = viewInfo[TSkNavScenarioID];
        self.scrollToMessageScenarioID = viewInfo[TSkScrollToMsgScenarioID];
        self.chatWithMeetingParticipantsScenarioID = viewInfo[TSkChatWithMeetingParticipantsScenarioID];
        self.chatCreateScenarioID = viewInfo[TSkChatCreateScenarioID];
        self.onUpdateNavItemNotificationName = viewInfo[TSkOnUpdateNavigationBar];
        
        // Cases when we navigated into this controller by specifying the recipient, such as directly from the people-card, this param is set.
        recipientIDs = [viewInfo valueForKey:TSkRecipientIDs];
        
        self.didAnonJoinCallEnd = [viewInfo[TSkAnonymousJoinMeetingEnded] boolValue];
        self.isAnonymouslyJoinedToCall = [viewInfo[TSkAnonymouslyJoinedToCall] boolValue];
        self.call = [viewInfo valueForKey:TSkCall];
        self.isNewFederatedUser = [viewInfo[TSkNewFederatedUser] boolValue];
        self.federatedUserSynced = NO;
        self.federatedUserDisplayName = viewInfo[TSkUserDisplayName];
        self.isConsultTransferConversation = [viewInfo[TSIsConsultTransferParticipantNavigationKey] boolValue];
        self.consultTransferPrepopulatedMessage = viewInfo[@"consultTransferPrepopulatedMessage"];
        self.hideVideoCallButton = [viewInfo[@"hideVideoCallButton"] boolValue];
        self.shouldShowKeyboard = [viewInfo[TSkShouldShowKeyboard] boolValue];
        self.textForDeepLinkedInitialization = viewInfo[TSkDeepLinkedInitializationText];
        self.calendarEventDetailsViewData = viewInfo[TSkMeetingItemViewData];
        self.fileShareUrl = viewInfo[TSFileDetailsShareUrlKey];
        self.fromThreadID = viewInfo[TSkOriginThreadID];
        self.forwardImages = viewInfo[TSkMultiImagesForwardKey];
        self.lateToMeetingPrepopulatedMessage = viewInfo[@"lateToMeetingPrepopulatedMessage"];
        self.shouldCollapseComposeToolbar = [viewInfo[TSkShouldCollapseComposeToolbar] boolValue];
        self.emptyStateForMeetings = [viewInfo valueForKey:TSkMeetingChatEmptyViewData];
        self.scenarioEntryPoint = viewInfo[TSkEntryPoint];
        self.chatJoinUrl = viewInfo[TSkChatInviteLinkProperty];
        self.groupAvatarEditPressed = [viewInfo[TSkGroupAvatarEditPressed] boolValue];
        self.hasCustomGroupAvatar = [viewInfo[TSkHasCustomGroupAvatar] boolValue];
        self.welcomeCardDidPressSmartReplyButton = NO;
        self.groupNameRequiredPromptShown = NO;
        self.shouldShowAccAwareToast = [viewInfo[TSkMTMAShowToast] boolValue] && [self.accountHandle.ecsManager accountAwareToastEnabledForTappedNotifications];
        self.activationOrigin = viewInfo[TSkActivationOrigin];
        self.activationPillar = viewInfo[TSkActivationPillar];
        self.forceEnableChat = [viewInfo[TSkShouldForceEnableChatOnChatView] boolValue];
        self.activeScheduledTagName = [viewInfo valueForKey:TSkShowTaggingByShiftsToolTip];
        
        if (self.accountHandle.policyManager.isTfwTflFedChatCreationOnTfwEnabled && viewInfo[TSkEntryPoint] == TSkEntryPointChatDetails)
        {
            self.recipientsUserInfo = [viewInfo valueForKey:TSkRecipientInfoDict];
            self.chatCreateDraftKey = [viewInfo valueForKey:TSkChatCreationDraftKey] ?: self.chatCreateDraftKey;
        }
                
        self.isGuardiansChat = [viewInfo[TSkIsGuardiansChat] boolValue] || self.isGuardiansChat;
        self.guardiansAadGroupId = viewInfo[TSkAADGroupID] ?: self.guardiansAadGroupId;
        self.guardiansUserId = viewInfo[TSKKeyUserID] ?: self.guardiansUserId;
        self.guardiansRecipientEmails = viewInfo[TSkRecipientEmails] ?: self.guardiansRecipientEmails;
        self.guardiansRecipientPhones = viewInfo[TSkRecipientPhones] ?: self.guardiansRecipientPhones;
        
        self.shouldHideBackBadgeCount = [viewInfo[TSkHideBackBadgeCount] boolValue];
        
        if (self.isGuardiansChat && ([NSString isNilOrEmpty:self.guardiansAadGroupId] ||
                                     [NSString isNilOrEmpty:self.guardiansUserId]))
        {
            LogErrorAH(self.logger, @"isGuardiansChat required values are invalid");
        }

        if (groupTemplateExperimentType != TSExperimentGroupTemplateCreateDisabled)
        {
            if (viewInfo[TSkGroupTemplateTypeKey])
            {
                self.groupChatCreationState = groupTemplateExperimentType == TSExperimentGroupTemplateCreateNameAndLandInChat || self.accountHandle.policyManager.isGroupTemplatesWithPeoplePickerEnabled ?
                                        TSGroupChatCreationStateStart :
                                        TSGroupChatCreationStateInChatWithCompose;
                self.topicName = [self.groupTemplateCoordinator defaultGroupName];
            }
        }
        
        if (self.accountHandle.policyManager.isLocationWithLiveSharingEnabled)
        {
            self.initialLocationSharingAction = viewInfo[TSkLocationSharingInitialAction];
            self.initialLocationSharingActionUserIdentifier = viewInfo[TSkLocationSharingInitialActionUserIdentifier];
            self.initialLocationSharingActionPlaceIdentifier = viewInfo[TSkLocationSharingInitialActionPlaceIdentifier];
        }
    }
    
    self.readReceiptsMaxParticipants = (self.threadType == TSThreadTypePrivateMeeting) ? [self.accountHandle.ecsManager meetingReadReceiptsMaxParticipants] : [self.accountHandle.ecsManager readReceiptsMaxParticipants];
    
    NSString *threadID = viewInfo[TSkThreadID];
    if ([threadID length])
    {
        // Get muted state first because that affects subtitle and presence state
        TSConversation *conv = [AXPCtx conversationForID:threadID];
        self.isMuted = [conv conversationAlertsAreMuted];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TSkConversationOpenedForPin
                                                            object:nil
                                                          userInfo:@{TSkNotificationKeyForConversation: threadID}];
    }
    
    // NOTE: there are UI specific logic(meeting banner view in particular) in the setter of threadID,
    // make sure you set necessary flags such as didAnonJoinCallEnd before setting it.
    self.isChatWithSelf = [threadID isEqualToString:TSkChatWithSelfThreadID];
    self.threadID = threadID;
    self.sourceSegueId = viewInfo[TSkSegueId];
    self.sessionId = viewInfo[TSkSessionId] ?: [[NSUUID UUID] UUIDString];
    
    if (self.accountHandle.ecsManager.isTranscriptFeatureEnabledOnECS)
    {
        TSMeetingInfo *meetingInfo = [[TSMeetingInfo alloc] initWithJson:(NSDictionary *)self.thread.meeting];
        self.transcriptViewModel = [self buildTranscriptViewModelWithMeetingInfo:meetingInfo];
        TSWeakify(self)
        self.transcriptViewModel.onTranscriptDownloaded = ^(NSString *filePath, UIView *view) {
            TSStrongifyAndReturnIfNil(self)
            if ([NSString isNilOrEmpty:filePath])
            {
                [self showToastViewWithTitle:AXPLocalizedString(@"FailedToDownload")];
                return;
            }
            NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
            // fromView is only used for iPad
            [TSFileUtility shareData:@[fileUrl] fromView:view viewController:self withModuleName:TSkActionModuleContextMenuOptions logger: self.accountHandle.logger];
        };
    }

    if (self.isNewFederatedUser)
    {
        self.toContainerViewHeight.constant = 0.0f;
        [self showChatViewBannerIfRequired];
        [self resetViewAndSyncFederatedUser:viewInfo];
    }
    else
    {
        self.composeView.hidden = !self.threadID && recipientIDs.count == 0;
    }
    
    [self nativeFederationChatPreFetch];
    
    if ([recipientIDs count] == 1)
    {
        [TSPresenceService.defaultService getPresenceOfUsers:@[recipientIDs.firstObject] withAccountHandle:self.accountHandle andCompletion:nil];
    }

    if (self.accountHandle.actionContext.isEduAccount &&
        self.accountHandle.ecsManager.isGuardianTeacherChatEnabled &&
        self.threadID && !self.isGuardiansChat)
    {
        // Recheck for Guardians chat in case they re-entered from the Chat List
        TSThreadProperty *threadProperty = [AXPCtx threadPropertyForThreadID:self.threadID
                                                             andPropertyName:TSkIsGuardiansChat
                                                                       inMoc:self.accountHandle.mainMOC];
        self.isGuardiansChat = [threadProperty.propertyValue.asDecimalNumber boolValue];
        
        // Entered Guardians chat from the chat list, check if banner needs to show
        if (self.isGuardiansChat)
        {
            TSThreadProperty *threadProperty = [AXPCtx threadPropertyForThreadID:self.threadID
                                                                 andPropertyName:TSkThreadPropertyGuardianChatInfo
                                                                           inMoc:self.accountHandle.mainMOC];
            
            [self checkInactiveGuardiansWithProperties:[[threadProperty.propertyValue asString] dictionaryFromJSON]];
        }
    }
    
    TSThread *thread = nil;
    if ([self.threadID length])
    {
        thread = [AXPCtx threadForID:self.threadID inMoc:self.accountHandle.mainMOC];
        if (self.isChatWithSelf && !thread)
        {
            self.isCreatingChatWithSelfThread = YES;
        }
        
        // Have self.threadID for a thread that hasn't synced yet. Tapped a notification, etc.  Sync and retry
        // If this view is for chat with self, do not retry for ThreadNotFound, and continue as a valid scenario
        if (!thread && [TSSharedManagers.authManager authStatus] == TSkHaveAuthentication && !self.isChatWithSelf)
        {
            if (!self.retriedForThreadNotFound)
            {
                self.retriedForThreadNotFound = YES;
                
                LogInfoAH(self.accountHandle.logger, @"%@ not found, sync and retry", self.threadID);
                
                [self willNavigateChatThreadNotFound:viewInfo];
            }
            else
            {
                // Retried and still couldn't sync.  Show empty state instead of blank view
                self.threadNotFound = YES;
                [self showEmptyStateView:YES];
            }
            return;
        }
    }
    
    BOOL navigatingToPeoplePickerForGroupTemplate = self.isGroupTemplateChat
        && self.accountHandle.policyManager.isGroupTemplatesWithPeoplePickerEnabled
        // Note: If naming is enabled then People Picker will be determined later.
        && groupTemplateExperimentType != TSExperimentGroupTemplateCreateNameAndLandInChat;
    
    if (thread != nil)
    {
        [self updateRecipientList];
        [self updateFederationPropertiesForRoster];
        [self startScenarioMarker];
        [self loadInitialMessagePage];
        self.hasAppeared = YES;
    }
    else if (recipientIDs.count)
    {
        self.recipientIDs = [recipientIDs copy];
        if ([self.sourceSegueId isEqualToString:TSkSeguePushDeviceContactChat])
        {
            NSMutableDictionary *recipientsDict = [NSMutableDictionary new];
            [recipientsDict addEntriesFromDictionary:@{
                TSkDeviceContactID : viewInfo[TSkDeviceContactID],
                TSkDisplayName : viewInfo[TSkDisplayName],
                TSkUserMRI : viewInfo[TSkUserMri],
                TSkSearchResultItemType: viewInfo[TSkSearchResultItemType],
            }];
            if ([viewInfo[TSkPhoneNumber] isNotNilOrEmpty])
            {
                [recipientsDict setValue:viewInfo[TSkPhoneNumber] forKey:TSkPhoneNumber];
            }
            else if ([viewInfo[TSkUserEmail] isNotNilOrEmpty])
            {
                [recipientsDict setValue:viewInfo[TSkUserEmail] forKey:TSkUserEmail];
            }
            if([recipientsDict count])
            {
                self.recipientsUserInfo = [TSUtilities recipientIDsWithUserInfoFromSelectedRecipients:@[recipientsDict]];
            }
        }
        
        [self startScenarioMarker];
        
        if (self.groupChatCreationState == TSGroupChatCreationStateNoOp || self.groupChatCreationState == TSGroupChatCreationStateInChatWithCompose)
        {
            [self findConversationWithRecipients];
        }
        else if (self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants) {
            if ([self showOneToOneChatInGroupCreationFlow])
            {
                [self findConversationWithRecipients];
            }
            else
            {
                [self showEmptyStateView:YES];
            }
        }
    }
    else if (self.groupChatCreationState == TSGroupChatCreationStateInChatWithCompose &&
             (groupTemplateExperimentType == TSExperimentGroupTemplateCreateAndLandInChat ||
              groupTemplateExperimentType == TSExperimentGroupTemplateCreateAndLandInDashboard))
    {
        [self createEmptyGroupChat];
    }
    else if (self.groupChatCreationState == TSGroupChatCreationStateStart && !navigatingToPeoplePickerForGroupTemplate)
    {
        [self showEmptyStateView:YES]; // not showing empty state means real empty page
        [self removeStatusMessageBannerView];
    }
    else if (!self.isChatWithSelf)
    {
        // threadID will be nil when creating a new chat
        self.errorContainerNotFound = ![NSString isNilOrEmpty:self.threadID];
        self.messageFetchEngine = nil;
        self.messageDictionary = NSDictionary.dictionary;
        
        [self showEmptyStateView:NO]; // not showing empty state means real empty page
        // following disables interaction with compose vc.
        self.composeViewController.entityType = nil;
        [self reloadTable];
        
        // do not allow pull-to-load-more as the chat has no recipients
        self.hasAppeared = NO;
        
        if (!self.chatCreateDraftKey)
        {
            self.chatCreateDraftKey = TSkNewChatDraftKey;
        }
        [self removeStatusMessageBannerView];
        navigatingWithNoThreadAndParticipants = YES;
    }
    
    if (self.toViewController != nil && self.recipientIDs && self.loadedWithViewPreservation)
    {
        // In case of launching through view preservation, viewDidLoad gets called before decodeRestorableStateWithCoder,
        // that causes ToView to get visible. Here we need to hide it if its not needed
        self.toContainerViewHeight.constant = 0.0f;
        [self.toView setHidden:YES];
    }
    
    if (self.isChatWithSelf && self.toViewController != nil)
    {
        [self hideToContainerAndShowOuterViewTabs];
    }
    
    // Need to pick up Video URLs included in the ImageDatas key
    if (self.threadID && viewInfo[TSkImageDatasKey])
    {
        for (id data in (NSArray *)viewInfo[TSkImageDatasKey])
        {
            if ([data isKindOfClass:NSString.class])
            {
                NSString *filePath = (NSString *)data;
                
                [self.composeViewController.fileUploadComposer documentPickerDidPickDocumentAtURL:[NSURL fileURLWithPath:filePath]
                                                                                          isVideo:[[TSFileUtility normalizeFileExtension:filePath.pathExtension] isEqualToString:@"video"]
                                                                                      defaultName:filePath.lastPathComponent
                                                                                       completion:^
                 {
                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                }];
            }
        }
    }
    
    if (self.threadID && viewInfo[TSkOnEntryAction])
    {
        self.onEntryAction = viewInfo[TSkOnEntryAction];
    }
    self.loadedWithViewPreservation = NO;
    
    if(self.shouldShowAccAwareToast)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:TSkMTMAShowToast object:nil];
    }

    [self checkLogTelemetryForBotChatLoad];

    BOOL useFlowV2 = self.shouldUseFlowV2
        && !self.isGroupTemplateChat
        && (self.groupChatCreationState == TSGroupChatCreationStateStart
            || self.groupChatCreationState == TSGroupChatCreationStateNoOp);
    
    BOOL useTemplatePeoplePicker = navigatingToPeoplePickerForGroupTemplate
        && self.groupChatCreationState == TSGroupChatCreationStateStart;
    
    if (navigatingWithNoThreadAndParticipants && (useFlowV2 || useTemplatePeoplePicker))
    {
        [self transitionToAddingParticipantsInitialState];
    }
    
    self.inactiveGuardiansDisplayNames = [viewInfo[TSkInactiveGuardians] asArray];
}

-(void)dismissEcryptionMessageView
{
    self.heightEncryptionView.constant = 0.0f;
}

- (void)willNavigateChatThreadNotFound:(NSDictionary *)viewInfo
{
    NSString *correlationID = [@"ChatThreadNotFound:" stringByAppendingString:[[NSUUID UUID] UUIDString]];
    
    [self startActivityIndicator];
    [self disableChatAndUpdateComposeView:YES];
    
    TSWeakify(self);
    [TSSyncEngine.sharedInstance.threadSyncManager syncThreadsWithIDs:@[ self.threadID ]
                                                     forCorrelationID:correlationID
                                                        accountHandle:self.accountHandle
                                                       withCompletion:^(NSError *err)
     {
        [TSDispatchUtilities dispatchOnMainThread:^
         {
            TSStrongifyAndReturnIfNil(self);
            
            if (err)
            {
                NSString *message = [NSString stringWithFormat:@"Error syncing thread %@, %@ %ld", self.threadID, err.domain, err.code];
                [AXPUtilities logNetworkErrorOrWarning:err withMessage:message logger:self.accountHandle.logger];
                
                [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"UnknownChatTitle")
                                                    andMessage:AXPLocalizedString(@"UnknownChatDescription")
                                              andButtonContent:AXPLocalizedString(@"TSOK")
                                             andViewController:self];
            }
            
            [self stopActivityIndicator];
            [self disableChatAndUpdateComposeView:NO];
            [self willNavigateToSelf:viewInfo];
        }];
    }];
    
}

- (BOOL) isOneToOneChatWelcomeCardEnabled
{
    return self.accountHandle.policyManager.isOneToOneChatWelcomeCardEnabled;
}

- (BOOL) shouldTriggerOneToOneInviteFlow
{
    return self.recipientIDs.count == 1
    && self.accountHandle.policyManager.isOneToOneChatWelcomeCardEnabled
    && self.accountHandle.policyManager.isUserInviteEnabled
    && [self isOutOfNetworkUser:[self.recipientIDs firstObject]];
}

- (BOOL) isAnyWelcomeCardFeatureEnabled
{
    return self.accountHandle.policyManager.isGroupChatWelcomeCardEnabled || self.accountHandle.policyManager.isOneToOneChatWelcomeCardEnabled;
}

- (void) calculateThreadType
{
    __weak typeof (self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^
     {
        __strong typeof (self) strongSelf = weakSelf;
        
        strongSelf.threadTypeFromThreadProperties = TSThreadTypeUnknown;
        
        if ([strongSelf.threadID isNotNilOrEmpty])
        {
            TSThread *thread = [AXPCtx threadForID:strongSelf.threadID];
            
            if ([thread isPrivateMeeting])
            {
                strongSelf.threadTypeFromThreadProperties = TSThreadTypePrivateMeeting;
            }
            else if ([TSUtilities isInteropChatByThreadTypeOrThreadIdForThread:thread])
            {
                strongSelf.threadTypeFromThreadProperties = TSThreadTypeInteropChat;
            }
            else if ([thread isSMSChat])
            {
                strongSelf.threadTypeFromThreadProperties = TSThreadTypePhoneChat;
            }
            else if ([thread isOneOnOneChat])
            {
                strongSelf.threadTypeFromThreadProperties = TSThreadTypeOneOnOneChat;
            }
            else if ([thread isChatWithSelfThread])
            {
                strongSelf.threadTypeFromThreadProperties = TSThreadTypeStreamOfNotes;
            }
            else if ([thread isGroupChat])
            {
                strongSelf.threadTypeFromThreadProperties = TSThreadTypeGroupChat;
            }
        }
        else if ([self.recipientIDs count] > 1)
        {
            strongSelf.threadTypeFromThreadProperties = TSThreadTypeGroupChat;
        }
    }];
}

- (BOOL) isRosterWithFederatedUser
{
    return (self.externalParticipantsInRoster & FederatedUserInRoster) != 0;
}

- (BOOL) isRosterWithTflInterOpUser
{
    return (self.externalParticipantsInRoster & TflInterOpUserInRoster) != 0;
}

- (BOOL) isRosterWithExtendedDirectoryUser
{
    return (self.externalParticipantsInRoster & ExtendedDirectoryUserInRoster) != 0;
}

- (BOOL) isRosterWithOffNetworkFedUser
{
    return (self.externalParticipantsInRoster & OffNetworkFedUserInRoster) != 0;
}

- (BOOL) isRosterWithBlockedTenantFedUser
{
    return (self.externalParticipantsInRoster & BlockedTenantFedUserInRoster) != 0;
}

- (void)updateFederationPropertiesForRoster
{
    
    [self updateExternalParticipantsInRosterDetails];
    
    if(self.accountHandle.policyManager.isTfwTflFedChatConsumptionPhase2OnTflEnabled)
    {
        //For Phase2 consumption on TFL - limit consumption options if chat is created on tfW
        self.isFedRosterCreatedOnTfL = [NSString isNilOrEmpty:self.threadID] || [self.federationUtils isChatCreatorTfLUserFor:self.threadID inMoc:self.accountHandle.mainMOC];
        self.chatCreatorTenantName = [self.federationUtils chatCreatorTenantNameFor:self.threadID inMoc:self.accountHandle.mainMOC];
    }
    
    self.shouldLimitComposeOptnInFedChat = [self shouldLimitComposeOptionInFederatedChat];
    [self showBannerAboutOffNetworkOrFedMsgPolicyIfNeeded];
}

- (void)updateExternalParticipantsInRosterDetails
{
    self.externalParticipantsInRoster = NoExternalUserInRoster;
    self.isFedRosterCreatedOnTfL = NO;
    
    if(self.threadID)
    {
        TSThread *thread = [AXPCtx threadForID:self.threadID inMoc:self.accountHandle.mainMOC];
        if ([thread isExternalThreadByCfet])
        {
            self.externalParticipantsInRoster |= OffNetworkFedUserInRoster;
        }
    }
    
    if (self.threadID == nil && self.isGuardiansChat)
    {
        self.recipientsUserInfo = [self buildGuardiansRecipientsUserInfo];
    }

    for (NSString *recipientID in self.recipientIDs)
    {
        NSDictionary *info = self.recipientsUserInfo[recipientID];
        NSString *itemType = info[TSkSearchResultItemType];
        BOOL phoneOrEmail = [itemType isEqual:TSkDeviceContactSearchType] ||
            [itemType isEqual:TSkAnonymousUserWithEmailSearchType] ||
            [itemType isEqual:TSkAnonymousUserWithPhoneSearchType];
        TSUser *user = [AXPCtx userForID:recipientID inMoc:self.accountHandle.mainMOC];
        if (phoneOrEmail)
        {
            self.externalParticipantsInRoster |= OffNetworkFedUserInRoster;
        }
        else if (!self.isRosterWithFederatedUser && [user isTypeOfFederated])
        {
            self.externalParticipantsInRoster |= FederatedUserInRoster;
        }
        else if (!self.isRosterWithExtendedDirectoryUser && [user isExtendedDirectoryUser])
        {
            self.externalParticipantsInRoster |= ExtendedDirectoryUserInRoster;
        }
        else if (!self.isRosterWithTflInterOpUser && [user isTypeOfTFLInterOpUser])
        {
            self.externalParticipantsInRoster |= TflInterOpUserInRoster;
        }
        
        if ([self shouldUpdateBlockedTenantFedUserInRosterFlag:user])
        {
            self.externalParticipantsInRoster |= BlockedTenantFedUserInRoster;
        }
        
        if (self.isRosterWithFederatedUser && self.isRosterWithTflInterOpUser && self.isRosterWithExtendedDirectoryUser
            && self.isRosterWithOffNetworkFedUser && self.isRosterWithBlockedTenantFedUser)
        {
            break;
        }
    }
}

-(BOOL)shouldUpdateBlockedTenantFedUserInRosterFlag:(TSUser *)user
{
    return self.recipientIDs.count > 1 && !self.isRosterWithBlockedTenantFedUser && !user.displayName
    && ([user isFederatedUser]
        || ([NSString isNilOrEmpty:user.type] && user.isFederated.boolValue)
        || (self.accountHandle.policyManager.isTfwTflFedChatConsumptionOnTflEnabled && [user hasAADUserPrefix]));
}

- (BOOL)shouldLimitComposeOptionInFederatedChat
{
    if(self.accountHandle.policyManager.enableFederatedGroupChatConsumption)
    {
        //All fed chats on TfW need to limit consumption options
        return [self isTfLInterOpOrOffNetworkFedChat];
    }
    else if(self.accountHandle.policyManager.isTfwTflFedChatConsumptionPhase2OnTflEnabled)
    {
        //For Phase2 consumption on TFL - limit consumption options if chat is created on tfW
        return !self.isFedRosterCreatedOnTfL;
    }
    else if(self.accountHandle.policyManager.isTfwTflFedChatConsumptionOnTflEnabled)
    {
        //For Phase1 consumption on TfL - limit consumption if chat has Fed members.
        return [self isTfLInterOpOrOffNetworkFedChat];
    }
    else
    {
        return NO;
    }
}

// NOTE: Should always be invoked from main thread
- (void)checkShouldShowPresence
{
    AssertMainThread();
    if (self.isMuted || self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants)
    {
        self.shouldShowPresenceOnTitle = NO;
    }
    else if (self.recipientIDs && self.recipientIDs.count == 1)
    {
        // after we support sfb presence data sourece, we will show presence for interop chats
        self.shouldShowPresenceOnTitle = (self.threadType == TSThreadTypeOneOnOneChat ||
                                          (self.threadType == TSThreadTypeInteropChat && [TSUtilities upsEnabled]));
        
        BOOL isSfCInteropChat = [self isSfCInteropChat];
        // Do not show sfc presence
        if (isSfCInteropChat)
        {
            self.shouldShowPresenceOnTitle = NO;
        }
        NSString *receipientID = self.recipientIDs.firstObject;
        if ([self.accountHandle.actionContext isSfCInteropEnabled]
            && [NSString isNilOrEmpty:self.threadID]
            && self.recipientIDs.count == 1
            && isSfCInteropChat
            && ![self.accountHandle.policyManager.blockListForUser containsObject:receipientID])
        {
            self.shouldShowPresenceOnTitle = NO;
        }
        
        if (self.shouldShowPresenceOnTitle)
        {
            TSUserInfo *user = [self userInfoForID:[self.recipientIDs firstObject]];
            if ((user && [user isConnectorBot]) || (self.threadType == TSThreadTypePrivateMeeting))
            {
                self.shouldShowPresenceOnTitle = NO;
            }
            
            [self updatePresenceStatusIfRequired];
            BOOL shouldHidePresenceUI = [TSUtilities shouldHidePresenceIconForStatus:self.currentPresenceStatus];
            
            if (shouldHidePresenceUI)
            {
                self.shouldShowPresenceOnTitle = NO;
            }
        }
        
        if ([self isSMSChat])
        {
            self.shouldShowPresenceOnTitle = NO;
        }
    }
}

- (void) updatePresenceStatusIfRequired
{
    if (self.recipientIDs && self.recipientIDs.count == 1 && self.shouldShowPresenceOnTitle)
    {
        self.currentPresenceStatus = [[TSPresenceService defaultService] presenceStatusForUser:[self.recipientIDs firstObject]];
    }
}

// method looks at the last sent msg from the user and updates last seen at based on that
- (void) updatePresenceStatusIfRequiredFromMessageList:(NSArray *)messageList
{
    if (self.recipientIDs.count == 1 && self.shouldShowPresenceOnTitle)
    {
        NSString *recipientMri = [self.recipientIDs firstObject];
        for (NSDictionary *item in messageList)
        {
            NSString *senderUserMri = item[@"userID"];
            if ([senderUserMri compareString:recipientMri])
            {
                self.recipientLastSentMsgTime = [[item[@"arrivalTime"] asString] dateFromSkypeDateString];
                [self updatePresenceStatusIfRequired];
                break;
            }
        }
    }
}

- (BOOL)shouldSetSubTitle
{
    return ([self isNotSfbAndNotSfcInteropChat] && [self isTfLInterOpOrOffNetworkFedChat] == NO) && [TSUtilities upsEnabled];
}

- (TSPresenceStatus)getPresenceStatus
{
    return self.currentPresenceStatus;
}

- (BOOL)isSingleLineNavBar
{
    NSString *titleText = [self getNavTitle];
    
    return [NSString isNilOrEmpty:self.threadID]
    && self.shouldSetSubTitle == NO
    && ([titleText compareString:AXPLocalizedString(@"NewChtTitle")]
        || [titleText compareString:AXPLocalizedString(@"ExistingChatTitle")]
        || [titleText compareString:AXPLocalizedString(@"NewGrpChtTtl")]);
}

- (NSString *)getNavTitle
{
    if (self.isChatWithSelf)
    {
        TSUserInfo *user = [self userInfoForID:self.accountHandle.MRI];
        return user ? [NSString stringWithFormat:AXPLocalizedString(@"CwsTtl"), [user displayName]] : AXPLocalizedString(@"OnlyMe");
    }
    
    if ([self.recipientIDs count])
    {
        if ([self.threadID length])
        {
            TSConversation *conv = [AXPCtx conversationForID:self.threadID];
            NSString *convTopic = [conv customTopic];
            if (convTopic)
            {
                return convTopic;
            }
        }
        else if (self.topicName && self.topicName.length)
        {
            return self.topicName;
        }
        
        if (self.recipientIDs.count == 1)
        {
            TSUserInfo *user = [self userInfoForID:self.recipientIDs.firstObject];
            if (user && user.isGuestUser)
            {
                return [user displayNameWithGuestInfo];
            }
        }
        
        NSString *resolvedTitle = [TSNameUtils getAggregatedNamesForUserIDs:self.recipientIDs
                                                               withFullName:YES
                                                              withFirstName:YES
                                                              withUserInfos:self.recipientsUserInfo
                                                              accountHandle:self.accountHandle];
        if ([resolvedTitle isEqualToString:AXPLocalizedString(@"UnknownUser")])
        {
            // When creating a 1-1 SMS chat, the UI is shown before the display name is updated in roster.
            // To avoid briefly showing the Chat placeholder, we show the display name that we've sent to the server.
            if ([self.fallbackDisplayName isNotNilOrEmpty])
            {
                return self.fallbackDisplayName;
            }
            // getAggregatedNamesForUserIDs falls back to use "Unknown User" if no users can be resolved locally
            // Since it is used in other scenarios, we only change the behavior here to fall back to "Chat"
            return AXPLocalizedString(@"ExistingChatTitle");
        }
        
        return resolvedTitle;
    }
    
    if (self.isNewFederatedUser && [self.federatedUserDisplayName isNotNilOrEmpty])
    {
        return self.federatedUserDisplayName;
    }
    
    if ([self isGroupTemplateChat])
    {
        TemplatesDataSourceType selectedTemplateType = self.groupTemplateCoordinator.selectedTemplateType;

        NSString *navbarTitle = [TemplatesDataSourceTypeBridge navBarFor:selectedTemplateType];
        if ([navbarTitle isNotNilOrEmpty] && self.groupChatCreationState == TSGroupChatCreationStateStart)
        {
            return navbarTitle;
        }
        
        if ([self.topicName isNotNilOrEmpty])
        {
            return self.topicName;
        }
    }

    // If we are creating a new chat then we opt for one of the titles below
    if (![self.threadID length])
    {
        if (self.isGuardiansChat && ![NSString isNilOrEmpty:self.topicName])
        {
            return self.topicName;
        }
        
        if (self.shouldConfigureForMeetings)
        {
            return self.navigationItem.title;
        }
        
        if (self.shouldUseFlowV2)
        {
            return AXPLocalizedString(@"NewChtTitle");
        }
        
        switch (self.groupChatCreationState)
        {
            case TSGroupChatCreationStateStart:
                return AXPLocalizedString(@"NewGrpChtTtl");
            case TSGroupChatCreationStateAddingParticipants:
                return [self.topicName isNotNilOrEmpty] ? self.topicName : AXPLocalizedString(@"NewGrpChtTtl");
            default:
                break;
        }

        return AXPLocalizedString(@"NewChtTitle");
    }
    
    if (![NSString isNilOrWhitespace:self.topicName])
    {
        return self.topicName;
    }
    
    // We are querying topic explicitly if empty group creation is enabled,
    // since in empty group creation UI flow on initial navigation to group
    // just created "if ([self.recipientIDs count])" at the top of this method
    // denies querying topic there since count is zero and control flow comes
    // here to return "existing chat title" constant.
    //
    // Note that after initial navigation to newly created group in all other
    // use cases self.recipeitnIDs is not empty, so the topci query at the top
    // of this method is used.
    //
    // Please also note that we do not modify the "if" at the top of this method
    // in order to preserve existing behavior as much as possible since:
    //   1. The empty group creation is a growth hack at the moment and it is not
    //      decided if it will remain in code long term.
    //   2. It's not clear why querying for custom topic depends on number of
    //      recipients. And I (yuzholob) was not able to find documentation or
    //      people who would confirm if it's a bug or a feature.
    if (self.accountHandle.policyManager.isEmptyGroupCreationEnabled)
    {
        if ([self.threadID length])
        {
            TSConversation *conv = [AXPCtx conversationForID:self.threadID];
            NSString *convTopic = [conv customTopic];
            if (convTopic)
            {
                return convTopic;
            }
        }
    }
    
    // Handle if thread was created but no recipients have accepted invites yet
    if ([self.threadID isNotNilOrEmpty])
    {
        TSConversation *conv = [AXPCtx conversationForID:self.threadID];
        NSString *convTopic = [conv customTopic];
        if (convTopic)
        {
            return convTopic;
        }
    }

    return AXPLocalizedString(@"ExistingChatTitle");
}

- (void)autoNameOffNetworkChat:(NSString * __nullable)edContactName
             deviceContactName:(NSString * __nullable)deviceContactName
            defaultDisplayName:(NSString * __nullable)displayName
{
    if ([edContactName isNotNilOrEmpty])
    {
        self.topicName = [NSString stringWithFormat:AXPLocalizedString(@"AutoNameCht"),
                          [self.accountHandle account].userDisplayName, edContactName];
    }
    else if ([deviceContactName isNotNilOrEmpty])
    {
        self.topicName = [NSString stringWithFormat:AXPLocalizedString(@"AutoNameCht"),
                          [self.accountHandle account].userDisplayName, deviceContactName];
    }
    else if ([displayName isNotNilOrEmpty])
    {
        self.topicName = [NSString stringWithFormat:AXPLocalizedString(@"AutoNameCht"), [self.accountHandle account].userDisplayName, displayName];
    }
}

- (NSString *)getNavSubTitle
{
    if (self.isMuted)
    {
        return AXPLocalizedString(@"ChatMutedLabel");
    }
    
    if (self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants) {
        return @"";
    }
    
    if ([self isGroupTemplateChat])
    {
        return @"";
    }
    
    if (self.threadID.length || self.recipientIDs.count)
    {
        BOOL upsEnabled = [TSUtilities upsEnabled];
        NSString *recipientId = [self.recipientIDs firstObject];
        NSString *presenceString = [TSUtilities presenceStatusStringForUser:recipientId];
        if ([self isSMSChat])
        {
            if ([self shouldInitiate2WaySMSChatWithRecipient:recipientId])
            {
                return AXPLocalizedString(@"SMSUserPS");
            }
            return AXPLocalizedString(@"ChatSubTitleSMS");
        }
        if (self.threadType == TSThreadTypeInteropChat && [TSUtilities isSfCInteropChatByThreadId:self.threadID])
        {
            if ([TSSFCInteropOrTFLChatBlockAcceptViewController isBlockedSfCInteropOrTFLChatForThread:self.threadID
                                                                                         recipientMri:self.recipientIDs.firstObject
                                                                                        accountHandle:self.accountHandle])
            {
                self.currentPresenceStatus = TSPresenceStatusBlocked;
                self.shouldShowPresenceOnTitle = YES;
                return AXPLocalizedString(@"MessageStateBlocked");
            }
            else
            {
                return AXPLocalizedString(@"FederatedLabel");
            }
        }
        if ([self isTfLInterOpOrOffNetworkFedChat] && [self isOneToOneChat])
        {
            if(!self.accountHandle.policyManager.isMarkingFederatedUserExternalEnabled)
            {
                if(self.accountHandle.policyManager.isTfwTflFedChatConsumptionPhase2OnTflEnabled && !self.isFedRosterCreatedOnTfL)
                {
                    NSString *label = [self.chatCreatorTenantName isNotNilOrEmpty] ? self.chatCreatorTenantName : AXPLocalizedString(@"OrgLbl");
                    return [NSString stringWithFormat:@"%@ (%@)", presenceString, label];
                }
                return presenceString;
            }
            NSString *externalString = AXPLocalizedString(@"FederatedLabel");
            return upsEnabled ? [NSString stringWithFormat:@"%@ (%@)", presenceString, externalString] : externalString;
        }
        else if(self.accountHandle.policyManager.isTfwTflFedChatConsumptionPhase2OnTflEnabled && !self.isFedRosterCreatedOnTfL && [self isOneToOneChat])
        {
            // Show Organisation subtitle, in 1:1 chats for TfW created chats on TfL
            NSString *label = [self.chatCreatorTenantName isNotNilOrEmpty] ? self.chatCreatorTenantName : AXPLocalizedString(@"OrgLbl");
            return [NSString stringWithFormat:@"%@ (%@)", presenceString, label];
        }
        else if ([self isSfBInteropChat])
        {
            if ([NSString isNilOrEmpty:self.threadID]
                && [self.recipientIDs count] == 1
                && [TSUtilities isSfCUserForUserID:self.recipientIDs.firstObject accountHandle:self.accountHandle])
            {
                // This is for creating new 1:1 SfC chat before the thread is created, so self.threadID is nil
                return AXPLocalizedString(@"FederatedLabel");
            }
            else
            {
                NSString *sfbString = AXPLocalizedString(@"ChatViewSfbInteropHeaderSubtitle");
                return upsEnabled ? [NSString stringWithFormat:@"%@ (%@)", presenceString, sfbString] : sfbString;
            }
        }
        else if (self.threadType == TSThreadTypeOneOnOneChat)
        {
            if ([TSUtilities isContactBlockingEnabled:self.accountHandle] &&
                [TSSFCInteropOrTFLChatBlockAcceptViewController isBlockedSfCInteropOrTFLChatForThread:self.threadID
                                                                                         recipientMri:self.recipientIDs.firstObject
                                                                                        accountHandle:self.accountHandle])
            {
                LogInfoAH(self.logger, @"Thread ID - %@ is in blocked state", self.threadID);
                self.currentPresenceStatus = TSPresenceStatusBlocked;
                self.shouldShowPresenceOnTitle = YES;
                return AXPLocalizedString(@"MessageStateBlocked");
            }
            return ([self.accountHandle.policyManager shouldShowPresenceUI] ||
                    (self.currentPresenceStatus == TSPresenceStatusBlocked)) ? presenceString : @""; // only show presence for 1:1 chat
        }
        else
        {
            NSArray *guestIDList = [TSSyncEngine.sharedInstance.userSyncManager filterGuestsFromUsers:self.recipientIDs
                                                                                              withMoc:self.accountHandle.mainMOC];

            //  we show the number of participants
            NSUInteger includingMySelf = self.recipientIDs.count + 1;
            
            if (self.accountHandle.policyManager.enableFederatedGroupChatConsumption && [self isTfLInterOpOrOffNetworkFedChat])
            {
                if(self.accountHandle.policyManager.isMarkingFederatedUserExternalEnabled)
                {
                    return [NSString stringWithFormat:AXPLocalizedString(@"ChatSubTitleWithExternalParticipants"), includingMySelf];
                }
                else
                {
                    
                    return [NSString stringWithFormat:AXPLocalizedString(@"DashboardPeopleTltN"), includingMySelf];
                }
            }
            else if (self.accountHandle.policyManager.isTfwTflFedChatConsumptionPhase2OnTflEnabled && !self.isFedRosterCreatedOnTfL)
            {
                // Show Organisation in subtitle on TfL for chats that have TFW creator
                if([self.chatCreatorTenantName isNotNilOrEmpty])
                {
                    return [NSString stringWithFormat:AXPLocalizedString(@"ChatSubtitleWithTenantName"),includingMySelf,self.chatCreatorTenantName];
                }
                else
                {
                    LogVerboseAH(self.logger, "Chat creator not synced for TFW created Fed chat on TfL for threadID: %@",self.threadID);
                    return [NSString stringWithFormat:AXPLocalizedString(@"ChatSubtileForOrgCht"), includingMySelf];
                }
            }
            else if (guestIDList.count)
            {
                if (guestIDList.count == 1)
                {
                    return [NSString stringWithFormat:AXPLocalizedString(@"ChtSbttl1Gst"), @(includingMySelf)];
                }
                else
                {
                    return [NSString stringWithFormat:AXPLocalizedString(@"ChtSbttlNGsts"),
                            @(includingMySelf), @(guestIDList.count)];
                }
            }
            else if (self.accountHandle.policyManager.isNavigationBarStylingL2Enabled && self.recipientIDs.count > 1)
            {
                //For meeting chats, the recipientIDs count already includes myself, so we don't need to add an additional member
                NSUInteger totalCount = [self isMeeting] ? self.recipientIDs.count : includingMySelf;
                return [NSString stringWithFormat:AXPLocalizedString(@"DashboardPeopleTltN"), totalCount];
            }
        }
    }
    
    return @"";
}

- (void)disableChatAndUpdateComposeView:(BOOL)isDisableChat
{
    if (isDisableChat)
    {
        self.isChatDisable = YES;
        self.composeViewController.textBody.text = @"";
        [self configureDisabledStateView];
    }
    else
    {
        self.isChatDisable = NO;
        self.disabledStateView.hidden = YES;
    }
    [self.composeViewController updateComposeViewState];
}

- (NSString *) title
{
    return [self getNavTitle];
}

- (NSMutableArray*) supportedSyncStateNotifications
{
    NSMutableArray* states = [super supportedSyncStateNotifications];
    [states addObject:@(AXPSyncStateTypeChatSyncingStarted)];
    [states addObject:@(AXPSyncStateTypeChatSyncingEnded)];
    
    return states;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LogInfoAH(self.accountHandle.logger, @"viewDidLoad %@", self.threadID);
    
    [self updateBubbleColors];
    
    self.shouldUseFlowV2 = self.accountHandle.policyManager.isGroupCreationFlowV2Enabled;
    self.shouldMultiSelectParticipants = self.accountHandle.policyManager.isGroupCreationMultiSelectEnabled || self.shouldUseFlowV2;
    self.dynamicDecorationType = self.accountHandle.ecsManager.chatBubbleDecorationType;

    self.initialItemsHasBeenLoaded = NO;
    self.loadStartTime = [NSDate date];
    // default for non-iPad
    self.dlpViewModel = [TSDlpViewModel new];
    self.targetBottomConstraint = self.stackviewBottomToSafeArea;
    self.bottomConstant = 0;
    self.emptyStateView.newGroupWelcomeScreenType = self.accountHandle.ecsManager.newGroupWelcomeScreenType;
    self.emptyStateView.isGroupTemplatesEnabled = [self.accountHandle.policyManager isGroupCreationWithTemplatesEnabled];
    self.emptyStateView.isUntitledGroupAllowed = self.accountHandle.ecsManager.isUntitledNewGroupAllowed;
    // loading indicator flag
    self.isLoadingIndicatorInChatEnabled = [self.accountHandle.policyManager isLoadingIndicatorInChatEnabled];
    
    if (self.shouldShowEcryptionMessage) {
        self.heightEncryptionView.constant = TSkEncryptionViewMessageHeight;
        self.encryptionMessageView.showShowEncryptionMessageView = true;
        [self.encryptionMessageView setup];
        self.encryptionMessageView.encryptionMessageViewDelegate = self;
    } else {
        self.heightEncryptionView.constant = TSkTypingIndicatorViewMinimumHeight;
    }

    self.hasUnreadMessages = NO;

    if (self.accountHandle.policyManager.isLocationWithLiveSharingEnabled) {
        id<LocationDependencyRegistrarProtocol> locationDependencyRegistrar = ResolveProtocol(LocationDependencyRegistrarProtocol);
        self.locationBannerCoordinator = [[locationDependencyRegistrar userDependenciesWithAccountHandle:self.accountHandle]
                                          makeChatLocationBannerCoordinatorBridgeWithCurrentThreadId:self.threadID
                                          bannerDelegate:self
                                          fromViewController: self];
        [self.locationBannerCoordinator start];
    }
    
    self.longPressImpact = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    
    self.composeViewController = [[TSCompactComposeViewController alloc] initWithNibName:@"TSCompactComposeViewController" bundle:[NSBundle bundleForClass:[self class]]];
    
    if([self.composeViewController isKindOfClass:TSCompactComposeViewController.class] && self.accountHandle.policyManager.showDrawerAnimationForActivation)
    {
        [self.composeViewController willNavigateToView:@{ TSkActivationOrigin: self.activationOrigin ?: @"",
                                                          TSkActivationPillar: self.activationPillar ?: @"",
                                                          TSkLegacyAppearanceProxy: self.legacyAppearanceProxy
        }];
    }
    else
    {
        [self.composeViewController willNavigateToView:@{TSkLegacyAppearanceProxy: self.legacyAppearanceProxy}];
    }
    
    self.contextOptionsHandler = [[TSChatMessageContextOptionsHandler alloc] initWithAccountHandle:self.accountHandle
                                                                                  providerDelegate:self
                                                                         isAnonymouslyJoinedToCall:self.isAnonymouslyJoinedToCall
                                                                                didAnonJoinCallEnd:self.didAnonJoinCallEnd];
    
    self.longPressHandler = [[TSChatMessageLongPressHandler alloc] initWithAccountHandle:self.accountHandle
                                                                            msgVCUtility:self.msgVCUtility
                                                                        providerDelegate:self];
    
    // ensures that iPhone X bottom indicator for accessing home screen is colored correctly
    self.view.backgroundColor = self.legacyAppearanceProxy.primarySurfaceColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.composeView.backgroundColor = self.view.backgroundColor;
    self.composeView.layer.zPosition = CGFLOAT_MAX;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    if ([self shouldShowMeetingChatMuteStateBanner])
    {
        [self constructAndShowChatMuteStatusBannerView:NO];
    }
    else if([self shouldShowFedUserMsgRelatedPolicyBanner] && [TSSFCInteropOrTFLChatBlockAcceptViewController isAcceptedSfCInteropOrTFLChatForThread:self.threadID accountHandle:self.accountHandle])
    {
        // do not construct policy banner for quarantine chats since
        // Accept/Block banner will be on top of this banner.
        [self contructFedUserMsgRelatedPolicyBanner];
    }
    else if ((self.accountHandle.policyManager.enableFederatedGroupChatConsumption || self.accountHandle.policyManager.isTfwTflFedChatConsumptionOnTflEnabled)
             && [self shouldShowFederatedThreadWithBlockedUserBanner])
    {
        if (self.accountHandle.policyManager.enableFederatedGroupChatConsumption)
        {
            [self constructFederatedBanner:AXPLocalizedString(@"ChatHasBlockedUsersLabel")
                         enableCancelImage:YES
                         enableLeaveButton:YES
                            chatBannerType:TSkFederatedChatWithBlockedUsers];
        }
        else
        {
            [self constructFederatedBanner:AXPLocalizedString(@"ChatHasBlockedTfwUsersOnTflLabel")
                         enableCancelImage:YES
                         enableLeaveButton:YES
                            chatBannerType:TSkFederatedChatWithBlockedUsers];
        }
    }
    else if (self.accountHandle.policyManager.enableFederatedGroupChatConsumption && [self isFederatedThreadWithDowngradedUser])
    {
        [self constructFederatedBanner:[self getSfBDowngradeBannerLabelToDisplay]
                     enableCancelImage:YES
                     enableLeaveButton:NO
                        chatBannerType:TSkFederatedChatWithSfBUsers];
    }
    else if ([self shouldShowMeetingOrGroupCallJoinBannerView])
    {
        [self constructAndShowMeetingJoinBannerView];
    }
    else if ([self isFederatedThread])
    {
        [self constructFederatedBanner:AXPLocalizedString(@"FederatedConversationStartLabel")
                     enableCancelImage:NO
                     enableLeaveButton:NO
                        chatBannerType:TSkNewFederatedChat];
    }
    else if (self.isConsultTransferConversation)
    {
        if ([TSCallManager.sharedInstance isMultiCall:NO])
        {
            self.multiCallBannerViewManager = [[TSMultiCallSwitchBannerViewManager alloc] initWithCall:self.call hostViewController:self];
            [self.multiCallBannerViewManager instantiateCallElementView];
            [self.multiCallBannerViewManager loadWithContainerView:self.customBannerViewContainer];
        }
        else
        {
            self.customBannerViewHeightConstraint.constant = TSkCallBannerViewHeight;
        }
        
        self.transferBannerViewManager = [[TSCallTransferBannerViewManager alloc] initWithCall:self.call hostViewController:self];
        [self.transferBannerViewManager instantiateCallElementView];
        [self.transferBannerViewManager loadWithContainerView:self.customBannerViewContainer];
    }
    else
    {
        self.customBannerViewHeightConstraint.constant = 0.0f;
    }
    
    self.statusMessageBannerView.legacyAppearanceProxy = self.legacyAppearanceProxy;
    
    if ([self shouldShowStatusMessageBannerView])
    {
        [self constructAndShowStatusMessageBannerView:YES];
    }
    else
    {
        [self removeStatusMessageBannerView];
    }
    [self updateInactiveGuardiansBanner];
    
    self.messagesView = self.view;
    self.entitySearch = [TSEntitySearch searchWithAccountHandle:self.accountHandle];
    self.peoplePickerSearchProvider = [[TSPeoplePickerSearchProvider alloc] initWithAccountHandle:self.accountHandle];
    
    if ([self.accountHandle.tagManager isTargetedChatsEnabled] && [NSString isNilOrEmpty:self.threadID])
    {
        [TSDispatchUtilities dispatchOnBackgroundThread:^
         {
            // Fetch Tags from network for New Chat Search Scenario only if cache has expired
            [self.accountHandle.tagManager fetchTagsForAllTeamsIfRequired:TSkInvokedFromNewChat];
        }];
    }
    
    if (self.accountHandle.ecsManager.isDragAndDropEnabled && IS_IPAD()) {
        self.view.userInteractionEnabled = YES;
        [self.view addInteraction: [[UIDropInteraction alloc] initWithDelegate: self]];
    }
    self.composeViewController.delegate = self;
    self.composeViewController.sendMessageLatencyDelegate = self;
    [self addChildViewController:(UIViewController *)self.composeViewController];
    self.composeViewController.view.frame = CGRectMake(0, 0, self.composeView.frame.size.width, self.composeView.frame.size.height);
    [self.composeView addSubview:self.composeViewController.view];
    
    if ([self.recipientIDs count] == 1)
    {
        [TSPresenceService.defaultService getPresenceOfUsers:@[self.recipientIDs.firstObject] withAccountHandle:self.accountHandle andCompletion:nil];
    }
    
    [self nativeFederationChatPreFetch];
    
    [self showJoinBannerIfRequired];
    
    if ([self.threadID length])
    {
        TSThread *thread = [AXPCtx threadForID:self.threadID];
        TSThreadProperty *awarenessProperty = nil;
        if (self.threadType == TSThreadTypePrivateMeeting)
        {
            awarenessProperty = [AXPCtx threadPropertyForThreadID:self.threadID
                                                  andPropertyName:TSkThreadPropertyPrivateMeetingAwareness
                                                            inMoc:self.accountHandle.mainMOC];
        }
        if(thread && [thread isDisabledChatWithInProgressMeetingOption:YES meetingInProgress:awarenessProperty ? awarenessProperty.propertyValue : NO] && !self.forceEnableChat)
        {
            [self disableChatAndUpdateComposeView:YES];
        }
    }
    else if ([self.recipientIDs count])
    {
        if((!self.actionContext.userPrivateChatEnabledOnTenant && !self.isMeeting) ||
           [TSUser hasAnyUserDisabledChat:self.recipientIDs inMoc:self.accountHandle.mainMOC])
        {
            [self disableChatAndUpdateComposeView:YES];
        }
    }
    else
    {
        self.composeView.hidden = YES;
        if (self.shouldConfigureForMeetings)
        {
            [self showEmptyStateView:YES];
        }
    }
    
    [self.composeView setNeedsDisplay];
    [self.composeView setNeedsLayout];
    
    [self configureDisabledStateView];
    
    [self.composeViewController didMoveToParentViewController:self];
    
    self.hasPromptedUserLessThanLimit = [TSQuickReactPromptManager.sharedInstance hasPromptedUserLessThanLimit];
    
    BOOL isNewGuardiansChat = self.isGuardiansChat && self.threadID == nil;
    
    if ([self isGroupTemplateChat] && !self.accountHandle.policyManager.isGroupTemplatesWithPeoplePickerEnabled)
    {
        [self showWaitForGroupTemplateCreation];
        [self.toView setHidden:YES];
        self.toContainerViewHeight.constant = 0;
        [self startActivityIndicator];
    }
    else if (isNewGuardiansChat || [self shouldAddToViewControllerAsChild])
    {
        self.toViewController.toControlDelegate = self;
        self.toViewController.hidesBottomBarWhenPushed = self.hidesBottomBarWhenPushed;
        self.toViewController.isAddingAnonymousUsersAllowed = [self.accountHandle.actionContext isInviteAnonymousUserByEmailOrPhoneEnabled] || self.isGuardiansChat;
        [self addChildViewController:self.toViewController];
        self.toViewController.view.frame = CGRectMake(0, 0, self.toView.frame.size.width, self.toView.frame.size.height);
        [self.toView addSubview:self.toViewController.view];
        [self.toViewController didMoveToParentViewController:self];
        self.toViewController.delegate = self;
        // While creating a new chat or a group chat with a particular user included, Opt-out of activity indicator provided by base class
        self.isActivityIndicatorSupported = NO;

        if ([self.accountHandle.policyManager shouldUseIconInEntitySearch])
        {
            [self.toViewController.entitySearchBarViewController setIconImageViewVisible:YES];
            [self.toViewController.entitySearchBarViewController setToLabelVisible:NO];
            [self.toViewController.entitySearchBarViewController setDefaultPlaceholder:AXPLocalizedString(@"TitleSearch")];
        }
        self.toViewController.shouldFetchTflInterOpUser = self.accountHandle.policyManager.isTfwTflFedChatCreationOnTfwEnabled;
        self.toViewController.shouldFetchExtendedDirectoryUser = self.accountHandle.policyManager.isTfwEdChatCreationOnTfwEnabled;
        
        if (isNewGuardiansChat)
        {
            [self addGuardianRecipients];
        }
    }
    else
    {
        [self.toView setHidden:YES];
        self.toContainerViewHeight.constant = 0;
        
        // increase the chatCount for each person in the chat
        [TSUtilities increaseChatCountForUsers:self.recipientIDs accountHandle:self.accountHandle];
    }
    
    if (!isTeamsSDK() && self.accountHandle.policyManager.isLocationWithLiveSharingEnabled && [self.initialLocationSharingAction isNotNilOrEmpty])
    {
        if ([self.initialLocationSharingAction isEqualToString:TSkLocationSharingInitialActionStartSharing])
        {
            id<LocationDependencyRegistrarProtocol> locationDependencyRegistrar = ResolveProtocol(LocationDependencyRegistrarProtocol);
            self.groupLocationsCoordinator = [[locationDependencyRegistrar userDependenciesWithAccountHandle:self.accountHandle]
                                              makeGroupLocationsLiveCoordinatorBridgeWithManageViewController:self
                                              currentThreadId:self.threadID
                                              initialUserMapIdentifier:nil
                                              source:LocationTelemetrySourceActivityFeed];
            [self.groupLocationsCoordinator setInitialActionOnPresentable:GroupLocationsInitialActionStartSharing source:LocationTelemetrySourceActivityResumed];
            [self.groupLocationsCoordinator start];
        }
        else if ([self.initialLocationSharingAction isEqualToString:TSkLocationSharingInitialActionOpenGroupMap])
        {
            id<LocationDependencyRegistrarProtocol> locationDependencyRegistrar = ResolveProtocol(LocationDependencyRegistrarProtocol);
            if (![NSString isNilOrEmpty:self.initialLocationSharingActionPlaceIdentifier])
            {
                self.groupLocationsCoordinator = [[locationDependencyRegistrar userDependenciesWithAccountHandle:self.accountHandle]
                                                  makeGroupLocationsLiveCoordinatorBridgeWithManageViewController:self
                                                  currentThreadId:self.threadID
                                                  initialPlaceIdentifier:self.initialLocationSharingActionPlaceIdentifier
                                                  source:LocationTelemetrySourceActivityFeed];
            }
            else
            {
                // initialUserMapIdentifier is optional so we're not necessarily centering on a user
                self.groupLocationsCoordinator = [[locationDependencyRegistrar userDependenciesWithAccountHandle:self.accountHandle]
                                                  makeGroupLocationsLiveCoordinatorBridgeWithManageViewController:self
                                                  currentThreadId:self.threadID
                                                  initialUserMapIdentifier:self.initialLocationSharingActionUserIdentifier
                                                  source:LocationTelemetrySourceActivityFeed];
            }
            [self.groupLocationsCoordinator start];
        }
    }
    
    self.tableView.transform = CGAffineTransformMakeScale(1, -1);
    
    self.tableView.sectionHeaderHeight = CGFLOAT_MIN;
    
    self.tableView.estimatedRowHeight = TSkChatViewControllerEstimatedRowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.accountHandle.ecsManager.isDragAndDropEnabled && IS_IPAD()) {
        self.tableView.dragInteractionEnabled = YES;
        self.tableView.dragDelegate = self;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:TSkNibNameChatMessageCellLeft bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:TSkNibNameChatMessageCellLeft];
    [self.tableView registerNib:[UINib nibWithNibName:TSkNibNameChatMessageCellRight bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:TSkNibNameChatMessageCellRight];
    [self.tableView registerNib:[UINib nibWithNibName:TSkConnectorCellViewCell bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:TSkConnectorCellViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:TSkNibNameChatCallingMessageViewCell bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:TSkNibNameChatCallingMessageViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:TSkNibNameChatMeetingCardViewCell bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:TSkNibNameChatMeetingCardViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:TSkNibNameRevealableLabel bundle:[NSBundle bundleForClass:[self class]]] forRevealableReuseIdentifier:TSkNibNameRevealableLabel];
    [self.tableView registerNib:[UINib nibWithNibName:kNibNameLastReadWatermarkCellChat bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:kNibNameLastReadWatermarkCellChat];
    [self.tableView registerNib:[UINib nibWithNibName:kNibNameNativeFederationChatCell bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:kNibNameNativeFederationChatCell];
    [self.tableView registerNib:[UINib nibWithNibName:TSkNibNameChatRecordingCardViewCell bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:TSkNibNameChatRecordingCardViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:TSkNibNameChatGroupTimestampCell bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:TSkNibNameChatGroupTimestampCell];
    [self.tableView registerNib:[UINib nibWithNibName:TSkNibNameSmartReplyCell bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:TSkNibNameSmartReplyCell];
//    [self.tableView registerNib:[UINib nibWithNibName:TSFluidTablePreviewCell.reuseIdentifier bundle:[NSBundle bundleForClass:[self class]]] forCellReuseIdentifier:TSFluidTablePreviewCell.reuseIdentifier];//11235813
    [self.tableView registerClass:TSRetentionPolicyMessageViewCell.class forCellReuseIdentifier:TSRetentionPolicyMessageViewCell.reuseIdentifier];
    [self.tableView registerClass:TSChatConsumptionHorizonUsersCell.class forCellReuseIdentifier:TSkNibNameConsumptionHorizonCell];
    
    self.tableView.isAccessibilityElement = NO;
    ((TSCustomUITableView *)self.tableView).parentViewController = self;
    
    self.latestMessageArrivalTime = [NSDate distantPast];
    [self initNavigationItem];
    self.userIdDict = [NSMutableDictionary new];
    self.typingIndicatorViewHeight.constant = 0.0f;
    self.semanticObjectListModels = [NSMutableDictionary new];
    
#pragma mark - ECS check for Fluid object feature
    if (self.isFluidObjectEnabled)
    {
        self.fluidService = [[TSFluidComponentService alloc] initWithThreadId:self.threadID accountHandle:self.accountHandle experimentationService:self.experimentationService];
    }
#pragma mark -
    
    self.needToRegisterForNotifications = YES;
    
    self.tappedOnCellGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnChat:)];
    self.tappedOnCellGesture.numberOfTapsRequired = 1;
    self.tappedOnCellGesture.cancelsTouchesInView = NO;
    self.tappedOnCellGesture.delegate = self;
    [self.tableView addGestureRecognizer:self.tappedOnCellGesture];
    
    self.longPressedOnCellGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedOnChat:)];
    self.longPressedOnCellGesture.minimumPressDuration = TSkMinimumLongPressDuration;
    self.longPressedOnCellGesture.numberOfTouchesRequired = TSkNumberOfTouchesRequired;
    self.longPressedOnCellGesture.cancelsTouchesInView = NO;
    self.longPressedOnCellGesture.delegate = self;
    [self.tappedOnCellGesture requireGestureRecognizerToFail:self.longPressedOnCellGesture];
    [self.tableView addGestureRecognizer:self.longPressedOnCellGesture];
    
    if ([self.accountHandle.ecsManager doubleTapToLikeEnabled])
    {
        self.doubleTappedOnCellGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(multipleTapOnChat:)];
        self.doubleTappedOnCellGesture.numberOfTapsRequired = 2;
        self.doubleTappedOnCellGesture.cancelsTouchesInView = NO;
        self.doubleTappedOnCellGesture.delegate = self;
        [self.tableView addGestureRecognizer:self.doubleTappedOnCellGesture];
        [self.tappedOnCellGesture requireGestureRecognizerToFail:self.doubleTappedOnCellGesture];
        [self.doubleTappedOnCellGesture requireGestureRecognizerToFail:self.longPressedOnCellGesture];
    }
    
    if ([self.accountHandle.ecsManager tripleTapToReactEnabled])
    {
        self.tripleTappedOnCellGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(multipleTapOnChat:)];
        self.tripleTappedOnCellGesture.numberOfTapsRequired = 3;
        self.tripleTappedOnCellGesture.cancelsTouchesInView = NO;
        self.tripleTappedOnCellGesture.delegate = self;
        [self.tableView addGestureRecognizer:self.tripleTappedOnCellGesture];
        [self.tappedOnCellGesture requireGestureRecognizerToFail:self.tripleTappedOnCellGesture];
        [self.tripleTappedOnCellGesture requireGestureRecognizerToFail:self.longPressedOnCellGesture];
        [self.doubleTappedOnCellGesture requireGestureRecognizerToFail:self.tripleTappedOnCellGesture];
    }
    
    if ([TSkSeguePushChatWithParticipants isEqualToString:self.sourceSegueId] && [self.chatWithMeetingParticipantsScenarioID isNotNilOrEmpty])
    {
        [self.accountHandle.logger logScenarioStopEvent:self.chatWithMeetingParticipantsScenarioID status:ScenarioStatusOK];
    }
    
    [self addObserverToNotificationCenterForNotificationName:TSkUserPresenceSynced selector:@selector(userPresenceSynced:)];
    [self addObserverToNotificationCenterForNotificationName:TSkExtensionCreatedMessage selector:@selector(extensionCreatedMessage:)];
    [self addObserverToNotificationCenterForNotificationName:TSkImageDownloadCompleteNotification selector:@selector(imageLoaded:)];
    [self addObserverToNotificationCenterForNotificationName:UIContentSizeCategoryDidChangeNotification selector:@selector(sizeCategoryDidChange:)];
    if (self.accountHandle.policyManager.isInviteFreeEnabled || [TSUtilities isContactBlockingEnabled:self.accountHandle])
    {
        [self addObserverToNotificationCenterForNotificationName:TSkUserBlockedNavigationNotification selector:@selector(reloadForUserBlockStatusChange:)];
    }
    
    if (IS_IPAD())
    {
        [self addObserverToNotificationCenterForNotificationName:UIKeyboardWillChangeFrameNotification selector:@selector(keyboardChanged:)];
        [self addObserverToNotificationCenterForNotificationName:UIKeyboardWillHideNotification selector:@selector(keyboardChanged:)];
    }
    
    [self.customBannerViewContainer addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self updateUnreadIndicatorConstraintsPinnedToBottomView:self.composeView];
    
    [self checkLogTelemetryForBotChatLoad];

    // Install custom accessibiity rotor to allow swipe up/down navigation between group timestamp cells
    __weak typeof(self) weakSelf = self;
    UIAccessibilityCustomRotor *rotor = [[UIAccessibilityCustomRotor alloc]
                                         initWithName:AXPLocalizedString(@"DatesHeading")
                                         itemSearchBlock:^UIAccessibilityCustomRotorItemResult * _Nullable(UIAccessibilityCustomRotorSearchPredicate * _Nonnull predicate) {
        __strong typeof(self) strongSelf = weakSelf;
        return [strongSelf searchRotorItemWithPredicate:predicate];
    }];
    
    self.tableView.accessibilityCustomRotors = @[rotor];
    [self relayoutStackView];
    if ([self isAnyWelcomeCardFeatureEnabled])
    {
        [self.emptyStateView setWelcomeCardViewDelegate:self];
        
        // Empty stateview needs to be behind ToView
        [self.emptyStateView removeFromSuperview];
        [self.stackView insertSubview:self.emptyStateView atIndex:0];
        [self.stackView sendSubviewToBack:self.tableView];
        
        // Welcome card view should be between toView and composeView.
        NSLayoutConstraint *topConstraint = [self.emptyStateView.mainLayoutGuide.topAnchor constraintEqualToAnchor:self.tableView.topAnchor];
        topConstraint.priority = UILayoutPriorityDefaultLow + 10;
        topConstraint.active = YES;
        [self.emptyStateView.mainLayoutGuide.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [self.emptyStateView.mainLayoutGuide.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        NSLayoutConstraint *bottomConstraint = [self.emptyStateView.mainLayoutGuide.bottomAnchor constraintEqualToAnchor:self.tableView.bottomAnchor];
        bottomConstraint.priority = UILayoutPriorityDefaultLow + 10;
        bottomConstraint.active = YES;
        
        // Don't hide or show the EmptyState View here unless needed
        if (self.shouldConfigureForMeetings)
        {
            // For meetings, the empty state view is set above.
        }
        else if (self.groupChatCreationState == TSGroupChatCreationStateNoOp)
        {
            [self showEmptyStateView:NO];
        }
        else if (self.groupChatCreationState == TSGroupChatCreationStateStart)
        {
            [self showEmptyStateView:YES];
        }
    }
    
    if ([self.accountHandle.policyManager isGroupCreationWithTemplatesEnabled])
    {
        [self.emptyStateView setGroupTemplateCoordinatorProvider:self];
    }
    
    if (self.accountHandle.policyManager.shouldAddContactOnMessageSent)
    {
        self.shouldSendAddContactRequest = [self checkShouldSendAddContactRequest];
    }
    
    if (self.onEntryAction && [self.onEntryAction isEqualToString:TSkNewChatTapVoiceButtonAction])
    {
        [self voiceCallButtonTapped:self.voiceCallButton];
        self.onEntryAction = nil;
    }
    
    if (self.accountHandle.policyManager.shouldShowContactSyncEmptyState || self.accountHandle.policyManager.shouldShowInviteFriendsEmptyState)
    {
        self.tappedOnEmptyStateGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView:)];
        self.tappedOnEmptyStateGesture.delegate = self;
        self.tappedOnEmptyStateGesture.cancelsTouchesInView = NO;
        [self.emptyStateView addGestureRecognizer:self.tappedOnEmptyStateGesture];
    }
    
    if ([self isPrivateChatWithBot] || self.recipientIDs.count > 1)
    {
        [self configureBotMenuView];
    }

    [self showTaggingByShiftsTooltipIfRequired];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBotmenuAccessibilityContainer)
                                                 name:UIAccessibilityVoiceOverStatusDidChangeNotification object:nil];
    
    [self showBannerAboutOffNetworkOrFedMsgPolicyIfNeeded];
    [self shiftChatWindowIfNeeded];
    
    if ([TSTranslationManager isAutomaticChatTranslationSuggestionEnabled:self.accountHandle])
    {
        self.translationMode = [TSTranslationManager getTranslationModeSetting:self.accountHandle];
        self.isTranslationInProgress = NO;
        self.isAutomaticTranslationButtonTapped = NO;
    }
    self.isSMBPrivacyAlertShown = [self getSMBPrivacyAlertShownFlag];
    
    [self configureCustomInputContainer];
    
    self.typingIndicatorView.legacyAppearanceProxy = self.legacyAppearanceProxy;
}

- (void) configureCustomInputContainer
{
    UIView *container = self.composeViewController.customInputContainer;
    [self.view addSubview:container];
    [[container.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[container.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[container.topAnchor constraintEqualToAnchor:self.composeView.bottomAnchor] setActive:YES];
}

- (void)configureBotMenuView
{
    TBMBotInvocationConversationType invocationType = TBMBotInvocationConversationTypePersonal;
    NSString *botID = nil;
    if ([self isPrivateChatWithBot])
    {
        botID = self.recipientIDs[0];
    }
    else if (self.recipientIDs.count > 1)
    {
        invocationType = TBMBotInvocationConversationTypeGroup;
    }
    
    self.botMenuProvider = [[TSBotmenuProvider alloc] initWithController:self
                                                           accountHandle:self.accountHandle
                                                       composeController:self.composeViewController
                                                                   scope:invocationType
                                                              anchorView:self.composeView
                                                                threadId:self.threadID
                                            providesAccessibilityHandler:YES
                                                                   botID:botID];
    if ([self isPrivateChatWithBot])
    {
        [self.stackView setCustomSpacing:[self.botMenuProvider initialMenuHeight] afterView:self.typingIndicatorView];
        [self updateBotmenuAccessibilityContainer];
        // User has no message in the thread. Show expanded menu
        // https://domoreexp.visualstudio.com/MSTeams/_workitems/edit/1638606
        if ([[self.thread messagesByMe] count] == 0)
        {
            [self.botMenuProvider.botMenuClientRequestHandler createUpdateMenuStateExpandedRequest];
        } else {
            [self.botMenuProvider.botMenuClientRequestHandler createUpdateMenuStateRetractedRequest];
        }
    }
}

- (NSDictionary *)botTelemetryDataBag
{
    NSString *userID = self.recipientIDs.count == 1 ? self.recipientIDs[0] : nil;
    TSPTelemetryConstructBridge *telemetryConstruct = [[TSPTelemetryConstructBridge alloc] initWithBotId:userID name:@""];
    TSPlatformTelemetryInputData *inputParams = [[[[[[[[TSPTelemetryInputDataBuilder alloc]
                                                        initWithAccountHandle:self.accountHandle
                                                        moc:self.accountHandle.mainMOC]
                                                        withThreadId:self.threadID]
                                                        withAppId:userID]
                                                        withBotId:userID]
                                                        withAppScenarioCapability:TSPTelemetryScenarioCapabilityBot]
                                                        withTelemetryConstructBridge:telemetryConstruct]
                                                        build];
    NSDictionary *dataBag = nil;
    if (inputParams)
    {
        dataBag = [[[TSPTelemetryData alloc] initWithInputData:inputParams] toDictionary];
    }
    return dataBag;
}

- (void) adjustEmptyStateView:(BOOL)isChatEmptyState
{
    if (self.emptyStateTopYoffset == 0.0 && isChatEmptyState)
    {
        self.emptyStateTopYoffset = TSkToAndNewGroupChatContainerHeight;
    }
    self.emptyStateViewTopConstraint.constant = isChatEmptyState ? self.emptyStateTopYoffset : 0.0f;
    [self.emptyStateView updateConstraints];
}

- (BOOL) showSeparator
{
    return NO;
}

- (BOOL) prefersNavigationBarHairlineHidden
{
    if ([self shouldShowNavigationBarHairlineWhenDashboardHeaderEntryPointIsEnabled])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL) shouldShowNavigationBarHairlineWhenDashboardHeaderEntryPointIsEnabled
{
    return self.accountHandle.policyManager.isChatDashboardHeaderEntryPointEnabled && ![self isMeeting];
}

- (void) initNavigationItem
{
    if (!self.didAnonJoinCallEnd)
    {
        TSDropdownWithPresenceTitleView *titleView = self.titleView;
        titleView.parentViewController = self.outerViewController ?: self;
        titleView.userMri = [self.recipientIDs firstObject];
        [titleView setDropdownDirection:TSDropdownWithPresenceTitleViewDirectionRight];
        
        if (!self.isConsultTransferConversation)
        {
            titleView.action = @selector(customTitleButtonTapped:);
        }
    }
    
    // TODO:(tubhatia) check if we need to add badge on back button for anonymous join cases
    [self createBadgedBackButtonIfNeeded];
    [self createBrandingImageIfNeeded];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.customBannerViewContainer && [keyPath isEqualToString:@"hidden"])
    {
        [self updateLocationBannerVisibility];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void) createBadgedBackButtonIfNeeded
{
    UIViewController *viewController = self.outerViewController ?: self;
    
    if (self.splitViewController && !self.splitViewController.isCollapsed)
    {
        // non-collapsed split views should not show badged back button
        viewController.navigationItem.leftBarButtonItem = nil;
        return;
    }
    
    if ([self isMeeting] && [self.chatViewSource isEqualToString:@"calendarTab"])
    {
        // Should not show badge count, if meeting is opened from agenda view controller
        viewController.navigationItem.leftBarButtonItem = nil;
        return;
    }
    
    if (self.shouldHideBackBadgeCount) {
        viewController.navigationItem.leftBarButtonItem = nil;
        return;
    }
    
    if (self.call)
    {
        // In calling scenarios, back button will never return to chat list so do not show badge count. We don't
        // set left bar button item to nil here because right panel uses that to display its close button.
        return;
    }
    
    unsigned long long badgeCount = TSBadgeCountManager.sharedInstance.chatBadgeCount;
    
    if (self.accountHandle.policyManager.isNavigationBarStylingL2Enabled && self.shouldUseCenterAlignedTitle == NO)
    {
        NSArray *viewControllerArray = self.navigationController.viewControllers;
        // get index of the previous ViewContoller
        NSUInteger viewControllerIndex = [viewControllerArray indexOfObject:self.outerViewController ?: self];
        if (viewControllerIndex == NSNotFound)
        {
            return;
        }
        NSInteger previousViewControllerIndex = viewControllerIndex - 1;
        if (previousViewControllerIndex < 0)
        {
            return;
        }
        UIViewController *previousController = viewControllerArray[previousViewControllerIndex];
        if (badgeCount > 0)
        {
            NSString *badgeText = [NSString localizedStringWithFormat:@"%llu", badgeCount];
            BOOL isRightToLeft = [TSUtilities isRightToLeftLayout];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TSkChatBadgeBackButtonBarStylingL2Width, TSkChatBadgeBackButtonHeight)];
            [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            button.contentHorizontalAlignment = (isRightToLeft
                                                 ? UIControlContentHorizontalAlignmentRight
                                                 : UIControlContentHorizontalAlignmentLeft);
            
            UIImage *image = [UIImage imageWithCoreIcon:IconSymbolCoreIosArrow
                                                  color:self.legacyAppearanceProxy.navigationBarButtonDefaultColor
                                                  style:IconSymbolStyleFilled];
            // IconSymbolIosArrowRight is not available.  Flip the layout for the Left icon
            if (isRightToLeft)
            {
                image = [image imageFlippedForRightToLeftLayoutDirection];
            }
            
            [button setImage:image forState:UIControlStateNormal];
            
            button.accessibilityLabel = AXPLocalizedString(@"LabelBack");
            button.accessibilityHint = (badgeCount == 1
                                        ? AXPLocalizedString(@"UnreadOneChatAccessibilityFormat")
                                        : [NSString stringWithFormat:AXPLocalizedString(@"UnreadChatAccessibilityFormat"),
                                           badgeText]);

            UIEdgeInsets insets = TSEdgeInsetsMake(0, TSkChatBadgeBackButtonLeftInset, 0, 0);
            button.titleEdgeInsets = UIEdgeInsetsZero;
            button.imageEdgeInsets = insets;
            
            // For Layout with new headers:
            // Use a fixed button size with image, adding a separate UILabel instead of using the button's titleLabel
            CGFloat xOffset = isRightToLeft ? -TSkChatBadgeBackButtonLeftInset : TSkChatBadgeBackButtonLeftInset;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectOffset(button.frame, xOffset, 0)];
            label.text = badgeCount > 99 ? @"" : badgeText;
            label.textColor = self.legacyAppearanceProxy.navigationBarButtonDefaultColor;
            label.textAlignment = isRightToLeft ? NSTextAlignmentLeft : NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:13.0f]; // explicitly 13.0f since nav bar fonts do not scale with user preference
            label.isAccessibilityElement = NO;
            [button addSubview:label];

            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            viewController.navigationItem.hidesBackButton = YES;
            viewController.navigationItem.leftBarButtonItem = barButtonItem;
        }
        else
        {
            [previousController clearBackButtonTitle];
            viewController.navigationItem.hidesBackButton = NO;
            viewController.navigationItem.leftBarButtonItem = nil;
        }
    }
    else
    {
        if ((badgeCount > 0 || self.forceShowBackButton) && !self.isInCallRightPanel)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TSkChatBadgeBackButtonWidth, TSkChatBadgeBackButtonHeight)];
            [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            button.contentHorizontalAlignment = [TSUtilities isRightToLeftLayout] ? UIControlContentHorizontalAlignmentRight : UIControlContentHorizontalAlignmentLeft;
            [button setImage:[UIImage imageWithCoreIcon:IconSymbolCoreIosArrow color:self.legacyAppearanceProxy.navigationBarButtonDefaultColor style:IconSymbolStyleFilled]
                    forState:UIControlStateNormal];
            if (badgeCount > 0) {
                [button setTitle:[NSString localizedStringWithFormat:@"%llu", badgeCount]
                        forState:UIControlStateNormal];
            }
            [button setTitleColor:self.legacyAppearanceProxy.navigationBarButtonDefaultColor forState:UIControlStateNormal];
            button.accessibilityLabel = AXPLocalizedString(@"LabelBack");
            NSString *unreadChatAccessibilityFormat = AXPLocalizedString(@"UnreadChatAccessibilityFormat");
            button.accessibilityHint = badgeCount == 1 ? AXPLocalizedString(@"UnreadOneChatAccessibilityFormat") : [NSString stringWithFormat:unreadChatAccessibilityFormat, button.titleLabel.text];
            button.titleLabel.font = [UIFont systemFontOfSize:13.0f]; // explicitly 13.0f since nav bar fonts do not scale with user preference
            
            UIEdgeInsets insets = TSEdgeInsetsMake(0, TSkChatBadgeBackButtonLeftInset, 0, 0);
            button.titleEdgeInsets = insets;
            button.imageEdgeInsets = insets;
            
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
            viewController.navigationItem.leftBarButtonItem = barButtonItem;
        }
        else if (!self.isInCallRightPanel)
        {
            viewController.navigationItem.leftBarButtonItem = nil;
        }
    }
}

- (void)createBrandingImageIfNeeded
{
    if (isTeamsSDK() && TeamsAppSDKManager.sharedInstance.isBrandingSupported)
    {
        UIViewController *viewController = self.outerViewController ?: self;
        UIBarButtonItem *barBrandButtonItem = [self createBrandButtonItemWithColoredIcon:YES];
        viewController.navigationItem.leftItemsSupplementBackButton = YES;
        viewController.navigationItem.leftBarButtonItems = @[barBrandButtonItem];
    }
}

- (void) reloadForUserBlockStatusChange:(NSNotification *)notification
{
    [self reloadForSfCInteropChatBlockStateChange];
}

- (void) badgeCountChanged: (NSNotification *) notification
{
    [self createBadgedBackButtonIfNeeded];
}

- (BOOL)shouldUseCenterAlignedTitle
{
    BOOL shouldShowCreateNewGroupChatEntryPoint = self.accountHandle.policyManager.shouldShowCreateNewGroupChatEntryPoint;
    TSGroupChatCreationState state = self.groupChatCreationState;
    if (shouldShowCreateNewGroupChatEntryPoint && (state == TSGroupChatCreationStateAddingParticipants || state == TSGroupChatCreationStateStart))
    {
        return YES;
    }
    if (self.recipientIDs == nil && self.isNewFederatedUser == NO && ![self.threadID length] && self.shouldConfigureForMeetings == NO)
    {
        return YES;
    }
    if (self.splitViewController && self.splitViewController.isCollapsed)
    {
        return YES;
    }
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1)
    {
        return YES;
    }
    return NO;
}

- (void) backButtonTapped:(id)sender
{
    BOOL shouldShowCreateNewGroupChatEntryPoint = self.accountHandle.policyManager.shouldShowCreateNewGroupChatEntryPoint;
    TSGroupChatCreationState state = self.groupChatCreationState;
    BOOL didComeFromBanner = [self.scenarioEntryPoint isEqual:TSkEntryPointActivationBanner];
    if (shouldShowCreateNewGroupChatEntryPoint
        && state == TSGroupChatCreationStateAddingParticipants
        && !self.isStartOfNonBifurcatedFlow
        && (!self.isGroupTemplateChat || self.accountHandle.policyManager.isGroupCreationWithNamingInTemplatesEnabled))
    {
        if (self.shouldMultiSelectParticipants
            && !self.isMultiSelectParticipantsInProgress)
        {
            // Go back from pre-chat to adding participants
            [self transitionToAddingParticipantsInitialState];
            [self.toViewController entitySearchBarViewController:nil
                                                       didSearch:@""
                                                  withRecipients:self.toViewController.selectedRecipients];
            [self.toViewController clearSearchBarText];
            [self.toViewController setSearchBarFocus];
        }
        else
        {
            // Go back to chat name/avatar edit view
            [self closeTitleDropdown:nil];
            [self.composeViewController saveCurrentDraft];
            [self willNavigateToView:@{
                TSkGroupChatCreationStateKey:@(TSGroupChatCreationStateStart),
                TSkTopicName: self.topicName ?: @"",
                TSkEntryPoint: self.scenarioEntryPoint,
                TSkGroupAvatarEditPressed: @(self.groupAvatarEditPressed),
                TSkHasCustomGroupAvatar: @(self.hasCustomGroupAvatar),
                TSkActivationOrigin: self.activationOrigin ?: @"",
                TSkActivationPillar: self.activationPillar ?: @""
            }];
            
            [self.toView setHidden:YES];
            [self.toViewController hideNewGroupChatEntryPoint];
            self.emptyStateTopYoffset = TSkToSearchBarContainerHeight;
        }
    }
    else if (shouldShowCreateNewGroupChatEntryPoint && state == TSGroupChatCreationStateStart && !didComeFromBanner && !self.didShowGroupTemplatePicker && ![self isGroupTemplateChat])
    {
        // Go back to main new chat window
        [self willNavigateToView:@{
            TSkEntryPoint  : TSkEntryPointNewChat,
            TSkGroupChatCreationStateKey:@(TSGroupChatCreationStateNoOp)
        }];
        
        [self.toView setHidden:NO];
        [self showEmptyStateView:NO];
        [self.toViewController.entitySearchBarViewController removeAllRecipientsSuppressingCallbacks:NO];
        [self.toViewController entitySearchBarViewController:nil didSearch:@"" withRecipients:nil];
        
        if ([self isSimpleSearchBarVisible])
        {
            [self.toViewController clearSearchBarText];
            [self.toViewController updateCarouselRecipients];
            [self.toViewController.simpleSearchBarContainerView setHidden:YES];
            [self.toViewController.entitySearchBarContainerView setHidden:NO];
        }

        [self.toViewController.entitySearchBarViewController.textView becomeFirstResponder];
    }
    else if (self.splitViewController && self.splitViewController.isCollapsed)
    {
        [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (self.presentingViewController && self.navigationController.viewControllers.count == 1)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    self.canRemoveConsultTransferCallSession = YES;
    self.emptyStateTopYoffset = TSkToAndNewGroupChatContainerHeight;
}

- (void) nativeFederationChatPreFetch
{
    if (self.isNativeFedChatEnabled)
    {
        if ([self isSfBInteropChat] && [self isFederatedUserWithTeamsOnlyInMoc:self.accountHandle.mainMOC])
        {
            self.composeView.hidden = YES;
            if ([NSString isNilOrEmpty:self.nativeFederationThreadID])
            {
                [self findNativeFederationChatThreadLocally];
            }
        }
        else if ([self isOneToOneChat] && [self isTfLInterOpOrOffNetworkFedChat] && [NSString isNilOrEmpty:self.previousFederationThreadID])
        {
            [self syncPreviousFederationChat];
        }
    }
}

- (void) syncPreviousFederationChat
{
    if ([self.threadID isNotNilOrEmpty])
    {
        TSThreadProperty *previousFederationProperty = [AXPCtx threadPropertyForThreadID:self.threadID
                                                                         andPropertyName:TSkThreadPropertyPreviousFederationThreadID];
        NSString *previousFederationID = previousFederationProperty.propertyValue.asString;
        if ([previousFederationID isNotNilOrEmpty])
        {
            self.previousFederationThreadID = previousFederationID;
        }
        else
        {
            [self findPreviousFederationChatThreadLocally];
        }
    }
}

- (void) leaveGroupChat
{
    if(!self.threadID.length)
    {
        LogErrorAH(self.accountHandle.logger, @"Calling:TSChatViewController:LeaveChat:Unable to leave chat: Invalid threadId");
        return;
    }

    if (![TSNetworkStatusManager sharedInstance].isReachable)
    {
        LogInfoAH(self.accountHandle.logger, @"TSChatViewController:LeaveChat: Unable to leave chat due to offline state");
        [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"AlertErrorTitle")
                                                  andMessage:AXPLocalizedString(@"OfflineErrorMsg")
                                            andButtonContent:AXPLocalizedString(@"TSOK")
                                           andViewController:self];
        return;
    }

    [self.accountHandle.logger logPanelAction:TSkScenarioLeaveChat
                                      outCome:TSkActionOutcomeSubmit
                                      gesture:TSkActionGestureTap
                                     scenario:SCENARIO_MEETING_LEAVE_CHAT
                                 scenarioType:TSkScenarioTypeMeetingChat
                               destinationuri:@""
                         destinationUriParams:@""
                                   moduleType:TSkActionModuleTypeButton
                                  moduleState:nil
                                moduleSummary:nil
                                    panelType:TSkPanelTypeChat
                                     panelUri:TSkPanelUriConversation
                               panelUriParams:nil
                                     threadId:self.threadID
                                   threadType:TSkThreadTypeChatPrivateMeeting];
    
    NSString *correlationID = [@"LeaveChat:" stringByAppendingString:[[NSUUID UUID] UUIDString]];
    TSAction *leaveAction = [self.accountHandle.actionContext actionOfClass:TSNALeaveGroupChat.class
                                                             fromDictionary:@{TSkThreadID       : self.threadID,
                                                                              TSkCorrelationID  : correlationID,
                                                                              TSkKeyStatusMessage  : [NSString stringWithFormat:@" TSChatViewControlelr: leaving group chat from threadID : %@", self.threadID ]}
                                                             withCompletion:nil];
    
    TSWeakify(self);
    [leaveAction executeActionChain:@"leaving group chat" withCompletion: ^(TSAction *action, TSAResult *result, NSError *err) {
        
        TSStrongifyAndReturnIfNil(self);
        [TSDispatchUtilities dispatchOnMainThread:^{
            if (!err)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                LogErrorAH(self.accountHandle.logger, @"Calling:TSChatViewControlelr:LeaveMeetingChat:Unable to leave chat: error code: %zd", err.code);
                [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"AlertErrorTitle")
                                                    andMessage:AXPLocalizedString(@"FailedToLeaveChatError")
                                              andButtonContent:AXPLocalizedString(@"TSOK")
                                             andViewController:self];
            }
        }];
    }];
}

- (void) setPreviousFederationID:(NSString *)previousFederationID
           forNativeFederationID:(NSString *)nativeFederationID
                           inMoc:(NSManagedObjectContext *)moc
{
    if ([previousFederationID isNotNilOrEmpty] && [nativeFederationID isNotNilOrEmpty])
    {
        BOOL didCreate = NO;
        TSThreadProperty *previousFederationProperty = [TSThreadProperty threadPropertyForThreadID:nativeFederationID
                                                                                   andPropertyName:TSkThreadPropertyPreviousFederationThreadID
                                                                                         canCreate:YES
                                                                                           creator:NSStringFromClass(self.class)
                                                                                         didCreate:&didCreate
                                                                            inManagedObjectContext:moc];
        previousFederationProperty.propertyValue = previousFederationID;
    }
}

- (void) findPreviousFederationChatThreadLocally
{
    __weak typeof (self) weakSelf = self;
    NSString *correlationID = [TSkCorrelationTagFederation stringByAppendingString:[[NSUUID UUID] UUIDString]];
    TSAction *action = [self.actionContext actionOfClass:[TSAAFindContainerForRecipients class]
                                          fromDictionary:@{ TSkCorrelationID : correlationID,
                                                            TSkRecipientIDs  : self.recipientIDs,
                                                            kForceSearchInterop : @YES }
                                          withCompletion:nil];
    [action executeActionChain:@"search previous federation chat" withCompletion:^(TSAction *action, TSAResult *result, NSError *err)
     {
        NSString *threadID = [[result processedListForClass:[TSThread class]] firstObject];
        if (!err && [threadID isNotNilOrEmpty])
        {
            weakSelf.previousFederationThreadID = threadID;
            [weakSelf setPreviousFederationID:threadID forNativeFederationID:weakSelf.threadID inMoc:action.managedObjectContext];
            // fetch to perform a reload on the view data.
            [weakSelf.messageFetchEngine getNextPageFromSyncDate:self.lastMessageDate];
        }
    }];
}

- (void) findNativeFederationChatThreadLocally
{
    __weak typeof (self) weakSelf = self;
    NSString *correlationID = [TSkCorrelationTagFederation stringByAppendingString:[[NSUUID UUID] UUIDString]];
    TSAction *action = [self.actionContext actionOfClass:[TSAAFindContainerForRecipients class]
                                          fromDictionary:@{ TSkCorrelationID : correlationID,
                                                            TSkRecipientIDs  : self.recipientIDs,
                                                            kForceSearchInterop : @NO }
                                          withCompletion:nil];
    [action executeActionChain:@"search native federation chat" withCompletion:^(TSAction *action, TSAResult *result, NSError *err)
     {
        NSString *threadID = [[result processedListForClass:[TSThread class]] firstObject];
        weakSelf.nativeFederationThreadID = (!err && [threadID length]) ? threadID : nil;
    }];
}

- (void) extractBIThreadAndChatType
{
    self.biThreadType = nil;
    self.biChatType = nil;
    if (self.threadID)
    {
        switch (self.threadType) {
                
            case TSThreadTypeOneOnOneChat:
            {
                self.biThreadType = TSkThreadTypeOneOnOneChat;
                TSUserInfo *user = [self userInfoForID:[self.recipientIDs firstObject]];
                if (user && [user isBot])
                {
                    self.biThreadType = TSkThreadTypeBotOnlyChat;
                }
                break;
            }
            case TSThreadTypeInteropChat:
            {
                self.biThreadType = TSkThreadTypeInteropChat;
                break;
            }
            case TSThreadTypeGroupChat:
            {
                self.biThreadType = TSkThreadTypeGroupChat;

                if ([self.thread isGuardianThread])
                {
                    self.biChatType = TSkChatTypeGuardianChat;
                }

                break;
            }
            case TSThreadTypePrivateMeeting:
            {
                self.biThreadType = TSkThreadTypeChatPrivateMeeting;
                break;
            }
            case TSThreadTypePhoneChat:
            {
                self.biThreadType = TSkThreadTypeSMSChat;
                break;
            }
            case TSThreadTypeUnknown:
            {
                self.biThreadType = @"";
                break;
            }
            default:
            {
                break;
            }
        }
    }
    else if(self.recipientIDs.count)
    {
        // if ThreadId is nil, implies chat has not yet been created
        // Private meetings can't be created currently from mobile client.
        if (self.recipientIDs.count > 1)
        {
            self.biThreadType = TSkThreadTypeGroupChat;

            if (self.isGuardiansChat)
            {
                self.biChatType = TSkChatTypeGuardianChat;
            }
        }
        else if (self.recipientIDs.count == 1)
        {
            self.biThreadType = TSkThreadTypeOneOnOneChat;
            TSUserInfo *user = [self userInfoForID:[self.recipientIDs firstObject]];
            if (user)
            {
                if ([user isBot]) {
                    self.biThreadType = TSkThreadTypeBotOnlyChat;
                }
                else if ([user isPSTNUser]) {
                    self.biThreadType = TSkThreadTypeSMSChat;
                }
            }
            if (self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants) {
                self.biThreadType = TSkThreadTypeGroupChat;
            }
        }
        else
        {
            self.biThreadType = @"";
        }
    }
}

- (NSNumber *)biThreadMembersCount
{
    if (self.recipientIDs == nil)
    {
        return nil;
    }
    
    return [NSNumber numberWithLong:(self.threadType == TSThreadTypePrivateMeeting ? self.recipientIDs.count : self.recipientIDs.count + 1)];
}

- (void)videoCallButtonTapped:(UIButton *)sender
{
    if ([self.accountHandle.policyManager isCallingDisabledDueToMobilityPolicy])
    {
        [TSCallUtilities showCallDisabledDueToMobilityPolicyAlertWithMessage:TSCallingDisabled
                                                            inViewController:self];
        [self.accountHandle.logger logPanelView:TSkPanelTypeChat
                                       scenario:SCENARIO_MOBILITY_POLICY_USE_WIFI_FOR_AUDIO_DIALOG
                                   scenarioType:TSkScenarioTypeMobilityPolicyAudioDisabled
                                     moduleName:TSkActionModuleNameUseWifiForAudioDialog
                                     moduleType:TSkActionModuleTypeView
                                     threadType:self.biThreadType];
        return;
    }
    
    if ([self.accountHandle.policyManager isVideoDisabledDueToMobilityPolicy])
    {
        [TSCallUtilities showCallDisabledDueToMobilityPolicyAlertWithMessage:TSVideoDisabled
                                                            inViewController:self];
        [self.accountHandle.logger logPanelView:TSkPanelTypeChat
                                       scenario:SCENARIO_MOBILITY_POLICY_USE_WIFI_FOR_VIDEO_DIALOG
                                   scenarioType:TSkScenarioTypeMobilityPolicyVideoDisabled
                                     moduleName:TSkActionModuleNameUseWifiForVideoDialog
                                     moduleType:TSkActionModuleTypeView
                                     threadType:self.biThreadType];
        return;
    }
    
    if ([self isGroupCall])
    {
        [self groupCallDialog:true];
    }
    else
    {
        [self startAudioOrVideoCall:true];
    }
}

- (void)voiceCallButtonTapped:(UIButton *)sender
{
    if ([self.accountHandle.policyManager isCallingDisabledDueToMobilityPolicy])
    {
        [TSCallUtilities showCallDisabledDueToMobilityPolicyAlertWithMessage:TSCallingDisabled
                                                            inViewController:self];
        [self.accountHandle.logger logPanelView:TSkPanelTypeChat
                                       scenario:SCENARIO_MOBILITY_POLICY_USE_WIFI_FOR_AUDIO_DIALOG
                                   scenarioType:TSkScenarioTypeMobilityPolicyAudioDisabled
                                     moduleName:TSkActionModuleNameUseWifiForAudioDialog
                                     moduleType:TSkActionModuleTypeView
                                     threadType:nil];
        return;
    }
    
    if ([self isGroupCall])
    {
        [self groupCallDialog:false];
    }
    else
    {
        [self startAudioOrVideoCall:false];
    }
    
    self.canRemoveConsultTransferCallSession = YES;
}

- (void)resolveThreadAndPlaceCallWithVideo:(BOOL)isSendingLocalVideo callUUID:(NSUUID *)callUUID
{
    if (self.threadType == TSThreadTypeUnknown)
    {
        __weak typeof (self) weakSelf = self;
        NSString *correlationID = [@"PlaceVideoCallChatFind:" stringByAppendingString:[[NSUUID UUID] UUIDString]];
        [[[TSSyncEngine sharedInstance] threadSyncManager] findOrCreateChatThread:self.recipientIDs
                                                                 previousThreadId:self.threadID
                                                                        topicName:self.topicName
                                                                    correlationID:correlationID
                                                                    accountHandle:self.accountHandle
                                                    threadCreationDataBagOverride:^NSDictionary *()
         {
            return [self newThreadCreatedTelemetryDatabag];
        }
                                                                       completion:^(NSString *threadID, NSError *err, BOOL hasMultiStatusResponse)
         {
            if((err && !hasMultiStatusResponse) || !threadID.length)
            {
                if(!err)
                {
                    err = [NSError errorWithDescription:@"findOrCreateChatThread returned nil threadID."];
                }
                
                BOOL failedDueToOffline = [AXPUtilities isNetworkOfflineError:err];
                [TSDispatchUtilities dispatchOnMainThread:^{
                    __strong typeof (self) strongSelf = weakSelf;
                    NSString *errorMessage= failedDueToOffline ? AXPLocalizedString(@"CallTitleFailedNetworkUnavailableLabel") :
                    AXPLocalizedString(@"CallFailedGenericErrorLabel");
                    [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"CallTitleFailedLabel")
                                                        andMessage:errorMessage
                                                  andButtonContent:AXPLocalizedString(@"TSOK")
                                                 andViewController:strongSelf];
                }];
                
                return;
            }
            
            [TSDispatchUtilities dispatchOnMainThread:^{
                __strong typeof (self) strongSelf = weakSelf;
                [strongSelf updateThreadInfo];
                [strongSelf placeCallWithVideo:isSendingLocalVideo newCallUUID:callUUID];
            }];
        }];
    }
    else
    {
        [self placeCallWithVideo:isSendingLocalVideo newCallUUID:callUUID];
    }
}

- (void)placeCallWithVideo:(BOOL)isSendingLocalVideo newCallUUID:(NSUUID *)newCallUUID
{
    NSString *scenarioName = self.threadType == TSThreadTypeGroupChat ? SCENARIO_CALL_PLACE_GROUP_CALL : [self placeOneToOneCallScenarioName];
    
    NSString *scenarioID = [[NSUUID UUID] UUIDString];
    NSString *placeCallPrefix = self.threadType == TSThreadTypeGroupChat ? TSkCorrelationTagPlaceGroupCall : TSkCorrelationTagPlaceCall;
    NSString *correlationID = [placeCallPrefix stringByAppendingString:scenarioID];
    [self.accountHandle.logger logStartScenarioEventOfType:scenarioName
                                             correlationID:correlationID
                                                scenarioID:scenarioID
                                            withProperties:@{SCENARIO_SOURCE: @"chat"}];
    
    NSMutableArray *recipientDisplayNames = NSMutableArray.new;
    for (NSString *recipientId in self.recipientIDs)
    {
        TSUserInfo *person = [self userInfoForID:recipientId];
        [recipientDisplayNames addObject: person ? [person displayNameWithGuestInfo] : AXPLocalizedString(@"UnknownUser")];
    }
    
    UIViewController *hostViewController = self;
    
    
    if (self.isConsultTransferConversation && self.recipientIDs.count == 1)
    {
        // If we are placing a call while already inside a calling scenario we want to replace our existing modal VC
        // with the new mainstage view controller that will be created for the new call. Our logic in CallNavigationUtilities
        // will handle replacing the existing callViewController if we make a call from a callViewController. To reuse this logic
        // in this scenario, we navigate back to the call view controller before navigating forward to the new call.
        // If we don't do this, we end up with two modal CallingNavigationControllers on top of each other.
        if ([self.navigationController isKindOfClass:TSCallingNavigationController.class])
        {
            NSArray *viewControllers = [self navigationController].viewControllers;
            for (UIViewController *vc in viewControllers)
            {
                if ([vc isKindOfClass:TSCallViewController.class])
                {
                    hostViewController = vc;
                }
            }
            
            [[self navigationController] popViewControllerAnimated:NO];
        }
        
        if ([[TSCallManager sharedInstance].consultTransferCallSession.transferToMri isEqualToString:self.recipientIDs[0]])
        {
            [self.logger logPanelAction:TSkActionModuleTypeConsultTransferCall
                                outCome:TSkActionOutcomeSubmit
                                gesture:nil
                               scenario:SCENARIO_CONSULT_TRANSFER_CALL
                           scenarioType:TSkScenarioTypeCallTransfer
                         destinationuri:nil
                   destinationUriParams:nil
                             moduleType:TSkActionModuleTypeButton
                            moduleState:nil
                          moduleSummary:nil
                              panelType:TSkPanelTypeCallOrMeetUpLive
                               panelUri:TSkPanelUriCalling
                         panelUriParams:nil
                               threadId:self.threadID
                             threadType:self.call.callType == TSPSTNCall ? TSkThreadTypePSTN : TSkThreadTypeOneOnOneChat
                               callType:[TSCallUtilities biCallTypeStringForCall:self.call]
                                 callId:self.call.initialUUIDString];
            
            [TSCallManager sharedInstance].consultTransferCallSession.type = TSConsultTransferTypeCall;
        }
    }
    
    [TSCallNavigationUtilities showDelegatorsAndPlaceCallFrom:hostViewController
                                          isSendingLocalVideo:isSendingLocalVideo
                                                  containerId:self.threadID
                                                 recipientIds:self.recipientIDs
                                        recipientDisplayNames:recipientDisplayNames
                                                correlationID:correlationID
                                                  isVoicemail:NO
                                                accountHandle:self.accountHandle
                                                     animated:YES
                                                      callUUID:newCallUUID
                                                   completion:nil];
    
}

- (void)transitionToAddingParticipantsInitialState
{
    [self willNavigateToView:@{
        TSkGroupChatCreationStateKey:@(TSGroupChatCreationStateAddingParticipants),
        TSkTopicName: self.topicName ?: @"",
        TSkForceShowBackButton: @(YES),
        TSkEntryPoint: self.scenarioEntryPoint,
        TSkGroupAvatarEditPressed: @(self.groupAvatarEditPressed),
        TSkHasCustomGroupAvatar: @(self.hasCustomGroupAvatar),
        TSkActivationOrigin: self.activationOrigin ?: @"",
        TSkActivationPillar: self.activationPillar ?: @""
    }];
    
    if (self.shouldMultiSelectParticipants)
    {
        self.isMultiSelectParticipantsInProgress = YES;
        [self updateSimpleSearchBarVisibility];
    }
    
    [self createBadgedBackButtonIfNeeded];
    
    [self.toView setHidden:NO];
    
    [self.toViewController hideNewGroupChatEntryPoint];
    self.emptyStateTopYoffset = TSkToSearchBarContainerHeight;
}

- (void) updateSimpleSearchBarVisibility
{
    if (self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants)
    {
        [self.toViewController.entitySearchBarContainerView setHidden:YES];
        [self.toViewController.simpleSearchBarContainerView setHidden:NO];
        [self.toViewController setupSimpleSearchBarBeforeMultiselectUse];
    }
    else
    {
        [self.toViewController.simpleSearchBarContainerView setHidden:YES];
        [self.toViewController.entitySearchBarContainerView setHidden:NO];
    }
}

- (BOOL)isSimpleSearchBarVisible
{
    return !self.toViewController.simpleSearchBarContainerView.hidden;
}

- (BOOL)shouldAddToViewControllerAsChild
{
    if (self.groupChatCreationState == TSGroupChatCreationStateInChatWithCompose)
    {
        return YES;
    }
    
    return (!self.recipientIDs && !(self.emptyStateForMeetings || self.isChatWithSelf));
}

- (void)logTelemetryForNextButtonTapWithModuleName:(NSString *)moduleName
{
    NSInteger deviceContactsCount = 0;
    NSInteger suggestedContactsCount = 0;
    
    for (NSDictionary *recipient in self.toViewController.selectedRecipients)
    {
        NSString *itemType = recipient[TSkSearchResultItemType];
        if ([itemType isEqualToString:TSkDeviceContactSearchType])
        {
            deviceContactsCount += 1;
        }
        else
        {
            suggestedContactsCount += 1;
        }
    }
    
    NSDictionary *databag = @{
        TSkChatCreationEntryPoint: self.scenarioEntryPoint,
        TSkNewGroupWelcomeScreenTypeKey: @(self.accountHandle.ecsManager.newGroupWelcomeScreenType),
        TSkUntitledGroupCreationEnabledKey: @(self.accountHandle.ecsManager.isUntitledNewGroupAllowed),
        TSkHasCustomNameKey: @([self.topicName isNotNilOrEmpty]),
        TSkDeviceContactsSelectedKey: @(deviceContactsCount),
        TSkSuggestedContactsSelectedKey: @(suggestedContactsCount),
        TSkTotalContactsSelectedKey: @(deviceContactsCount + suggestedContactsCount),
        TSkIsNonBifurcationEnabledKey: @(self.accountHandle.policyManager.isGroupCreationFlowV2Enabled),
    };
    
    NSString *panelType = @"next";
    NSString *scenarioType = TSkScenarioChatCreation;
    
    if ([self.accountHandle.policyManager isGroupCreationWithTemplatesEnabled])
    {
        TemplatesDataSourceType templateType = self.groupTemplateCoordinator.selectedTemplateType;
        if (templateType != TemplatesDataSourceTypeUnknown) {
            NSString *templateTypeString = [TemplatesDataSourceTypeBridge rawStringFor:self.groupTemplateCoordinator.selectedTemplateType];
            databag = [databag dictionaryByAddingEntries:@{
                TSkBIMetadataKeyGroupTemplateType: templateTypeString,
                TSkBIMetadataKeyGroupTemplateNamingEnabled: @([self.accountHandle.policyManager isGroupCreationWithNamingInTemplatesEnabled])
            }];
            panelType = TSkPanelTypeGroupTemplateNameAvatarNext;
            scenarioType = TSkScenarioTypeGroupTemplateActions;
        }
    }
    
    [self.accountHandle.logger logPanelAction:moduleName
                                      outCome:TSkActionOutcomeNav
                                      gesture:TSkActionGestureTap
                                     scenario:TSkPeoplePickerForNewChatScenarioName
                                 scenarioType:scenarioType
                               destinationuri:nil
                         destinationUriParams:nil
                                   moduleType:nil
                                  moduleState:nil
                                moduleSummary:nil
                                    panelType:panelType
                                     panelUri:nil
                               panelUriParams:nil
                                     threadId:self.threadID
                                   threadType:nil
                                     metaData:@{TSkDATABAG_PROPERTIES: [databag jsonString]}];
}

- (void)createNewGroupChatNextButtonTapped:(UIButton *)sender
{
    if (self.toViewController.selectedRecipients.count == 0
        && ([self isGroupTemplateChat] && !self.accountHandle.policyManager.isGroupTemplatesWithPeoplePickerEnabled)
        && self.accountHandle.policyManager.isEmptyGroupCreationEnabled
        && self.groupChatCreationState == TSGroupChatCreationStateStart)
    {
        [self createEmptyGroupChat];
        [self logTelemetryForNextButtonTapWithModuleName:TSkActionModuleNameNameGroupChat];
    }
    else if (self.groupChatCreationState == TSGroupChatCreationStateStart)
    {
        [self transitionToAddingParticipantsInitialState];

        [self logTelemetryForNextButtonTapWithModuleName:TSkPeoplePickerModuleName];
        
        if (self.toViewController.selectedRecipients.count > 0) {
            [self toViewController:self.toViewController didChangeRecipients:self.toViewController.selectedRecipients];
            [self.composeViewController.textBody becomeFirstResponder];
        }
        else
        {
            [self.toViewController entitySearchBarViewController:nil
                                                       didSearch:@""
                                                  withRecipients:nil];
            [self.toViewController setSearchBarFocus];
        }
    }
    else if (self.toViewController.selectedRecipients.count == 0
             && self.accountHandle.policyManager.isEmptyGroupCreationEnabled
             && self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants)
    {
        if (self.isMultiSelectParticipantsInProgress)
        {
            [self logTelemetryForNextButtonTapWithModuleName:TSkPeoplePickerModuleNameMultiSelectPicker];
        }
        [self createEmptyGroupChat];
    }
    else if (self.toViewController.selectedRecipients.count > 0
             && self.isGuardiansChat)
    {
        NSDictionary *recipientsUserInfo = [TSUtilities recipientIDsWithUserInfoFromSelectedRecipients:self.toViewController.selectedRecipients];
        [self createNewGroupChatWithRecipientsInfo:recipientsUserInfo threadInfo:self.guardiansChatThreadInfo];
    }
    else if (self.toViewController.selectedRecipients.count > 0
             && self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants
             && self.accountHandle.policyManager.isGroupCreationWithTemplatesEnabled
             && self.groupTemplateCoordinator.selectedTemplateType != TemplatesDataSourceTypeUnknown)
    {
        [self logTelemetryForNextButtonTapWithModuleName:TSkPeoplePickerModuleNameMultiSelectPicker];
        NSDictionary *recipientsUserInfo = [TSUtilities recipientIDsWithUserInfoFromSelectedRecipients:self.toViewController.selectedRecipients];
        [self createNewGroupChatWithRecipientsInfo:recipientsUserInfo threadInfo:nil];
    }
    else if (self.toViewController.selectedRecipients.count > 0
             && self.shouldMultiSelectParticipants
             && self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants)
    {
        [self logTelemetryForNextButtonTapWithModuleName:TSkPeoplePickerModuleNameMultiSelectPicker];
        self.isMultiSelectParticipantsInProgress = NO;
        if (self.shouldHideToLineInPreChat)
        {
            [self.toView setHidden:YES];
            self.toContainerViewHeight.constant = 0;
        }
        [self toViewController:self.toViewController didChangeRecipients:self.toViewController.selectedRecipients];
        [self.toViewController entitySearchBarViewControllerResetSearch];
    }
    else
    {
        self.emptyStateTopYoffset = TSkToAndNewGroupChatContainerHeight;
    }
}

- (void)showAvatarPopupWithSource:(UIView *)sourceView {
    if (!self.avatarPopup)
    {
        BOOL isGroupChatDefaultAvatarEnabled = [self.experimentationService boolForAgentName:TSECSTeamName
                                                             keyPath:TSECSIsGroupChatDefaultAvatarEnabled
                                                        defaultValue:NO];
        
        self.avatarPopup = [[AvatarPickerPopup alloc] initWithAccountHandle:self.accountHandle
                                                                   delegate:self
                                                        imagePickerDelegate:self
                                                         fromViewController:self
                                                               logTelemetry:NO
                                                                     thread:self.thread
                                                    shouldShowDefaultAvatar:isGroupChatDefaultAvatarEnabled];
        [self.avatarPopup start];
    }
    
    [self.avatarPopup showWithSource:sourceView];
}

#pragma mark - Single participant group chat creation

- (void)navigateToChat:(NSString *)threadID
{
    [self toViewController:self.toViewController didChangeRecipients:@[
        @{
            @"mri" : threadID,
            @"role" : @"User",
            @"displayName" : @"",
        }
    ]];
}

- (void)createEmptyGroupChat
{
    [self createNewGroupChatWithRecipientsInfo:nil threadInfo:nil];
}

- (BOOL)isGroupTemplateChat
{
    TemplatesDataSourceType selectedTemplateType = self.groupTemplateCoordinator.selectedTemplateType;
    TSExperimentGroupTemplateCreate groupTemplateExperimentType = self.accountHandle.policyManager.groupCreationWithTemplateExperimentationValue;
    BOOL isGroupTemplateChat = groupTemplateExperimentType != TSExperimentGroupTemplateCreateDisabled &&
                                self.groupTemplateCoordinator &&
                                selectedTemplateType != TemplatesDataSourceTypeUnknown;
    return isGroupTemplateChat;
}

- (void)createNewGroupChatWithRecipientsInfo:(NSDictionary *)recipientsInfo
                                  threadInfo:(NSDictionary *)threadInfo
{
    // make the whole UX not clickable when creating empty group, and enable in callback
    [self changeViewEnableState:(NO)];
    [self startActivityIndicator];
    
    UIImage *groupAvatar = nil;
    NSString *avatarId = self.customAvatarId;
    TemplatesDataSourceType selectedTemplateType = self.groupTemplateCoordinator.selectedTemplateType;
    BOOL isGroupTemplateChat =  [self isGroupTemplateChat];
    if (self.emptyStateView.avatarImage != nil)
    {
        groupAvatar = self.emptyStateView.avatarImage;
    }
    else if (isGroupTemplateChat)
    {
        groupAvatar = [self.groupTemplateCoordinator defaultGroupAvatar];
    }
    
    NSString *groupName = nil;
    if ([self.topicName isNotNilOrEmpty])
    {
        groupName = self.topicName;
    }
    else if (isGroupTemplateChat)
    {
        groupName = [self.groupTemplateCoordinator defaultGroupName];
    }

    NSString *correlationID = [TSkCorrelationTagCreateGroup stringByAppendingString:[[NSUUID UUID] UUIDString]];

    TSWeakify(self)
    [[[TSSyncEngine sharedInstance] threadSyncManager] findOrCreateChatThread:@[self.accountHandle.MRI]
                                                                recipientInfo:recipientsInfo
                                                                   threadInfo:threadInfo
                                                             previousThreadId:nil
                                                                    topicName:groupName
                                                                  groupAvatar:groupAvatar
                                                                     avatarId:avatarId
                                                                correlationID:correlationID
                                                                  forceCreate:YES
                                                                accountHandle:self.accountHandle
                                                threadCreationDataBagOverride:^NSDictionary *()
     {
        NSString *templateType = nil;
        if (selectedTemplateType != TemplatesDataSourceTypeUnknown)
        {
            templateType = [TemplatesDataSourceTypeBridge rawStringFor:selectedTemplateType];
        }
        return [self newThreadCreatedTelemetryDatabagWithGroupTemplateType:templateType];
    }
                                                                   completion:^(NSString *threadID, NSError *err, BOOL hasMultiStatusResponse)
     {
        TSStrongifyAndReturnIfNil(self)
        if ((err && !hasMultiStatusResponse) || [NSString isNilOrEmpty:threadID])
        {
            if (err && !hasMultiStatusResponse)
            {
                LogErrorAH(self.accountHandle.logger, @"Error occured during creation of a group chat with a single participant.  Error - domain %@, code %ld", err.domain, (long)err.code);
            }
            else
            {
                LogErrorAH(self.accountHandle.logger, @"Failed to create a group chat with a single participant.");
            }
            [TSDispatchUtilities dispatchOnMainThread:^{
                [self stopActivityIndicator];
                [self changeViewEnableState:(YES)];
                [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"GenericErrorDialogTitle")
                                             andMessage:AXPLocalizedString(@"CreateChatFailedErrorMessage")
                                       andButtonContent:AXPLocalizedString(@"TSOK")
                                      andViewController:self];
            }];
            return;
        }
        
        TSWeakify(self)
        [TSMeetingTabbedUXUtilities unhideThreadWithId:threadID
                                            scenarioId:@""
                                         accountHandle:self.accountHandle
                                            completion:^(NSError * _Nonnull err, NSString * _Nonnull threadID, BOOL isFromDB)
        {
            TSStrongifyAndReturnIfNil(self)
            
            TSWeakify(self)
            NSString *correlationID = [TSkCorrelationTagThreadSync stringByAppendingString:[[NSUUID UUID] UUIDString]];
            [[TSSyncEngine.sharedInstance threadSyncManager] syncThreadsWithIDs:@[threadID]
                                                               forCorrelationID:correlationID
                                                                  accountHandle:self.accountHandle
                                                                 withCompletion:^(NSError *err)
            {
                TSStrongifyAndReturnIfNil(self)

                TSWeakify(self)
                [self setGroupTemplateIfNeeded:selectedTemplateType
                                  withThreadId:threadID
                                withCompletion:^(BOOL groupTemplateWasNeeded, BOOL groupTemplatePropertyUpdated)
                {
                    TSStrongifyAndReturnIfNil(self)
                    
                    if (groupTemplateWasNeeded && !groupTemplatePropertyUpdated)
                    {
                        // TODO: spmor - pass template type directly to MT
                        // https://domoreexp.visualstudio.com/MSTeams/_workitems/edit/1416283
                        LogWarningAH(self.logger, @"Couldn't set group template");
                        
                        __weak typeof(self) weakSelf = self;
                        [TSDispatchUtilities dispatchOnMainThread:^{
                            [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"GenericErrorDialogTitle")
                                                         andMessage:AXPLocalizedString(@"CreateChatFailedErrorMessage")
                                                   andButtonContent:AXPLocalizedString(@"TSOK")
                                                  andViewController:weakSelf];
                        }];
                    }

                    if (self.accountHandle.policyManager.sendEmptyGroupCreationPrecannedMessage)
                    {
                        NSString *text = isGroupTemplateChat ? AXPLocalizedString(@"SnglPtcptGrp1stMsgGtt") : [NSString stringWithFormat:AXPLocalizedString(@"SnglPtcptGrp1stMsg"), groupName ?: @""];
                        NSDictionary *createMessageParams = @{
                            TSkThreadID: threadID,
                            @"text": text,
                            @"subject": @"",
                            @"importance": @""
                        };
                        TSAction *createMessageAction = [self.accountHandle.actionContext actionOfClass:TSAACreateMessage.class
                                                                                         fromDictionary:createMessageParams
                                                                                         withCompletion:nil];
                        TSWeakify(self)
                        [createMessageAction executeActionChain:@"Creating initial message for single participant group chat"
                                                 withCompletion:^(TSAction *action, TSAResult *result, NSError *err)
                        {
                            TSStrongifyAndReturnIfNil(self)
                            TSMessageUniqueKey *messageUniqueKey = [[result createdListForClass:[TSSMessage class]] firstObject];
                            if (messageUniqueKey && messageUniqueKey.messageID && messageUniqueKey.threadID)
                            {
                                NSDictionary *uploadMessageParams = @{
                                    TSkThreadID: messageUniqueKey.threadID,
                                    @"messageID": messageUniqueKey.messageID,
                                    @"scenarioID": @""
                                };
                                TSAction *uploadMessageAction = [self.accountHandle.actionContext actionOfClass:TSNAUploadMessage.class
                                                                                                 fromDictionary:uploadMessageParams
                                                                                                 withCompletion:nil];
                                [uploadMessageAction executeActionChain:@"Creating initial message for single participant group chat"
                                                         withCompletion:nil];
                                
                                [self logTelemetryForInitialEmptyGroupCreationWithMessageID:messageUniqueKey.messageID threadID:messageUniqueKey.threadID];
                            }

                            [self completeCreateNewGroupChatWithRecipientsInfo:threadID];
                        }];
                    }
                    else
                    {
                        [self completeCreateNewGroupChatWithRecipientsInfo:threadID];
                    }
                }];
            }];
        }];
    }];
}

- (NSDictionary *) newThreadCreatedTelemetryDatabag
{
    return [self newThreadCreatedTelemetryDatabagWithGroupTemplateType:nil];
}

- (NSDictionary *) newThreadCreatedTelemetryDatabagWithGroupTemplateType:(NSString *)groupTemplateType
{
    NSDictionary *additionalDataBag = [self addNewChatCompleteTelemetry];
    return [TSUtilities threadCreationDataBagWithAccountHandle:self.accountHandle
                                     newChatScenarioEntryPoint:[self getNewChatScenarioEntryPoint]
                                                     isSMSChat:[self isSMSChat]
                                             groupTemplateType:groupTemplateType
                                             additionalDataBag:additionalDataBag];
}

- (void) logTelemetryForInitialEmptyGroupCreationWithMessageID:(NSNumber *)messageID
                                                      threadID:(NSString *)threadID
{
    [TSDispatchUtilities dispatchOnMainThread:^{
        __block NSMutableDictionary *dataBagValues = [[NSMutableDictionary alloc] initWithDictionary:@{
            TSkType: TSkChatMsgSendTypeRegular,
            TSkSessionId: self.sessionId
        }];
        
        if (self.accountHandle.policyManager.isGroupCreationWithTemplatesEnabled)
        {
            TemplatesDataSourceType templateType = self.groupTemplateCoordinator.selectedTemplateType;
            if (templateType != TemplatesDataSourceTypeUnknown)
            {
                NSString *groupTemplateId = [TemplatesDataSourceTypeBridge rawStringFor:templateType];
                [dataBagValues addEntriesFromDictionary:@{
                    TSkBIMetadataKeyGroupTemplateType: groupTemplateId,
                    TSkBIMetadataKeyGroupTemplateNamingEnabled: @([self.accountHandle.policyManager isGroupCreationWithNamingInTemplatesEnabled])
                }];
            }
        }
        
        NSManagedObjectContext *moc = self.accountHandle.highPriMOC;
        TSWeakify(self);
        DbReadWrite(SELECTOR_NAME(self), moc, ^
                    {
            TSStrongifyAndReturnIfNil(self);
            
            [dataBagValues addEntriesFromDictionary:[self addNewChatCompleteTelemetry]];
            
            [self logTelemetryForSendMessageEvent:nil
                                    withMessageID:messageID
                                     withThreadID:threadID
                                     withScenario:TSkScenarioChatSendMessage
                                      andPanelUri:TSkPanelUriConversation
                                   isOneOnOneChat:NO
                                       andDataBag:dataBagValues];
        });
    }];
}

- (void) changeViewEnableState:(BOOL)enabled
{
    UIViewController *viewController = self.outerViewController ?: self;
    if (viewController.view != nil)
    {
        viewController.view.userInteractionEnabled = enabled;
    }
    if (viewController.navigationItem.rightBarButtonItem != nil)
    {
        viewController.navigationItem.rightBarButtonItem.enabled = enabled;
    }
    if (viewController.navigationItem.leftBarButtonItem != nil)
    {
        viewController.navigationItem.leftBarButtonItem.enabled = enabled;
    }
}

- (void) setGroupTemplateIfNeeded:(TemplatesDataSourceType)selectedTemplateType
                     withThreadId:(NSString *)threadID
                   withCompletion:(void (^)(BOOL wasNeeded, BOOL groupTemplatePropertyUpdated))completion
{
    NSString *groupTemplateId = nil;
    if ([self.accountHandle.policyManager isGroupCreationWithTemplatesEnabled] && selectedTemplateType != TemplatesDataSourceTypeUnknown)
    {
        groupTemplateId = [TemplatesDataSourceTypeBridge rawStringFor:selectedTemplateType];
    }

    if ([NSString isNilOrEmpty:groupTemplateId])
    {
        completion(NO, NO);
        return;
    }
    
    NSDictionary *groupTemplate = @{
        @"id": groupTemplateId
    };
    
    NSString *scenarioID = [self.logger logStartScenarioEventOfType:SCENARIO_STAMP_GROUP_TEMPLATE
                                                     withProperties:@{@"templateId" : groupTemplateId}];
    
    TSWeakify(self)
    
    NSString *correlationID = [TSkCorrelationTagUpdateGroupTemplateProperty stringByAppendingString:[[NSUUID UUID] UUIDString]];
    TSAction *groupTemplateUpdateThreadPropertyAction = [self.accountHandle.actionContext actionOfClass:TSNAUpdateThreadProperty.class
                                                                                         fromDictionary:@{
                                                                                             TSkThreadID : threadID,
                                                                                             TSkPropertyNameKey : TSkThreadPropertyGroupTemplate,
                                                                                             TSkPropertyValueKey : [groupTemplate jsonString],
                                                                                             TSkCorrelationID : correlationID,
                                                                                             @"statusMessage" : [NSString stringWithFormat:@"Setting group template %@", groupTemplateId]
                                                                                         }
                                                                                         withCompletion:^(TSAction *action, TSAResult *result, NSError *err) {
        TSStrongify(self)
        if (err)
        {
            LogWarningAH(self.logger, @"Couldn't update group template thread property to %@", groupTemplateId);
            completion(YES, NO);
            [self.logger logScenarioStopEvent:scenarioID status:ScenarioStatusFailure];
            return;
        }
        
        [self.logger logScenarioStopEvent:scenarioID status:ScenarioStatusOK];
        BOOL didCreate = NO;
        TSThreadProperty *groupTemplateProperty = [TSThreadProperty threadPropertyForThreadID:threadID
                                                                              andPropertyName:TSkThreadPropertyGroupTemplate
                                                                                    canCreate:YES
                                                                                      creator:action.creatorString
                                                                                    didCreate:&didCreate
                                                                       inManagedObjectContext:action.managedObjectContext];
        
        if (groupTemplateProperty)
        {
            groupTemplateProperty.propertyValue = groupTemplate;
        }
        
        if (self)
        {
            [TSGttUtils sendIntentSignalTemplatedGroupCreatedWithAccountHandle:self.accountHandle groupTemplateId:groupTemplateId];
        }
        
        completion(YES, YES);
    }];
    [groupTemplateUpdateThreadPropertyAction executeActionChain:@"Setting group template" withCompletion:nil];
}

- (void)completeCreateNewGroupChatWithRecipientsInfo:(NSString *)threadID
{
    TSWeakify(self)
    [TSDispatchUtilities dispatchOnMainThread:^{
        TSStrongifyAndReturnIfNil(self)

        [self stopActivityIndicator];
        [self changeViewEnableState:(YES)];

        // Navigate to the new chat with newEmptyGroup flag
        [self toViewController:self.toViewController didChangeRecipients:@[
            @{
                @"mri" : threadID,
                @"role" : @"User",
                @"displayName" : @"",
                TSkNewEmptyGroup : @(YES)
            }
        ]];
    }];
}

#pragma mark - Computed Properties

/// Lazy property to store thread
- (TSThread *)thread
{
    if ([self.threadID isValidString])
    {
        if (_thread == nil)
            _thread = [AXPCtx threadForID:self.threadID];
        return _thread;
    }
    return nil;
}

#pragma mark - Disabled State View

- (void) configureDisabledStateView
{
    self.disabledStateView.backgroundColor = self.legacyAppearanceProxy.disabledComposeBackgroundColor;
    self.disabledStateView.layer.zPosition = CGFLOAT_MAX;
    
    BOOL disableCompose = NO;
    NSString *message = [self.delegate placeHolderTextForComposeViewController:&disableCompose];
    
    if (self.hasDisabledReason)
    {
        DisabledComposer *disabledComposer = [[DisabledComposer alloc] init];
        DisabledComposerViewData *viewData = [[DisabledComposerViewData alloc] initWithMessage:message buttonTitle:self.localizedDisabledComposerButton];
        TSWeakify(self);
        DisabledComposerConfig *config = [[DisabledComposerConfig alloc] initWithViewData: viewData onButtonPress:^{
            TSStrongifyAndReturnIfNil(self);
            [self disabledComposerDidPressButton];
        }];
        [disabledComposer setConfig:config];
        [self fillContainerView:self.disabledStateView withSubView:disabledComposer];
    }
    else
    {
        self.disabledStateViewLabel.text = message;
        self.disabledStateViewLabel.textColor = self.legacyAppearanceProxy.disabledComposeTitleColor;
        self.disabledStateViewLabel.font = [TSFont preferredFontForTextStyle:UIFontTextStyleSubheadline ofType:TSkFontTypeRegular];
        self.disabledStateViewLabel.numberOfLines = TSkDisabledStateViewLabelLineCount;
        [self.disabledStateViewLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    }
    
    self.disabledStateView.hidden = !disableCompose;
    self.disabledStateViewSeparator.backgroundColor = self.legacyAppearanceProxy.separatorColor;
    [self configureContentInset];
}

- (void) fillContainerView:(UIView *)containerView withSubView:(UIView *)subView
{
    if (containerView == nil || subView == nil)
    {
        return;
    }
    
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:subView];
    [subView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor].active = YES;
    [subView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor].active = YES;
    [subView.topAnchor constraintEqualToAnchor:containerView.topAnchor].active = YES;
    [subView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor].active = YES;
}

- (void)disabledComposerDidPressButton
{
    NSString *reason = [self disabledReasonCode];
    
    if ([reason isEqualToString:TSkThreadPropertyDisabledReasonCodeDeprovisioned])
    {
        // the thread has been deprovisioned due to inactivity -> navigate to a new chat screen
        [self navigateToNewChatScreen];
        return;
    }
    if ([reason isEqualToString:TSkThreadPropertyDisabledReasonCodeClaimed])
    {
        // the SMS user has converted to a TFL user -> navigate to a chat with the TFL user
        NSString *userId = [self disabledReasonUserId];
        [self navigateToChatWithUserId:userId];
        return;
    }
    LogWarningAH(self.logger, @"disabledComposerButtonTouch: code not supported");
}

- (void) navigateToNewChatScreen
{
    UIViewController *rootViewController = [self.navigationController.viewControllers firstObject];
    if ([rootViewController isKindOfClass:[TSChatListMultiViewController class]])
    {
        TSChatListMultiViewController *chatListViewController = (TSChatListMultiViewController *)rootViewController;
        [chatListViewController newChatButtonTapped:nil];
    }
}

- (void) navigateToChatWithUserId:(NSString *)userId
{
    if ([NSString isNilOrEmpty:userId])
    {
        LogWarningAH(self.logger, @"navigateToChatWithUserId: userId is empty");
        return;
    }
    
    TSWeakify(self);
    [TSThread getThreadForUsersFromDB:@[userId] completion:^(NSString * _Nonnull threadId)
    {
        if([threadId isNotNilOrEmpty])
        {
            NSMutableDictionary *viewInfo = [NSMutableDictionary dictionary];
            
            [viewInfo setValue:threadId forKey: TSkThreadID];
            [viewInfo setValue:TSkEntryPointSMSThread forKey:TSkEntryPoint];
            
            [TSDispatchUtilities dispatchOnMainThread:^{
                TSStrongifyAndReturnIfNil(self)
                [self performSegue:TSkSeguePushChatMultiView withViewInfo:viewInfo];
            }];
        }
    }];
}

- (void) configureContentInset
{
    CGFloat bottomContentInset = 0;
    BOOL disableCompose = NO;
    [self.delegate placeHolderTextForComposeViewController:&disableCompose];
    if (disableCompose)
    {
        bottomContentInset = TSkDisabledChatVerticalContentInset;
    }
    if ([self shouldShowStatusMessageBannerView])
    {
        bottomContentInset = TSkStatusMessageVerticalContentInset;
    }
    // bottomContentInset goes as top in content inset since table inverted
    self.tableView.contentInset = UIEdgeInsetsMake(bottomContentInset, 0, 0, 0);
}

#pragma mark - Universal Bots

- (void)handleExecuteResponse:(TSCAdaptiveCardsActionHandler*)actionHandler
                 withCardView:(ACRView*)acrView
                  messageInfo:(TSMessageInfo*)messageInfo
                executeAction:(TSBotExecuteActionResponseHandler*)executeActionResponse
{
    if (!messageInfo.isLocal.boolValue && !executeActionResponse && [self.accountHandle.ecsManager isRefreshForAdaptiveCardsEnabled])
    {
        TSWeakify(self)
        /**
          This delay is added intentionally to wait for card to load and to avoid queuing auto refresh request when card is in sending state.
          If card has valid auto refresh params and view is ideal only then we will trigger card refresh.
          TODO: Remove the delay and handle the same in the refresh manager
        */
        [TSDispatchUtilities dispatchOnMainThread:^{
            TSStrongifyAndReturnIfNil(self)
            [self.adaptiveCardsUtility processCardRefresh:TSAdaptiveCardAutoRefreshOnCardLoad
                                              withHandler:actionHandler
                                             withCardView:acrView
                                           forMessageInfo:messageInfo
                                   forTableViewController:self];
        } afterDelay:TSkCardAutomaticRefreshTriggerDelay];
    }
}

#pragma mark - TSCustomTitleViewController

- (UIView*) buildTitleDropdownView
{
    if (self.isAnonymouslyJoinedToCall)
    {
        // no chat dropdown for anonymously joined calls chat view.
        return nil;
    }
    
    self.chatDropdown = [AXPApp viewFromId:NSStringFromClass([TSChatDropdownViewController class])];
    [self addChildViewController:self.chatDropdown];
    [self.chatDropdown didMoveToParentViewController:self];
    
    [self.chatDropdown configureWithDelegate:self];
    return self.chatDropdown.view;
}

- (void) removeTitleDropdownView
{
    [self.chatDropdown removeFromParentViewController];
    [self.chatDropdown didMoveToParentViewController:nil];
    self.chatDropdown = nil;
}

- (CGFloat) requiredHeightForTitleDropdown
{
    return [self.chatDropdown requiredHeightForDropdown];
}

- (void) updateCustomTitle:(BOOL)isOpeningDropdown
{
    NSString *titleText = [self getNavTitle];
    NSString *subTitleText = [self getNavSubTitle];
    TSDropdownWithPresenceTitleViewDirection dropdownDirection = [self getDropdownDirectionForIsOpeningDropdown:isOpeningDropdown];
    [self buildTitleView:titleText
            withSubTitle:subTitleText
            showDropdown:self.shouldShowDropdownOnTitle
       dropdownDirection:dropdownDirection
            showPresence:self.shouldShowPresenceOnTitle
           withAnimation:YES];
}

- (TSDropdownWithPresenceTitleViewDirection) getDropdownDirectionForIsOpeningDropdown:(BOOL)isOpeningDropdown
{
    if (self.shouldOpenTitleDropdown)
    {
        return isOpeningDropdown ?
        TSDropdownWithPresenceTitleViewDirectionTop :
        TSDropdownWithPresenceTitleViewDirectionBottom;
    }
    else
    {
        return TSDropdownWithPresenceTitleViewDirectionRight;
    }
}

- (BOOL) shouldShowDropdownOnTitle
{
    BOOL isInGroupCreateState = self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants || self.groupChatCreationState == TSGroupChatCreationStateInChatWithCompose;
    BOOL isGroupTemplate = self.groupTemplateCoordinator && self.thread == nil;
    return !(isInGroupCreateState || isGroupTemplate || self.isAnonymouslyJoinedToCall || self.didAnonJoinCallEnd || (self.accountHandle.ecsManager.leaveMeetingChatEnabledOnECS && [self isMeeting]));
}

- (BOOL) shouldOpenTitleDropdown
{
    return ![self isConsultTransferConversation] && ([self isMeeting] || (self.recipientIDs.count && ![self.threadID isNotNilOrEmpty]));
}

#pragma mark - SMB Privacy Alert

- (void) showPrivacyAlert:(TSMeetingInviteBlock *)inviteBlock
          meetingcardView:(TSChatBubbleMeetingCardView *)meetingCardView
         isUpdateCalendar:(BOOL)isUpdateCalendar
{
    UIAlertController *alert = [TSAlertUtils alertControllerWithTitle:AXPLocalizedString(@"AddToCalendar") message:[self localized: @"AddToCldrPrvcyMsg"]];
    TSWeakify(self);
    UIAlertAction *learnMoreAction = [TSAlertUtils linkOpenActionWithURL:TSMeetingInfoConstants.TSkSMBLearnMoreLink
                                                          withCompletion:^(BOOL success){
        TSStrongify(self);
        [meetingCardView stopLoader];
        [self logTelemetryForAddToCalendar:TSkActionScenarioNameAddToCalendarLearnMore scenarioType:TSkScenarioTypeNav];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:AXPLocalizedString(@"LabelCancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        TSStrongify(self);
        [meetingCardView stopLoader];
        [self logTelemetryForAddToCalendar:TSkActionScenarioNameAddToCalendarCancel scenarioType:TSkScenarioTypeSkip];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:AXPLocalizedString(@"TSOK")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
        TSStrongify(self);
        [self setSMBPrivacyAlertShownFlag];
        [self addToCalendar:inviteBlock meetingCardView:meetingCardView isUpdateCalendar:isUpdateCalendar];
        [self logTelemetryForAddToCalendar:TSkActionScenarioNameAddToCalendarConfirm scenarioType:TSkScenarioTypeNav];
    }];
    
    [alert addAction:learnMoreAction];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *) localized:(NSString *)key
{
    return [self.accountHandle.sharedStrings stringWithKey:key];
}

- (BOOL) getSMBPrivacyAlertShownFlag
{
    return [self.accountHandle.tenantDefaults boolForKey:TSkSMBPrivacyAlertShownKey];
}

- (void) setSMBPrivacyAlertShownFlag
{
    self.isSMBPrivacyAlertShown = YES;
    [self.accountHandle.tenantDefaults setBool:YES forKey:TSkSMBPrivacyAlertShownKey];
}

- (BOOL) shouldShouldPrivacyAlert
{
    return !self.isSMBPrivacyAlertShown && [self.accountHandle.policyManager isSMBCalendarSyncEnabled];
}

#pragma mark - TSChatBannerViewDelegate
- (void)chatBannerCancelAction
{
    [TSDispatchUtilities dispatchOnMainThread:^{
        self.isFederatedBannerCancelled = YES;
        self.customBannerViewContainer.hidden = YES;
    }];
    
    if(self.chatBannerView.chatBannerType == TSkFederatedChatMessageRelatedPolicy)
    {
        [self recordFedUserMsgPolicyBannerDismissal];
        self.hasCancelledFedInfoBanner = YES;
    }
}

- (void)createLeaveChatAlert
{
    UIAlertController *alert;
    if (self.recipientIDs.count < 2)
    {
        alert = [TSAlertUtils alertControllerWithTitle:AXPLocalizedString(@"LeaveChatLabel")
                                               message:AXPLocalizedString(@"OneOnOneChatLeaveChatError")];
        [alert addAction:[UIAlertAction actionWithTitle:AXPLocalizedString(@"TSOK") style:UIAlertActionStyleDefault handler:nil]];
    }
    else
    {
        
        alert = [TSAlertUtils alertControllerWithTitle:AXPLocalizedString(@"LeaveChatLabel")
                                               message:AXPLocalizedString(@"LeaveChatConfirmationMessage")];
        UIAlertAction *leaveAction = [UIAlertAction actionWithTitle:AXPLocalizedString(@"LeaveButtonText")
                                                              style:UIAlertActionStyleDestructive
                                                            handler:^(UIAlertAction * action) {

                                                                // Once you leave group chat you cannot send messages, remove the keyboard.
                                                                [AXPApp sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

                                                                // Leave group chat
                                                                [self leaveGroupChat];
                                                            }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:AXPLocalizedString(@"LabelCancel")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 // Do nothing
                                                             }];
        [alert addAction:leaveAction];
        [alert addAction:cancelAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didTapTextView:(UITextView *)textView
        locationInView:(CGPoint)location
         forBannerType:(NSInteger)bannerType
{
    if(bannerType == TSkFederatedChatMessageRelatedPolicy && [self.federationInfoUtil didSelectLinkIn:textView locationTapped:location])
    {
        [self.federationInfoUtil openExternalAccessPolicyURLFor:self isBannerOnTfl:self.accountHandle.policyManager.isTfwTflFedChatConsumptionOnTflEnabled];
    }
}

- (void) federatedUserSynced:(NSNotification *)notification
{
    if (![self.accountHandle isNotificationForHandle:notification])
    {
        return;
    }
    
    NSDictionary *info = [notification userInfo];
    NSString *userID = info[TSkUserId];
    NSString *email = info[TSkUserEmail];
    
    if (self.isNewFederatedUser &&
        [email isNotNilOrEmpty] &&
        [self.federatedUserDisplayName compareString:email])
    {
        if ([userID isNotNilOrEmpty])
        {
            [TSDispatchUtilities dispatchOnMainThread:^{
                self.recipientIDs = @[userID];
                self.chatBannerView.labelString = [NSString stringWithFormat:AXPLocalizedString(@"FederatedUserIdentifiedLabel"), email];
                self.chatBannerView.enableCancelImage = YES;
                self.chatBannerView.enableLeaveButton = NO;
                self.chatBannerView.enableUserReceivedImage = YES;
                self.federatedUserSynced = YES;
                self.composeView.hidden = NO;
                [self.composeViewController.textBody becomeFirstResponder];
                [self findConversationWithRecipients];
            }];
        }
        else
        {
            NSInteger statusCode = [info[TSkHTTPStatusCode] intValue];
            NSString *errMessage = AXPLocalizedString(@"FederatedFailedChatHeaderInfo");
            if (statusCode == TSkHTTPStatusCodeNotFound)
            {
                errMessage = AXPLocalizedString(@"FederatedFailedChatHeaderUserNotFound");
            }
            else if (statusCode == TSkHTTPStatusCodeForbidden)
            {
                errMessage = AXPLocalizedString(@"FederatedFailedChatHeaderForbidden");
            }
            [TSDispatchUtilities dispatchOnMainThread:^{
                self.chatBannerView.labelString = errMessage;
                self.chatBannerView.enableCancelImage = YES;
                self.chatBannerView.enableLeaveButton = NO;
                self.chatBannerView.enableUserReceivedImage = NO;
            }];
        }
    }
}

- (UIEdgeInsets)visibleAreaInsets
{
    if (!self.customBannerViewContainer.isHidden)
    {
        return UIEdgeInsetsMake(self.customBannerViewContainer.bounds.size.height, 0, 0, 0);
    }
    else if (!self.locationBannerViewContainer.isHidden)
    {
        return UIEdgeInsetsMake(self.locationBannerViewContainer.bounds.size.height, 0, 0, 0);
    }
    
    return UIEdgeInsetsZero;
}

#pragma mark - TSChatDropdownDelegate

// if there is no threadID / meeting, open drop down or else open chat details page
- (void) openTitleDropdown
{
    if (self.shouldOpenTitleDropdown)
    {
        [super openTitleDropdown];
    }
    else
    {
        if ([self isMeeting])
        {
            [self showMeetingChatDetails];
        }
        else
        {
            [self showChatDetails];
        }
    }
}

- (BOOL) shouldShowMeetingChatDetails
{
    return self.recipientIDs.count && self.threadID.length && !self.shouldConfigureForMeetings;
}

- (void) showMeetingChatDetails
{
    if (self.shouldShowMeetingChatDetails)
    {
        if(self.calendarEventDetailsViewData)
        {
            [self performSegue:TSkSeguePushMeetingChatDetails withViewInfo:@{TSkThreadID : self.threadID, @"recipientIds" : self.recipientIDs, TSkMeetingItemViewData : self.calendarEventDetailsViewData}];
        }
        else
        {
            [self performSegue:TSkSeguePushMeetingChatDetails withViewInfo:@{TSkThreadID : self.threadID, @"recipientIds" : self.recipientIDs}];
        }
    }
}

- (BOOL) shouldShowChatDetails
{
    return self.threadID.length > 0;
}

- (void) showChatDetails
{
    if ([self shouldShowChatDetails])
    {
        if (self.isChatWithSelf)
        {
            [self performSegue:TSkSeguePushChatDetails withViewInfo:@{
                TSkThreadID : self.threadID
            }];
            return;
        }
        
        BOOL isBot = NO;
        if (self.recipientIDs.count) {
            TSUserInfo *user = [self userInfoForID:[self.recipientIDs firstObject]];
            if (self.threadType == TSThreadTypeOneOnOneChat && user.isBot)
            {
                isBot = YES;
            }
        }
        BOOL isNotInteropChat = self.threadType != TSThreadTypeInteropChat;
        BOOL isNotUnknownChat = self.threadType != TSThreadTypeUnknown;
        BOOL isFederatedChatButFedGroupChatNotEnabled = !([self.accountHandle.ecsManager nativeFedGroupChatEnabled] || self.accountHandle.policyManager.isTfwTflFedChatCreationOnTfwEnabled) && [self isTfLInterOpOrOffNetworkFedChat];
        BOOL isNotSMSChat = self.threadType != TSThreadTypePhoneChat;
        BOOL shouldShowFedChatInfo = self.accountHandle.policyManager.isTfwTflFedChatConsumptionPhase2OnTflEnabled && self.shouldLimitComposeOptnInFedChat;
        
        BOOL isCreateNewChatEnabled = isNotInteropChat && isNotUnknownChat && !isFederatedChatButFedGroupChatNotEnabled
                                        && isNotSMSChat && ![self isOneOnOneFedChatWithFedChatCreationDisabled];
        // TODO : once SMS supports muting, remove muteChatDisabled for SMSChats
        __weak typeof(self) weakSelf = self;
        [self performSegue:TSkSeguePushChatDetails withViewInfo:@{TSkChatParticipantsList: self.recipientList,
                                                                  TSkThreadID : self.threadID,
                                                                  @"isBot": @(isBot),
                                                                  @"createNewChatEnabled": @(isCreateNewChatEnabled),
                                                                  @"muteChatEnabled": @(isNotSMSChat),
                                                                  TSkShouldShowFedChatInfo: @(shouldShowFedChatInfo),
                                                                  TSkOnChatRenamed: ^(NSString *chatTitle) {
            weakSelf.topicName = chatTitle;
        }
        }];
    }
}

- (void) dismissChatDropdown
{
    [self closeTitleDropdown:nil];
}

- (BOOL) isMeeting
{
    if ([self.threadID isNotNilOrEmpty])
    {
        TSConversation *conv = [AXPCtx conversationForID:self.threadID];
        if (conv != nil && ![conv isChatConversation])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL) showRecipientListForOnetoOneGroup {
    return self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants;
}

- (NSArray<TSEntitySearchResultItem*> *) recipientList
{
    NSMutableArray<TSEntitySearchResultItem*> *searchResultList = NSMutableArray.new;
    for (NSString *recipientId in self.recipientIDs)
    {
        TSUserInfo *person = [self userInfoForID:recipientId];
        if (person)
        {
            TSEntitySearchResultItem *searchResultItem = [[TSEntitySearchResultItem alloc] initWithItem:person.tsID sort:person.displayName type:TSkEntitySearchResultTypeUser];
            [searchResultList addObject:searchResultItem];
        }
        
        // in TFL, there is a scenario where user compose chat and search for new email say red@outlook.com
        // we wanna inlude this email search result in recipient list because
        // user cannot visit profile from chat dropdown as it does not include recipient id
        
        else if (self.accountHandle.policyType == TSPolicyTypeLife)
        {
            TSEntitySearchResultItem *searchResultItem = [[TSEntitySearchResultItem alloc] initWithItem:recipientId sort:recipientId type:TSkEntitySearchResultTypeUser];
            [searchResultList addObject:searchResultItem];
        }
    }
    
    return [searchResultList sortedArrayUsingComparator:^NSComparisonResult(TSEntitySearchResultItem *a, TSEntitySearchResultItem *b) {
        NSString* first = a.sort ?: AXPLocalizedString(@"UnknownUser");
        NSString* second = b.sort ?: AXPLocalizedString(@"UnknownUser");
        return [first compare:second];
    }];
}

- (void) addPeopleInChat
{
    // TODO: implement add people later
    [self closeTitleDropdown:nil];
}

- (void) leaveChat
{
    // TODO: implement leave chat later
    [self closeTitleDropdown:nil];
}

- (void) enableNotifications:(BOOL)isEnabled
{
    // TODO: implement notifications later
    [self closeTitleDropdown:nil];
}

- (void) viewProfile:(TSEntitySearchResultItem *)searchResultItem
{
    if (searchResultItem &&
        searchResultItem.type &&
        searchResultItem.type.integerValue == TSkEntitySearchResultTypeUser &&
        !self.isAnonymouslyJoinedToCall)
    {
        NSString *userId = (NSString *)searchResultItem.item;
        __weak TSChatViewController *weakSelf = self;
        [self closeTitleDropdown:^
         {
            // YES to allow navigating from a group chat to a 1:1 chat.
            [weakSelf openPeopleCardForUser:userId withChatEnabled:YES];
        }];
    }
}

- (void) dismissComposeBox
{
    if (self.toViewController.selectedRecipients.count != 0)
    {
        [self.toViewController entitySearchBarViewControllerResetSearch];
    }
    [AXPApp resignFirstResponder];
    [self animateBottomOffsetIfNeeded];
}

- (void) dismissBotMenu
{
    [self.botMenuProvider.botMenuClientRequestHandler createUpdateMenuStateRetractedRequest];
}

- (void) tappedOnChat:(UITapGestureRecognizer*)recognizer
{
    if ([TSUtilities isTableViewScrolling:self.tableView])
    {
        return;
    }
    
    CGPoint rowLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:rowLocation];
    if (path)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        if (cell)
        {
            if ([cell isKindOfClass:TSChatMessageViewCell.class])
            {
                [(TSChatMessageViewCell *)cell tappedOnChatMessage:recognizer
                                                    viewController:self
                                                     accountHandle:self.accountHandle];
            }
//            else if ([cell isKindOfClass:TSFluidTablePreviewCell.class])
//            {
//                NSDictionary *itemData = [self dataForRowAtIndexPath:path inTableView:self.tableView];
//                TSMessageInfo *messageInfo = [self messageFromItemData:itemData];
//                CGFloat fluidHeaderHeight = [messageInfo.isSentByMe boolValue] ? TSkFluidPreviewHeaderSentByMeHeight : TSkFluidPreviewHeaderHeight;
//                CGPoint locationInCell = [recognizer locationInView:cell];
//
//                CGFloat locationMaxHeight = [self.tableView rectForRowAtIndexPath:path].size.height;
//                if (messageInfo.reactionsSummary > 0)
//                {
//                    CGFloat reactionViewHeight = 30.0;
//                    locationMaxHeight -= reactionViewHeight;
//                }
//
//                if (locationInCell.y >= fluidHeaderHeight && locationInCell.y < locationMaxHeight)
//                {
//                    TSFluidTablePreviewCell *fluidPreviewCell = (TSFluidTablePreviewCell *)cell;
//                    CGPoint locationInCellCardView = [recognizer locationInView:fluidPreviewCell.fluidCardView];
//                    if (locationInCellCardView.x > 0 && locationInCellCardView.x < fluidPreviewCell.fluidCardView.bounds.size.width) {
//                        [self didPressedFluidTablePreviewCellWith:self.fluidService messageInfo:messageInfo inEditMode:NO];
//                    }
//                }
//            }
            else if (UIAccessibilityIsVoiceOverRunning() && cell && [cell isKindOfClass:TSRetentionPolicyMessageViewCell.class])
            {
                [(TSRetentionPolicyMessageViewCell *) cell openInfoUrl];
            }
        }
    }

    [UIView animateWithDuration:0 animations:^{
        [self dismissBotMenu];
    }];

    [self dismissComposeBox];
}

- (void) multipleTapOnChat:(UITapGestureRecognizer*)recognizer
{
    if ([TSUtilities isTableViewScrolling:self.tableView])
    {
        return;
    }
    
    CGPoint rowLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:rowLocation];
    if (path)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        if (cell && [cell isKindOfClass:TSChatMessageViewCell.class])
        {
            TSSMessage *message = [self messageForCellAtIndexPath:path];
            if ([self.contextOptionsHandler supportReactionForMessage:message])
            {
                BOOL isDoubleTap = NO;
                if (recognizer == self.doubleTappedOnCellGesture)
                {
                    isDoubleTap = YES;
                }
                [self handleQuickReaction:message isDoubleTap:isDoubleTap];
            }
        }
    }
}

- (void) tappedOnPreviousConversationCell:(UITapGestureRecognizer*)recognizer
{
    __weak typeof(self) weakSelf = self;
    if ([self.previousFederationThreadID length])
    {
        NSDictionary *viewInfo = @{ TSkThreadID : self.previousFederationThreadID };
        [TSDispatchUtilities dispatchOnMainThread:^
         {
            weakSelf.nativeFederationThreadID = weakSelf.threadID;
            [weakSelf willNavigateToSelf:viewInfo];
        }];
    }
    
    [self.logger logPanelAction:TSkActionLegacyChatLink
                        outCome:TSkActionOutcomeNav
                        gesture:TSkActionGestureTap
                       scenario:TSkActionLegacyChatLink
                   scenarioType:TSkScenarioTypeFederatedUpgrade
                 destinationuri:nil
           destinationUriParams:nil
                     moduleType:TSkActionModuleTypeListItem
                    moduleState:nil
                  moduleSummary:nil
                       threadId:self.threadID];
}

- (void) tappedOnNativeFederationChatCell:(UITapGestureRecognizer*)recognizer
{
    NSString *actionName = @"";
    if ([self.nativeFederationThreadID length])
    {
        [self navigateToNativeFederationChatViewByThreadID:self.nativeFederationThreadID];
        actionName = TSkActionNativeChatLink;
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        NSString *correlationID = [@"NativeFederationChatChatFind:" stringByAppendingString:[[NSUUID UUID] UUIDString]];
        [TSSyncEngine.sharedInstance.threadSyncManager findOrCreateChatThread:self.recipientIDs
                                                             previousThreadId:self.threadID
                                                                correlationID:correlationID
                                                                accountHandle:self.accountHandle
                                                threadCreationDataBagOverride:^NSDictionary *()
     {
        return [self newThreadCreatedTelemetryDatabag];
    }
                                                                   completion:^(NSString *threadID, NSError *err, BOOL hasMultiStatusResponse)
         {
            if ([threadID isNotNilOrEmpty])
            {
                weakSelf.nativeFederationThreadID = threadID;
                [weakSelf navigateToNativeFederationChatViewByThreadID:threadID];
            }
            else
            {
                LogWarningAH(weakSelf.logger, @"Couldn't navigate to native fed chat");
                [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"GenericErrorDialogTitle")
                                                    andMessage:AXPLocalizedString(@"UnknownChatTitle")
                                              andButtonContent:AXPLocalizedString(@"TSOK")
                                             andViewController:weakSelf];
            }
        }];
        actionName = TSkActionFederatedUpgradeNewChat;
    }
    
    [self.logger logPanelAction:actionName
                        outCome:TSkActionOutcomeNav
                        gesture:TSkActionGestureTap
                       scenario:actionName
                   scenarioType:TSkScenarioTypeFederatedUpgrade
                 destinationuri:nil
           destinationUriParams:nil
                     moduleType:TSkActionModuleTypeListItem
                    moduleState:nil
                  moduleSummary:nil
                       threadId:self.threadID];
}

- (void) navigateToNativeFederationChatViewByThreadID:(NSString *)nativeFederationChatThreadID
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *viewInfo = @{ TSkThreadID : nativeFederationChatThreadID };
    [TSDispatchUtilities dispatchOnMainThread:^
     {
        weakSelf.previousFederationThreadID = weakSelf.threadID;
        [weakSelf willNavigateToSelf:viewInfo];
    }];
}

- (void)longPressedOnChat:(UILongPressGestureRecognizer*)recognizer
{
    if ([TSUtilities isTableViewScrolling:self.tableView])
    {
        return;
    }
    
    if (UIGestureRecognizerStateBegan == recognizer.state)
    {
        CGPoint rowLocation = [recognizer locationInView:self.tableView];
        NSIndexPath *path = [self.tableView indexPathForRowAtPoint:rowLocation];
        if (path)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
            if (cell)
            {
                if ([cell isKindOfClass:TSChatMessageViewCell.class])
                {
                    TSChatMessageViewCell *chatMessageCell = (TSChatMessageViewCell *)cell;
                    
                    [self.longPressImpact impactOccurred];
                    
                    if ([chatMessageCell.fileAttachmentViews count])
                    {
                        CGRect fileAttachmentView = [chatMessageCell.fileAttachmentStackView convertRect:chatMessageCell.fileAttachmentStackView.bounds toView:self.tableView];
                        if (CGRectContainsPoint(fileAttachmentView, rowLocation))
                        {
                            return;
                        }
                    }
                    
                    TSSMessage *message = [TSSMessage messageForID:chatMessageCell.messageID
                                                       andThreadID:chatMessageCell.threadID
                                            inManagedObjectContext:self.accountHandle.mainMOC];
                    
                    NSDictionary *rrParams = nil;
                    if ([self shouldShowReadByInContextMenuForMsg:message])
                    {
                        NSInteger seenByCount = [self getSeenByCountForMessage:message.ts_numericArrivalTime];
                        NSInteger totalRecipientCount = [[self recipientIDs] count];
                        rrParams = @{
                            TSkReadReceiptSeenByCountKey : @(seenByCount),
                            TSkReadReceiptTotalRecipientsCountKey : @(totalRecipientCount)
                        };
                    }
                    
                    if ([chatMessageCell longPressedOnLink:recognizer viewController:self readReceiptsParams:rrParams])
                    {
                        return;
                    }
                    
                    if ([self handleLongPressForAdaptiveCardIfNecessary:chatMessageCell
                                                            withMessage:message
                                                          forTouchPoint:rowLocation])
                    {
                        return;
                    }
                    
                    [self triggerLongPressHighlightOnCell:chatMessageCell];
                    
                    CGRect messageBubbleViewRect = [chatMessageCell.messageBubbleView convertRect:chatMessageCell.messageBubbleView.bounds toView:self.tableView];
                    if (CGRectContainsPoint(messageBubbleViewRect, rowLocation))
                    {
                        [self openPopupForMessageAtPath:path withBaseView:chatMessageCell.messageBubbleView];
                    }
                }
                else if ([cell isKindOfClass:TSChatRecordingCardViewCell.class])
                {
                    TSChatRecordingCardViewCell *recordingMessageCell = (TSChatRecordingCardViewCell *)cell;
                    CGRect recordingThumbnailRect = [recordingMessageCell.recordingThumbnail convertRect:recordingMessageCell.recordingThumbnail.bounds toView:self.tableView];
                    if (CGRectContainsPoint(recordingThumbnailRect, rowLocation) && recordingMessageCell.shouldAllowLongPress)
                    {
                        [self openPopupForMessageAtPath:path withBaseView:recordingMessageCell.recordingThumbnail];
                    }
                }
//                else if ([cell isKindOfClass:TSFluidTablePreviewCell.class])
//                {
//                    TSFluidTablePreviewCell *fluidCell = (TSFluidTablePreviewCell *)cell;
//                    CGRect messageViewRect = [fluidCell.fluidCardView convertRect:fluidCell.fluidCardView.bounds toView:self.tableView];
//                    if (CGRectContainsPoint(messageViewRect, rowLocation))
//                    {
//                        [self openPopupForMessageAtPath:path withBaseView:fluidCell.contentView];
//                    }
//                }
            }
        }
    }
}

- (void)triggerLongPressHighlightOnCell:(TSChatMessageViewCell *)cell
{
    [self updateTable:^{
        self.longPressMessageID = cell.messageID;
        
        NSIndexPath *indexPathToReload = self.itemLookupMap[self.longPressMessageID];
        if (indexPathToReload)
        {
            if ([[self.tableView indexPathsForVisibleRows] containsObject:indexPathToReload])
            {
                [self.tableView reloadRowsAtIndexPaths:@[indexPathToReload] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
}

- (BOOL)handleLongPressForAdaptiveCardIfNecessary:(UITableViewCell *)cell
                                      withMessage:(TSSMessage *)message
                                    forTouchPoint:(CGPoint)touchPoint
{
    if (![cell isKindOfClass:TSChatMessageViewCell.class])
    {
        return NO;
    }
    TSChatMessageViewCell *adaptiveCardsCell = (TSChatMessageViewCell *)cell;
    UIStackView *cardView = adaptiveCardsCell.messageStackView;
    BOOL handleLongPressForCardViews = [self.longPressHandler handleLongPressForAdaptiveCardIfNecessaryForCardViews:[cardView arrangedSubviews]
                                                                                                        fromMessage:message
                                                                                                      forTouchPoint:touchPoint];
    return handleLongPressForCardViews ? YES : [self handleLongPressForAdaptiveCardsRootLevelActions:adaptiveCardsCell forMessage:message];
}

- (BOOL)handleLongPressForAdaptiveCardsRootLevelActions:(TSChatMessageViewCell *)cell
                                      forMessage:(TSSMessage *)message
{
    if (cell.adaptiveCardsActionHandler && cell.adaptiveCardsActionHandler.rootLevelAlertActions && cell.adaptiveCardsActionHandler.rootLevelAlertActions.count != 0)
    {
        [self.platformTelemetryLogger logTelemetryForOverflowWithScenario:TSkOverflowMenuAdaptiveCard
                                                                  outcome:TSkLaunchOverflowActionSheet
                                                               moduleName:TSkCardLongPress
                                                                 cardType:TSBotCardContentTypeAdaptive
                                                                messageId:message.tsID
                                                                panelType:self.panelType];
        [self.msgVCUtility presentRootLevelActionsOnInputExtensionsAlertController:cell.adaptiveCardsActionHandler.rootLevelAlertActions];
        return YES;
    }
    return NO;
}

- (void) openPopupForMessageAtPath:(NSIndexPath*)path withBaseView:(UIView *)view
{
    TSMessageInfo *messageInfo = [self dataAtIndexPath:path];
    if ([TSUtilities shouldGetDLPPolicyInfoAndReturnForMessageInfo:messageInfo hostViewController:self baseView:view])
    {
        return;
    }
    
    [self continueOpeningPopupForMessageInfo:messageInfo withBaseView:view];
}

- (void)continueOpeningPopupForMessageInfo:(TSMessageInfo *)info withBaseView:(UIView *)view
{
    if (self.messageLikersPopup == nil)
    {
        self.messageLikersPopup = [[TSMessageLikersPopupController alloc]init];
    }
    
    TSSMessage *message = [TSSMessage messageForID:info.tsID andThreadID:info.threadID inManagedObjectContext:self.accountHandle.mainMOC];
    if (self.isFluidObjectEnabled && [self.fluidService isFluidMessageWithInfo:info messageEntity:message fromAccount:self.accountHandle])
    {
        self.fluidPopupViewController = [TSFluidPreviewCellPopUpActionsViewController viewControllerWithMessage:message
                                                                                                withMessageInfo:info
                                                                                               withFluidService:self.fluidService
                                                                                                   withDelegate:(id<TSFluidPopUpActionDelegate>)self.contextOptionsHandler];
        [self.fluidPopupViewController openFluidPopupForHostViewController:self baseView:view accountHandle:self.accountHandle];
        return;
    }
    
    NSInteger totalRecipientCount = [[self recipientIDs] count];
    [TSDispatchUtilities dispatchOnMainThread:^{
        TSSMessage *message = [AXPCtx messageForID:info.tsID andThreadID:info.threadID];
        NSInteger seenByCount = [self getSeenByCountForMessage:message.ts_numericArrivalTime];
        NSString *seenByList = self.accountHandle.policyManager.shouldShowReadByInContextMenuForAllMessage ?
                               [self getSeenByList:message seenByCount:seenByCount totalCount:totalRecipientCount] : @"";
        NSDictionary *rrParams = @{
            TSkReadReceiptSeenByCountKey : @(seenByCount),
            TSkReadReceiptTotalRecipientsCountKey : @(totalRecipientCount),
            TSkReadReceiptSeenByListKey : seenByList
        };
        
        [self.logger logPanelAction:TSkActionModuleContextMenuOptions
                            outCome:nil
                            gesture:TSkActionGestureLongTap
                           scenario:TSkScenarioMessageLongPress
                       scenarioType:TSkScenarioTypeChatContextMenu
                         moduleType:TSkActionModuleTypeMessage
                          panelType:TSkPanelTypeChat
                           panelUri:nil
                           threadId:self.threadID
                         threadType:nil
                           metaData:nil];
        
        [self.messageLikersPopup openPopupForMessage:message
                                  readReceiptsParams:rrParams
                                   forViewController:self
                                        withDelegate:self.contextOptionsHandler
                                        withBaseView:view
                           withRestoreVoiceOverFocus:YES];
    }];
}

- (void) traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    [self updateBottomConstraint];
}

- (void)updateBottomConstraint
{
    CGFloat newBottomConstant = self.bottomConstant;
    if (IS_IPAD() || ![self tabBarHidden])
    {
        newBottomConstant = self.shouldApplyTabBarInsets ? TSkComposeBottomConstantForiPad : 0;
    }
    
    if (IS_IPAD() || ![self tabBarHidden] || self.bottomConstant != newBottomConstant)
    {
        // Necessary to fix bug https://domoreexp.visualstudio.com/DefaultCollection/MSTeams/_workitems/edit/245527
        // Constraining bottom to safeArea does not work as expected in iPad when splitView isCollapsed, so
        // we constrain to superView.  Seems like an Apple bug.
        BOOL isCollapsed = !self.splitViewController || self.splitViewController.isCollapsed;
        if (isCollapsed || (self.isSideBarEnabledAndShowing && self.composeViewController.hasFirstResponder))
        {
            self.stackviewBottomToSafeArea.active = NO;
            self.stackviewBottomToSuperView.active = YES;
            self.targetBottomConstraint = self.stackviewBottomToSuperView;
        }
        else
        {
            self.stackviewBottomToSafeArea.active = YES;
            self.stackviewBottomToSuperView.active = NO;
            self.targetBottomConstraint = self.stackviewBottomToSafeArea;
        }
        
        // iPad does not always collapse UITabBar, increase space between top of UITabBar and bottom of compose view if needed
        self.bottomConstant = newBottomConstant;
        
        self.targetBottomConstraint.constant = self.keyboardHeight + self.bottomConstant;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view setNeedsLayout];
        }];
    }
}

- (void)checkAndRefreshChatForMeeting:(BOOL)MeetingInProgress
{
    
    // normally a meeting must have a thread but just in case
    
    if (self.thread && MeetingInProgress)
    {
        if (!self.forceEnableChat)
        {
            self.forceEnableChat = YES;
            LogInfoAH(self.logger, @"TSChatViewController: checkAndRefreshChatForMeeting force enabling meeting chat");
            [self disableChatAndUpdateComposeView:NO];
        }
    }
    else
    {
        if (self.forceEnableChat)
        {
            LogInfoAH(self.logger, @"TSChatViewController: checkAndRefreshChatForMeeting canceling forceEnable meeting chat");
            self.forceEnableChat = NO;
            if ([self.thread isDisabledChatWithInProgressMeetingOption:YES meetingInProgress:MeetingInProgress])
            {
                [self disableChatAndUpdateComposeView:YES];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    BOOL isMessageExtensionDiscoveryEnabled = [self.discoverabilityService isMessageExtensionDiscoverabilityEnabled];
    NSDictionary *metaData = nil;
    NSString *redDotScenarioID = nil;
    if (isMessageExtensionDiscoveryEnabled)
    {
        BOOL isRedDotVisible = [self.settingsService boolForKey:TSkNewFlagAppsKey defaultValue:NO];
        metaData = @{TSkRedDotMetaDataKey : @(isRedDotVisible)};
        if (isRedDotVisible)
        {
            ScenarioEvent *scenarioEvent = [[ScenarioEvent alloc] initWithScenarioName:TSkRedDotScenarioID properties:@{}];
            redDotScenarioID = [self.accountHandle.logger logScenarioStartWithEvent:scenarioEvent];
        }
    }
    [self.accountHandle.logger logPanelView:TSkPanelTypeChatStart
                               launchMethod:TSkLaunchMethodNav
                                   panelUri:TSkPanelUriConversation
                             panelUriParams:nil
                                     region:TSkRegionMain
                                   metadata:[TSUtilities metaDataFromDataBagDictionary:metaData]];
    
    self.customBannerViewContainer.hidden = YES;
    
    if ([self.composeViewController isKindOfClass:TSCompactComposeViewController.class])
    {
        ((TSCompactComposeViewController *)self.composeViewController).redDotScenarioID = redDotScenarioID;
    }
    
    if (self.accountHandle.policyManager.shouldDisableAudioOrVideoOnCellular)
    {
        [[TSMobilityPolicySettingsManager sharedInstance] addObserver:self accountHandle:self.accountHandle];
    }
    
    if (IS_IPAD_REGULAR())
    {
        [self updateNavigationRightBarItemsAnimated:NO];
    }
    [self updateRecipientList];
    [self updateFederationPropertiesForRoster];
    [self showJoinBannerIfRequired];
    [self showChatViewBannerIfRequired];
    [self updateChatHeaderViewVisibilityIfNeeded];
    
    [[self.accountHandle.logger teamChannelThreadInfo] removeAllObjects];
    [[self.accountHandle.logger teamChannelThreadInfo] setObject:TSkThreadTypeChat forKey:TSkTelemetryTeamID];
    [[self.accountHandle.logger teamChannelThreadInfo] setObject:TSkThreadTypeChat forKey:TSkTelemetryTeamType];
    [self updateThreadTelemetryProperties];
    
    if (self.initiateChatWithTBot)
    {
        [self.toViewController initiateChatWithTBot];
        self.initiateChatWithTBot = nil;
    }
    
    if (self.groupChatCreationState == TSGroupChatCreationStateInChatWithCompose)
    {
        if (self.createChatWithRecipientIDs && self.recipientIDs.count > 0)
        {
            [self.toViewController initiateGroupChatWithRecipientIDs:self.recipientIDs];
        }
        else
        {
            [self.toViewController initiateGroupChatWithUser:self.userSearchResultItem];
        }
        self.groupChatCreationState = TSGroupChatCreationStateNoOp;
    }
    
    [super viewWillAppear:animated];
    
    [self correctNavigationBarForNavBarOpaqueness:YES];
    
    if (self.accountHandle.policyManager.isNavigationBarStylingL2Enabled)
    {
        //with the bar restyling the badge is the backbutton that might be restored
        [self createBadgedBackButtonIfNeeded];
    }
    
    [self updateBottomConstraint];
    
    [self forceTabBarToHideIfNecessary];
    
    if (self.chatWithTBot && !self.initiateChatWithTBot)
    {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.composeViewController.textBody);
    }
    else if([self.scenarioEntryPoint isEqual:TSkEntryPointChatList])
    {
        UIAccessibilityElement *uiElement = (UIAccessibilityElement *)self.composeViewController.textBody;
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, uiElement);
    }
    
    if (![self.threadID length])
    {
        [self.accountHandle.logger logScenarioStopEvent:self.chatCreateScenarioID status:ScenarioStatusOK];
    }
    else
    {
        [self addObserverToNotificationCenterForNotificationName:TSkOneConversationSynced selector:@selector(threadUpdated:)];
    }
    
    if (self.multiCallBannerViewManager)
    {
        [self.multiCallBannerViewManager elementViewWillAppear];
    }
    
    if (self.transferBannerViewManager)
    {
        [self.transferBannerViewManager elementViewWillAppear];
    }
    
    if (self.needToRegisterForNotifications)
    {
        [self addObserverToNotificationCenterForNotificationName:TSkConversationDeleted selector:@selector(conversationDeleted:)];
        [self addObserverToNotificationCenterForNotificationName:UIApplicationDidBecomeActiveNotification selector:@selector(appDidBecomeActive:)];
        [self addObserverToNotificationCenterForNotificationName:TSkCallingEnabledUpdated selector:@selector(callingEnabledConfigurationChanged:)];
        [self addObserverToNotificationCenterForNotificationName:TSkGroupCallingEnabledUpdated selector:@selector(callingEnabledConfigurationChanged:)];
        [self addObserverToNotificationCenterForNotificationName:TSkPrivateMeetingEnabledUpdated selector:@selector(privateMeetingEnabledConfigurationChanged:)];
        [self addObserverToNotificationCenterForNotificationName:TSkVideoCallingEnabledUpdated selector:@selector(callingEnabledConfigurationChanged:)];
        [self addObserverToNotificationCenterForNotificationName:TSkACImageDownloadNotification selector:@selector(adaptiveCardImageDownloaded:)];
        [self addObserverToNotificationCenterForNotificationName:UIApplicationWillEnterForegroundNotification selector:@selector(appWillEnterForeground:)];
        [self addObserverToNotificationCenterForNotificationName:UIApplicationWillResignActiveNotification selector:@selector(appWillResignActive:)];
        [self addObserverToNotificationCenterForNotificationName:TSkPageOneChatsConversationsThreadsAndUsersSynced selector:@selector(chatConversationsUpdated:)];
        [self addObserverToNotificationCenterForNotificationName:TSkOneConversationSynced selector:@selector(syncConversationInfo:)];
        [self addObserverToNotificationCenterForNotificationName:TSkChatBadgeCountChangedNotification selector:@selector(badgeCountChanged:)];
        [self addObserverToNotificationCenterForNotificationName:TSkNavigateAwayFromCall selector:@selector(showJoinBannerIfRequired)];
        [self addObserverToNotificationCenterForNotificationName:TSkFederatedUsersSynced selector:@selector(federatedUserSynced:)];
        [self addObserverToNotificationCenterForNotificationName:TSkConversationMarkedUnread selector:@selector(conversationMarkedUnread:)];
        [self addObserverToNotificationCenterForNotificationName:TSkMemberConsumptionHorizonUpdateReceived selector:@selector(memberConsumptionHorizonUpdated:)];
        [self addObserverToNotificationCenterForNotificationName:TSkFileProgressStateNotification selector:@selector(updateFileProgressState:)];
        [self addObserverToNotificationCenterForNotificationName:TSkMessageSentA11yNotif selector:@selector(messageSent:)];
        if (!IS_IPAD())
        {
            [self addObserverToNotificationCenterForNotificationName:UIKeyboardWillChangeFrameNotification selector:@selector(keyboardChanged:)];
            [self addObserverToNotificationCenterForNotificationName:UIKeyboardWillHideNotification selector:@selector(keyboardChanged:)];
        }
        
        
        if ([TSPresenceService defaultService].trackUserPresence)
        {
            [self addObserverToNotificationCenterForNotificationName:TSUserPresenceStatusChangedForChatList selector:@selector(userPresenceStatusChanged)];
        }
        
        if ([self.recipientIDs count] < self.maxGroupChatParticipantsForFanout)
        {
            [self addObserverToNotificationCenterForNotificationName:TSkControlTypingMessageReceivedNotification selector:@selector(controlTypingMessageReceived:)];
        }
        
        if ([self.thread isOneOnOneChat])
        {
            [self addObserverToNotificationCenterForNotificationName:TSkSSOAuthMessageReceivedNotification selector:@selector(startSilentAuthForBotSSOWithNotification:)];
        }
        
        if ([TSTranslationManager isAutomaticChatTranslationSuggestionEnabled:self.accountHandle])
        {
            [self addObserverToNotificationCenterForNotificationName:TSkTranslationNotificationSettingsChangedFromSuggestion selector:@selector(updateChatMessages:)];
        }
        
        NSDictionary *ephMessagePayload = [[TSPlatformBotSSOCache sharedInstance]fetchPayloadWithThreadId:self.threadID];
        if (ephMessagePayload)
        {
            [self startSilentAuthForBotSSOWithNotification: nil];
        }
        if (self.accountHandle.policyManager.isSmartReplyEnabled)
        {
            LogInfoAH(self.logger, @"SmartReply: SR is ON");
            [self.accountHandle.logger logPanelView:TSkSmartReplyEnabled scenario:nil scenarioType:nil];
            
            [self addObserverToNotificationCenterForNotificationName:TSkSmartReplyModified selector:@selector(updateSmartReply:)];
        }
        
        self.needToRegisterForNotifications = NO;
    }
    
    __weak typeof(self) weakSelf = self;
    self.composeLocationObserver = [AXPObserver observerForObject:self.composeViewController.bottomEdge key:@"center" onChange:^(AXPListener *listener, NSDictionary *change)
                                    {
        [weakSelf updateViewConstraints];
    }];
    
    [self updateViewConstraints];
    
    if ((self.isNewFederatedUser && !self.federatedUserSynced) || self.groupChatCreationState == TSGroupChatCreationStateStart)
    {
        [self.toView setHidden:YES];
        [self.composeView setHidden:YES];
    }
    
    
    if (self.keyboardHeight != 0 &&
        !self.composeViewController.textBody.isFirstResponder &&
        !self.composeViewController.textSubject.isFirstResponder &&
        !self.isFirstResponder &&
        !self.shouldShowKeyboard)
    {
        self.keyboardHeight = 0;
        self.targetBottomConstraint.constant = self.bottomConstant;
        [self.composeViewController applyMaxLineCountToBodyTextView];
        [self updateBottomConstraint];
    }
    
    [self removeButtonsForInteropThreadIfNeeded];

    if ([self.threadID length]) {
        [self.coachMarkManager showDashboardCoachMarkIfNeeded];
        [self.accountHandle.mruCache addChatIDToMRU:self.threadID];
    }
    
    // Used to set back button to dark mode if this view has dark mode forced on.
    // When all calling views force dark theme, this can be configured just once in TSCallMainStageViewController by setting its navigation item back button.
    // Doesn't need to be reset because `AXPAppViewController` clears nav item on `viewWillAppear`.
    if (self.legacyAppearanceProxy != TSTheme.current && self.isMovingToParentViewController)
    {
        self.navigationController.navigationBar.backItem.backBarButtonItem.tintColor = self.legacyAppearanceProxy.dominantIconColor;
    }
    
    if ([self shouldShowNavigationBarHairlineWhenDashboardHeaderEntryPointIsEnabled])
    {
        [self.navigationController.navigationBar.standardAppearance setShadowColor:StylesheetManager.S.ElementColor.divider];
        [self.navigationController.navigationBar.scrollEdgeAppearance setShadowColor:StylesheetManager.S.ElementColor.divider];
    }
    
    [self updateBubbleColors];
    [self applyDynamicDecorationIfNeeded];
}

- (void)removeButtonsForInteropThreadIfNeeded
{
    // Hide extra compose buttons for SfB and SfC Interops in the new single compose input UI
    if ([self.composeViewController isKindOfClass:TSCompactComposeViewController.class])
    {
        if (self.threadType == TSThreadTypeInteropChat)
        {
            [(TSCompactComposeViewController *)self.composeViewController removeButtonsForInteropThread];
        }
        else
        {
            [(TSCompactComposeViewController *)self.composeViewController showButtonsForInteropThread];
        }
    }
}

-(void)messageSent:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    
    BOOL isForwardedMessage = [dict[TSkMessageSentA11yNotifForwarded] boolValue];
    BOOL isLocalMessage = ![NSString isNilOrEmpty:dict[TSkThreadID]]  && [self.threadID isEqualToString:dict[TSkThreadID]];
    
    if (isLocalMessage || isForwardedMessage)
    {
        [[TSAccessibilityNotificationHelper sharedInstance] delayQueueMessage:AXPLocalizedString(@"MessageSentAccessibilityLabel") withDelayInSeconds:TSkMessageSendAnnouncementDelay];
        [self processRecipientOnMessageSent];
    }
}

-(void)processRecipientOnMessageSent
{
    if (self.accountHandle.policyManager.shouldAddContactOnMessageSent && self.shouldSendAddContactRequest && self.recipientIDs.count > 0)
    {
        LogInfoAH(self.logger, @"adding recipient to buddy group.");
        __weak typeof (self) weakSelf = self;
        NSString *recipientMri = self.recipientIDs.firstObject;
        // Set this flag to NO while add contact request is ongoing.
        self.shouldSendAddContactRequest = NO;
        if ([recipientMri isEqualToString:self.accountHandle.MRI])
        {
            LogErrorAH(self.logger, @"Cannot add self as a contact");
            return;
        }
        NSString *correlationID = [TSkCorrelationTagContactGroups stringByAppendingString:[[NSUUID UUID] UUIDString]];
        TSAction *addBuddy = [self.actionContext actionOfClass:[TSNABuddyGroup class]
                                                fromDictionary:@{
                                                    TSkActionType : [NSNumber numberWithInteger:TSkBuddyGroupActionTypeManage],
                                                    TSkCorrelationID : correlationID,
                                                    TSkBuddyGroupID : TFLkContacts,
                                                    TSkUsersToAdd : @[recipientMri]
                                                }
                                                withCompletion:nil];
        
        [addBuddy executeActionChain:@"add recipient to buddy group" withCompletion:^(TSAction *action, TSAResult *result, NSError *err) {
            if (err)
            {
                [AXPUtilities logNetworkErrorOrWarning:err withMessage:[NSString stringWithFormat:@"Error has occured while adding recipient to buddy group. Error code: %zd, error domain: %@", err.code, err.domain] logger:action.accountHandle.logger];
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf)
                {
                    return;
                }
                // Reset this instance flag when errored so that it can retry using helper method in case conversation type or buddy list changed.
                strongSelf.shouldSendAddContactRequest = [strongSelf checkShouldSendAddContactRequest];
            }
            else
            {
                // Add this recipient to buddy group contacts list to make sure we will not send adding buddy request for this recipient.
                NSMutableArray<NSString *> *buddyGroupContacts = [[action.accountHandle.tenantDefaults objectForKey:TSkBuddyGroupContacts] mutableCopy];
                [buddyGroupContacts addObject:recipientMri];
                [action.accountHandle.tenantDefaults setObject:buddyGroupContacts forKey:TSkBuddyGroupContacts];
                
                // Manually refresh buddy group contacts list so that user can see the buddy on contact tab immediately.
                [TSBuddyGroup syncAllBuddyGroupsWithAccountHandle:action.accountHandle andCompletion:^(NSArray<TSBuddyGroup *> *syncedGroups, NSError *syncError) {
                    if (syncError)
                    {
                        LogErrorAH(action.accountHandle.logger, @"Error has occured refreshing buddy group. Error code: %zd, error domain: %@", syncError.code, syncError.domain);
                    }
                }];
            }
        }];
    }
    
}

-(BOOL)checkShouldSendAddContactRequest
{
    if ([self isOneToOneChat])
    {
        NSString *recipientMri = self.recipientIDs.firstObject;
        NSArray<NSString *> *buddyGroupContacts = [self.accountHandle.tenantDefaults objectForKey:TSkBuddyGroupContacts];
        
        // Send add contact request if it is not buddy contact.
        return ![buddyGroupContacts containsObject:recipientMri] && !([recipientMri hasPrefix:TSGroupChatSMSUserPrefix] || [recipientMri hasPrefix:TSBotPrefix]);
    }
    
    return NO;
}

-(BOOL)shouldAddMriToAcceptList
{
    return [self isOneToOneChat] && (self.isRosterWithExtendedDirectoryUser || self.isRosterWithTflInterOpUser);
}

- (void) updateFileProgressState:(NSNotification *) notification
{
    NSDictionary *dict = notification.object;
    
    if(dict)
    {
        __weak typeof(self) weakSelf = self;
        [TSDispatchUtilities dispatchOnMainThread:^{
            
            [TSUtilities extractFileInfoFromDict:dict completion:^(NSString *fileID, NSString *threadID, float progress, TSkFileUploadStatus status, NSError *error, NSURL *fileURL, TSFileUploadType uploadType, NSString *draftKey, NSString *requestId) {
                
                if([weakSelf.threadID isEqualToString:threadID])
                {
                    [weakSelf.composeViewController updateFileProgressState:dict];
                    [[TSFMRestrictionHelper sharedInstance] handleFileUploadRestrictionsWithError:error
                                                                                           status:status
                                                                                       uploadType:uploadType
                                                                                   viewController:weakSelf
                                                                                    accountHandle:self.accountHandle];
                }
            }];
        }];
    }
}

- (void)updateViewConstraints
{
    self.composeViewHeightConstraint.constant = self.composeViewController.bottomEdge.frame.origin.y;
    
    [super updateViewConstraints];
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSDictionary *dictionary = self.sfcInteropChatBlockViewController ? @{ TSkIsAcceptBlockBannerShown : @([self.sfcInteropChatBlockViewController isAcceptBlockBannerPresented])} : nil;
    
    [self.accountHandle.logger logPanelView:TSkPanelTypeChatEnd
                               launchMethod:TSkLaunchMethodNav
                                   panelUri:TSkPanelUriConversation
                             panelUriParams:nil
                                     region:TSkRegionMain
                                   metadata:[TSUtilities metaDataFromDataBagDictionary:dictionary]];
    
    [self cancelTypingIndicatorPerformRequestForAllUsers];
    
    if (![self readReceiptsEnabled])
    {
        [self updateConsumptionHorizon];
    }
    else
    {
        [self markAlertsAsRead];
    }
    
    if (self.isShowingQuickReactPrompt)
    {
        [TSQuickReactPromptManager.sharedInstance updateReactionCount];
    }
    
    if (self.isConsultTransferConversation &&
        ([TSCallManager sharedInstance].consultTransferCallSession.type == TSConsultTransferTypeChat) &&
        self.canRemoveConsultTransferCallSession)
    {
        [TSCallManager sharedInstance].consultTransferCallSession = nil;
        
        if (TSSharedManagers.buildConfigurationManager.isCIFxTesting)
        {
            [TSCallPiPManager.sharedInstance moveTo:FALSE];
        }
    }
    
    if (self.multiCallBannerViewManager)
    {
        [self.multiCallBannerViewManager elementViewWillDisappear];
    }
    
    if (self.transferBannerViewManager)
    {
        [self.transferBannerViewManager elementViewWillDisappear];
    }
    
    [self.composeLocationObserver removeAllListeners];
    self.composeLocationObserver = nil;
    self.fileShareUrl = nil;
    self.forwardImages = nil;
    self.fromThreadID = nil;
    
    if (self.accountHandle.policyManager.isChatDashboardHeaderEntryPointEnabled)
    {
        // Reset nav bar appearance
        // Probably not needed because a lot of other VCs are calling 'correctNavigationBarForNavBarOpaqueness'
        //  as a preventative measure, but just in case
        [self correctNavigationBarForNavBarOpaqueness:YES];
    }
    
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self.player stop];
    
    // NOTE: Only remove notifications added in viewWillAppear.
    //  Additional notification added in viewDidLoad should not be removed, since they will not be re-added when the view reappears
    //  Do not remove: TSkExtensionCreatedMessage, TSkImageDownloadCompleteNotification, UIContentSizeCategoryDidChangeNotification,
    //  TSkFileProgressStateNotification and TSkUserBlockedNavigationNotification.
    
    NSMutableSet *notificationsToRemove = [NSMutableSet setWithArray:@[UIApplicationDidBecomeActiveNotification,
                                                                       TSkCallingEnabledUpdated, TSkGroupCallingEnabledUpdated, TSkPrivateMeetingEnabledUpdated,
                                                                       TSkVideoCallingEnabledUpdated, TSkACImageDownloadNotification, UIApplicationWillResignActiveNotification,
                                                                       TSkPageOneChatsConversationsThreadsAndUsersSynced, TSkControlTypingMessageReceivedNotification, TSkSSOAuthMessageReceivedNotification, TSkOneConversationSynced,
                                                                       TSkChatBadgeCountChangedNotification, TSkNavigateAwayFromCall, TSkFederatedUsersSynced, TSkConversationMarkedUnread, TSkConversationDeleted]];
    
    if (!IS_IPAD())
    {
        [notificationsToRemove addObjectsFromArray:@[UIKeyboardWillChangeFrameNotification, UIKeyboardWillHideNotification, UIKeyboardDidShowNotification]];
    }
    
    if (self.accountHandle.policyManager.shouldDisableAudioOrVideoOnCellular)
    {
        [[TSMobilityPolicySettingsManager sharedInstance] removeObserver:self accountHandle:self.accountHandle];
    }
    
    if ([TSPresenceService defaultService].trackUserPresence)
    {
        [notificationsToRemove addObject:TSUserPresenceStatusChangedForChatList];
    }
    
    [self removeSelfAsObserverForNotifications:notificationsToRemove];
    
    self.needToRegisterForNotifications = YES;
    [self.composeViewController.fileUploadComposer logTelemetryForControllerBackButtonClick:self.currentPanelInfo];
    
    if ([TSTranslationManager isAutomaticChatTranslationEnabled:self.accountHandle] || [TSTranslationManager isOnDemandChatTranslationEnabled:self.accountHandle])
    {
        if ([[[TSTranslationManager sharedInstance] messageIDsToBeResetTranslationResult] count])
        {
            [[TSTranslationManager sharedInstance] setTranslationResultWithThreadID:self.threadID
                                                                   andMessageIDList:[[TSTranslationManager sharedInstance] messageIDsToBeResetTranslationResult].allObjects
                                                                 withResultCodeType:TSTranslatedItemResultCodeTypeNotShowErrorMessage
                                                         withNeedToUpdateReplyChain:NO
                                                                              inMoc:self.accountHandle.highPriMOC
                                                                     withCompletion:nil];
            
            [[[TSTranslationManager sharedInstance] messageIDsToBeResetTranslationResult] removeAllObjects];
        }
    }
    
    [super viewDidDisappear:animated];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil)
    {
        [self resetImageData];
    }
}

- (void)acknowledgeMsgSendFailure:(NSNumber *)messageID
{
    if (messageID.longLongValue != 0 && [self.accountHandle.ecsManager msgSendFailureIndicatorEnabled])
    {
        NSManagedObjectContext *moc = self.accountHandle.highPriMOC;
        NSString *threadID = self.threadID;
        DbReadWrite(SELECTOR_NAME(self), moc, ^{
            TSSMessage *message = [TSSMessage messageForID:messageID
                                               andThreadID:threadID
                                    inManagedObjectContext:moc];
            
            if (message.ts_numericFailureTime.longLongValue != 0)
            {
                message.ts_numericFailureTime = nil;
            }
        });
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.freezeConsumptionHorizonBookmarkReset && [self.threadID isNotNilOrEmpty])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:TSkConversationVisited
                                                            object:nil
                                                          userInfo:@{TSKKeyConversationID: self.threadID}];
    }
    
    if (self.navigationController.viewControllers.count > 1)
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    [self.toViewController viewDidAppear:animated];
    
    if ([self.threadID length])
    {
        TSConversation *conv = [AXPCtx conversationForID:self.threadID];
        self.initialHorizonTime = [conv userConsumptionHorizonTime];
        self.isMuted = [conv conversationAlertsAreMuted];
        [self acknowledgeMsgSendFailure:conv.ts_lastMessageID];
        
        if ([conv isDeleted])
        {
            [self stopActivityIndicator];
        }
        else if (!conv)
        {
            TSThread *thread = [AXPCtx threadForID:self.threadID];
            if (!thread)
            {
                // Chat has been deleted
                [self backButtonTapped:nil];
            }
        }
    }
    
    [self updateConsumptionHorizon];
    
    if (self.hasAppeared)
    {
        [self.accountHandle.logger clearStartEvent:self.scenarioMarkerID];
        [self.accountHandle.logger clearStartEvent:self.navScenarioID];
        [self.accountHandle.logger clearStartEvent:self.scrollToMessageScenarioID];
        self.scenarioMarkerID = nil;
        self.navScenarioID = nil;
        self.scrollToMessageScenarioID = nil;
    }
    else if (self.isGuardiansChat && self.threadID == nil)
    {
        [self.composeViewController.textBody becomeFirstResponder];
    }
    
    if (self.errorContainerNotFound && [TSSharedManagers.authManager authStatus] == TSkHaveAuthentication)
    {
        [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"UnknownChatTitle")
                                            andMessage:AXPLocalizedString(@"UnknownChatDescription")
                                      andButtonContent:AXPLocalizedString(@"TSOK")
                                     andViewController:self];
        [self stopScenarioMarker:YES messageDictionary:self.messageDictionary];
        [self.accountHandle.logger logScenarioStopEvent:self.scrollToMessageScenarioID status:ScenarioStatusOK];
    }
    
    // show active state notification, if any
    [self showStateNotification:self.pendingState];
    
    self.hasAppeared = YES;
    
    [TSEnableReviewPromptManager.sharedInstance visitedDetailPage];
    
    if (self.isConsultTransferConversation && ![NSString isNilOrEmpty:self.consultTransferPrepopulatedMessage.string])
    {
        self.composeViewController.textBody.attributedText = self.consultTransferPrepopulatedMessage;
        self.consultTransferPrepopulatedMessage = nil;
        [self.composeViewController.textBody becomeFirstResponder];
        if (self.composeViewController.importancePriority == TSImportantPriorityNone)
        {
            [self.composeViewController updateImportance:TSImportantPriorityHigh];
        }
        [self.composeViewController configureSendButton:YES];
        if (TSSharedManagers.buildConfigurationManager.isCIFxTesting)
        {
            [TSCallPiPManager.sharedInstance moveTo:TRUE];
        }
    }
    else if (![NSString isNilOrEmpty:self.lateToMeetingPrepopulatedMessage.string])
    {
        self.composeViewController.textBody.attributedText = self.lateToMeetingPrepopulatedMessage;
        self.consultTransferPrepopulatedMessage = nil;
        [self.composeViewController.textBody becomeFirstResponder];
        [self.composeViewController configureSendButton:YES];
    }
    
    if (self.shouldShowKeyboard && ![self shouldDisableFedChatComposeOptions])
    {
        [self.composeViewController.textBody becomeFirstResponder];
        
        self.shouldShowKeyboard = NO; // Only show first time view opens
    }
    if ([self.textForDeepLinkedInitialization isNotNilOrEmpty] )
    {
        self.composeViewController.textBody.text = self.textForDeepLinkedInitialization;
        self.textForDeepLinkedInitialization = @"";
        [self.composeViewController configureSendButton:YES];
    }
    
    if(self.fileShareUrl && self.composeViewController)
    {
        [self.composeViewController pasteFileSharingLink:self.fileShareUrl originThreadID:self.fromThreadID];
    }
    
    if(self.forwardImages && self.composeViewController)
    {
        for (UIImage *image in self.forwardImages) {
            [self.composeViewController attachImageData:UIImageJPEGRepresentation(image, 1.0)
                                     forLocalIdentifier:nil
                                                 ofType:TSkImageFileTypeJpeg
                                              sourceURL:nil
                                   becomeFirstResponder:YES
                                        sendImmediately:NO
                                         withCompletion:nil];
        }
    }
    
    if (self.needAcknowledgementForVisibleCells)
    {
        self.needAcknowledgementForVisibleCells = NO;
        for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows)
        {
            [self acknowledgeMessageAtIndexPath:indexPath];
        }
    }
    
    if (!IS_IPAD_REGULAR())
    {
        [self updateNavigationRightBarItemsAnimated:NO];
    }
    
    [self updateSfcInteropChatBlockView];
    
    if (((self.accountHandle.policyManager.shouldShowContactSyncEmptyState
          && !self.accountHandle.deviceContactsSync.isDeviceContactsSyncEnabled
          && self.accountHandle.deviceContactsSync.hasShownDeviceContactSyncModal)
         || self.accountHandle.policyManager.shouldShowInviteFriendsEmptyState)
        && (self.groupChatCreationState != TSGroupChatCreationStateStart))
    {
        [self.view endEditing:YES];
    }
    
    [self updateChatHeaderViewVisibilityIfNeeded];
    
    [self.botMenuProvider.botMenuClientRequestHandler createLayoutNeedsUpdateRequestWithView:self.view anchorView:self.composeView];
}

- (void) updateBotmenuAccessibilityContainer
{
    // Add accessibility container for the bot menu just before composeView which is inside a stackView
    // This is to make VO read bot menu before compose view since stackview's contents are read by
    // VO from start to end
    
    if ([self.botMenuProvider menuView] != nil && UIAccessibilityIsVoiceOverRunning())
    {
        [self.botMenuAccessibilityContainer removeFromSuperview];
        self.botMenuAccessibilityContainer = nil;
        
        UIView *menuView = [self.botMenuProvider menuView];
        self.botMenuAccessibilityContainer = [[TBMBotMenuAccessibilityContainer alloc] initWithMenuView: menuView];
        self.botMenuAccessibilityContainer.backgroundColor = [UIColor clearColor];
        NSInteger composeViewIndex = [self.stackView.arrangedSubviews indexOfObject: self.composeView];
        [self.stackView insertArrangedSubview:self.botMenuAccessibilityContainer atIndex:composeViewIndex];
        [self.botMenuAccessibilityContainer.bottomAnchor constraintEqualToAnchor:self.composeView.topAnchor constant:0].active = YES;
        [self.botMenuAccessibilityContainer.heightAnchor constraintEqualToAnchor:menuView.heightAnchor constant:0].active = YES;
    }
}

- (void) viewWillTransitionToSize:(CGSize)size
        withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self relayoutStackViewToWidth:size.width];
        
    TSWeakify(self);
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context)
     {
        TSStrongify(self);
        [self reloadTable];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        TSStrongify(self);
        
        // SfC Interop chat blocking UI responds to screen rotation
        if (self.sfcInteropChatBlockViewController)
        {
            [self.sfcInteropChatBlockViewController resetViews];
            self.sfcInteropChatBlockViewController =
                [[TSSFCInteropOrTFLChatBlockAcceptViewController alloc] initWithViewController:self
                                                                                     forThread:self.threadID
                                                                                  recipientMri:self.recipientIDs.firstObject
                                                                                 accountHandle:self.accountHandle];
        }

        if (self.isSideBarEnabled)
        {
            [self updateBottomConstraint];
        }
    }];
}

- (void) syncConversationInfo: (NSNotification*) notification
{
    NSDictionary *info = [notification userInfo];
    NSString *conversationID = [info objectForKey:TSKKeyConversationID];
    
    if ([conversationID compareString:self.threadID])
    {
        LogInfoAH(self.logger, @"Reloading chat info for conversation update.");
        [self chatConversationsUpdated:nil];
        [self.messageFetchEngine updateRetentionTime];
        return;
    }
}

- (void)conversationMarkedUnread: (NSNotification*) notification
{
    NSDictionary *info = [notification userInfo];
    NSString *updatedConversationID = [info objectForKey:TSkNotificationKeyForConversation];
    
    if ([updatedConversationID compareString:self.threadID])
    {
        self.freezeConsumptionHorizonBookmarkReset = YES;
        
        __weak typeof(self) weakSelf = self;
        
        [TSDispatchUtilities dispatchOnMainThread:^
         {
            [weakSelf fixInitialHorizonTimeAndReload];
        }];
        
        return;
    }
    
    LogInfoAH(self.logger, @"Skip fixing horizon time as notification is for another conversationId.");
}

- (void) fixInitialHorizonTimeAndReload
{
    // fix the initialhorizontime
    self.initialHorizonTime = [[AXPCtx conversationForID:self.threadID] userConsumptionHorizonTime];
    self.messageFetchEngine.horizonMsgTime = self.initialHorizonTime;
    
    // reset this flag which will enable us to add the readmsgindicator again
    self.messageFetchEngine.shouldRetainLastReadMsgIndicator = NO;
    
    // fetch to perform a reload on the view data.
    [self.messageFetchEngine getNextPageFromSyncDate:self.lastMessageDate];
}

- (void) chatConversationsUpdated:(NSNotification *)notification
{
    if (![self.accountHandle isNotificationForHandle:notification])
    {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^
     {
        [weakSelf updateRecipientList];
        [weakSelf updateFederationPropertiesForRoster];
        // Get latest muted state because that affects subtitle and presence state
        TSConversation *conv = [AXPCtx conversationForID:weakSelf.threadID];
        weakSelf.isMuted = [conv conversationAlertsAreMuted];
        
        [weakSelf updateTitleText];
        [weakSelf updateNavigationRightBarItemsAnimated:NO];
        // to fix the MOC multithreading violation exception
        [weakSelf showJoinBannerIfRequired];
        [weakSelf configureDisabledStateView];
        [weakSelf updateChatHeaderViewVisibilityIfNeeded];
        [weakSelf updateSfcInteropChatBlockView];
    }];
}

// NOTE: Should always be invoked from main thread
- (void)setIsMuted:(BOOL)isMuted
{
    AssertMainThread();
    _isMuted = isMuted;
    [self checkShouldShowPresence];
    [self updateTitleText];
}

- (void)extensionCreatedMessage:(NSNotification *)notification
{
    // Reload so message created externally is shown
    [self loadInitialMessagePage];
}

- (void) updateRecipientList
{
    if (self.isChatWithSelf)
    {
        // Early return since there is no other recipient
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *threadID = self.threadID;
    
    if ([threadID length])
    {
        [TSDispatchUtilities dispatchOnMainThread:^
         {
            TSThread *thread = [AXPCtx threadForID:threadID];
            
            // For private meeting chat threads, we don't want to remove
            // the signed in user from the recipient list as there are
            // cases that we invite guest users to the meeting and they normally
            // don't get add to the thread member list till they send messages.
            // This is for bug 222938 and 222947
            if (weakSelf.threadType == TSThreadTypePrivateMeeting)
            {
                weakSelf.recipientIDs = [thread getMemberIDList];
                [weakSelf updateThreadTelemetryProperties];
                return;
            }
            
            NSString* userMri = self.accountHandle.MRI;
            if ([userMri isNotNilOrEmpty])
            {
                NSArray *memberList = thread.isBotInChat ? [thread getNonBotMemberIDsExcept:@[userMri]] : [thread getMemberIDsExcept:@[userMri]];
                if (self.accountHandle.policyManager.isTfwTflFedChatConsumptionOnTfwEnabled)
                {
                    TSWeakify(self);
                    void (^completion)(TSAction *action, TSAResult *result, NSError *err) = ^void(TSAction *action, TSAResult *result, NSError *err){
                        if (!err)
                        {
                            [TSDispatchUtilities dispatchOnMainThread:^
                             {
                                TSStrongifyAndReturnIfNil(self);
                                [self updateFederationPropertiesForRoster];
                                [self updateTitleText];
                                [self.composeViewController setupToolbars];
                                [self removeButtonsForInteropThreadIfNeeded];
                                [self loadInitialMessagePageWithForcedRefresh:YES];
                                [self reloadTable];
                            }];
                        }
                    };
                    
                    if ([TSUtilities isSfCInteropChatByThreadId:threadID])
                    {
                        TSUser *user = [AXPCtx userForID:[memberList firstObject]];
                        if (![user.type isEqualToString:TSkUserTypeSfC])
                        {
                            NSString *correlationID = [TSkCorrelationTagSfCInterop stringByAppendingString:[[NSUUID UUID] UUIDString]];
                            [TSSyncEngine.sharedInstance.userSyncManager syncConsumerProfiles:@[[memberList firstObject]]
                                                                                actionContext:self.actionContext
                                                                                actionOfClass:TSNASyncSfCUsersByIDs.class
                                                                                correlationID:correlationID
                                                                               withCompletion:completion];
                        }
                    }
                    else if ([threadID isNotNilOrEmpty] && memberList.count == 1)
                    {
                        TSUser *user = [AXPCtx userForID:[memberList firstObject]];
                        if ([TSUtilities isConsumerUserMriForUserID:user.tsID] && ![user.type isEqualToString:TSkUserTypeTFLConsumer])
                        {
                            NSString *correlationID = [TSkCorrelationTagTFLFederation stringByAppendingString:[[NSUUID UUID] UUIDString]];
                            [TSSyncEngine.sharedInstance.userSyncManager syncConsumerProfiles:@[[memberList firstObject]]
                                                                                actionContext:self.actionContext
                                                                                actionOfClass:TSNASyncTflFederatedUsersByIDs.class
                                                                                correlationID:correlationID
                                                                               withCompletion:completion];
                        }
                    }
                    else if ([threadID isNotNilOrEmpty] && memberList.count > 1)
                    {
                        NSMutableArray *tflMembersToSync = NSMutableArray.new;
                        for (NSString *member in memberList)
                        {
                            if ([TSUtilities isConsumerUserMriForUserID:member])
                            {
                                TSUser *user = [AXPCtx userForID:member];
                                if (![user isTeamsConsumerUser])
                                {
                                    [tflMembersToSync addObject:member];
                                }
                            }
                        }
                        if (tflMembersToSync.count > 0)
                        {
                            NSString *correlationID = [TSkCorrelationTagTFLFederation stringByAppendingString:[[NSUUID UUID] UUIDString]];
                            [TSSyncEngine.sharedInstance.userSyncManager syncConsumerProfiles:tflMembersToSync
                                                                                actionContext:self.actionContext
                                                                                actionOfClass:TSNASyncTflFederatedUsersByIDs.class
                                                                                correlationID:correlationID
                                                                               withCompletion:completion];
                        }
                    }
                }
                
                // for anonymous joins, we should not block user from composing
                if (memberList.count > 0 || [weakSelf isChatForAnonymousCall])
                {
                    NSSet *currentRecipientSet = weakSelf.recipientIDs ? [NSSet setWithArray:weakSelf.recipientIDs] : NSSet.new;
                    NSMutableSet* newRecipientSet = [NSMutableSet setWithArray:memberList];
                    [newRecipientSet minusSet:currentRecipientSet];
                    if (newRecipientSet.count)
                    {
                        NSString *correlationID = [TSkCorrelationTagOpenChatRefresh stringByAppendingString:[[NSUUID UUID] UUIDString]];
                        [TSSyncEngine.sharedInstance.userSyncManager refreshProfileForUsers:newRecipientSet.allObjects
                                                                                      inMoc:self.accountHandle.privateMOC
                                                                           forCorrelationID:correlationID
                                                                              accountHandle:self.accountHandle
                                                                             withCompletion:nil];
                    }
                    
                    weakSelf.recipientIDs = memberList;
                }
                else
                {
                    LogWarningAH(weakSelf.logger, @"Failed to resolve recipients of the chat container with ID %@: %@", threadID, thread);
                    weakSelf.recipientIDs =  NSArray.new;
                }
            }
            else
            {
                LogWarningAH(weakSelf.logger, @"Empty user MRI found while updating recipient list for chat container with ID %@: %@", threadID, thread);
                weakSelf.recipientIDs = NSArray.new;
            }
            
            [weakSelf updateThreadTelemetryProperties];
            [weakSelf updateMemberConsumptionHorizonTime];
        }];
    }
}

- (TSDropdownWithPresenceTitleView*)titleView
{
    UIViewController *viewController = self.outerViewController ?: self;
    TSDropdownWithPresenceTitleView *titleView = (TSDropdownWithPresenceTitleView *) viewController.navigationItem.titleView;
    return [titleView isKindOfClass:TSDropdownWithPresenceTitleView.class] ? titleView : nil;
}

- (void) updateTitleText
{
    if ([NSString isNilOrEmpty:self.threadID] && self.shouldConfigureForMeetings)
    {
        return;
    }
    
    TSWeakify(self)
    [TSDispatchUtilities dispatchOnMainThread:^{
        TSStrongifyAndReturnIfNil(self)
        NSString *titleText = [self getNavTitle];
        [self checkShouldShowPresence];
        
        if (self.onUpdateNavItemNotificationName != nil)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:self.onUpdateNavItemNotificationName object:self];
        }
        
        if ([NSString isNilOrEmpty:self.threadID] && ([titleText compareString:AXPLocalizedString(@"NewChtTitle")] ||
                                                      [titleText compareString:AXPLocalizedString(@"ExistingChatTitle")] ||
                                                      [titleText compareString:AXPLocalizedString(@"NewGrpChtTtl")]))
        {
            NSString *subTitleText = [TSAccountManager.sharedInstance isSingleAccountSingleTenant] || self.shouldUseFlowV2 ? @"" : self.accountHandle.tenantName;
            [self buildTitleView:titleText
                    withSubTitle:subTitleText
                    showDropdown:NO
               dropdownDirection:[self getDropdownDirectionForIsOpeningDropdown:NO]
                    showPresence:NO
                   withAnimation:NO];
        }
        else
        {
            NSString *subTitleText = [self getNavSubTitle];
            if (self.accountHandle.policyManager.isMeetingTabUXEnabled)
            {
                [self updateNavigationRightBarItems];
            }
            [self buildTitleView:titleText
                    withSubTitle:subTitleText
                    showDropdown:self.shouldShowDropdownOnTitle
               dropdownDirection:[self getDropdownDirectionForIsOpeningDropdown:NO]
                    showPresence:self.shouldShowPresenceOnTitle
                   withAnimation:NO];
        }
    }];
}

- (void)updateSubtitleText
{
    if (self.onUpdateNavItemNotificationName != nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.onUpdateNavItemNotificationName object:self];
    }
    
    TSDropdownWithPresenceTitleView *titleView = self.titleView;
    titleView.userMri = [self.recipientIDs firstObject];
    [titleView setSubtitleViewWithMuteStatus:self.isMuted
                              presenceStatus:self.currentPresenceStatus
                           shouldSetSubtitle:self.shouldSetSubTitle];
}

- (void) buildTitleView:(NSString *)title
           withSubTitle:(NSString *)subTitle
           showDropdown:(BOOL)showDropdown
      dropdownDirection:(TSDropdownWithPresenceTitleViewDirection)dropdownDirection
           showPresence:(BOOL)showPresence
          withAnimation:(BOOL)animateDropdown
{
    TSDropdownWithPresenceTitleView *titleView = self.titleView;
    titleView.userMri = [self.recipientIDs firstObject];
    titleView.title = title;
    titleView.subtitle = subTitle;
    
    // titleButton should only be active if it is not new chat
    // threadID only exists if chat is existing chat
    if ([self.threadID length] && !self.shouldConfigureForMeetings)
    {
        [titleView setTitleButtonToActive:YES];
        
        titleView.dropdownEnabled = YES;
        titleView.accessibilityHint = AXPLocalizedString(@"ChatDetailsA11y");
    }
    
    if (animateDropdown)
    {
        [titleView setDropdownDirectionWithAnimation:dropdownDirection];
    }
    else
    {
        titleView.dropdownDirection = dropdownDirection;
    }
    
    titleView.dropdownEnabled = showDropdown;
    
    titleView.actionEnabled = showDropdown;
    titleView.presenceEnabled = showPresence;
    titleView.showMutedState = self.isMuted;
    
    if (self.isMuted || showPresence)
    {
        [self updateSubtitleText];
    }
    
    titleView.subtitleEnabled = [subTitle isNotNilOrEmpty];
}

/*
 * If read receipt is enabled, CH is updated when the user enters the view, and there is a msg update in foreground.
 * If read receipt is disabled, CH is updated when user enters or leaves; (no CH update on enter foreground)
 */
- (void) updateConsumptionHorizon
{
    if (self.threadID && !self.errorContainerNotFound && self.isCurrentlyVisible)
    {
        NSString *correlationID =[@"ConsHorz:" stringByAppendingString:[[NSUUID UUID] UUIDString]];
        TSAction *update = [self.actionContext actionOfClass:TSNAUpdateConsumptionHorizon.class
                                              fromDictionary:@{
            TSkThreadID      : self.threadID,
            TSkCorrelationID : correlationID,
            @"statusMessage" : [NSString stringWithFormat:@"setting consumption horizon for chat container %@", self.threadID],                                                                 }
                                              withCompletion:nil];
        __weak typeof(self) weakSelf = self;
        [update executeActionChain:@"updating last view time for chat"
                    withCompletion:^(TSAction *action, TSAResult *result, NSError *err)
         {
            [weakSelf markAlertsAsRead];
            [TSBadgeCountManager.sharedInstance calculateBadgeCounts:nil];
        }];
        
        if (!self.freezeConsumptionHorizonBookmarkReset)
        {
            NSString *threadID = self.threadID;
            NSManagedObjectContext *moc = self.accountHandle.highPriMOC;
            DbReadWrite(SELECTOR_NAME(self), moc, ^{
                TSConversation *conversation = [AXPCtx conversationForID:threadID
                                                                   inMOC:moc];
                
                if ([conversation ts_consumptionHorizonBookmarkTime].longLongValue != 0)
                {
                    TSAction *updateConsumptionHorizonBookmark = [self.actionContext actionOfClass:TSNAResetConsumptionHorizonBookmark.class
                                                                                    fromDictionary:@{
                        TSkThreadID : threadID,
                        TSkCorrelationID : correlationID
                    }
                                                                                    withCompletion:nil];
                    [updateConsumptionHorizonBookmark executeActionChain:@"updating the consumption horizon bookmark"
                                                          withCompletion:^(TSAction *action, TSAResult *result, NSError *err)
                     {
                        [TSBadgeCountManager.sharedInstance calculateBadgeCounts:nil];
                    }];
                }
            });
        }
    }
}

- (void)appDidBecomeActive:(NSNotification *)notification
{
    // When the user moves the multitasking divider on iPad, iOS calls applicationWillResignActive.
    // If the user doesn't dimiss the app by moving the divider all the way across the screen,
    // we need to update the bottom constraint since it differs when splitView is collapsed.
    [self updateBottomConstraint];
    [self syncLatestMemberConsumptionHorizon];
}

- (void) customInputDidUpdate
{
    [self animateBottomOffsetIfNeeded];
}

- (void) animateBottomOffsetIfNeeded
{
    [self animateKeyboardChange:TSkCustomInputAnimationTimeInterval options:0];
}

- (void) keyboardChanged:(NSNotification *)notification
{
    BOOL isTabBarHidden = [self tabBarHidden] || (IS_IPAD_REGULAR() && !self.splitViewController) || self.isInCallRightPanel;
    CGFloat kHeight = [TSUxUtils keyboardHeightForNotification:notification
                                                        inView:self.view
                                                isTabBarHidden:isTabBarHidden
                                          andDetermineExternal:nil];
    // When custom input attached to the text view, it will report size with safe content offset if custom input height is non-zero
    // Detecting such situation with min compose input height
    if (kHeight <= TSkMinimumComposeInputHeight) {
        kHeight = 0;
    }
    self.keyboardHeight = kHeight;
    if (self.isInCallRightPanel && self.keyboardHeight!= 0)
    {
        self.keyboardHeight -= self.viewBottomOffset;
    }
    NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [self animateKeyboardChange:animationDuration options:animationCurve];
}

- (void) animateKeyboardChange: (NSTimeInterval) duration options: (UIViewAnimationOptions) options
{
    CGFloat accessoryHeight = self.composeViewController.customInputHeight;
    CGFloat keyboardH = self.keyboardHeight;
    CGFloat targetedBottomOffset = keyboardH + self.bottomConstant + accessoryHeight;
    
    if (fequal(self.targetBottomConstraint.constant, targetedBottomOffset))
    {
        return;
    }
    
    [self updateChatHeaderViewVisibilityIfNeeded];
    self.targetBottomConstraint.constant = targetedBottomOffset;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:options | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        [self updateBottomConstraint];
        [self.view layoutIfNeeded];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self applyDynamicDecorationIfNeeded];
        });
    }
                     completion:^(BOOL finished) {
        [self.composeViewController keyboardFrameDidFinishAnimation];
    }];
}

- (void)likeButtonPressed:(NSNumber *)messageID threadID:(NSString *)threadID withView:(UIView*)view
{
    if (self.messageLikersPopup == nil)
    {
        self.messageLikersPopup = [[TSMessageLikersPopupController alloc]init];
    }
    
    TSSMessage *message = [AXPCtx messageForID:messageID andThreadID:threadID];
    [self.messageLikersPopup openPopupForMessage:message forViewController:self withDelegate:self.contextOptionsHandler withBaseView:view];
}

- (BOOL) isInvertedView
{
    return YES;
}

- (void)callingEnabledConfigurationChanged:(NSNotification *)notification
{
    if ([self.accountHandle isNotificationForHandle:notification])
    {
        __weak typeof(self) weakSelf = self;
        [TSDispatchUtilities dispatchOnMainThread:^{
            [weakSelf updateNavigationRightBarItemsAnimated:NO];
            [weakSelf showJoinBannerIfRequired];
        }];
    }
}

- (void)privateMeetingEnabledConfigurationChanged:(NSNotification *)notification
{
    [self showJoinBannerIfRequired];
}

- (void)relayoutCustomBannerView
{
    if (self.isConsultTransferConversation)
    {
        self.customBannerViewHeightConstraint.constant = !self.multiCallBannerViewManager.callElementView.hidden
        ? TSkCallBannerViewHeight * 2 : TSkCallBannerViewHeight;
    }
}

- (BOOL) isChatHeaderActionViewHidden
{
    return !self.accountHandle.policyManager.isHeaderActionViewInNewChatEnabled ||
    self.shouldHideChatHeaderContainer ||
    self.chatHeaderCoordinator.hasRemovedHeroTile;
}

- (void) constructFederatedBanner:(NSString *)bannerLabel
                enableCancelImage:(BOOL)enableCancelImage
                enableLeaveButton:(BOOL)enableLeaveButton
                   chatBannerType:(NSInteger)chatBannerType
{
    if (!self.chatBannerView)
    {
        LogInfoAH(self.logger, @"Adding banner for federated chat");
        self.chatBannerView = [[TSChatBannerView alloc] initWithLabel:bannerLabel
                                              enableUserReceivedImage:NO
                                                    enableCancelImage:enableCancelImage
                                                    enableLeaveButton:enableLeaveButton
                                                       chatBannerType:chatBannerType
                                                         withDelegate:self];
        [self.customBannerViewContainer addArrangedSubview:self.chatBannerView];
        self.customBannerViewHeightConstraint.constant = TSkChatViewControllerFederatedBannerHeight;
    }
}

- (void)contructFedUserMsgRelatedPolicyBanner
{
    if(!self.chatBannerView)
    {
        LogInfoAH(self.logger, @"Adding Message-related Policy banner in chat");
        NSString *oneOnOneChatUserName = @"";
        if(self.threadType == TSThreadTypeOneOnOneChat && self.recipientIDs.count == 1)
        {
            TSUser *user = [AXPCtx userForID:self.recipientIDs.firstObject inMoc:self.accountHandle.mainMOC];
            oneOnOneChatUserName = user.displayName;
        }
        NSString *baseMsg = [self.federationInfoUtil getExtAccessPolicyBannerBaseMsgFor:self.threadType
                                                                   oneOnOneChatUserName:oneOnOneChatUserName
                                                                          isBannerOnTfL:self.accountHandle.policyManager.isTfwTflFedChatConsumptionOnTflEnabled];
        self.chatBannerView = [[TSChatBannerView alloc] initWithtextView:[self.federationInfoUtil getFedUserMsgPolicyStringFor:baseMsg]
                                                 enableUserReceivedImage:NO
                                                       enableCancelImage:YES
                                                       enableLeaveButton:NO
                                                          chatBannerType:TSkFederatedChatMessageRelatedPolicy
                                                            withDelegate:self];
        [self.customBannerViewContainer addArrangedSubview:self.chatBannerView];
        self.customBannerViewHeightConstraint.constant = TSkChatViewControllerFederatedBannerHeight;
    }
}

- (NSString *)getSfBDowngradeBannerLabelToDisplay
{
    NSMutableArray * federatedParticipantNames = [self getFederatedParticipantNames];
    if (federatedParticipantNames.count == 1)
    {
        return [NSString stringWithFormat:AXPLocalizedString(@"ChatHasOneDowngradedUserLabel"), federatedParticipantNames[0]];
    }
    else if (federatedParticipantNames.count == 2)
    {
        return [NSString stringWithFormat:AXPLocalizedString(@"ChatHasTwoDowngradedUsersLabel"), federatedParticipantNames[0], federatedParticipantNames[1]];
    }
    else if (federatedParticipantNames.count > 2)
    {
        return [NSString stringWithFormat:AXPLocalizedString(@"ChatHasThreeDowngradedUsersLabel"), federatedParticipantNames[0], [NSString stringWithFormat:@"%lu",federatedParticipantNames.count - 1]];
    }
    
    return @"";
}

- (void) showChatViewBannerIfRequired
{
    if (self.isConsultTransferConversation || (self.isNewFederatedUser && !self.isFederatedBannerCancelled) || [self shouldShowChatViewBannerForFederatedChat])
    {
        LogInfoAH(self.logger, @"Show banner for new federated user");
        self.customBannerViewContainer.hidden = NO;
    }
}

- (void) updateNavigationRightBarItems
{
    [self updateNavigationRightBarItemsAnimated:NO];
}

- (void) updateNavigationRightBarItemsAnimated:(BOOL)animated
{
    AssertMainThread();
    
    if (!self.isViewLoaded)
    {
        return;
    }
    
    UIViewController *viewController = self.outerViewController ?: self;
    
    if (((![self.accountHandle.policyManager isCallingAllowed] ||
          self.hideCallOptions) && !self.shouldConfigureForMeetings) ||
        !self.actionContext.userPrivateChatEnabledOnTenant ||
        (self.threadID.length && [TSConversation didUserLeaveChatwithThreadID:self.threadID]))
    {
        viewController.navigationItem.rightBarButtonItems = nil;
        return;
    }
    
    if ([self.threadID isNotNilOrWhitespace])
    {
        TSThreadProperty *awarenessProperty = nil;
        if (self.threadType == TSThreadTypePrivateMeeting)
        {
            awarenessProperty = [AXPCtx threadPropertyForThreadID:self.threadID
                                                  andPropertyName:TSkThreadPropertyPrivateMeetingAwareness
                                                            inMoc:self.accountHandle.mainMOC];
        }
        if([self.thread isDisabledChatWithInProgressMeetingOption:YES meetingInProgress:awarenessProperty ? awarenessProperty.propertyValue : NO] && !self.forceEnableChat)
        {
            viewController.navigationItem.rightBarButtonItems = nil;
            return;
        }
        
        if ([self.thread isOneOnOneChat] && [self isConversationDisabled])
        {
            viewController.navigationItem.rightBarButtonItems = nil;
            return;
        }
    }
    
    // hide the calling buttons if the user is blocked for a 1:1 chat
    if (self.threadType == TSThreadTypeOneOnOneChat &&
        ([TSUtilities isContactBlockingEnabled:self.accountHandle]) &&
        [TSSFCInteropOrTFLChatBlockAcceptViewController isBlockedSfCInteropOrTFLChatForThread:self.threadID
                                                                                 recipientMri:self.recipientIDs.firstObject
                                                                                accountHandle:self.accountHandle])
    {
        viewController.navigationItem.rightBarButtonItems = nil;
        if ([self reportRightBarChangeForViewController:viewController])
        {
            LogWarningAH(self.accountHandle.logger, @"Calling: Chat calling disabled: blocked SfC: 1.");
        }
        
        return;
    }
    
    // On meeting chat tab, we need to build the overflow menu even if some recipients are bots
    BOOL isMeetingChatTab = self.isMeeting && self.accountHandle.policyManager.isMeetingTabUXEnabled;
    if (!isMeetingChatTab)
    {
        for (NSString *recipientID in self.recipientIDs)
        {
            if ([TSUser isBOT:recipientID])
            {
                // We should not show calling buttons if any bot user presents on the recipient list
                viewController.navigationItem.rightBarButtonItems = nil;
                if ([self reportRightBarChangeForViewController:viewController])
                {
                    LogWarningAH(self.accountHandle.logger, @"Calling: Chat calling disabled: bot: 1.");
                }
                
                return;
            }
        }
    }
    
    BOOL callChat = NO;
    BOOL oneOnOneChat = NO;
    BOOL groupChat = NO;
    BOOL sfbChat = NO;
    BOOL sfcChat = NO;
    BOOL federatedChat = NO;
    BOOL newSfCChat = NO;
    if ((callChat = [self.accountHandle.groupTraits isCallEnabledForRecipients:self.recipientsUserInfo]
         && [self.accountHandle.policyManager isCallingAllowed]
         && [self.recipientIDs count] > 0)
        &&
        ((oneOnOneChat = self.threadType == TSThreadTypeOneOnOneChat || [self isSMSChat] || self.threadType == TSThreadTypeUnknown)
         || (groupChat = self.threadType == TSThreadTypeGroupChat && (self.customBannerViewContainer.hidden || [self isFederatedGroupChatWithChatViewBanner]))
         || (sfbChat = self.threadType == TSThreadTypeInteropChat && [self.accountHandle.actionContext isSfBInteropEnabled] && [TSUtilities isSfBInteropChatByThreadId:self.threadID])
         || (sfcChat = self.threadType == TSThreadTypeInteropChat && [self.accountHandle.actionContext isSfCInteropEnabled] && [TSUtilities isSfCInteropChatByThreadId:self.threadID])
         || (federatedChat = self.threadType == TSThreadTypeInteropChat && [self.federationUtils isFederatedChatByThreadId:self.threadID])
         || (newSfCChat = self.isNewChat && self.recipientIDs.count == 1 && [self.accountHandle.actionContext isSfCInteropEnabled] && [TSUtilities isSfCUserForUserID:self.recipientIDs.firstObject accountHandle:self.accountHandle]))
        )
    {
        UIButton *voiceCallButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TSkNavigationBarItemWidth, TSkNavigationBarItemHeight)];
        UIImage *voiceCallButtonImage = [TSCallUIUtilities getAudioIconImage:IconSymbolCall iconStyle:IconSymbolStyleRegular iconSize:IconSymbolSizeNormal defaultStateColor:self.legacyAppearanceProxy.navigationBarButtonDefaultColor restrictedStateColor:self.legacyAppearanceProxy.callsButtonRestrictedIconColor];
        
        [voiceCallButtonItem setImage:voiceCallButtonImage forState:UIControlStateNormal];
        [voiceCallButtonItem.widthAnchor constraintEqualToConstant:TSkNavigationBarItemWidth].active = YES;
        voiceCallButtonItem.accessibilityLabel = AXPLocalizedString(@"AudioCall");
        [voiceCallButtonItem addTarget:self action:@selector(voiceCallButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.voiceCallButton = voiceCallButtonItem;
        
        self.voiceCallButton.enabled = [self isAudioAndVideoCallButtonEnabled];
        
        UIStackView *itemsStackView = [[UIStackView alloc] init];
        
        itemsStackView.axis = UILayoutConstraintAxisHorizontal;
        itemsStackView.spacing = 16.0f;
        
        if (!self.hideVideoCallButton && ![self isSMSChat] && [self.accountHandle.policyManager isVideoCallingAllowed])
        {
            UIButton *videoCallButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TSkNavigationBarItemWidth, TSkNavigationBarItemHeight)];
            UIImage *videoCallButtonImage = [TSCallUIUtilities getVideoIconImage:IconSymbolVideo iconStyle:IconSymbolStyleRegular iconSize:IconSymbolSizeNormal defaultStateColor:self.legacyAppearanceProxy.navigationBarButtonDefaultColor restrictedStateColor:self.legacyAppearanceProxy.callsButtonRestrictedIconColor];
            
            [videoCallButtonItem setImage:videoCallButtonImage forState:UIControlStateNormal];
            [videoCallButtonItem.widthAnchor constraintEqualToConstant:TSkNavigationBarItemWidth].active = YES;
            videoCallButtonItem.accessibilityLabel = AXPLocalizedString(@"VideoCall");
            [videoCallButtonItem addTarget:self action:@selector(videoCallButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *videoCallBarButton = [[UIBarButtonItem alloc] initWithCustomView:videoCallButtonItem];
            
            videoCallBarButton.enabled = [self isAudioAndVideoCallButtonEnabled];
            
            [itemsStackView addArrangedSubview:videoCallButtonItem];
        }
        
        [itemsStackView addArrangedSubview:voiceCallButtonItem];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemsStackView];
        
        [viewController.navigationItem setRightBarButtonItems:@[barButtonItem] animated:animated];
    }
    else if (isMeetingChatTab)
    {
        [self.outerViewController setOptionView];
    }
    else if (self.emptyStateForMeetings)
    {
        [self.outerViewController setupRightBarItemPadding];
    }
    else if (self.groupChatCreationState == TSGroupChatCreationStateStart
             || self.isStartOfNonBifurcatedFlow)
    {
        [self createNextButtonForCreateGroupFlow];
    }
    else if ((self.accountHandle.policyManager.isEmptyGroupCreationEnabled
              || self.shouldMultiSelectParticipants)
             && self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants
             && self.recipientIDs == nil)
    {
        [self createNextButtonForCreateGroupFlow];
    }
    else
    {
        viewController.navigationItem.rightBarButtonItems = nil;
        if ([self reportRightBarChangeForViewController:viewController])
        {
            LogWarningAH(self.accountHandle.logger, @"Calling: Chat calling disabled: call: %d, one on one: %d, group: %d, SfB: %d, SfC: %d, federated: %d, new SfC: %d.", callChat, oneOnOneChat, groupChat, sfbChat, sfcChat, federatedChat, newSfCChat);
        }
    }
    
    // Remove voice and video call buttons for SfC Interop chat if not accepted or blocked
    if ([self.accountHandle.actionContext isSfCInteropEnabled] && [TSUtilities isSfCInteropChatByThreadId:self.threadID])
    {
        if ([TSSFCInteropOrTFLChatBlockAcceptViewController isBlockedSfCInteropOrTFLChatForThread:self.threadID recipientMri:self.recipientIDs.firstObject accountHandle:self.accountHandle] ||
            ![TSSFCInteropOrTFLChatBlockAcceptViewController isAcceptedSfCInteropOrTFLChatForThread:self.threadID accountHandle:self.accountHandle])
        {
            viewController.navigationItem.rightBarButtonItems = nil;
            if ([self reportRightBarChangeForViewController:viewController])
            {
                LogWarningAH(self.accountHandle.logger, @"Calling: Chat calling disabled: disabled SfC: 1.");
            }
        }
    }
}

- (BOOL)reportRightBarChangeForViewController:(UIViewController *)viewController
{
    NSNumber *wasEnabled = self.rightBarButtonItemsEnabled;
    NSNumber *isEnabled = @(viewController.navigationItem.rightBarButtonItems != nil);
    self.rightBarButtonItemsEnabled = isEnabled;
    return (!wasEnabled || wasEnabled.boolValue) && !isEnabled.boolValue;
}

- (void)createNextButtonForCreateGroupFlow
{
    if (!self.isViewLoaded)
    {
        return;
    }
    
    UIViewController *viewController = self.outerViewController ?: self;
    viewController.navigationItem.rightBarButtonItems = nil;
    
    UIBarButtonItem *nextBarButton = [[UIBarButtonItem alloc] initWithTitle:AXPLocalizedString(@"TSFRENextButtonTitle")
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(createNewGroupChatNextButtonTapped:)];
    nextBarButton.accessibilityLabel = AXPLocalizedString(@"TSNext");
    nextBarButton.enabled = [self.topicName isNotNilOrEmpty] || self.accountHandle.ecsManager.isUntitledNewGroupAllowed;
    [nextBarButton setTitleTextAttributes:@{NSFontAttributeName : [TSFont preferredFontForTextStyle:UIFontTextStyleSubheadline ofType:TSkFontTypeSemiBold]}
                                 forState:UIControlStateNormal];
    
    [viewController.navigationItem setRightBarButtonItems:@[nextBarButton] animated:NO];
}

- (void) findConversationWithRecipients
{
    __weak TSChatViewController *weakSelf = self;
    
    if ([self.recipientIDs count] == 0)
    {
        [TSDispatchUtilities dispatchOnMainThread:^
         {
            [weakSelf matchMentionsToRecipients];
        }];
        
        // Return early if there are no recipients
        return;
    }
    
    if (self.isGuardiansChat)
    {
        // Exception for Guardians Chat: Don't find by recipients
        // The chat could be for a different child with the same parents. Each should have their own chat.
        // Stop spinners since the view is ready for the first message
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf hideInvertedPulldownSpinner];
            [weakSelf stopActivityIndicator];
        }];
        return;
    }
    
    NSArray *recipientsIDs = [self.recipientIDs mutableCopy];
    // try to find an existing recipient group for user group.
    TSAAFindContainerForRecipients *findContainerForRecipientsAction = [self.actionContext actionOfClass:[TSAAFindContainerForRecipients class]
                                                                                          fromDictionary:@{
        TSkRecipientIDs : self.recipientIDs,
        @"statusMessage" : @"getting chat container for recipients",
        @"topicName" : self.topicName ?: @""
    }
                                                                                          withCompletion:nil];
    
    findContainerForRecipientsAction.isHighPriority = YES;
    [findContainerForRecipientsAction executeActionChain:@"searching chats"
                                          withCompletion:^(TSAction *action, TSAResult *result, NSError *err)
     {
        __strong TSChatViewController *strongSelf = weakSelf;
        if (err)
        {
            LogErrorAH(strongSelf.logger, @"Error occured during find container for recipients call.  Error - domain %@, code %ld", err.domain, (long)err.code);
            return;
        }
        
        // check if recipientID changed even before we got the result; can happen by selecting all users and deleting from toViewVC
        BOOL didRecipientsChange = !([recipientsIDs isEqualToArray:strongSelf.recipientIDs]);
        
        NSArray *results = [result processedListForClass:[TSThread class]];
        if (!didRecipientsChange && results && results.count > 0)
        {
            strongSelf.threadID = [results lastObject];
        }
        else
        {
            strongSelf.threadID = nil;
        }
        
        if (strongSelf.threadID)
        {
            [strongSelf updateThreadTelemetryProperties];
        }
        
        [TSDispatchUtilities dispatchOnMainThread:^
         {
            if ((strongSelf.groupChatCreationState == TSGroupChatCreationStateNoOp)
                || (strongSelf.groupChatCreationState == TSGroupChatCreationStateAddingParticipants && [strongSelf showOneToOneChatInGroupCreationFlow]))
            {
                [strongSelf loadInitialMessagePage];
                [strongSelf reloadTable];
                [strongSelf.composeViewController setupToolbars];
                [strongSelf.composeViewController updateActionExtensionButtons];
                [strongSelf removeButtonsForInteropThreadIfNeeded];
                [strongSelf.composeViewController restoreCurrentDraft];
                
                if (strongSelf.threadID)
                {
                    // mark as hasAppeared so we can load more data with pull-to-load-more
                    strongSelf.hasAppeared = YES;
                    
                    // update composeViewController State; required for when we fetch chat container for blocked bot
                    [strongSelf.composeViewController updateComposeViewState];
                    
                    // refresh the data to load older messages once a recipient is selected, if any
                    [strongSelf refreshData];
                }
                else if (strongSelf.isAnyWelcomeCardFeatureEnabled)
                {
                    [strongSelf showEmptyStateView:YES];
                }
                
                /* Selected 1 recipient and it resolved into a group chat or meeting -- switch directly to chat view
                 * For Tags, we do not want to resolve into group chat or meeting
                 */
                if ([recipientsIDs isEqualToArray:strongSelf.recipientIDs] && recipientsIDs.count == 1)
                {
                    TSThread *thread = [AXPCtx threadForID:strongSelf.threadID];
                    
                    if ([thread isGroupChat] || [thread isPrivateMeeting])
                    {
                        [AXPApp sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
                        
                        [strongSelf resetViewWithComposeHidden:NO];
                        
                        // setThreadID passes to multi-view depending on TO state, trigger after hiding TO addressing
                        [strongSelf setThreadID:strongSelf.threadID];
                    }
                }
                
                [strongSelf matchMentionsToRecipients];
            }
        }];
        [strongSelf computeMessageActions: self.threadID];
    }];
    if ([self shouldShowStatusMessageBannerView])
    {
        [self constructAndShowStatusMessageBannerView:YES];
    }
    else
    {
        [self removeStatusMessageBannerView];
    }
}

- (void)tappedOnCreateEvent:(NSString *)messageString
{
    if([self.composeViewController isKindOfClass:TSCompactComposeViewController.class])
    {
        [((TSCompactComposeViewController *)self.composeViewController) createMeetingButtonAction:YES withMessageTitle:messageString];
    }
}

- (void)tappedOnCreateTask:(NSString *)messageString withMessage:(TSSMessage *)message
{
    if([self.composeViewController isKindOfClass:TSBaseComposeViewController.class])
    {
        id <TSLoggerProtocol> logger = self.logger;
        
        if (![self.threadID isValidString])
        {
            LogErrorAH(logger, "threadID not set")
            [TSUtilities showTasksDeeplinkNavigationError:self];
            return;
        }
        
        if (![[message.tsID stringValue] isValidString])
        {
            LogErrorAH(logger, "message ID not set");
            [TSUtilities showTasksDeeplinkNavigationError:self];
            return;
        }
        
        if (messageString.length == 0)
        {
            LogErrorAH(logger, "No text in message")
            [TSUtilities showTasksDeeplinkNavigationError:self];
            return;
        }
        
        
        NSString *subMessageString;
        if ([messageString length] >= TSkTaskTitleNumberOfCharacters)
        {
            LogInfoAH(logger, "Message truncated to 256 character")
            subMessageString = [messageString substringToIndex:TSkTaskTitleNumberOfCharacters];
        }
        else
        {
            subMessageString = messageString;
        }
        
        NSString *from = message.imdisplayname;
        if(![from isValidString])
        {
            NSManagedObjectContext *moc = self.accountHandle.unsafeDoNotUseNormalizedHighPriMocForCurrentThread;
            from = [AXPCtx userForID:message.from inMoc:moc].displayName;
        }
        if (!from){
            LogErrorAH(logger, "Unable to fetch user's imDisplayName")
            from = AXPLocalizedString(@"UnknownUser");
        }
        
        NSString *chatName;
        if ([self.threadID length])
        {
            TSConversation *conv = [AXPCtx conversationForID:self.threadID inMOC:self.accountHandle.mainMOC];
            
            if (conv.customTopic != nil)
            {
                chatName = conv.customTopic;
            }
            else
            {
                chatName = [TSNameUtils getAggregatedRecipientNames:[AXPCtx threadForID:self.threadID]
                                                           fullName:YES
                                                      accountHandle:self.accountHandle];
            }
            
            if (![chatName isValidString])
            {
                LogErrorAH(logger, "Unable to fetch thread name")
                chatName = @"";
            }
        }
        else
        {
            LogErrorAH(logger, "Thread ID is empty")
            [TSUtilities showTasksDeeplinkNavigationError:self];
            return;
        }
        
        NSDictionary *messageToTaskDetails = [NSDictionary dictionaryWithObjectsAndKeys:
                                              self.threadID, TSkMessageToTaskThreadId,
                                              chatName, TSkMessageToTaskThreadName,
                                              [message.tsID stringValue], TSkMessageToTaskMessageId,
                                              subMessageString, TSkMessageToTaskTaskTitle,
                                              from, TSkMessageToTaskMessageCreatorName,
                                              nil];
        
        BOOL handled = [TSUtilities navigateToTasksForThreadId:self.threadID
                                          fromNavigationOrigin:TSkTeamsTasksAppNavOriginTypeMessageSupportAction
                                                    withPlanId:nil
                                            withMessageDetails:messageToTaskDetails
                                            withAccountHandler:self.accountHandle];
        
        [self.accountHandle.logger logPanelAction:TSKActionModuleNameCreateTaskFromMessage
                                          outCome:(handled? TSkActionOutcomeNav : TSkActionOutcomeFailure)
                                          gesture:TSkActionGestureTap
                                         scenario:TSkScenarioCreateTaskFromMessage
                                     scenarioType:TSkScenarioTypeTaskEvent
                                   destinationuri:nil
                             destinationUriParams:nil
                                       moduleType:TSKActionModuleNameCreateTaskFromMessage
                                      moduleState:nil
                                    moduleSummary:TSkActionModuleSummaryCreateTaskFromMessageButton
                                        panelType:TSkPanelTypeChat
                                         panelUri:TSkPanelUriTasks
                                   panelUriParams:nil
                                         threadId:self.threadID
                                       threadType:nil];
        if (!handled)
        {
            [TSUtilities showTasksDeeplinkNavigationError:self];
        }
        
    }
}

#pragma mark - TSComposeViewControllerDelegate

- (BOOL) isCortanaDictationSupported
{
    return YES;
}

- (BOOL) shouldUseSoundWaveRecordingIcon
{
    return YES;
}

- (UIFontTextStyle) fontTextStyleForComposeViewController:(TSBaseComposeViewController *__nullable)composeViewController
{
    return [TSFont defaultComposeBoxFontTextStyleForChats];
}

- (BOOL) composeViewControllerShouldShowSendButton:(TSBaseComposeViewController *)composeViewController
{
    return YES;
}

- (BOOL) isOneToOneChat
{
    return self.threadType == TSThreadTypeOneOnOneChat;
}

- (BOOL) showOneToOneChatInGroupCreationFlow
{
    return self.shouldUseFlowV2 && [self.recipientIDs count] == 1;
}

- (TSThreadType)threadType
{
    if ([self.threadID isNotNilOrEmpty])
    {
        return self.threadTypeFromThreadProperties;
    }
    
    // Predict thread type based on current recipients
    TSThreadType threadTypeFromRecipientIDs = self.recipientIDs.count > 1 ? TSThreadTypeGroupChat : TSThreadTypeOneOnOneChat;
    
    if (self.recipientIDs.count == 1)
    {
        if ([[self.recipientIDs firstObject] hasPrefix:TSPSTNUserPrefix])
        {
            threadTypeFromRecipientIDs = TSThreadTypePhoneChat;
        }
        else
        {
            TSUser *user = [AXPCtx userForID:self.recipientIDs.firstObject inMoc:self.accountHandle.unsafeDoNotUseNormalizedMocForCurrentDbThread];
            if (user)
            {
                if ([user isPSTNUser])
                {
                    threadTypeFromRecipientIDs = TSThreadTypePhoneChat;
                }
                else if ([self.accountHandle.actionContext isSfBInteropAvailableForUser:user] || [user isSfCInteropUser])
                {
                    threadTypeFromRecipientIDs = TSThreadTypeInteropChat;
                }
            }
        }
    }
    
    return threadTypeFromRecipientIDs;
}

- (BOOL) willDismissKeyboard
{
    return YES;
}

- (BOOL) allowAtMentionsForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    // This check should always be first
    if (self.isAnonymouslyJoinedToCall || [self isSMSChat])
    {
        return NO;
    }
    
    if (![self isComposerActionEnabled:TSkComposerActionMention])
    {
        return NO;
    }
    
    if (self.threadType == TSThreadTypeGroupChat || self.threadType == TSThreadTypePrivateMeeting || self.threadType == TSThreadTypeOneOnOneChat)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL) allowAtLessMentionsForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    if ([self.accountHandle.ecsManager atLessMentionEnabled])
    {
        return [self allowAtMentionsForComposeViewController:composeViewController];
    }
    return NO;
}

- (BOOL) allowImportantMessagesForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    if ([self isSfbOrSfcInteropChat])
    {
        return NO;
    }
    
    if (![self isComposerActionEnabled:TSkComposerActionImportant])
    {
        return NO;
    }
    
    return (self.threadType != TSThreadTypeStreamOfNotes);  // Priority messages are not relevant for chat with self
}

//Urgent messages are allowed for oneOnOne chats and chat's less than maxGroupChatParticipantsForFanout = 20 for now.
- (BOOL) allowUrgentMessagesForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    if (([self.recipientIDs count] >= self.maxGroupChatParticipantsForFanout) || [self isSMSChat])
    {
        return NO;
    }
    
    if (self.threadType == TSThreadTypePrivateMeeting)
    {
        return self.accountHandle.ecsManager.enablePriorityMessagingForMeetingChat;
    }
    
    if (self.shouldLimitComposeOptnInFedChat)
    {
        return NO;
    }
    
    TSUser *currentUser = [AXPCtx userForID:self.accountHandle.MRI inMoc:self.accountHandle.mainMOC];
    if ([currentUser isGuestUser])
    {
        return NO;
    }
    
    if ([currentUser isTFLUser])
    {
        return NO;
    }
    
    BOOL isOneOnOneOrGroupChat = (self.threadType == TSThreadTypeOneOnOneChat) || (self.threadType == TSThreadTypeGroupChat);
    return isOneOnOneOrGroupChat;
}

- (BOOL) allowVaultMessagesForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    if ([self isSMSChat] ||
        ![self isComposerActionEnabled:TSkComposerActionVault] ||
        self.threadType == TSThreadTypePrivateMeeting ||
        self.shouldLimitComposeOptnInFedChat ||
        !((self.threadType == TSThreadTypeOneOnOneChat) || (self.threadType == TSThreadTypeGroupChat)) ||
        [NSString isNilOrEmpty:self.threadID])
    {
        return NO;
    }
    
    return self.accountHandle.policyManager.isChatVaultEnabled && self.accountHandle.policyManager.isVaultEnabled;
}

- (BOOL) allowFluidMessageForComposeViewControler:(TSBaseComposeViewController *)composeViewController
{
    return !self.shouldLimitComposeOptnInFedChat;
}

- (BOOL) allowTasksMessagesForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    if ([self isSMSChat] ||
        ![self isComposerActionEnabled:TSkComposerActionTasks] ||
        self.threadType == TSThreadTypePrivateMeeting ||
        self.shouldLimitComposeOptnInFedChat ||
        !((self.threadType == TSThreadTypeOneOnOneChat) || (self.threadType == TSThreadTypeGroupChat)) ||
        [NSString isNilOrEmpty:self.threadID])
    {
        return NO;
    }
    
    if (self.threadType == TSThreadTypeGroupChat &&
        [NSString isNilOrEmpty:[TSUtilities getConsumerGroupIdFromThreadId:self.threadID inMoc:self.accountHandle.mainMOC]])
    {
        return NO;
    }
    
    return self.accountHandle.policyManager.isChatTasksEnabled;
}

- (BOOL) allowMeetupsForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    return NO;
}

- (BOOL) canCreateReminderOrTaskForMessage:(TSSMessage *)message
{
    if ([self isSMSChat] ||
        self.threadType == TSThreadTypePrivateMeeting ||
        self.shouldLimitComposeOptnInFedChat ||
        !((self.threadType == TSThreadTypeOneOnOneChat) || (self.threadType == TSThreadTypeGroupChat)) ||
        [self isOneOnOneSMSChat] ||
        [NSString isNilOrEmpty:self.threadID])
    {
        return NO;
    }
    
    if (self.threadType == TSThreadTypeGroupChat &&
        [NSString isNilOrEmpty:[TSUtilities getConsumerGroupIdFromThreadId:self.threadID inMoc:self.accountHandle.mainMOC]])
    {
        return NO;
    }
    
    TSMessageInfo *messageInfo = [self.messageDictionary objectForKey:message.tsID];
    // Treat this like a bool. If true, message contains some plain text
    NSMutableArray *isPlainTextArray = [NSMutableArray array];
    NSString *messageString;
    // Show for both sent and received messages
    if (![message.thread isInteropChatThread]
        && ([message canBeEdited]
            || ([self shouldAllowReplyToChat] && (self.accountHandle.ecsManager.chatReplyToMessage
                                                  || TSSharedManagers.buildConfigurationManager.isScenarioTesting)
                && [self canQuoteMessageID:message.tsID]))
        && ![self isMessageInfoForMeetingChiclet:messageInfo])
    {
        // Do not add `Create Reminder` option for standalone images/gifs/files
        NSMutableAttributedString *str = [message attributedContent].mutableCopy;
        
        [str enumerateAttribute:NSAttachmentAttributeName
                        inRange:NSMakeRange(0, str.length)
                        options:kNilOptions
                     usingBlock:^(id _Nullable value, NSRange range, BOOL * _Nonnull stop)
         {
            if (!value)
            {
                [isPlainTextArray addObject:[NSNumber numberWithInt:1]];
            }
            else
            {
                if(([value isKindOfClass:[AXPTextAttachment class]]))
                    
                {
                    [str replaceCharactersInRange:range withString:@""];
                }
            }
        }];
        str = [[str trimWhiteSpace] mutableCopy];
        messageString = str.string.removeNewlines;
    }
    
    return ([messageString isNotNilOrEmpty] && [isPlainTextArray count]);
}

- (NSString *) channelMentionShortcutIDForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    return nil;
}

- (UIView *) messagesViewForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    return _messagesView;
}

- (CGFloat) keyboardHeightForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    return _keyboardHeight;
}

- (UIColor *) backgroundColorForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    return self.legacyAppearanceProxy.chatBackgroundColor;
}

- (BOOL) shouldCollapseToolbarForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    return self.shouldCollapseComposeToolbar;
}

- (BOOL) shouldEnableSubjectForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    return NO;
}

- (void) funImagesPrivacySettingUpdated
{
    [self reloadTable];
}

- (CGFloat) additionalHeightOffsetForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    CGFloat internalBannerHeight = self.customBannerViewContainer.hidden ? 0 : self.customBannerViewContainer.height;
    CGFloat internalLocationBannerHeight = self.locationBannerViewContainer.hidden ? 0 : self.locationBannerViewContainer.height;
    
    CGFloat outerBannerHeight = [[TSCompanionBannerViewManager sharedInstance] bannerHeight];
    
    return internalBannerHeight + internalLocationBannerHeight + outerBannerHeight;
}

- (BOOL) isFileUploadDisabledForUser:(TSBaseComposeViewController *)composeViewController
{
    // This check should always be first
    if (self.isAnonymouslyJoinedToCall)
    {
        return YES;
    }
    
    if (!self.accountHandle.policyManager.isFileAttachmentEnabled)
    {
        return YES;
    }
    
    // is threadID is null, there means we haven't talked with that user
    // Due to image need to upload to the ams service and that need threadid, we follow the web,
    // so don't allow file upload for new chat
    if (![self.threadID isNotNilOrEmpty])
    {
        return YES;
    }
    
    if ([self isPrivateChatWithBot])
    {
        return ![TSPlatformConstants isBotAttachmentsAvailableForUserId:self.accountHandle.MRI
                                                                  botId:self.recipientIDs[0]
                                                                withMOC:self.accountHandle.mainMOC];
    }
    
    if (![self.threadID isNotNilOrEmpty])
    {
        return YES;
    }
    
    // we not only need to verify that the chat isn't a sfbInteropChat or sfcInteropChat, we also need
    // to verify that this is not 1:1 chat with a native federation user
    if ([self isSfbOrSfcInteropChat] || self.shouldLimitComposeOptnInFedChat)
    {
        return YES;
    }
    
    TSUserInfo *signedInUser = [self userInfoForID:self.accountHandle.MRI];
    if (signedInUser && [signedInUser isGuestUser])
    {
        return YES;
    }
    
    if ([self isSMSChat])
    {
        return YES;
    }
    
    if (![self isComposerActionEnabled:TSkComposerActionAttachment])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL) isPrivateChatWithBot
{
    BOOL isPrivateChatWithBot = NO;
    if ([self.biThreadType compareString:TSkThreadTypeBotOnlyChat])
    {
        isPrivateChatWithBot = YES;
    }
    else if (self.recipientIDs && self.recipientIDs.count == 1)
    {
        // its possible the thread has yet not created;
        TSUserInfo *user = [self userInfoForID:[self.recipientIDs lastObject]];
        if (user && [user isBot])
        {
            isPrivateChatWithBot = YES;
        }
    }
    return isPrivateChatWithBot;
}

- (BOOL) isBotSupportsFiles
{
    return [TSPlatformConstants isBotAttachmentsAvailableForUserId:self.accountHandle.MRI
                                                             botId:self.recipientIDs[0]
                                                           withMOC:self.accountHandle.mainMOC];
}

- (void) composeViewController:(TSBaseComposeViewController *)composeView
         textViewDidChangeText:(UITextView *)textView;
{
    
    
    if ([self isPrivateChatWithBot] || (self.recipientIDs.count > 1))
    {
        BotMenuProviderState mentionHandlerResult = [self.botMenuProvider handleTextChanges];
        switch (mentionHandlerResult)
        {
            case BotMenuProviderStateInitialized:
                [self updateBotmenuAccessibilityContainer];
                [self.stackView setCustomSpacing:[self.botMenuProvider initialMenuHeight]
                                       afterView:self.typingIndicatorView];
                [self.botMenuProvider.botMenuClientRequestHandler createLayoutNeedsUpdateRequestWithView:self.view anchorView:self.composeView];
                break;
            case BotMenuProviderStateNotInitialized:
                [self.stackView setCustomSpacing:UIStackViewSpacingUseDefault afterView:self.typingIndicatorView];
                break;
            default: break;
        }
    }
}

- (void)composeViewDidSubmitMessage:(TSBaseComposeViewController *)composeViewController
{
    if (self.recipientIDs.count > 1)
    {
        [self.botMenuProvider.botMenuClientRequestHandler createUpdateMenuStateHiddenRequest];
    }
}

-(void) composeViewControllerDidChangeText:(TSBaseComposeViewController *)composeViewController
{
    BOOL shouldSendComposeMessage = (self.threadID.length &&
                                     [self isNotSfbAndNotSfcInteropChat] &&
                                     ![self isPrivateChatWithBot] &&
                                     ([self.recipientIDs count] < self.maxGroupChatParticipantsForFanout) &&
                                     ![self isSMSChat]);
    
    // reduce user composing msgs call on slow network.
    NSInteger maxComposeMessageDuration = TSNetworkStatusManager.sharedInstance.isSlowNetwork ? (2 * TSkTypingIndicatorDisplayDurationInMilliSeconds) : TSkTypingIndicatorDisplayDurationInMilliSeconds;
    
    if (shouldSendComposeMessage)
    {
        NSDate *currentTime = [NSDate date];
        NSNumber *currentTimeNumber = [NSNumber numberWithLongLong:currentTime.skypeTimeInterval];
        NSNumber *lastPostTimeNumberForUserComposingMessage = [NSNumber numberWithLongLong:self.lastPostTimeForUserComposingMessage.skypeTimeInterval];
        BOOL isComposeMessageBeingDisplayed = ((currentTimeNumber.longLongValue - lastPostTimeNumberForUserComposingMessage.longLongValue) < maxComposeMessageDuration);
        
        if (isComposeMessageBeingDisplayed)
        {
            return;
        }
        self.lastPostTimeForUserComposingMessage = currentTime;
        NSString *correlationID = [@"Typing:" stringByAppendingString:[[NSUUID UUID] UUIDString]];
        TSAction *update = [self.actionContext actionOfClass:TSNAUserComposingMessage.class
                                              fromDictionary:@{
            TSkThreadID : self.threadID,
            @"statusMessage" : [NSString stringWithFormat:@"Post user composing message for container %@", self.threadID],
            @"currentTime" : [currentTimeNumber stringValue],
            TSkCorrelationID : correlationID
        }
                                              withCompletion:nil];
        NSString *threadID = self.threadID;
        id <TSLoggerProtocol> logger = self.logger;
        [update executeActionChain:@"Post user composing message" withCompletion: ^(TSAction *action, TSAResult *result, NSError *err){
            if (err)
            {
                LogErrorAH(logger, @"failed user compose post threadID: (%@), err code:%zd, domain:%@",
                           threadID, err.code, err.domain);
            }
        }];
    }
    else
    {
        LogVerboseAH(self.logger, @"[ChatVC]:skipping posting user composing message post");
    }
    
}

- (void) composeViewControllerDidFinishComposing:(TSBaseComposeViewController *)composeViewController
                                   withMessageID:(NSNumber *)messageID
                                     andThreadID:(NSString*)threadID
                                      scenarioID:(NSString *)scenarioID
                                   correlationID:(NSString *)correlationID
                                 dismissComposer:(BOOL)dismissComposer
{
    if (messageID)
    {
        [self.accountHandle.messageUploadManager uploadMessageWithID:messageID
                                                            threadID:threadID
                                                          scenarioID:scenarioID
                                                       correlationID:correlationID
                                                 announceSendSuccess:YES];
        
        __weak typeof(self) weakSelf = self;
        [TSDispatchUtilities dispatchOnMainThread:^{
            if (dismissComposer)
            {
                [self dismissComposeBox];
            }
            // Sent a message, scroll to the top if needed
            if (!fequal(weakSelf.tableView.contentOffset.y, 0.0f) && weakSelf.numberOfSections > 0 && [weakSelf.tableView numberOfRowsInSection:0])
            {
                weakSelf.isScrollingToTop = YES;
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }];
    }
    
    if (self.accountHandle.ecsManager.meetingChatMuteSettingsEnabledOnECS)
    {
        [self unmuteChatIfRequired];
    }
    
    if (self.emptyStateView.state == TSkEmptyStateGroupChatWelcomeCard || self.emptyStateView.state == TSkEmptyStateOneToOneChatWelcomeCard)
    {
        [self removeStatusMessageBannerView];
    }
}

- (void) composeViewControllerDidPostFluidMessageToNewChatGroupWithThreadId:(NSString *)threadId completion:(void (^)(void))completion
{
    self.threadID = threadId;
    TSWeakify(self);
    [TSDispatchUtilities dispatchOnMainThread:^{
        TSStrongify(self);
        if ([threadId isNotNilOrEmpty] && !fequal(self.toContainerViewHeight.constant, 0.0f))
        {
            [self.outerViewController didReceiveThreadID:threadId withThreadType:self.biThreadType chatType:self.biChatType];
        }
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.toContainerViewHeight.constant = 0;
            [self.toView setHidden:YES];
        }
                         completion:nil];
        
        [self loadInitialMessagePage];
        
        TSConversation *conv = [AXPCtx conversationForID:self.threadID inMOC:self.accountHandle.mainMOC];
        if ([NSString isNilOrEmpty:conv.consumptionHorizon])
        {
            [self updateConsumptionHorizon];
        }
        
        self.lastPostTimeForUserComposingMessage = nil;
        completion();
    }];
    
    [TSDispatchUtilities dispatchOnBackgroundThread:^{
        [TSEnableReviewPromptManager.sharedInstance updateEngagedActionsStatistics];
        [TSEnableNotificationPromptManager.sharedInstance updateEnableNotificationPromptStatusToBeDisplayed];
    }];
}

- (void) composeViewControllerDidBeginEditing
{
    CGFloat entityBarContainerHeight = self.toViewController.entitySearchBarContainerView.frame.size.height;
    // if toView Container is showing users, only then reset entitySearchBarViewController
    if (!fequal(self.toContainerViewHeight.constant, entityBarContainerHeight))
    {
        [self.toViewController entitySearchBarViewControllerResetSearch];
    }
}

- (NSString *) sendScenarioName
{
    NSString *scenarioName = SCENARIO_CHAT_SEND_MESSAGE;
    if (self.threadID)
    {
        if ([self isSfCInteropChat])
        {
            scenarioName = SCENARIO_CHAT_SEND_MESSAGE_SFC;
        }
        else if ([self isSfBInteropChat])
        {
            scenarioName = SCENARIO_CHAT_SEND_MESSAGE_SFB;
        }
        else if (self.isRosterWithFederatedUser || self.isRosterWithExtendedDirectoryUser || self.isRosterWithTflInterOpUser || self.isRosterWithOffNetworkFedUser)
        {
            scenarioName = SCENARIO_CHAT_SEND_MESSAGE_FEDERATED;
        }
    }
    else
    {
        scenarioName = SCENARIO_CHAT_SEND_MESSAGE_NEWTHREAD;
        if (self.recipientIDs.count == 1)
        {
            NSString *userID = [self.recipientIDs firstObject];
            TSUserInfo *user = [self userInfoForID:userID];
            if ([self.accountHandle.actionContext isSfCInteropEnabled]
                && [TSUtilities isSfCUserForUserID:userID accountHandle:self.accountHandle])
            {
                scenarioName = SCENARIO_CHAT_SEND_MESSAGE_SFC_NEWTHREAD;
            }
            else if (user.isSfBInteropAvailable)
            {
                scenarioName = SCENARIO_CHAT_SEND_MESSAGE_SFB_NEWTHREAD;
            }
        }
        
        if (self.isRosterWithFederatedUser || self.isRosterWithExtendedDirectoryUser || self.isRosterWithTflInterOpUser || self.isRosterWithOffNetworkFedUser)
        {
            scenarioName = SCENARIO_CHAT_SEND_MESSAGE_FEDERATED_NEWTHREAD;
        }
    }
    
    return scenarioName;
}

-(BOOL) galleryAllowMediaUpload
{
    BOOL disableCompose = NO;
    
    // Allow gallery media upload when compose is not disabled
    [self placeHolderTextForComposeViewController:&disableCompose];
    
    return !disableCompose;
}

-(NSString *) placeHolderTextForComposeViewController:(BOOL *)disableCompose
{
    *disableCompose = NO;
    NSString *placeHolderText = AXPLocalizedString(@"CmposBdyPlcHldrNewMsg");
    NSString *userID = [self.recipientIDs firstObject];
    
    if (!self.isMeeting && !self.accountHandle.actionContext.userPrivateChatEnabledOnTenant)
    {
        *disableCompose = YES;
        placeHolderText = AXPLocalizedString(@"ChatDisabledMessage");
        return placeHolderText;
    }
    
    if ([self shouldDisableFedChatComposeOptions])
    {
        *disableCompose = YES;
        placeHolderText = AXPLocalizedString(@"ChatDisabledTitle");
        return placeHolderText;
    }
    
    if (self.threadType == TSThreadTypeOneOnOneChat)
    {
        if ([TSUser isBOT:userID])
        {
            if ([self isBotConversationBlocked])
            {
                *disableCompose = YES;
                placeHolderText = AXPLocalizedString(@"ComposeBodyPlaceHolderTextBlockedChat");
            }
            
            if ([TSAppDefinitionManager.sharedInstance isNotificationsOnlyBot:userID])
            {
                *disableCompose = YES;
                placeHolderText = AXPLocalizedString(@"ComposeBodyPlaceHolderTextForBotConversationNotSupported");
            }
        }
        else if (self.isChatDisable || [self isConversationDisabled])
        {
            *disableCompose = YES;
            TSUser *user = [TSUser userForID:userID inManagedObjectContext:self.accountHandle.mainMOC];
            placeHolderText = [self localizedDisabledReasonForUserName:[user displayName]];
        }
        else
        {
            if ([TSUtilities isContactBlockingEnabled:self.accountHandle] &&
                [TSSFCInteropOrTFLChatBlockAcceptViewController isBlockedSfCInteropOrTFLChatForThread:self.threadID recipientMri:self.recipientIDs.firstObject accountHandle:self.accountHandle])
            {
                *disableCompose = YES;
                placeHolderText = AXPLocalizedString(@"CmpPHTxtSfCChtUIDbled");
            }
            else if ((self.accountHandle.policyManager.isInviteFreeEnabled || self.accountHandle.policyManager.isTfwTflFedChatConsumptionPhase2OnTfwEnabled) &&
                     ![TSSFCInteropOrTFLChatBlockAcceptViewController isAcceptedSfCInteropOrTFLChatForThread:self.threadID accountHandle:self.accountHandle])
            {
                *disableCompose = YES;
                placeHolderText = AXPLocalizedString(@"CmpPHTxtInvtChtDbled");
            }
        }
    }
    else if (self.threadType == TSThreadTypeInteropChat && [TSUtilities isSfCInteropChatByThreadId:self.threadID])
    {
        [self.accountHandle.actionContext logSfCInteropFlags];
        if (![self.accountHandle.actionContext isSfCInteropEnabled])
        {
            *disableCompose = YES;
            placeHolderText = AXPLocalizedString(@"CmpPHTxtSfCInteropDbled");
        }
        else
        {
            if ([self.accountHandle.policyManager.blockListForUser containsObject:userID])
            {
                *disableCompose = YES;
                placeHolderText = AXPLocalizedString(@"CmpPHTxtSfCChtUIDbled");
            }
            else if ([self.actionContext.acceptedSfCInteropChats containsObject:userID])
            {
                *disableCompose = NO;
                placeHolderText = AXPLocalizedString(@"CmposBdyPlcHldrNewMsg");
            }
            else
            {
                *disableCompose = YES;
                placeHolderText = AXPLocalizedString(@"CmpPHTxtSfCChtUIDbled");
            }
        }
    }
    else if (self.threadType == TSThreadTypeInteropChat && [TSUtilities isSfBInteropChatByThreadId:self.threadID] && ![self.accountHandle.actionContext isSfBInteropEnabled])
    {
        [self.accountHandle.actionContext logSfBInteropFlags];
        *disableCompose = YES;
        placeHolderText = AXPLocalizedString(@"ComposeBodyPlaceHolderTextInteropChatsDisabled");
    }
    else if (self.didAnonJoinCallEnd)
    {
        *disableCompose = YES;
        placeHolderText = AXPLocalizedString(@"ComposeBodyPlaceHolderTextLeftAnonJoinMeeting");
    }
    else if (self.threadType == TSThreadTypeGroupChat || [self isMeeting])// group chat or meeting chat
    {
        if ([TSConversation didUserLeaveChatwithThreadID:self.threadID])
        {
            *disableCompose = YES;
            placeHolderText = AXPLocalizedString(@"ComposePlaceholderWhenNotInChat");
        }
        
        if (![self isMeeting] && [TSUtilities hasSfBOnlyUser:self.recipientIDs accountHandle:self.accountHandle])
        {
            placeHolderText = AXPLocalizedString(@"ComposePlaceholderForSfBGroupChat");
        }
        
        if (self.isChatDisable)
        {
            *disableCompose = YES;
            placeHolderText = AXPLocalizedString(@"ChatDisabledMessage");
        }
    }
    
    return placeHolderText;
}

- (AXPPanelInfo *) biPanelInfo
{
    AXPPanelInfo *panelInfo = [[AXPPanelInfo alloc] init];
    panelInfo.type = TSkPanelTypeChat;
    panelInfo.uri = TSkPanelUriConversation;
    panelInfo.threadType = self.biThreadType;
    panelInfo.chatType = self.biChatType;
    panelInfo.threadId = self.threadID;
    panelInfo.threadMembers = self.biThreadMembersCount;
    
    return panelInfo;
}

-(void) composeViewController:(TSBaseComposeViewController *)composeViewController
          willFinishComposing:(NSDictionary *)composeInfo
                   completion:(void (^)(NSError *, NSNumber *, NSString *, NSString *, NSString *))completion
{
    typeof(self) __weak weakSelf = self;
    [self askForGroupNameIfNeeded:^(BOOL completed) {
        if (completed)
        {
            [weakSelf sendMessageFrom:composeViewController composeInfo:composeInfo completion:completion];
        } else {
            completion([NSError errorWithDescription:@"Cancelled"], nil, nil, nil, nil);
        }
    }];
}

- (void) askForGroupNameIfNeeded: (void(^)(BOOL)) completion
{
    if (self.accountHandle.policyManager.isTfwTflFedChatConsumptionPhase2OnTfwEnabled &&
        [NSString isNilOrEmpty:self.topicName] && self.recipientIDs.count == 1)
    {
        NSDictionary* userInfo = self.recipientsUserInfo[self.recipientIDs.firstObject];
        NSString *itemType = userInfo[TSkSearchResultItemType];
        if ([itemType isEqual:TSkAnonymousUserWithEmailSearchType] ||
            [itemType isEqual:TSkAnonymousUserWithPhoneSearchType])
        {
            [self autoNameOffNetworkChat:userInfo[TSkEDUserNameKey]
                       deviceContactName:userInfo[TSkDeviceContactName]
                      defaultDisplayName:userInfo[TSkUserDisplayName]];
            
            if ([self.topicName isNotNilOrEmpty])
            {
                completion(true);
                return;
            }
        }
    }
    
    BOOL groupNameRequired = [self.accountHandle.groupTraits groupNameRequiredFor:self.recipientsUserInfo]
    && [NSString isNilOrEmpty:self.topicName]
    && [NSString isNilOrEmpty:self.threadID];
    if (!groupNameRequired) {
        completion(true);
        return;
    }
    
    self.textInputAlertController = [[TextInputAlertController alloc] initWithTitle:AXPLocalizedString(@"GroupNameReqTitle2")
                                                                            message:AXPLocalizedString(@"GroupNameReqMessage2")
                                                                        placeholder:AXPLocalizedString(@"GroupNameReqPlchldr")
                                                                       confirmTitle:AXPLocalizedString(@"TSOK")];
    TSChatViewController * __weak weakSelf = self;
    [self.textInputAlertController showIn:self completion:^(NSString *text)
     {
        self.groupNameRequiredPromptShown = YES;
        if ([text isNotNilOrEmpty])
        {
            weakSelf.topicName = text;
            completion(true);
        } else {
            completion(false);
        }
    }];
}

- (void)addRecipientAsBuddy
{
    LogInfoAH(self.logger, @"adding recipient to buddy group.");
    NSString *recipientMri = self.recipientIDs.firstObject;
    if ([recipientMri isEqualToString:self.accountHandle.MRI])
    {
        LogErrorAH(self.logger, @"Cannot add self as a contact");
        return;
    }
    NSString *correlationID = [TSkCorrelationTagContactGroups stringByAppendingString:[[NSUUID UUID] UUIDString]];
    NSString *scenarioID = [self.accountHandle.logger logStartScenarioEventOfType:SCENARIO_ADD_BUDDY];
    [self.accountHandle.logger addScenarioProperties:scenarioID properties:@{TSkAddBuddySource : TSkSendMessageSource}];
    TSAction *addBuddy = [self.actionContext actionOfClass:[TSNABuddyGroup class]
                                            fromDictionary:@{
        TSkActionType : [NSNumber numberWithInteger:TSkBuddyGroupActionTypeManage],
        TSkCorrelationID : correlationID,
        TSkBuddyGroupID : TFLkContacts,
        TSkUsersToAdd : @[recipientMri]
    }
                                            withCompletion:nil];
    
    [addBuddy executeActionChain:@"add recipient to buddy group" withCompletion:^(TSAction *action, TSAResult *result, NSError *err) {
        if (err)
        {
            [AXPUtilities logNetworkErrorOrWarning:err withMessage:[NSString stringWithFormat:@"Error has occured while adding recipient to buddy group. Error code: %zd, error domain: %@", err.code, err.domain] logger:action.accountHandle.logger];
            [self.accountHandle.logger logScenarioStopEvent:scenarioID status:ScenarioStatusFailure withError:err];
        }
        else
        {
            // Add this recipient to buddy group contacts list to make sure we will not send adding buddy request for this recipient.
            NSMutableArray<NSString *> *buddyGroupContacts = [[self.accountHandle.tenantDefaults objectForKey:TSkBuddyGroupContacts] mutableCopy];
            [buddyGroupContacts addObject:recipientMri];
            [self.accountHandle.tenantDefaults setObject:buddyGroupContacts forKey:TSkBuddyGroupContacts];
            [self.accountHandle.logger logScenarioStopEvent:scenarioID status:ScenarioStatusOK];
            
            // Manually refresh buddy group contacts list so that user can see the buddy on contact tab immediately.
            [TSBuddyGroup syncAllBuddyGroupsWithAccountHandle:self.accountHandle andCompletion:^(NSArray<TSBuddyGroup *> *syncedGroups, NSError *syncError) {
                if (syncError)
                {
                    LogErrorAH(self.logger, @"Error has occured refreshing buddy group. Error code: %zd, error domain: %@", syncError.code, syncError.domain);
                }
            }];
        }
    }];
}

- (void)addUserToAcceptList
{
    if ([self.recipientIDs count] == 0)
    {
        return;
    }
    
    NSString *recipientMri = self.recipientIDs.firstObject;
    TSAction *addToAcceptList = [self.accountHandle.actionContext actionOfClass:[TSNAManageAcceptList class]
                                                                 fromDictionary:@{
        TSkUsersToAdd : @[recipientMri]
    }
                                                                 withCompletion:nil];
    
    [addToAcceptList executeActionChain:@"add recipient to accept list" withCompletion:^(TSAction *action, TSAResult *result, NSError *err) {
        if (err)
        {
            [AXPUtilities logNetworkErrorOrWarning:err
                                       withMessage:[NSString stringWithFormat:@"Error has occured while adding recipient to accept list. Error code: %zd, error domain: %@", err.code, err.domain]
                                            logger:action.accountHandle.logger];
        }
    }];
}

-(void) sendMessageFrom:(TSBaseComposeViewController *)composeViewController
            composeInfo:(NSDictionary *)composeInfo
             completion:(void (^)(NSError *, NSNumber *, NSString *, NSString *, NSString *))completion
{
    // Extra safety check, don't send
    if (!self.isMeeting && !self.accountHandle.actionContext.userPrivateChatEnabledOnTenant)
    {
        LogErrorAH(self.accountHandle.logger, @"Send pressed when not userPrivateChatEnabledOnTenant");
        
        [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"ChatDisabledTitle")
                                     andMessage:AXPLocalizedString(@"ChatDisabledMessage")
                               andButtonContent:AXPLocalizedString(@"TSOK")
                              andViewController:self];
        return;
    }
    
    __block NSMutableDictionary *dataBagValues = [[NSMutableDictionary alloc] initWithDictionary:@{
        TSkType: [composeInfo objectForKey:TSkAudioId] ? TSkChatMsgSendTypeAudio : TSkChatMsgSendTypeRegular,
        TSkSessionId: self.sessionId
    }];
    
    BOOL isNewThread = (self.thread == nil);
    BOOL isOneOnOneChat = NO;
    
    __block BOOL isNewGroupThread = NO;
    if (isNewThread)
    {
        isNewGroupThread = [self isNewGroupThread];
    }
    else
    {
        isOneOnOneChat = self.thread.isOneOnOneChat;
    }
    
    NSString *userID = self.recipientIDs.count == 1 ? self.recipientIDs[0] : nil;
    
    NSString *scenario = TSkScenarioChatSendMessage;
    NSString *panelUri = TSkPanelUriConversation;
    if ([self isSMSChat])
    {
        scenario = TSkScenarioChatSMSSendMessage;
    }
    
    if ([self isSfCInteropChat])
    {
        panelUri = TSkPanelURIChatSfCInterop;
    }
    
    NSAttributedString *textBody = self.composeViewController.textBody.attributedText;
    NSManagedObjectContext *moc = self.accountHandle.privateMOC;
    TSWeakify(self);
    DbReadWrite(SELECTOR_NAME(self), moc, ^
                {
        TSStrongifyAndReturnIfNil(self);
        if (isNewThread)
        {
            // Add more telemetry data for new chat creation
            [dataBagValues addEntriesFromDictionary:[self addNewChatCompleteTelemetry]];
            
            NSInteger phoneUsersCount = [self phoneUsersCount];
            if (phoneUsersCount > 0)
            {
                [self logNewGroupWithPhoneUsersCreatedPanelAction: phoneUsersCount];
            }
        }
        
        NSDictionary *basicMetaData = [self.composeViewController basicSendMessageMetaData:self.threadID
                                                                                threadType:self.biThreadType
                                                                                  textBody:textBody
                                                                                       moc:moc];
        [dataBagValues addEntriesFromDictionary:basicMetaData];
        
        if (self.accountHandle.policyManager.isTfwTflFedChatConsumptionEnabled)
        {
            [dataBagValues addEntriesFromDictionary:@{
                TSkHasAADFederatedMembers : (self.isRosterWithFederatedUser ? @"true" : @"false"),
                TSkHasMSAFederatedMembers : ((self.isRosterWithTflInterOpUser || self.isRosterWithExtendedDirectoryUser) ? @"true" : @"false")
            }];
        }
        
        if (self.accountHandle.policyManager.isGroupCreationWithTemplatesEnabled)
        {
            NSString *groupTemplateId = [AXPCtx threadForID:self.threadID inMoc:moc].groupTemplateId;
            if (![NSString isNilOrEmpty:groupTemplateId])
            {
                [dataBagValues addEntriesFromDictionary:@{
                    TSkBIMetadataKeyGroupTemplateType: groupTemplateId,
                    TSkBIMetadataKeyGroupTemplateNamingEnabled: @([self.accountHandle.policyManager isGroupCreationWithNamingInTemplatesEnabled])
                }];
            }
        }
        
        [self.accountHandle saveMoc:moc caller:SELECTOR_NAME(self) completion:nil];
        
        BOOL isFileSuggestionClicked = [self.selectedFileSmartReplyID isNotNilOrEmpty];
        BOOL isFileBrowseClicked = [self.browseFileSmartReplyID isNotNilOrEmpty];
        if (self.suggestedFiles && self.suggestedFiles.count > 0 && (isFileSuggestionClicked || isFileBrowseClicked))
        {
            NSString *whisperId = isFileSuggestionClicked ? self.selectedFileSmartReplyID : self.browseFileSmartReplyID;
            NSNumber *attachedFilesCount = [NSNumber numberFromString:basicMetaData[TSFilesAttached] ?: @"0"];
            if ([attachedFilesCount compare:@0] != NSOrderedDescending)
            {
                [self logSmartReplyActionCompleteEvent:whisperId
                                            withStatus:TSkSmartReplyCancelled
                                   isFileBrowseClicked:isFileBrowseClicked];
            }
            else
            {
                [self logSmartReplyActionCompleteEvent:whisperId
                                            withStatus:TSkCompletedKey
                                   isFileBrowseClicked:isFileBrowseClicked && !isFileSuggestionClicked];
            }
            
            self.selectedFileSmartReplyID = nil;
            self.browseFileSmartReplyID = nil;
        }
    });
    
    __weak TSChatViewController* weakSelf = self;
    
    NSString *scenarioName = [self sendScenarioName];
    
    NSString *scenarioID = [[NSUUID UUID] UUIDString];
    NSString *correlationID = [TSkCorrelationTagChatMsgSend stringByAppendingString:scenarioID];
    NSMutableDictionary *properties = [self.accountHandle.logger teamChannelThreadInfo].mutableCopy ?: [NSMutableDictionary new];
    properties[TSkDATABAG_PROPERTIES] = [@{
        TSkChatCreationEntryPoint: (self.scenarioEntryPoint ?: @""),
        TSkIsNewChat: @(isNewThread),
        TSkIsSmsChat: @([self isSMSChat]),
    } jsonString];
    LogInfoAH(self.logger, @"New chat thread creation initiated, CID:%@", correlationID);
    scenarioID = [self.accountHandle.logger logStartScenarioEventOfType:scenarioName
                                                          correlationID:correlationID
                                                             scenarioID:scenarioID
                                                         withProperties:properties];
    
    NSMutableDictionary *params = [composeInfo mutableCopy];
    LogInfoAH(self.logger, @"[ChatVC]: composeVC callback starting message creation");
    
    BOOL areZeroRecipientsAllowed = (self.accountHandle.policyManager.allowMessagesToSingleUserChat ||
                                     (self.isGuardiansChat && self.threadID) ||
                                     self.isChatWithSelf);
    if ((self.recipientIDs == nil || [self.recipientIDs count] == 0) && !areZeroRecipientsAllowed)
    {
        // Return early if the recipients are empty
        NSError *creationError = [NSError errorWithDomain:TSErrorDomain
                                                     code:TSErrorCancelled
                                                 userInfo:@{NSLocalizedDescriptionKey : @"Create message failed. Recipients are empty"}];
        if (completion)
        {
            [self.accountHandle.logger logScenarioStopEvent:scenarioID status:ScenarioStatusCancel];
            completion(creationError, nil, nil, scenarioID, correlationID);
        }
        
        LogErrorAH(self.logger, @"[ChatVC]: Create message failed due to invalid participant count");
        return;
    }
    
    if ((self.accountHandle.policyManager.isInviteFreeEnabled || self.accountHandle.policyManager.isTfwTflFedChatConsumptionPhase2OnTfwEnabled || [self.accountHandle.policyManager isTfwTflFedChatCreationOnTfwEnabled]) && [self isOneToOneChat] && !isNewGroupThread)
    {
        TSConversation *conv = [TSConversation conversationForID:self.threadID inMOC:self.accountHandle.mainMOC];
        if ([[conv quarantineMessageCount] integerValue] >= [self.accountHandle.ecsManager maxQuarantineCounter])
        {
            NSError *creationError = [NSError errorWithDomain:TSErrorDomain
                                                         code:TSErrorCancelled
                                                     userInfo:@{NSLocalizedDescriptionKey : SCENARIO_ERROR_QUARANTINE_LIMIT_REACHED}];
            
            TSUser *user = [TSUser userForID:self.recipientIDs.firstObject inManagedObjectContext:self.accountHandle.mainMOC];
            [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"SendMsgErrTtle")
                                         andMessage:[NSString stringWithFormat:AXPLocalizedString(@"SendMsgErrMsg"), user.displayNameWithGuestInfo]
                                    andAlertActions:@[[UIAlertAction actionWithTitle:AXPLocalizedString(@"TSOK")
                                                                               style:UIAlertActionStyleDefault
                                                                             handler:nil]]
                                  andViewController:self];
            
            if (completion)
            {
                completion(creationError, nil, nil, scenarioID, correlationID);
            }
            LogErrorAH(self.logger, @"[ChatVC]: Create message failed due to conversation not accepted and quarantine message limit hit");
            return;
        }
    }
    
    params[@"statusMessage"] = @"creating chat message";
    if (self.lastPostTimeForUserComposingMessage)
    {
        params[@"lastPostTimeForUserComposingMessage"] = self.lastPostTimeForUserComposingMessage;
    }
    
    if ([self.threadID length])
    {
        params[TSkThreadID] = self.threadID;
        [self createChatMessage:params
                       scenario:scenarioID
                  correlationID:correlationID
                     completion:^(NSError *error, NSNumber *messageID, NSString *threadID,
                                  NSString *scenarioID, NSString *correlationID) {
            if (!error) {
                if (self.accountHandle.ecsManager.shareShortcutsEnabled) {
                    DbReadWrite(SELECTOR_NAME(self), self.accountHandle.highPriMOC, ^{
                        ShareSuggestionsIntentHandler *intentHandler = [[ShareSuggestionsIntentHandler alloc] initWith:self.threadID spokenPhrase:self.topicName for:self.accountHandle];
                        [intentHandler donateIntent];
                    });
                }
            }
            
            [self logTelemetryForSendMessageEvent:userID
                                    withMessageID:messageID
                                     withThreadID:threadID
                                     withScenario:scenario
                                      andPanelUri:panelUri
                                   isOneOnOneChat:isOneOnOneChat
                                       andDataBag:dataBagValues];
            
            if(completion) {
                completion(error, messageID, threadID, scenarioID, correlationID);
            }
        }];
    }
    else
    {
        [self startActivityIndicator];
        [self.composeViewController updateUIForSendingState:YES];
        
        if (isNewGroupThread)
        {
            [self updateStatusBannerState];
            [[NSNotificationCenter defaultCenter] postNotificationName:TSkGroupConversationCreated
                                                                object:self.accountHandle];
            
            NSDictionary *campaignAttributes = [TSUtilities metaDataFromDataBagDictionary: @{TSkFunnelEventAttributeCampaign: self.activationPillar ?: @""}];
            NSDictionary *tflActivationMetadata  = [campaignAttributes dictionaryByAddingEntries:@{TSkFunnelEventAttributeSource: self.activationOrigin ?: @""}];
            
            // write pillar that was used to create group to settings so we can show default/some other banner next
            [self.accountHandle.tenantDefaults setObject:self.activationPillar forKey:TSkActivateLifeAccountBannerPillarKey];
            self.createGroupPerformanceScenarioID = [self.logger logStartScenarioEventOfType:PERF_SCENARIO_CREATE_NEW_GROUP];
            [self.logger logPanelAction:TSkActionModuleNameNameGroupChat
                                outCome:TSkActionOutcomeSubmit
                                gesture:TSkActionGestureTap
                               scenario:TSkActionTFLGroupCreationCompleted
                           scenarioType:TSkScenarioTypeTFLActivation
                         destinationuri:nil
                   destinationUriParams:nil
                             moduleType:nil
                            moduleState:nil
                          moduleSummary:nil
                              panelType:TSkPanelTypeChatList
                               panelUri:nil
                         panelUriParams:nil
                               threadId:self.threadID
                             threadType:self.biThreadType
                          threadMembers:self.biThreadMembersCount
                               metaData:tflActivationMetadata
            ];
        }
        
        if (isNewThread && self.isRosterWithOffNetworkFedUser)
        {
            [self updateStatusBannerState];
        }
        
        if(isNewThread && self.recipientIDs.count > 1)
        {
            //logging the user breakdown of any new group chat being created.
            NSDictionary* dataBagValues = [NSDictionary getUserTypeInfo:self.recipientIDs
                                                        additionContext:nil
                                                isChatCreationScenarion:YES
                                               withOffNetworkUsersCount:nil
                                                                  inMOC:self.accountHandle.mainMOC];
            [self.logger logPanelAction:TSkModuleNameStartNewGroupChat
                                outCome:nil
                                gesture:nil
                               scenario:TSkScenarioCreateGroupChat
                           scenarioType:TSkScenarioChatCreation
                             moduleType:nil
                              panelType:TSkPanelTypePeoplePicker
                               panelUri:nil
                               threadId:self.threadID
                             threadType:TSkThreadTypeGroupChat
                               metaData:[TSUtilities metaDataFromDataBagDictionary:dataBagValues]];
        }
        
        if (isNewThread && self.recipientIDs.count > 1)
        {
            [[TSAccessibilityNotificationHelper sharedInstance] delayQueueMessage:AXPLocalizedString(@"GrpCrtdAccLbl") withDelayInSeconds:TSkMessageSendAnnouncementDelay];
        }
        
        if (isNewThread && self.recipientIDs.count == 1)
        {
            // logging thread creation action for one-on-one chat threads.
            [self.accountHandle.logger logPanelAction:TSkActionModuleNameSendButton
                                              outCome:TSkActionOutcomeSubmit
                                              gesture:TSkActionGestureTap
                                             scenario:TSkPeoplePickerForNewChatScenarioName
                                         scenarioType:TSkScenarioTypeChat
                                           moduleType:nil
                                            panelType:TSkPanelTypeNewChatCreated
                                             panelUri:TSkPanelUriConversation
                                             threadId:nil
                                           threadType:TSkThreadTypeOneOnOneChat
                                        threadMembers:nil
                                             chatType:nil
                                             metaData:[TSUtilities metaDataFromDataBagDictionary:dataBagValues]];
        }
        
        BOOL handled = [[[TSSyncEngine sharedInstance] threadSyncManager] tryCreateOneOnOneSmsChatThread:self.recipientIDs
                                                                                           recipientInfo:self.recipientsUserInfo
                                                                                                 message:params[TSkAttributedText]
                                                                                           correlationID:correlationID
                                                                                           accountHandle:self.accountHandle
                                                                                              completion:^(NSString *threadID, NSString *displayName, NSError *error, BOOL hasMultiStatusResponse)
                        {
            if (error)
            {
                [weakSelf handleThreadCreationError:error
                                         scenarioID:scenarioID
                                      correlationID:correlationID
                                         completion:completion];
                
            }
            else
            {
                self.groupChatCreationState = TSGroupChatCreationStateNoOp;
                [weakSelf handleSmsThreadCreationSuccessWithThreadId:threadID
                                                         displayName:displayName
                                                          scenarioID:scenarioID
                                                       correlationID:correlationID
                                                          completion:completion];
            }
        }];
        
        if (handled)
        {
            return;
        }
        
        if (self.threadID == nil && self.isGuardiansChat)
        {
            self.recipientsUserInfo = [self buildGuardiansRecipientsUserInfo];
        }
        
        [[[TSSyncEngine sharedInstance] threadSyncManager] findOrCreateChatThread:self.recipientIDs
                                                                    recipientInfo:self.recipientsUserInfo
                                                                       threadInfo:self.guardiansChatThreadInfo
                                                                 previousThreadId:self.threadID
                                                             chatCreateEntryPoint:self.scenarioEntryPoint
                                                               chatCreateJoinLink:self.chatJoinUrl
                                                                        topicName:self.topicName
                                                                      groupAvatar:self.emptyStateView.avatarImage
                                                                         avatarId:self.customAvatarId
                                                                    correlationID:correlationID
                                                                      forceCreate:isNewGroupThread && ![self showOneToOneChatInGroupCreationFlow]
                                                                    accountHandle:self.accountHandle
                                                    threadCreationDataBagOverride:^NSDictionary *()
         {
            return [self newThreadCreatedTelemetryDatabag];
        }
                                                    callsIBViolationHandleEnabled:NO
                                                                       completion:^(NSString *threadID, NSError *err, BOOL hasMultiStatusResponse)
         {
            
            if ((err && !hasMultiStatusResponse) || !threadID.length)
            {
                if (!err)
                {
                    err = [NSError errorWithDescription:@"findOrCreateChatThread returned nil threadID."];
                }
                [weakSelf handleThreadCreationError:err
                                         scenarioID:scenarioID
                                      correlationID:correlationID
                                         completion:completion];
                return;
            }
            
            // Check for if the current process is only using for sending fluid message to create new chat group
            // Protected with ECS flag check
            if (self.isFluidObjectEnabled && [[composeInfo objectForKey:TSkFluidComposeNewGroupKey] boolValue])
            {
                [TSDispatchUtilities dispatchOnMainThread:^{
                    TSThread *thread = [AXPCtx threadForID:threadID inMoc:self.accountHandle.mainMOC];
                    TSThreadProperty *awarenessProperty = nil;
                    if (self.threadType == TSThreadTypePrivateMeeting)
                    {
                        awarenessProperty = [AXPCtx threadPropertyForThreadID:self.threadID
                                                              andPropertyName:TSkThreadPropertyPrivateMeetingAwareness
                                                                        inMoc:self.accountHandle.mainMOC];
                    }
                    if (thread && ([thread isDisabledChatWithInProgressMeetingOption:YES meetingInProgress:awarenessProperty ? awarenessProperty.propertyValue : NO] && !self.forceEnableChat))
                    {
                        // Return early if the recipients are disabled for chat
                        NSError *error = [NSError errorWithDomain:TSErrorDomain
                                                             code:TSErrorCancelled
                                                         userInfo:@{NSLocalizedDescriptionKey : @"Create message failed.  Chat is blocked with one of the recipients"}];
                        if (completion)
                        {
                            completion(error, nil, nil, scenarioID, correlationID);
                        }
                    } else {
                        if (completion)
                        {
                            completion(nil, nil, threadID, @"", correlationID);
                        }
                    }
                }];
                
                return;
            }
            
            if (self.accountHandle.policyManager.isInviteFreeEnabled && self.shouldSendAddContactRequest)
            {
                [self addRecipientAsBuddy];
            }
            
            if (self.accountHandle.policyManager.isTfwTflFedChatCreationOnTfwEnabled && [self shouldAddMriToAcceptList])
            {
                [self addUserToAcceptList];
            }
            
            if (isNewThread && self.isGuardiansChat && self.guardiansUserId && self.guardiansAadGroupId)
            {
                [self checkInactiveGuardiansWithUserId:self.guardiansUserId
                                            aadGroupID:self.guardiansAadGroupId];
            }
            
            [TSDispatchUtilities dispatchOnMainThread:^
             {
                // Intentionally using self in this Dispatch!
                // Navigating back during thread creation could dealloc this viewController and stop the message sending.
                
                // Thread created or found, no longer in new chat mode. Note that isNewChat is based on chatCreateDraftKey so remember it before resetting.
                BOOL isFirstMessage = [self isNewChat];
                TSThread *thread = [AXPCtx threadForID:threadID];
                
                if([userID hasPrefix:TSUserPrefix] && [self isOneToOneChat])
                {
                    // post notification to chat list to remove suggestion if shown
                    [[NSNotificationCenter defaultCenter] postNotificationName:TSkChatCreatedFromSuggestedContact
                                                                        object:nil
                                                                      userInfo:@{TSKKeyUserID:userID}];
                }
                
                [self.outerViewController didJustCreateNewChatAndSendFirstMessage:thread.isGroupChat];
                self.chatCreateDraftKey = nil;
                
                if (thread && ([thread isDisabledChat] && !self.forceEnableChat))
                {
                    [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"ChatDisabledTitle")
                                                 andMessage:AXPLocalizedString(@"ChatDisabledMessage")
                                           andButtonContent:AXPLocalizedString(@"TSOK")
                                          andViewController:self];
                    
                    if (completion)
                    {
                        // Return early if the recipients are disabled for chat
                        NSError *error = [NSError errorWithDomain:TSErrorDomain
                                                             code:TSErrorCancelled
                                                         userInfo:@{NSLocalizedDescriptionKey : @"Create message failed.  Chat is blocked with one of the recipients"}];
                        //expected result
                        [self.accountHandle.logger logScenarioStopEvent:scenarioID status:ScenarioStatusCancel];
                        if (completion)
                        {
                            completion(error, nil, nil, scenarioID, correlationID);
                        }
                    }
                }
                else
                {
                    // If this is the first message extract off-network recipients so they can be invited to join the chat after the message is sent.
                    TSRecipientsResolver *resolver = [TSRecipientsResolver resolveRecipientInfo:self.recipientsUserInfo];
                    if ((isFirstMessage && ([self.accountHandle.actionContext isInviteAnonymousUserByEmailOrPhoneEnabled] ||
                                            self.isGuardiansChat)) ||
                        (isNewThread && self.isGuardiansChat))
                    {
                        params[TSkPhoneUsersToInviteKey] = resolver.phones;
                        params[TSkEmailUsersToInviteKey] = resolver.emails;
                    }
                    params[TSkThreadID] = threadID;
                    
                    [TSUtilities logPanelActionForChatSendMessage:self.logger
                                                    accountHandle:self.accountHandle
                                                         scenario:scenario
                                                         panelUri:panelUri
                                                         threadId:self.threadID
                                                       threadType:self.biThreadType
                                                    threadMembers:self.biThreadMembersCount
                                                         chatType:self.biChatType
                                                    dataBagValues:[TSUtilities metaDataFromDataBagDictionary:dataBagValues]];
                    if (self.accountHandle.policyManager.isTfwTflFedChatCreationOnTfwEnabled
                        && (resolver.hasNonResolvedRecipients || [self.federationUtils hasExternalTeamsUserIn:resolver.resolvedRecipients inMoc:self.accountHandle.mainMOC]))
                    {
                        [TSUserActionsManager.sharedInstance updateThreadJoinLinkForThreadID:threadID
                                                                    threadJoinLinkActionType:TSkThreadJoinLinkActionTypeCreate
                                                                               accountHandle:self.accountHandle
                                                                       withCompletionHandler:^(NSString *correlationID, NSError *updateThreadError) {
                            [TSChatViewController createChatMessageHelper:self
                                                                   params:params
                                                                 scenario:scenarioID
                                                            correlationID:correlationID
                                                               completion:completion];
                        }];
                    }
                    else
                    {
                        [TSChatViewController createChatMessageHelper:self
                                                               params:params
                                                             scenario:scenarioID
                                                        correlationID:correlationID
                                                           completion:completion];
                    }
                }
                
                // Inform user there was a partial success after message has been sent
                if (hasMultiStatusResponse)
                {
                    if (err.code == TSErrorCreateChat && err.domain == TSErrorDomain)
                    {
                        NSString *alertTitle = TSAccountLocalizedString(@"AlertErrCrGrpChTtl");
                        NSString *alertMessage = TSAccountLocalizedString(@"AlErrCrChatMsg");
                        
                        [TSAlertUtils presentAlertViewWithTitle:alertTitle
                                                     andMessage:alertMessage
                                               andButtonContent:AXPLocalizedString(@"TSOK")
                                                        andLink:[self.accountHandle.policyManager supervisedChatLearnMoreUrl]
                                              andViewController:self
                                                 withCompletion:^(BOOL success) {
                            [self.view endEditing:YES];
                        }];
                    }
                    else
                    {
                        NSString *title = AXPLocalizedString(@"AlertErrorTitle");
                        NSString *buttonText = AXPLocalizedString(@"TSOK");
                        NSString *message = nil;
                        if (err.code == TSErrorInvite)
                        {
                            message = AXPLocalizedString(@"InvError");
                        } else {
                            message = AXPLocalizedString(@"IBPolicyViolationErrorMessage");
                        }
                        [TSAlertUtils presentAlertViewWithTitle:title
                                                     andMessage:message
                                               andButtonContent:buttonText
                                              andViewController:self];
                    }
                }
                
                [self stopActivityIndicator];
                [self.composeViewController updateUIForSendingState:NO];
            }];
        }];
    }
    self.groupChatCreationState = TSGroupChatCreationStateNoOp;
    
    if ([self isPrivateChatWithBot])
    {
        /** Make sure menu is filtering with what the user sees in the compose box
         * https://domoreexp.visualstudio.com/MSTeams/_workitems/edit/1657343
         */
        [self.botMenuProvider.botMenuClientRequestHandler createResetBotMenuRequest];
    }
}

+ (void)createChatMessageHelper:(TSChatViewController *)chatViewController
                         params:(NSDictionary *)params
                       scenario:(NSString *)scenarioID
                  correlationID:(NSString *)correlationID
                     completion:(void (^)(NSError *, NSNumber *, NSString *, NSString *, NSString *))completion
{
    if (chatViewController)
    {
        [chatViewController createChatMessage:params
                                     scenario:scenarioID
                                correlationID:correlationID
                                   completion:completion];
    }
    else
    {
        [TSChatViewController createMessageWithParams:params
                                             scenario:scenarioID
                                        correlationID:correlationID
                                        accountHandle:TSAccountManager.activeConfigHandle
                                           completion:nil];
    }
}

- (void) logTelemetryForDragEvent:(NSString *)scenarioType
                          outCome:(NSString *)outCome
                          dataBag:(NSDictionary *)dataBag
{
    NSDictionary* metadata = [TSUtilities metaDataFromDataBagDictionary:dataBag];
    
    [self.logger logPanelAction:TSkActionModuleNameDragChatCell
                        outCome:outCome
                        gesture:TSkActionGestureDrag
                       scenario:TSkScenarioDragAndDrop
                   scenarioType:scenarioType
                 destinationuri:nil
           destinationUriParams:nil
                     moduleType:TSkActionModuleTypeChatList
                    moduleState:nil
                  moduleSummary:nil
                      panelType:self.currentPanelInfo.type
                       panelUri:self.currentPanelInfo.uri
                 panelUriParams:self.currentPanelInfo.uriParams
                     threadType:self.currentPanelInfo.threadType
                       metaData:metadata];
}

- (void) logTelemetryForAddToCalendar:(NSString *)scenarioName
                         scenarioType:(NSString *)scenarioType
{
    [self.logger logPanelAction:scenarioName
                        outCome:TSkActionOutcomeSubmit
                        gesture:TSkActionGestureTap
                       scenario:scenarioName
                   scenarioType:scenarioType
                     moduleType:TSkActionModuleTypeButton
                      panelType:TSkPanelTypeChat
                       panelUri:nil
                     threadType:nil
                       metaData:nil];
}

- (void) logTelemetryForSendMessageEvent:(NSString *)userID
                           withMessageID:(NSNumber *)messageID
                            withThreadID:(NSString *)threadID
                            withScenario:(NSString *)scenario
                             andPanelUri:(NSString *)panelUri
                          isOneOnOneChat:(BOOL)isOneOnOneChat
                              andDataBag:(NSDictionary *)dataBagValues
{
    NSManagedObjectContext *moc = self.accountHandle.highPriMOC;
    TSSMessage *message = [TSSMessage messageForID:messageID andThreadID:threadID
                            inManagedObjectContext:moc];
    
    NSString *senderID = (userID == nil) ? message.from : userID;
    
    //Scenario: User sending a card/multiple cards
    if (message.ts_botCardData != nil) {
        //Exclude this when compiling the SDK, build fails as the SDK excludes cards.
        NSArray *botCards = [TSUtilities unarchiveBotCards:message.ts_botCardData];
        //If the message has one or more cards sent by a user we log card telemetry for each card.
        for (id cardInfo in botCards)
        {
            NSDictionary *cardDataBag = dataBagValues.copy;
            TSBotCard *botCardInfo = (TSBotCard *)cardInfo;
            TSPTelemetryConstructBridge *telemetryConstruct = [[TSPTelemetryConstructBridge alloc] initWithCardType:botCardInfo.contentType messageId:messageID senderId:senderID];
            TSPlatformTelemetryInputData *inputParams = [[[[[[[[[TSPTelemetryInputDataBuilder alloc]
                                                                initWithAccountHandle:self.accountHandle moc:moc]
                                                               withThreadId:self.threadID ?: threadID]
                                                              withThreadType:self.biThreadType]
                                                             withTelemetryConstructBridge:telemetryConstruct]
                                                            withAppId:botCardInfo.appId]
                                                           withBotId:botCardInfo.appId]
                                                          withAppScenarioCapability:TSPTelemetryScenarioCapabilityMessagingExtension]
                                                         build];
            if (inputParams != nil)
            {
                cardDataBag = (NSDictionary *) [[[TSPTelemetryData alloc] initWithInputData:inputParams
                                                                         externalDictionary:cardDataBag] toDictionary];
            }
            
            [TSUtilities logPanelActionForChatSendMessage:self.logger
                                            accountHandle:self.accountHandle
                                                 scenario:scenario
                                                 panelUri:panelUri
                                                 threadId:self.threadID ?: threadID
                                               threadType:self.biThreadType
                                            threadMembers:self.biThreadMembersCount
                                                 chatType:self.biChatType
                                            dataBagValues:cardDataBag];
            
        }
    }
    //Scenario: Bot sending a text message to user - we are logging bot metadata
    //Scenario: User sending a plain text to bot - we are logging bot metadata
    else if ([senderID hasPrefix:TSBotPrefix] && isOneOnOneChat)
    {
        TSPTelemetryConstructBridge *telemetryConstruct = [[TSPTelemetryConstructBridge alloc] initWithBotId:senderID name:@""];
        TSPlatformTelemetryInputData *inputParams = [[[[[[[[[TSPTelemetryInputDataBuilder alloc]
                                                            initWithAccountHandle:self.accountHandle moc:moc]
                                                           withThreadId:self.threadID ?: threadID]
                                                          withThreadType:self.biThreadType]
                                                         withTelemetryConstructBridge:telemetryConstruct]
                                                        withAppId:senderID]
                                                       withBotId:senderID]
                                                      withAppScenarioCapability:TSPTelemetryScenarioCapabilityBot]
                                                     build];
        if (inputParams)
        {
            dataBagValues = (NSDictionary *) [[[TSPTelemetryData alloc] initWithInputData:inputParams
                                                                       externalDictionary:dataBagValues] toDictionary];
        }
        
        [TSUtilities logPanelActionForChatSendMessage:self.logger
                                        accountHandle:self.accountHandle
                                             scenario:scenario
                                             panelUri:panelUri
                                             threadId:self.threadID ?: threadID
                                           threadType:self.biThreadType
                                        threadMembers:self.biThreadMembersCount
                                             chatType:self.biChatType
                                        dataBagValues:dataBagValues];
    }
    else
    {   //user sending message to a user
        [TSUtilities logPanelActionForChatSendMessage:self.logger
                                        accountHandle:self.accountHandle
                                             scenario:scenario
                                             panelUri:panelUri
                                             threadId:self.threadID ?: threadID
                                           threadType:self.biThreadType
                                        threadMembers:self.biThreadMembersCount
                                             chatType:self.biChatType
                                        dataBagValues:[TSUtilities metaDataFromDataBagDictionary:dataBagValues]];
    }
}

- (void) handleThreadCreationError:(NSError *)error
                        scenarioID:(NSString *)scenarioID
                     correlationID:(NSString *)correlationID
                        completion:(void (^)(NSError *, NSNumber *, NSString *, NSString *, NSString *))completion
{
    [self showThreadCreationError:error];
    
    BOOL isPolicyEnforcedOrNetworkFailure = [ChatPermissionUtils isPolicyEnforcedFailureForChatCreate:error] || [AXPUtilities isNetworkOfflineOrTimeoutError:error];
    
    [self.accountHandle.logger logScenarioStopEvent:scenarioID
                                             status:isPolicyEnforcedOrNetworkFailure ? ScenarioStatusCancel : ScenarioStatusFailure
                                          withError:error];
    
    if (completion)
    {
        // If thread creation failed due to the message being sent as a 1-way invite, clear the composer (message was successfully sent)
        completion([self wasInviteSent1Way:error] ? nil : error, nil, nil, scenarioID, correlationID);
    }
    
    [self updateUIAfterThreadCreation];
}

- (void) handleSmsThreadCreationSuccessWithThreadId:(NSString *)threadId
                                        displayName:(NSString *)displayName
                                         scenarioID:(NSString *)scenarioID
                                      correlationID:(NSString *)correlationID
                                         completion:(void (^)(NSError *, NSNumber *, NSString *, NSString *, NSString *))completion
{
    [self.accountHandle.logger logScenarioStopEvent:scenarioID status:ScenarioStatusOK withError:nil];
    
    if (completion)
    {
        completion(nil, nil, threadId, @"", correlationID);
    }
    
    [self oneOnOneSmsChatCreatedWithThreadID:threadId
                                    scenario:scenarioID
                               correlationID:correlationID];
    
    self.fallbackDisplayName = displayName;
    [self updateUIAfterThreadCreation];
    self.recipientsUserInfo = nil;
}

- (void) updateUIAfterThreadCreation
{
    __weak TSChatViewController* weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        [weakSelf stopActivityIndicator];
        [weakSelf.composeViewController updateUIForSendingState:NO];
    }];
}

- (void) showThreadCreationError:(NSError *)error
{
    NSString *alertTitle = @"";
    NSString *alertMessage = @"";
    NSString *learnMoreLink = nil;
    void (^ onOk)(UIAlertAction *) = nil;
    
    if ([AXPUtilities isNetworkOfflineOrTimeoutError:error])
    {
        alertTitle = AXPLocalizedString(@"OfflineAlertTtl");
        alertMessage = AXPLocalizedString(@"OfflineAlertMsg");
    }
    else if ((error.code == TSErrorIBPolicyViolation) && [error.domain compareString:TSErrorDomain])
    {
        alertTitle = AXPLocalizedString(@"AlertErrorTitle");
        alertMessage = AXPLocalizedString(@"IBPolicyViolationErrorMessage");
    }
    else if ([self.actionContext isSMSChatEnabled] && (error.code == TSErrorSMSChatNeedsEscalation) && [error.domain compareString:TSErrorDomain])
    {
        [self.accountHandle.logger logPanelAction:TSkActionModuleNameSMSError
                                          outCome:nil
                                          gesture:nil
                                         scenario:TSkScenarioChatSMSSentToTeamsError
                                     scenarioType:TSkScenarioTypeSMSMessaging
                                   destinationuri:nil
                             destinationUriParams:nil
                                       moduleType:nil
                                      moduleState:nil
                                    moduleSummary:nil
                                         threadId:self.threadID];
        alertTitle = AXPLocalizedString(@"AlertErrorTitle");
        alertMessage = AXPLocalizedString(@"SMSIntrmEscltMsg");
    }
    else if (error.code == TSErrorCreateChat && error.domain == TSErrorDomain)
    {
        alertTitle = TSAccountLocalizedString(@"AlertErrCrChatTitle");
        alertMessage = TSAccountLocalizedString(@"AlErrCrChatMsg");
        learnMoreLink = [self.accountHandle.policyManager supervisedChatLearnMoreUrl];
    }
    else if (error.code == TSErrorAddToGroupChat && error.domain == TSErrorDomain)
    {
        alertTitle = TSAccountLocalizedString(@"AlertNoAddTitle");
        alertMessage = TSAccountLocalizedString(@"AlertNoAddChErrMsg");
        learnMoreLink = [self.accountHandle.policyManager supervisedChatLearnMoreUrl];
    }
    else if ([self wasInviteSent1Way:error])
    {
        alertTitle = AXPLocalizedString(@"Alert1WayInvSentTitle");
        alertMessage = AXPLocalizedString(@"Alert1WayInvSentMsg");
        __weak TSChatViewController* weakSelf = self;
        onOk = ^(__unused UIAlertAction *action)
        {
            [weakSelf popToChatListWithBannerText:AXPLocalizedString(@"InviteBanner")];
        };
    }
    else
    {
        alertTitle = AXPLocalizedString(@"AlertErrorTitle");
        alertMessage = AXPLocalizedString(@"CreateChatFailedErrorMessage");
    }
    
    __weak TSChatViewController* weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        UIAlertController *alertView = [TSAlertUtils alertControllerWithTitle:alertTitle
                                                                      message:alertMessage];
        
        UIAlertAction *okAct = [UIAlertAction actionWithTitle:AXPLocalizedString(@"TSOK")
                                                        style:UIAlertActionStyleDefault
                                                      handler:onOk];
        
        [alertView addAction:okAct];
        
        if (learnMoreLink != nil)
        {
            
            void (^completionHandler)(BOOL success)  = ^(__unused BOOL success)
            {
                [weakSelf.view endEditing:YES];
            };
            [alertView addAction:
             [TSAlertUtils linkOpenActionWithURL:learnMoreLink
                                  withCompletion:completionHandler]];
            
        }
        
        [weakSelf presentViewController:alertView animated:YES completion:nil];
    }];
}

- (void) popToChatListWithBannerText:(NSString *)text
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if ([NSString isNilOrEmpty:text])
    {
        return;
    }
    
    UIViewController *rootViewController = [self.navigationController.viewControllers firstObject];
    if ([rootViewController isKindOfClass:[TSChatListMultiViewController class]])
    {
        TSChatListMultiViewController *chatListViewController = (TSChatListMultiViewController *)rootViewController;
        [chatListViewController showBannerWithText:text completionBlock:nil];
    }
}

- (BOOL) wasInviteSent1Way:(NSError *)error
{
    return error.code == TSErrorOneWayInviteSent && error.domain == TSActionErrorDomain;
}

- (NSInteger) phoneUsersCount
{
    NSInteger phoneCount = 0;
    for (NSString *recipientId in self.recipientsUserInfo) {
        NSDictionary *user = self.recipientsUserInfo[recipientId];
        if ([user[TSkPhoneNumber] isNotNilOrEmpty] && [user[TSkUserDisplayName] isNotNilOrEmpty])
        {
            phoneCount++;
        }
    }
    return phoneCount;
}

- (void) logNewGroupWithPhoneUsersCreatedPanelAction:(NSInteger) phoneUsersCount
{
    NSDictionary *dataBagValues = @{
        TSkInvitePhoneCountAttribute: [NSNumber numberWithInteger: phoneUsersCount]
    };
    
    [self.accountHandle.logger logPanelAction:TSkActionModuleName2WaySms
                                      outCome:nil
                                      gesture:nil
                                     scenario:TSkScenario2WaySmsRecipientAddConfirmedNew
                                 scenarioType:TSkScenarioType2WaySms
                               destinationuri:nil
                         destinationUriParams:nil
                                   moduleType:nil
                                  moduleState:nil
                                moduleSummary:nil
                                     threadId:self.threadID
                                     metaData:[TSUtilities metaDataFromDataBagDictionary:dataBagValues]];
}

- (BOOL) composeViewControllerShouldEnableImagePickerButton:(TSBaseComposeViewController *)composeViewController
{
    return YES;
}

- (BOOL) composeViewControllerShouldComposeInPlainText:(TSBaseComposeViewController *)composeViewController
{
    return [self isSfbOrSfcInteropChat];
}

- (BOOL) isTfLInterOpOrOffNetworkFedChat
{
    return  self.isRosterWithOffNetworkFedUser || self.isRosterWithFederatedUser || self.isRosterWithExtendedDirectoryUser
    || self.isRosterWithTflInterOpUser || [self.federationUtils isExternalThreadByCfetWithThreadId:self.threadID inMoc:self.accountHandle.mainMOC];
}

- (BOOL) isFederatedUserWithTeamsOnlyInMoc:(NSManagedObjectContext *)moc
{
    // TODO: modify this function after enabling federated group chats
    if([self.recipientIDs count] == 1)
    {
        TSUserInfo *user = [self userInfoForID:[[self.recipientIDs firstObject] asString]];
        NSString* myUserMri = self.accountHandle.MRI;
        TSUserInfo *myUserInfo = [self userInfoForID:myUserMri inMoc:moc];
        return [user isFederatedUser] && (user.coexistenceMode == TSkCoexistenceModeTeamsOnly) && (myUserInfo.coexistenceMode == TSkCoexistenceModeTeamsOnly);
    }
    return NO;
}

- (BOOL)isFederatedGroupChatWithChatViewBanner
{
    if (!self.isRosterWithFederatedUser || !self.chatBannerView)
    {
        return NO;
    }
    
    return (self.chatBannerView.chatBannerType == TSkFederatedChatWithBlockedUsers
            || self.chatBannerView.chatBannerType == TSkFederatedChatWithSfBUsers
            || self.chatBannerView.chatBannerType == TSkFederatedChatMessageRelatedPolicy);
}

- (void)adaptiveCardMessageActionTapped:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:TSChatMessageViewCell.class]) {
        TSChatMessageViewCell *chatMessageCell = (TSChatMessageViewCell *)cell;
        [self openPopupForMessageAtPath:indexPath withBaseView:chatMessageCell.messageBubbleView];
    }
}

- (BOOL) isFederatedThread
{
    return ([self isTfLInterOpOrOffNetworkFedChat] && [self isOneToOneChat]) || self.isNewFederatedUser;
}

- (BOOL)isFederatedGroupChat
{
    return [self isTfLInterOpOrOffNetworkFedChat] && self.recipientIDs.count > 1;
}

- (BOOL) isFederatedThreadWithDowngradedUser
{
    if([self.recipientIDs count] < 2)
    {
        return  NO;
    }
    
    return [self hasFederatedUserNotTeamsOnly];
}

- (BOOL) isFederatedInteropThread
{
    return [self isFederatedThread] && self.threadType == TSThreadTypeInteropChat;
}

- (BOOL) isSfCInteropChat
{
    BOOL isSfcAvailableForUser = NO;
    if([self.recipientIDs count] == 1)
    {
        TSUserInfo *user = [self userInfoForID:[[self.recipientIDs firstObject] asString]];
        isSfcAvailableForUser = user.isSfCInteropAvailable;
    }
    return self.threadType == TSThreadTypeInteropChat && [self.threadID isNotNilOrEmpty] && [TSUtilities isSfCInteropChatByThreadId:self.threadID] && isSfcAvailableForUser;
}

- (BOOL) isSfBInteropChat
{
    BOOL isSfbAvailableForUser = NO;
    if([self.recipientIDs count] == 1)
    {
        TSUserInfo *user = [self userInfoForID:[[self.recipientIDs firstObject] asString]];
        isSfbAvailableForUser = user.isSfBInteropAvailable;
    }
    return self.threadType == TSThreadTypeInteropChat || ([self.threadID isNotNilOrEmpty] && [TSUtilities isSfBInteropChatByThreadId:self.threadID]) || isSfbAvailableForUser;
}

- (BOOL)isSfbOrSfcInteropChat
{
    return self.threadType == TSThreadTypeInteropChat && ([self isSfBInteropChat] || [self isSfCInteropChat]);
}

- (BOOL)isNotSfbAndNotSfcInteropChat
{
    return self.threadType != TSThreadTypeInteropChat || (![self isSfBInteropChat] && ![self isSfCInteropChat]);
}

- (BOOL) isSfcInteropChatFromReceipientIDs
{
    return [self.accountHandle.actionContext isSfCInteropEnabled] && [self.recipientIDs count] == 1
    && [TSUtilities isSfCUserForUserID:self.recipientIDs.firstObject accountHandle:self.accountHandle];
}

- (BOOL) isSMSChat
{
    return self.threadType == TSThreadTypePhoneChat;
}

-(void) createChatMessage:(NSDictionary *)params
                 scenario:(NSString *)scenarioID
            correlationID:(NSString *)correlationID
               completion:(void (^)(NSError *, NSNumber *, NSString *, NSString *, NSString *))completion
{
    
    if ([self animateNewItemInsert]) {
        self.preferInsertAnimationOnNextUpdate = YES;
    }
    
    __weak TSChatViewController* weakSelf = self;
    
    TSAction *createMessageWithChatContainer = [self.actionContext actionOfClass:[TSAACreateMessage class]
                                                                  fromDictionary:params
                                                                  withCompletion:^(TSAction *action, TSAResult *result, NSError *err) {
        
        if (err)
        {
            [weakSelf.accountHandle.logger logScenarioStopEvent:scenarioID status:ScenarioStatusFailure withError:err];
        }
        
        [weakSelf closeComposeViewAfterMessageSent];
    }];
    
    [createMessageWithChatContainer executeActionChain:@"creating chat message"
                                        withCompletion:^(TSAction *action, TSAResult *result, NSError *err)
     {
        if(err)
        {
            LogErrorAH(self.logger, @"Create message failed.  Error was domain %@, code %ld", err.domain, (long)err.code);
            if (completion)
            {
                completion(err, nil, nil, scenarioID, correlationID);
            }
            return;
        }
        
        LogVerboseAH(self.logger, @"Create message complete. %luP %luC %luU %luD", result.processed, result.created, result.updated, result.deleted);
        
        [TSDispatchUtilities dispatchOnBackgroundThread:^{
            NSSet *conversationSet = [result processedSetForClass:TSConversation.class];
            [[[TSSyncEngine sharedInstance] threadSyncManager] notifyForListOfThreadRelatedUpdates:conversationSet
                                                                                     accountHandle:action.accountHandle];
        }];
        
        TSMessageUniqueKey *messageUniqueKey = [[result createdListForClass:[TSSMessage class]] firstObject];
        
        
        if (completion)
        {
            completion(nil, messageUniqueKey.messageID, messageUniqueKey.threadID, scenarioID, correlationID);
        }
        
        if (!weakSelf.threadID || self.isCreatingChatWithSelfThread)
        {
            [weakSelf initializeNewConversationPageForThreadID:messageUniqueKey.threadID];
            self.isCreatingChatWithSelfThread = NO;
        }
        
        [TSDispatchUtilities dispatchOnBackgroundThread:^{
            [TSEnableReviewPromptManager.sharedInstance updateEngagedActionsStatistics];
            [TSEnableNotificationPromptManager.sharedInstance updateEnableNotificationPromptStatusToBeDisplayed];
        }];
        
        // resetting last post time after message is sent
        [TSDispatchUtilities dispatchOnMainThread:^{
            weakSelf.lastPostTimeForUserComposingMessage = nil;
        }];
    }];
}

-(void) oneOnOneSmsChatCreatedWithThreadID:(NSString *)threadID
                                  scenario:(NSString *)scenarioID
                             correlationID:(NSString *)correlationID
{
    if ([self animateNewItemInsert]) {
        self.preferInsertAnimationOnNextUpdate = YES;
    }
    
    __weak TSChatViewController* weakSelf = self;
    
    [TSDispatchUtilities dispatchOnBackgroundThread:^{
        [[[TSSyncEngine sharedInstance] threadSyncManager] notifyForListOfThreadRelatedUpdates:[NSSet setWithObject:threadID]
                                                                                 accountHandle:weakSelf.accountHandle];
    }];
    
    [weakSelf initializeNewConversationPageForThreadID:threadID];
    
    [TSDispatchUtilities dispatchOnBackgroundThread:^{
        [TSEnableReviewPromptManager.sharedInstance updateEngagedActionsStatistics];
        [TSEnableNotificationPromptManager.sharedInstance updateEnableNotificationPromptStatusToBeDisplayed];
    }];
    
    [TSDispatchUtilities dispatchOnMainThread:^{
        weakSelf.lastPostTimeForUserComposingMessage = nil;
        [weakSelf updateDashboardButton];
    }];
    
    [self closeComposeViewAfterMessageSent];
}

- (void) updateDashboardButton
{
    UIViewController *parentVC = self.parentViewController;
    if ([parentVC isKindOfClass:TSChatMultiViewController.class])
    {
        TSChatMultiViewController *chatMultiVC = (TSChatMultiViewController *)parentVC;
        [chatMultiVC updateDashboardButton];
    }
}

- (void) closeComposeViewAfterMessageSent
{
    if (!fequal(self.toContainerViewHeight.constant, 0.0f))
    {
        // Pass the threadID up so that we can show the tabs in outerViewController
        // and close the Compose control after message send.
        __weak TSChatViewController* weakSelf = self;
        [TSDispatchUtilities dispatchOnMainThread:^{
            NSString *threadID = weakSelf.threadID;
            
            if ([threadID isNotNilOrEmpty])
            {
                [weakSelf.outerViewController didReceiveThreadID:threadID withThreadType:weakSelf.biThreadType chatType:weakSelf.biChatType];
            }
            [UIView animateWithDuration:0.25
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                weakSelf.toContainerViewHeight.constant = 0;
                [weakSelf.toView setHidden:YES];
            }
                             completion:nil];
        }];
    }
}

- (void)initializeNewConversationPageForThreadID:(NSString *)threadID
{
    __weak TSChatViewController* weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        weakSelf.threadID = threadID;
        
        if (weakSelf.threadID)
        {
            [weakSelf updateThreadTelemetryProperties];
        }
        [weakSelf loadInitialMessagePage];
        
        // SetMarkAsUnreadConsumptionHorizonBookmark action fails if consumptionHorizon is nil for conversation
        // so we do an initial consumptionHorizon update for newly created threads
        TSConversation *conv = [AXPCtx conversationForID:weakSelf.threadID];
        if ([NSString isNilOrEmpty:conv.consumptionHorizon])
        {
            [weakSelf updateConsumptionHorizon];
        }
    }];
}

// TODO - Dunty Vinay : Move these methods to DTO itself and not have dependancy for them in the VCs

- (void) composeViewController:(TSBaseComposeViewController *)composeViewController
       fileURLSelectedToUpload:(NSURL *)fileURL
               defaultFileName:(NSString *)defaultFileName
                     overwrite:(BOOL)overwrite
          fileUploadScenarioId:(NSString *)fileUploadScenarioId
              andCorrelationID:(NSString *)correlationID
                     panelInfo:(AXPPanelInfo *)panelInfo
{
    [self.accountHandle.fileUploadManager uploadFile:fileURL
                                     defaultFileName:defaultFileName
                                            threadID:self.threadID
                                           overwrite:overwrite
                                fileUploadScenarioId:fileUploadScenarioId
                                    andCorrelationID:correlationID
                                           panelInfo:panelInfo
                                            draftKey:[self draftEntityIDForComposeViewController:composeViewController]];
}

- (void) composeViewController:(TSBaseComposeViewController *)composeViewController
             uploadFileWithDTO:(nonnull TSFileUploadDTO *)fileDTO
{
    fileDTO.isBotAttachmentFileUpload = [self isPrivateChatWithBot];
    fileDTO.panelInfo = [self biPanelInfo];
    fileDTO.draftKey = [self draftEntityIDForComposeViewController:composeViewController];
    [self.accountHandle.fileUploadManager uploadFileWithDTO:fileDTO];
}

- (NSString *) membershipEntityIDForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    return self.threadID;
}

- (NSSet<NSString *> *) membershipIDsForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    return self.recipientIDs ? [NSSet setWithArray:self.recipientIDs] : nil;
}

- (NSString *) threadIDForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    return self.threadID;
}

- (NSNumber *) rootMessageIDForComposeViewController:(TSBaseComposeViewController * __nullable)composeViewController
{
    return nil;
}

- (NSString *) messageType
{
    return self.threadID ? TSkMessageTypeReplyChat : TSkMessageTypeNewChat;
}

- (NSString *) draftEntityIDForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    if (self.chatCreateDraftKey)
    {
        if (self.recipientIDs.count > 0)
        {
            return [self recipientsDraftKey];
        }
        
        return self.chatCreateDraftKey;
    }
    
    if (self.isGuardiansChat && [NSString isNilOrEmpty:self.threadID] && self.recipientIDs.count > 0)
    {
        return [self recipientsDraftKey];
    }
    
    return self.threadID;
}

- (NSString *) recipientsDraftKey
{
    NSArray *sortedRecipients = [self.recipientIDs sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    // Store recipients in key, longer but would allow decoding to show a menu of drafts to restore when tap New Chat
    return [NSString stringWithFormat:@"draftTo:%@", [sortedRecipients jsonString]];
}

- (BOOL) isNewChat
{
    return self.chatCreateDraftKey != nil;
}

- (NSUInteger) lineCountMaximumForComposeViewController:(TSBaseComposeViewController *)composeViewController calculatedMaxLines:(NSUInteger)calculatedMaxLines
{
    if (self.toView && !self.toView.isHidden)
    {
        // When toView is visible, need to adjust line count for text entry.
        // subtract # of lines for To view + 1 so there is a gap between To and compose
        NSUInteger toHeightInLines = ceil(self.toView.bounds.size.height / composeViewController.textBody.font.lineHeight);
        NSUInteger lineCount = MAX(2, calculatedMaxLines - (1 + toHeightInLines));
        return lineCount;
    }
    
    if (!self.statusMessageBannerView.hidden)
    {
        // Need to subtract only 1 line to account for status view as subtracting more than 1 line
        // causes the compose view height to appear fixed and reduced
        calculatedMaxLines -= 1;
        
        if (IS_LANDSCAPE() || IS_IPHONE5())
        {
            if ((composeViewController.isPriorityMessage) && (!self.customBannerViewContainer.hidden))
            {
                [self removeStatusMessageBannerView];
            }
        }
    }
    
    return calculatedMaxLines;
}

- (BOOL) messageHasInvalidRecipientsForComposeViewController:(TSBaseComposeViewController *)composeViewController
{
    if (self.isChatWithSelf)
    {
        // No recipient validity logic for chat with self
        return NO;
    }
    
    if (self.isGuardiansChat && self.threadID != nil)
    {
        // Allow sending to single-user chat for guardians if it has a thread
        // Guardians will send invites, and to match Desktop should be able to send
        return NO;
    }
    
    BOOL hasNoRecipients = self.recipientIDs.count == 0;
    return hasNoRecipients && !self.accountHandle.policyManager.allowMessagesToSingleUserChat;
}

- (BOOL) composeViewControllerShouldShowGiphyButton:(TSBaseComposeViewController *)composeViewController
{
    return !(self.isAnonymouslyJoinedToCall || self.didAnonJoinCallEnd) && [self isNotSfbAndNotSfcInteropChat] && ![self isFederatedInteropThread] && ![self isSMSChat] && [self isComposerActionEnabled:TSkComposerActionGif];
}

- (BOOL) composeViewControllerShouldShowMemesButton:(TSBaseComposeViewController *)composeViewController
{
    return !(self.isAnonymouslyJoinedToCall || self.didAnonJoinCallEnd) && [self isNotSfbAndNotSfcInteropChat] && ![self isFederatedInteropThread] && ![self isSMSChat] && [self isComposerActionEnabled:TSkComposerActionMemes];
}

- (BOOL) composeViewControllerShouldShowStickersButton:(TSBaseComposeViewController *)composeViewController
{
    return !(self.isAnonymouslyJoinedToCall || self.didAnonJoinCallEnd) && [self isNotSfbAndNotSfcInteropChat] && ![self isFederatedInteropThread] && ![self isSMSChat] && [self isComposerActionEnabled:TSkComposerActionStickers];
}

- (BOOL) composeViewControllerShouldShowFunPickerGiphyButton:(TSBaseComposeViewController *)composeViewController
{
    return [self composeViewControllerShouldShowGiphyButton:composeViewController];
}

- (BOOL) composeViewControllerShouldShowFunPickerMemesButton:(TSBaseComposeViewController *)composeViewController
{
    return [self composeViewControllerShouldShowMemesButton:composeViewController];
}

- (BOOL) composeViewControllerShouldShowFunPickerStickersButton:(TSBaseComposeViewController *)composeViewController
{
    return [self composeViewControllerShouldShowStickersButton:composeViewController];
}

- (BOOL) composeViewControllerShouldShowExtensionButtons:(TSBaseComposeViewController *)composeViewController
{
    return [self isNotSfbAndNotSfcInteropChat] && ![self isSfcInteropChatFromReceipientIDs] && ![self isSMSChat];
}

- (BOOL) composeViewControllerShouldShowImagePickerButton:(TSBaseComposeViewController *)composeViewController
{
    return !(self.accountHandle.policyManager.shouldDisableImageAndLocationSharing || self.didAnonJoinCallEnd) && [self isNotSfbAndNotSfcInteropChat] && ![self isFederatedInteropThread] && ![self isSMSChat] && [self isComposerActionEnabled:TSkComposerActionImage];
}

- (BOOL) composeViewControllerShouldShowExpandButton:(TSBaseComposeViewController *)composeViewController
{
    return [self isNotSfbAndNotSfcInteropChat] && ![self isFederatedInteropThread] && ![self isSMSChat] && [self isComposerActionEnabled:TSkComposerActionFormat];
}

- (BOOL) composeViewControllerShouldShowShareLocationButton:(TSBaseComposeViewController *)composeViewController
{
    BOOL shouldEnableForFedChat = !self.shouldLimitComposeOptnInFedChat;
    if (self.isFedRosterCreatedOnTfL && shouldEnableForFedChat)
    {
        shouldEnableForFedChat = self.accountHandle.policyManager.isLocationWithLiveSharingOnFederatedChatsEnabled;
    }
    
    return !(self.accountHandle.policyManager.shouldDisableImageAndLocationSharing || self.didAnonJoinCallEnd)
    && [self isNotSfbAndNotSfcInteropChat] && shouldEnableForFedChat
    && [self.threadID isNotNilOrEmpty] && ![self isPrivateChatWithBot]
    && ![self isSMSChat] && [self isComposerActionEnabled:TSkComposerActionLocation];
}

- (BOOL) composeViewControllerShouldShowAudioMessageButton:(TSBaseComposeViewController *)composeViewController
{
    TSkAudioMessageAdminSetting audioMessageAdminSetting = self.actionContext.audioMessageAdminSetting;
    if (audioMessageAdminSetting == TSkAudioMessageChatsAndChannels || audioMessageAdminSetting == TSkAudioMessageChatsOnly)
    {
        return (!(self.isAnonymouslyJoinedToCall || self.didAnonJoinCallEnd) &&
                [self isNotSfbAndNotSfcInteropChat] && ![self isFederatedInteropThread] && ![self isPrivateChatWithBot] && ![self isSMSChat]);
    }
    
    return NO;
}

- (BOOL) composeViewControllerShouldShowComposeExtension
{
    return [self isNotSfbAndNotSfcInteropChat] && !self.shouldLimitComposeOptnInFedChat && ![self isSMSChat] && [self isComposerActionEnabled:TSkComposerActionMore];
}

- (BOOL) composeViewControllerShouldShowShareListButton:(TSBaseComposeViewController *)composeViewController
{
    return [self isNotSfbAndNotSfcInteropChat] && !self.shouldLimitComposeOptnInFedChat && ![self isSMSChat];
}

- (BOOL)composeViewControllerShouldShowShareTableButton:(TSBaseComposeViewController *)composeViewController
{
    return [self isNotSfbAndNotSfcInteropChat] && !self.shouldLimitComposeOptnInFedChat && ![self isSMSChat];
}

- (BOOL) composeViewControllerShouldShowFlyoutButton
{
    return !self.didAnonJoinCallEnd;
}

- (BOOL) composeViewControllerShouldShowCalendarButton:(TSBaseComposeViewController *)composeViewController;
{
    return YES;
}

#pragma mark - TSToViewControllerDelegate

- (TSSearchParameters *)getSearchParametersForResults
{
    return self.searchParams;
}

- (BOOL) shouldSearchEmptyTermWithNonEmptyRecipients
{
    return self.isMultiSelectParticipantsInProgress;
}

- (BOOL) shouldShowExistingChatsSuggestions
{
    return self.isMultiSelectParticipantsInProgress &&
    (!self.shouldUseFlowV2 || (self.shouldUseFlowV2 && self.toViewController.selectedRecipients.count > 1));
}

- (BOOL) shouldShowCellCheckmarkAccessoryForSelectedRecipients
{
    return self.isMultiSelectParticipantsInProgress;
}

- (BOOL) shouldAllowMultiSelectParticipants
{
    return self.isMultiSelectParticipantsInProgress;
}

- (NSArray<NSString *> *) availableRecipientTypes
{
    NSMutableArray<NSString *> *types = [NSMutableArray arrayWithObjects:NSStringFromClass(NSString.class),
                                         NSStringFromClass(NSDictionary.class),
                                         NSStringFromClass(TSNASearchUsersResultItem.class), nil, nil];
    
    id<TSPolicyManagerProtocol> manager = self.accountHandle.policyManager;
    if (manager.deviceContactsSearchEnabled || manager.isTfwTflFedChatCreationOnTfwEnabled || manager.isSMBContactSyncEnabled)
    {
        [types addObject:NSStringFromClass(TSDeviceContactSearchResult.class)];
    }
    
    if ([self.accountHandle.ecsManager enablePeoplePickerNewContactsOrder] && self.shouldUseFlowV2 && [self.recipientIDs count] == 0)
    {
        [types addObject:TSPeopleYouMayKnowSection];
    }
    
    return types;
}

- (NSInteger) maxNumberOfSelectableRecipientsInToViewController:(TSToViewController *)toViewController
{
    return 5;
}

- (BOOL) shouldShowShareChatHistoryView
{
    return NO;
}

- (void) toViewController:(TSToViewController *)toViewController didChangeHeight:(CGFloat)desiredHeight
{
    CGFloat newHeight = desiredHeight;
    CGFloat viewHeight = self.view.bounds.size.height;
    CGFloat availHeight = viewHeight - self.composeView.height;
    
    if (desiredHeight > availHeight)
    {
        newHeight = availHeight;
    }
    
    if (fequal(self.toContainerViewHeight.constant, newHeight))
    {
        return;
    }
    
    self.toContainerViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}


- (void) hideToContainerAndShowOuterViewTabs
{
    if (!fequal(self.toContainerViewHeight.constant, 0.0f))
    {
        __weak TSChatViewController* weakSelf = self;
        [TSDispatchUtilities dispatchOnMainThread:^{
            
            if ([weakSelf.threadID isNotNilOrEmpty])
            {
                [weakSelf.outerViewController didReceiveThreadID:weakSelf.threadID withThreadType:weakSelf.biThreadType chatType:weakSelf.biChatType];
            }
            
            [UIView animateWithDuration:0.25
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                            weakSelf.toContainerViewHeight.constant = 0;
                                            [weakSelf.toView setHidden:YES];
                                        }
                             completion:nil];
        }];
    }
}

- (TSSearchParameters *)searchParams
{
    if(!_searchParams)
    {
        _searchParams = [[TSSearchParameters alloc] init];
        _searchParams.searchUserType = TSkSearchUserTypeChat;
        
        _searchParams.showFederatedUsers = !(self.accountHandle.policyManager.shouldIgnoreFedUsersInSearch && !self.accountHandle.policyManager.isTfwTflFedChatCreationOnTfLEnabled);
        _searchParams.shouldCreateFedUserIfNoMatch = YES;
        _searchParams.showTflInterOpUsers = self.accountHandle.policyManager.isTfwTflFedChatCreationOnTfwEnabled;
        _searchParams.showEDUsers = self.accountHandle.policyManager.isTfwEdChatCreationOnTfwEnabled;
    }
    return _searchParams;
}

- (void) toViewController:(TSToViewController *)toViewController
                didSearch:(NSString *)searchTerm
            withIDsToOmit:(NSArray<NSString *> *)IDsToOmit
               completion:(void (^)(NSArray<TSEntitySearchResultItem *> *results, BOOL resultsAreRecents, BOOL finalResults))completion
{
    if([self.accountHandle.ecsManager newPeoplePickerEnabled])
    {
        [self.peoplePickerSearchProvider cancelPendingSearch];
    }
    else
    {
        [self.entitySearch cancelPendingSearch];
    }
    
    NSMutableArray<NSString *> *entityIDsToOmit  = (self.recipientIDs.count) ? self.recipientIDs.mutableCopy : NSMutableArray.new;
    // If ToVC has no recipients and chat with self is enabled, do not add userMri to list of IDs to omit
    if (![self.accountHandle.ecsManager isChatWithSelfEnabled] || self.recipientIDs.count > 0)
    {
        NSString* userMri = self.accountHandle.MRI;
        [entityIDsToOmit addObjectIfNotNil:userMri];
        
        if ([NSString isNilOrEmpty:userMri])
        {
            LogWarningAH(self.logger, @"Empty User MRI found in recipient search for chat view controller");
        }
    }
    
    [entityIDsToOmit addObjectsFromArray:IDsToOmit];
    
    // If no recipients selected, can search for users or group chats or tags
    // Once any are selected (which must be a User to continue searching) limit to User
    NSMutableArray<NSNumber *> *searchResultTypes =  @[@(TSkEntitySearchResultTypeUser)].mutableCopy;
    if (self.recipientIDs.count == 0)
    {
        [searchResultTypes addObject:@(TSkEntitySearchResultTypeBot)];
        
        // Do not show conversations in this group creation state
        if (self.groupChatCreationState != TSGroupChatCreationStateAddingParticipants)
        {
            [searchResultTypes addObject:@(TSkEntitySearchResultTypeConversation)];
        }
    }
    
    if ([self.accountHandle.ecsManager channelsInChatListEnabled] && [[self.accountHandle.tenantDefaults objectForKey:TSkChannelsInChatEnabled] boolValue] && self.recipientIDs.count == 0)
    {
        [searchResultTypes addObject:@(TSkEntitySearchResultTypeContainer)];
    }
    
    if ([self.accountHandle.actionContext isSMSChatEnabled] && self.recipientIDs.count == 0)
    {
        [searchResultTypes addObject:@(TSkEntitySearchResultTypeContact)];
    }
    
    // Targeted Chat enabled, allow addition of other tags
    if ([self.accountHandle.tagManager isTargetedChatsEnabled])
    {
        [searchResultTypes addObject:@(TSkEntitySearchResultTypeTeamMemberTag)];
        if ([self.accountHandle.policyManager scheduledTagsEnabled])
        {
            [searchResultTypes addObject:@(TSkEntitySearchResultTypeScheduledTag)];
        }
    }
    
    void (^completionBlockWithError)(NSArray<TSEntitySearchResultItem *>*, BOOL, BOOL, NSError *) = ^(NSArray<TSEntitySearchResultItem *> *results, BOOL resultsAreRecentRecipients, BOOL finalResults, NSError *error)
    {
        completion(results, resultsAreRecentRecipients, finalResults);
    };
    
    if ([self.accountHandle.ecsManager newPeoplePickerEnabled])
    {
        self.searchParams.types = searchResultTypes;
        self.searchParams.omittingEntityIDs = entityIDsToOmit;
        self.searchParams.showTflInterOpUsers = self.accountHandle.policyManager.isTfwTflFedChatCreationOnTfwEnabled;
        if ([self.accountHandle.policyManager DLsInAddToChatEnabled])
        {
            self.searchParams.isDLSupportEnabled = @(self.accountHandle.ecsManager.isDLSupportEnabled);
        }
        self.searchParams.showEDUsers = self.accountHandle.policyManager.isTfwEdChatCreationOnTfwEnabled;
        
        [self.peoplePickerSearchProvider searchEntities:searchTerm
                                           searchParams:self.searchParams
                                             completion:completionBlockWithError];
    }
    else
    {
        [self.entitySearch searchEntities:searchTerm
                                  ofTypes:searchResultTypes
                           searchUserType:TSkSearchUserTypeChat
                        omittingEntityIDs:entityIDsToOmit
                            includeOnline:YES
                                 chatMode:NO
                        showConnectorBots:NO
                      showTflInterOpUsers:self.accountHandle.policyManager.isTfwTflFedChatCreationOnTfwEnabled
                              showEDUsers:self.accountHandle.policyManager.isTfwEdChatCreationOnTfwEnabled
                               completion:completionBlockWithError];
    }
}

- (void) toViewController:(TSToViewController *)toViewController didChangeRecipients:(NSArray<NSDictionary *> *)recipients
{
    // Reset before changing new chat thread
    [self resetMessages];
    [self.composeViewController saveCurrentDraft];
    
    // Draft Key will change when the user changes the recipients, clear for the current key.
    // Will re-save below after switching recipients so draft is for the right key
    if (self.hasAppeared)
    {
        [self.composeViewController clearDraftForCurrentKey];
    }
    
    NSDictionary *recipientsUserInfo = [TSUtilities recipientIDsWithUserInfoFromSelectedRecipients:recipients];
    NSArray<NSString *> *recipientIDs = [recipientsUserInfo allKeys];
    if (recipientIDs.count == 1 && [recipientIDs.firstObject hasPrefix:TSContainerPrefix])
    {
        self.chatTabSetActive = YES;
        
        NSMutableDictionary *viewInfo = [@{TSkThreadID  : recipientIDs.firstObject,
                                           TSkEntryPoint: self.isGroupTemplateChat ? TSkEntryPointNewGroupTemplatedChat : TSkEntryPointNewChat
                                         } mutableCopy];
        
        NSDictionary *firstRecipient = [recipientsUserInfo objectForKey:recipientIDs.firstObject];
        if ([firstRecipient getBoolForKey:TSkNewEmptyGroup orDefault:NO])
        {
            viewInfo[TSkNewEmptyGroup] = @(YES);
        }
        
        [AXPAppViewController setActiveTab:TSkChatsTabId
                              rewindToRoot:YES
                                 thenSegue:TSkSeguePushChatMultiView
                              withViewInfo:viewInfo
                                  animated:NO];
        
        [self.logger logPanelAction:TSkPeoplePickerModuleName
                            outCome:TSkActionOutcomeNav
                            gesture:TSkActionGestureTap
                           scenario:TSkScenarioChatListNavConversations
                       scenarioType:TSkPeoplePickerResultSelectedScenarioType
                     destinationuri:nil
               destinationUriParams:nil
                         moduleType:TSkActionModuleTypeButton
                        moduleState:nil
                      moduleSummary:nil
                          panelType:nil
                           panelUri:nil
                     panelUriParams:nil
                           threadId:self.threadID
                         threadType:nil];
        return;
    }
    
    if ([self.accountHandle.policyManager shouldUseIconInEntitySearch])
    {
        [self.toViewController.entitySearchBarViewController setIconImageViewVisible:recipientIDs.count == 0];
        [self.toViewController.entitySearchBarViewController setToLabelVisible:recipientIDs.count > 0];
    }
    
    if (self.isMultiSelectParticipantsInProgress == YES)
    {
        [self.toViewController entitySearchBarViewController:self.toViewController.entitySearchBarViewController
                                                   didSearch:@""
                                              withRecipients:self.toViewController.selectedRecipients];
        if ([self isSimpleSearchBarVisible])
        {
            [self.toViewController clearSearchBarText];
        }
        return;
    }
    
    if (recipientIDs.count == 1 && [self.accountHandle.MRI isEqualToString:recipientIDs.firstObject] && [self.accountHandle.ecsManager isChatWithSelfEnabled])
    {
        [self willNavigateToView:@{
            TSkEntryPoint : self.scenarioEntryPoint ?: @"",
            TSkThreadID : TSkChatWithSelfThreadID
        }];
        
        return;
    }
    
    [self willNavigateToView:@{
        TSkOnUpdateNavigationBar: TSkOnUpdateNavigationBarNotification,
        TSkDeepLinkedInitializationText: self.textForDeepLinkedInitialization ?: @"",
        TSkRecipientIDs: recipientIDs,
        TSkEntryPoint: self.scenarioEntryPoint ?: @"",
        TSkTopicName: self.topicName ?: @"",
        TSkGroupChatCreationStateKey:@(self.groupChatCreationState),
        TSkGroupAvatarEditPressed: @(self.groupAvatarEditPressed),
        TSkHasCustomGroupAvatar: @(self.hasCustomGroupAvatar),
        TSkActivationOrigin: self.activationOrigin ?: @"",
        TSkActivationPillar: self.activationPillar ?: @""
    }];
    
    TSWeakify(self);
    [TSDispatchUtilities dispatchOnMainThread:^{
        TSStrongifyAndReturnIfNil(self);
        self.recipientIDs = recipientIDs;
        self.recipientsUserInfo = recipientsUserInfo;
        [self updateFederationPropertiesForRoster];
        
        if ([self singleOffNetworkUserInviteFlowEnabled]
            && self.accountHandle.policyManager.isOffNetworkSingleUserGroupNameOverride
            && self.groupChatCreationState == TSGroupChatCreationStateNoOp)
        {
            TSUserInfo *me = [self userInfoForID:self.accountHandle.MRI];
            TSDisplayableUserName *myUserName = [TSDisplayableUserName fullName:me.displayName];
            TSDisplayableUserName *otherUserName = [TSDisplayableUserName fullName:[recipients.firstObject valueForKey:TSkUserDisplayName]];
            
            self.topicName = [NSString stringWithFormat: AXPLocalizedString(@"TwoPeopleLabel"),
                              [myUserName abbreviatedFormIncludingLastNameInitial:NO includingGuestInfo:NO],
                              [otherUserName abbreviatedFormIncludingLastNameInitial:NO includingGuestInfo:NO]];
            self.topicOverridden = YES;
        }
        else if (self.topicOverridden)
        {
            self.topicOverridden = NO;
            self.topicName = nil;
        }
        
        [self updateNavigationRightBarItemsAnimated:NO];
        [self updateTitleText];
        [self updateThreadInfo];
        [self.composeViewController setupToolbars];
        [self.composeViewController updateActionExtensionButtons];
        [self showBannerAboutOffNetworkOrFedMsgPolicyIfNeeded];
        if (self.composeViewController.isEmpty)
        {
            [self.composeViewController restoreCurrentDraft];
        }
        else
        {
            [self.composeViewController saveCurrentDraft];
        }
        
        if (self.recipientIDs.count > 0)
        {
            BOOL disableCompose = NO;
            [self.delegate placeHolderTextForComposeViewController:&disableCompose];
            [self disableChatAndUpdateComposeView:disableCompose];
        }
        
        if ([self isPrivateChatWithBot])
        {
            [self configureBotMenuView];
            [self updateBotmenuAccessibilityContainer];
            [self.botMenuProvider.botMenuClientRequestHandler createLayoutNeedsUpdateRequestWithView:self.view anchorView:self.composeView];
        }
        else
        {
            [self.stackView setCustomSpacing:UIStackViewSpacingUseDefault afterView:self.typingIndicatorView];
            [[self.botMenuProvider menuView] removeFromSuperview];
            [self.botMenuAccessibilityContainer removeFromSuperview];
        }
    }];
}

- (void) toViewController:(TSToViewController *)toViewController didChangeFederatedUser:(NSDictionary *)userInfo
{
    //navigate to chat view of new federated user
    [self constructFederatedBanner:AXPLocalizedString(@"FederatedConversationStartLabel")
                 enableCancelImage:NO
                 enableLeaveButton:NO
                    chatBannerType:TSkNewFederatedChat];
    [self willNavigateToView:userInfo];
}

- (void) resetViewAndSyncFederatedUser:(NSDictionary *)userInfo
{
    [self resetViewWithComposeHidden:YES];
    
    // fire out sync federated user
    NSString *correlationID = [TSkCorrelationTagFederation stringByAppendingString:[[NSUUID UUID] UUIDString]];
    NSString *email = [userInfo[TSkUserEmail] asString];
    [TSSyncEngine.sharedInstance.userSyncManager syncProfilesOfFederatedUsersWithEmailIDs:@[email]
                                                                         forCorrelationID:correlationID
                                                                            accountHandle:self.accountHandle
                                                                           withCompletion:nil];
}

- (BOOL)shouldMoveFocusToSimpleSearchBar
{
    return [self isSimpleSearchBarVisible];
}

- (void)resetViewWithComposeHidden:(BOOL)composeHidden
{
    __weak typeof(self) weakSelf = self;
    
    [TSDispatchUtilities dispatchOnMainThread:^{
        // Reset before changing new chat thread
        [weakSelf resetMessages];
        
        [weakSelf.toViewController entitySearchBarViewControllerResetSearch];
        
        [weakSelf.toView setHidden:YES];
        [weakSelf.composeView setHidden:composeHidden];
        
        [weakSelf updateNavigationRightBarItemsAnimated:NO];
        [weakSelf updateTitleText];
        [weakSelf.composeViewController updateActionExtensionButtons];
    }];
}

- (TSkToControlContext) getToControlContext
{
    return TSkToControlContextChatNew ;
}

- (NSInteger) getCurrentRecipientCount
{
    if (self.threadID.length)
    {
        return self.recipientIDs.count;
    }
    return 0;
}

- (BOOL) shouldShowFMInviteMemberCell
{
    TSUserInfo *me = [self userInfoForID:self.accountHandle.MRI];
    return self.actionContext.isFMTenant && (me ? ![me isGuestUser] : NO);
}

- (void) hasContentChanged:(BOOL)hasContent
{
    if (![self isAnyWelcomeCardFeatureEnabled])
    {
        return;
    }
    
    BOOL hide = hasContent;
    
    if (hasContent && self.accountHandle.policyManager.shouldShowContactSyncEmptyState
        && !self.accountHandle.deviceContactsSync.isDeviceContactsSyncEnabled
        && self.accountHandle.deviceContactsSync.hasShownDeviceContactSyncModal
        && ((self.emptyStateView.state == TSkEmptyStateContactSync) || (self.emptyStateView.state == TSkEmptyStateInviteFriends)))
    {
        [self.toViewController.entitySearchBarViewController.textView becomeFirstResponder];
    }
    
    if (self.emptyStateView.isHidden != hide && !self.isShowingNewGroupChatCreationStateStart)
    {
        [self showEmptyStateView:!hide];
    }
}

- (void) startGroupChatCreationFlowWithTemplate:(NSString*)templateEntity
{
    NSDictionary *params = @{
        TSkBIMetadataKeyGroupTemplateType: templateEntity ?: @"",
        TSkBIMetadataKeyGroupTemplateNamingEnabled: @([self.accountHandle.policyManager isGroupCreationWithNamingInTemplatesEnabled])
    };
    [self.logger logPanelAction:TSkActionModuleNameGroupTemplateListItem
                        outCome:TSkActionOutcomeNav
                        gesture:TSkActionGestureTap
                       scenario:TSkPeoplePickerForNewChatScenarioName
                   scenarioType:TSkScenarioTypeGroupTemplateActions
                 destinationuri:nil
           destinationUriParams:nil
                     moduleType:TSkActionModuleTypeButton
                    moduleState:nil
                  moduleSummary:nil
                      panelType:TSkPanelTypeGroupTemplatePicker
                       panelUri:nil
                 panelUriParams:nil
                       threadId:self.threadID
                     threadType:nil
                       metaData:@{TSkDATABAG_PROPERTIES: [params jsonString]}];
    
    NSString *chatCreateScenarioID = [self.accountHandle.logger logStartScenarioEventOfType:SCENARIO_CHAT_CREATE
                                                                             withProperties:[self.accountHandle.logger teamChannelThreadInfo]];
    
    [self performSegue:TSkSeguePushChatMultiView withViewInfo:@{TSkChatCreateScenarioID:chatCreateScenarioID,
                                                                TSkGroupTemplateTypeKey:templateEntity,
                                                                TSkEntryPoint:TSkEntryPointNewGroupTemplatedChat}];
}


- (void) startGroupChatCreationFlow
{
    // Reset before changing new chat thread
    [self resetMessages];
    [self.composeViewController saveCurrentDraft];
    
    // Draft Key will change, clear for the current key.
    // Will re-save below after switching recipients so draft is for the right key
    [self.composeViewController clearDraftForCurrentKey];
    [self willNavigateToView:@{
        TSkEntryPoint  : TSkEntryPointPeoplePickerRow,
        TSkGroupChatCreationStateKey:@(TSGroupChatCreationStateStart)
    }];
    
    [self resetViewWithComposeHidden:YES];
}

- (StubGroupTemplateCoordinator *)groupTemplateCoordinator
{
    if (!_groupTemplateCoordinator && self.accountHandle.policyManager.isGroupCreationWithTemplatesEnabled)
    {
        _groupTemplateCoordinator = [[StubGroupTemplateCoordinator alloc] initWithTemplateType:self.initialGroupTemplateType accountHandle:self.accountHandle fromViewController:self];
    }
    
    return _groupTemplateCoordinator;
}

- (BOOL) shouldShowNewGroupChatEntryPoint
{
    return self.groupChatCreationState == TSGroupChatCreationStateNoOp && self.accountHandle.policyManager.shouldShowCreateNewGroupChatEntryPoint;
}

- (BOOL) isShowingNewGroupChatCreationStateStart
{
    return self.accountHandle.policyManager.shouldShowCreateNewGroupChatEntryPoint && self.groupChatCreationState == TSGroupChatCreationStateStart;
}

- (void) toViewControllerDidShowNewGroupTemplatePicker
{
    self.didShowGroupTemplatePicker = YES;
}

- (BOOL)toViewControllerShouldBecomeFirstResponder
{
    if (self.isGuardiansChat)
    {
        // Default recipients auto-added
        return NO;
    }
    
    if (!IS_IPAD_REGULAR())
    {
        return YES;
    }
    
    // Skip if another view (such as Settings) is being presented over the Chat view
    return [[AXPAppViewController activeOrPresentedViewController] isKindOfClass:TSChatMultiViewController.class];
}

- (BOOL)toViewControllerShouldShowEmptyStateSuggestions
{
    return !self.isGuardiansChat;
}

#pragma mark - GroupTemplateCoordinatorProvider

- (StubGroupTemplateCoordinator *)getGroupTemplateCoordinator
{
    return self.groupTemplateCoordinator;
}

#pragma mark - UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    BOOL isCallingMessage = NO;
    BOOL isControlMessage = NO;
    BOOL isLastReadIndicatorMessage = NO;
    BOOL isRecordingMessage = NO;
    BOOL isPreviousConversationMessage = NO;
    BOOL isUpdateToTeamsMessage = NO;
    BOOL isConversationContinuesMessage = NO;
//    BOOL isFluidObject = NO;//11235813
    BOOL isMeetingMessage = NO;
    BOOL isRetentionPolicyMessage = NO;
    BOOL isTranscriptMessage = NO;
    
    NSDictionary *itemData = [self dataForRowAtIndexPath:indexPath inTableView:self.tableView];
    
    // Group time separator
    if (itemData[TSkIsGroupSeparator])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:TSkNibNameChatGroupTimestampCell forIndexPath:indexPath];
        ((TSChatGroupTimestampCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
        
        [(TSChatGroupTimestampCell *)cell configureCellWithItemData:itemData
                                                          isTopCell:indexPath.section == tableView.numberOfSections - 1];
        cell.transform = CGAffineTransformMakeScale(1, -1);
        return cell;
    }
    
    if (itemData[TSkIsSmartReply])
    {
        LogInfoAH(self.logger, @"SmartReply: render SR cell %@ for threadID %@", itemData[TSkSmartReplySmartReplyID], self.threadID);
        
        cell = [tableView dequeueReusableCellWithIdentifier:TSkNibNameSmartReplyCell
                                               forIndexPath:indexPath];
        TSSmartReplyCell *smartReplyCell = (TSSmartReplyCell *)cell;
        smartReplyCell.legacyAppearanceProxy = self.legacyAppearanceProxy;
        
        smartReplyCell.lastMessageContent = self.smartReplyLastMessageContent;
        smartReplyCell.sendMessageDelegate = (id<TSSmartReplySendMessageDelegate>)self;
        smartReplyCell.telemetryDelegate = (id<SubstrateTelemetryDelegate>)self;
        [smartReplyCell configureCellWithItemData:itemData];
        smartReplyCell.transform = CGAffineTransformMakeScale(1, -1);
        self.smartReplyCell = smartReplyCell;
        return smartReplyCell;
    }
    
    if (itemData[TSkIsConsumptionHorizonLabel])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:TSkNibNameConsumptionHorizonCell
                                               forIndexPath:indexPath];
        BOOL isFromCurrentUser = [itemData[TSkUserID] isEqualToString:self.accountHandle.MRI];
        TSChatConsumptionHorizonUsersCell *consumptionHorizonCell = (TSChatConsumptionHorizonUsersCell *)cell;
        if (self.legacyAppearanceProxy != TSTheme.current)
        {
            [consumptionHorizonCell setThemeOverride_objc:self.legacyAppearanceProxy.themeType];
        }
        NSArray <NSString *> *userIDs = itemData[TSkConsumptionHorizonMRIsKey];
        NSMutableArray <NSString *> *userDisplayNames = [NSMutableArray array];
        [userIDs enumerateObjectsUsingBlock:^(NSString * _Nonnull userID, NSUInteger idx, BOOL * _Nonnull stop)
         {
            NSString *displayName = [self userInfoForID:userID].firstName;
            if (displayName != nil)
            {
                [userDisplayNames addObject:displayName];
            }
        }];
        [consumptionHorizonCell updateWithUserDisplayNames:[userDisplayNames copy]
                                           fromCurrentUser:isFromCurrentUser
                                                isEveryone:[(NSNumber *)itemData[TSkConsumptionHorizonIncludesEveryoneKey] boolValue]];
        consumptionHorizonCell.transform = CGAffineTransformMakeScale(1, -1);
        return consumptionHorizonCell;
    }
    
    TSMessageInfo *messageInfo = [self messageFromItemData:itemData];
    TSSMessage *messageEntity = nil;
    if (messageInfo && !([messageInfo isLastReadIndicatorMessage] || [messageInfo isRetentionPolicyMessage]))
    {
        messageEntity = [AXPCtx messageForID:messageInfo.tsID andThreadID:messageInfo.threadID];
    }
    
    if (messageInfo)
    {
        isCallingMessage = [messageInfo isMeetupMessage];
        isControlMessage = [messageInfo isControlMessage] || [messageEntity isEventMessage];
        isLastReadIndicatorMessage = [messageInfo isLastReadIndicatorMessage];
        isRecordingMessage = [messageInfo isRecordingMessage];
        isUpdateToTeamsMessage = [messageInfo isUpdateToTeamsMessage];
        isConversationContinuesMessage = [messageInfo isConversationContinuesMessage];
        isPreviousConversationMessage = [messageInfo isPreviousConversationMessage];
        isRetentionPolicyMessage = [messageInfo isRetentionPolicyMessage];
        isTranscriptMessage = [messageInfo isTranscriptMessage];
        self.isFluidObject = self.isFluidObjectEnabled && [self.fluidService isFluidMessageWithInfo:messageInfo
                                                                                 messageEntity:messageEntity
                                                                                   fromAccount:self.accountHandle];
        
        if (self.accountHandle.ecsManager.showMeetingChicletInGroupChat)
        {
            isMeetingMessage = [messageInfo isMeetupMessage] || [messageInfo isScheduledMeetingMessage];
        }
    }
    else {
        // Returns a hidden cell when messageInfo is nil
        // There might be race conditions when creating a new message from CE
        // This enables messageID being stale and hence a nil messageInfo
        LogVerbose(@"MessageInfo is nil, returning hidden cell");
        cell = [[UITableViewCell alloc] init];
        cell.hidden = YES;
        return cell;
    }
    
    if (isCallingMessage)
    {
        if (messageInfo.subType.intValue == TSkMessageSubTypeMeetupActive ||
            messageInfo.subType.intValue == TSkMessageSubTypeMeetupEnded)
        {
            if ((self.threadType == TSThreadTypePrivateMeeting)
                && [self.accountHandle.policyManager isPrivateMeetingEnabled]
                && messageInfo.subType.intValue == TSkMessageSubTypeMeetupEnded)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:TSkNibNameChatMeetingCardViewCell];
                ((TSChatMeetingCardViewCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
                BOOL hasTranscription = NO;
                if (self.accountHandle.ecsManager.isTranscriptFeatureEnabledOnECS)
                {
                    TSSMessage *messageEntity = [TSSMessage messageForID:messageInfo.tsID
                                                             andThreadID:messageInfo.threadID
                                                  inManagedObjectContext:self.accountHandle.mainMOC];
                    TSMessageInfo *transcriptionMessageInfo = self.transcriptViewModel.meetingTranscriptionDict[messageEntity.skypeguid ?: @""];
                    hasTranscription = (transcriptionMessageInfo != nil);
                    TSWeakify(self)
                    ((TSChatMeetingCardViewCell*)cell).onTapTranscript = ^{
                        TSStrongifyAndReturnIfNil(self)
                        [self didTapTranscriptionPreviewWithMessageInfo:transcriptionMessageInfo];
                    };
                    ((TSChatMeetingCardViewCell*)cell).onLongPressTranscript = ^(UIView *view){
                        TSStrongifyAndReturnIfNil(self)
                        [self.transcriptViewModel showMenuWithCallId:messageEntity.skypeguid from:view];
                    };
                }
                [(TSChatMeetingCardViewCell*)cell configureChatCellForMeetingCardWithMessageInfo:messageInfo forcedCompactMode:self.isInCallRightPanel withThumnbnailStripe:[TSThumbnailStripeViewController getThumbnailStripeView] accountHandle:self.accountHandle hasTranscription:hasTranscription];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:TSkNibNameChatCallingMessageViewCell];
                ((TSChatCallingMessageViewCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
                [(TSChatCallingMessageViewCell *)cell configureCellForCallMessageWithMessageInfo:messageInfo isPrivateMeeting:(self.threadType == TSThreadTypePrivateMeeting)];
                [self configureRevealableLabelForCard:cell withMessage:messageInfo];
            }
        }
        else
        {
            LogWarningAH(self.logger, @"unsupported calling message subtype: %@", messageInfo.subType);
        }
    }
    else if (isControlMessage)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:TSkNibNameChatCallingMessageViewCell];
        ((TSChatCallingMessageViewCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
        
        [(TSChatCallingMessageViewCell *)cell configureCellForControlMessageWithMessageInfo:messageInfo
                                                                           isPrivateMeeting:(self.threadType == TSThreadTypePrivateMeeting)
                                                                      isLiveLocationEnabled:self.accountHandle.policyManager.isLocationWithLiveSharingEnabled];
        [self configureRevealableLabelForCard:cell withMessage:messageInfo];
    }
    else if (isLastReadIndicatorMessage)
    {
        cell  = [tableView dequeueReusableCellWithIdentifier:kNibNameLastReadWatermarkCellChat];
        ((TSLastReadWatermarkCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
        
        [(TSLastReadWatermarkCell *)cell configureCellForLastReadWatermarkWithBackground:tableView.backgroundColor];
    }
    else if (isRetentionPolicyMessage)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:TSRetentionPolicyMessageViewCell.reuseIdentifier];
        ((TSRetentionPolicyMessageViewCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
        
        [(TSRetentionPolicyMessageViewCell *)cell configureCell];
    }
    else if (isRecordingMessage)
    {
        if ([[ResolveProtocol(AccountDependencyResolverObjCBridge) experimentationServiceObjCWithUserKey:self.accountHandle.userKey] boolForAgentName:TSECSTeamName keyPath:TSkRecordingChicletV2Enabled defaultValue:NO])
        {
            TSSMessage *message = [AXPCtx messageForID:messageInfo.tsID andThreadID:messageInfo.threadID];
            NSDictionary *recordingDetails = [TSMeetingUtils getRecordingCardDetails:message.content accountHandle:self.accountHandle];
            if (recordingDetails)
            {
                TSCallRecordingResponseStatus status = (TSCallRecordingResponseStatus)[[recordingDetails valueForKey:TSkRecordingStatus] unsignedIntValue];
                if (status == TSRecordingOngoing || status == TSRecordingProcessing)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:TSkNibNameChatCallingMessageViewCell];
                    [(TSChatCallingMessageViewCell*)cell configureCellForCallMessageWithMessageInfo:messageInfo isPrivateMeeting:(self.threadType == TSThreadTypePrivateMeeting)];
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:TSkNibNameChatRecordingCardViewCell];
                    [self configureRecordingCard:(TSChatRecordingCardViewCell*)cell atIndexPath:indexPath withMessage:messageInfo];
                }
                [self configureRevealableLabelForCard:cell withMessage:messageInfo];
            }
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:TSkNibNameChatRecordingCardViewCell];
            ((TSChatRecordingCardViewCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
            
            [self configureRecordingCard:(TSChatRecordingCardViewCell*)cell atIndexPath:indexPath withMessage:messageInfo];
            [self configureRevealableLabelForCard:cell withMessage:messageInfo];
        }
    }
    else if (isPreviousConversationMessage)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kNibNameNativeFederationChatCell];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnPreviousConversationCell:)];
        ((TSNativeFederationChatCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
        
        [(TSNativeFederationChatCell *)cell configureCellForPreviousConversationMessage];
        [[(TSNativeFederationChatCell *)cell messageLabel] setUserInteractionEnabled:YES];
        [[(TSNativeFederationChatCell *)cell messageLabel] addGestureRecognizer:gesture];
    }
    else if (isUpdateToTeamsMessage)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:TSkNibNameChatCallingMessageViewCell];
        ((TSChatCallingMessageViewCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
        
        TSUserInfo *user = [self userInfoForID:[[self.recipientIDs firstObject] asString]];
        [(TSChatCallingMessageViewCell *)cell configureCellForUpdateToTeamsMessageWithDisplayName:user.displayName];
        [self configureRevealableLabelForCard:cell withMessage:messageInfo];
    }
    else if (isConversationContinuesMessage)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kNibNameNativeFederationChatCell];
        ((TSNativeFederationChatCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnNativeFederationChatCell:)];
        if ([self.nativeFederationThreadID length])
        {
            [(TSNativeFederationChatCell *)cell configureCellForConversationContinuesMessage];
            [[(TSNativeFederationChatCell *)cell messageLabel] setUserInteractionEnabled:YES];
            [[(TSNativeFederationChatCell *)cell messageLabel] addGestureRecognizer:gesture];
        }
        else
        {
            [(TSNativeFederationChatCell *)cell configureCellForNavigationButton];
            [[(TSNativeFederationChatCell *)cell button] setUserInteractionEnabled:YES];
            [[(TSNativeFederationChatCell *)cell button] addGestureRecognizer:gesture];
        }
    }
//    else if (isFluidObject)
//    {
//        id<TSFluidTablePreviewCellDelegate> fluidTablePreviewCellDelegate = [self.fluidTablePreviewCellHandler conformsToProtocol:@protocol(TSFluidTablePreviewCellDelegate)] ? ((id<TSFluidTablePreviewCellDelegate>)self.fluidTablePreviewCellHandler) : nil;
//        TSFluidTablePreviewCell *fluidTableCell = [self.fluidService getCell:messageInfo
//                                                               messageEntity:messageEntity
//                                                                chatDelegate:fluidTablePreviewCellDelegate];
//        // because you have model here
//        if (fluidTableCell != nil) {
//            fluidTableCell.canReplyToChat = [self shouldAllowReplyToChat];
//            fluidTableCell.canQuoteMessage = [self canQuoteMessageID:messageInfo.tsID];
//            [fluidTableCell start:self.accountHandle];
//            cell = fluidTableCell;
//        }
//    }
    else if (isTranscriptMessage) {
        cell = [AXPUtilities emptyCell:tableView];
    }
    else
    {
        NSString *cellKey = TSkNibNameChatMessageCellLeft;
        NSString *userID = messageInfo.userID;
        if (messageInfo.isLocal.boolValue || [self.accountHandle.MRI compareString:userID])
        {
            cellKey = TSkNibNameChatMessageCellRight;
        }
        
        // Don't reuse cell when animates, to avoid possible layout issues. See 962374
        if (self.animatingTableChanges && indexPath.item == 0 && indexPath.section == 0) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:cellKey owner:self options:nil] firstObject];
        }
        
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:cellKey];
        }
        
        ((TSChatMessageViewCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
        [self configureCell:(TSChatMessageViewCell*)cell atIndexPath:indexPath withMessageInfo:messageInfo];
    }
    
    NSTimeInterval different = [[NSDate date] timeIntervalSinceDate:messageInfo.arrivalTime];
    BOOL isNewMessage = (abs((int)different) < RecentMessageStandard);
    
    if (messageInfo && indexPath.row == 0 && indexPath.section == 0 && [self isCurrentlyVisible])
    {
        BOOL moreRecent = [self.latestMessageArrivalTime timeIntervalSinceDate: messageInfo.arrivalTime] < 0;
        if (moreRecent)
        {
            self.latestMessageArrivalTime = messageInfo.arrivalTime;
        }
        
        // TODO: (hsaokar) We removed isRead field from Message, need to bring it back
        if (!messageInfo.isSentByMe.boolValue /* && !message.isRead */&& (isNewMessage || self.forceAccessibilityFocusOnScrollToUnread == YES))
        {
            NSString *newMessageArrivedString = AXPLocalizedString(@"NewMessageArrived");
            if (messageInfo.importanceLevel == TSImportantPriorityHigh)
            {
                newMessageArrivedString = AXPLocalizedString(@"NewImportantMessageArrivedAccessibilityAnnouncement");
            }
            else if (messageInfo.importanceLevel == TSImportantPriorityUrgent)
            {
                newMessageArrivedString = AXPLocalizedString(@"NewUrgentMessageArrivedAccessibilityAnnouncement");
            }
            
            // not sent by me and the arrivalTime is within 0.2 s
            NSString *accessibilityNotification = self.forceAccessibilityFocusOnScrollToUnread ? AXPLocalizedString(@"ScrollingToNewMessages") : newMessageArrivedString;
            
            // workaround for cases where the accessibility element is considered already focused and VO will not notify user
            if ([cell.accessibilityElements[0] accessibilityElementIsFocused])
            {
                accessibilityNotification = [accessibilityNotification stringByAppendingString:((UIView*)(cell.accessibilityElements[0])).accessibilityLabel];
                if (((UIView*)(cell.accessibilityElements[0])).accessibilityValue.length)
                {
                    accessibilityNotification = [accessibilityNotification stringByAppendingString:((UIView*)(cell.accessibilityElements[0])).accessibilityValue];
                }
            }
            [[TSAccessibilityNotificationHelper sharedInstance] queueMessage:accessibilityNotification];
            
            //move the accessibility element to the new element
            if (self.forceAccessibilityFocusOnScrollToUnread || self.tableViewHasVOFocus)
            {
                UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, cell);
            }
            
            self.forceAccessibilityFocusOnScrollToUnread = NO;
        }
    }
    
    // A final check to make sure we return a non-nil cell
    if (cell == nil)
    {
        cell = [[TSChatMessageViewCell alloc] init];
        ((TSChatMessageViewCell *)cell).legacyAppearanceProxy = self.legacyAppearanceProxy;
    }
    
    if (self.accountHandle.policyManager.isMsgAnimationsEnabled)
    {
        BOOL isLastMsgFromOthersAndUnread = [self isLastMessageSentByOthers:messageInfo] && self.hasUnreadMessages;
        if (isNewMessage || isLastMsgFromOthersAndUnread)
        {
            [self setupMsgAnimationFor:messageInfo andCell:(TSChatMessageViewCell *) cell];
        }
        
    }
    
    // Highlight text if this chat message is from search results
    if (self.searchTerms && [cell isKindOfClass:TSBaseTableViewCell.class])
    {
        [((TSBaseTableViewCell *)cell) highlightSearchResult:self.searchTerms attributes:self.searchHighlightAttributes];
    }
    
    if (self.scrollToMessageID && [self.scrollToMessageID isEqual:messageInfo.tsID])
    {
        if ([cell isKindOfClass:TSBaseTableViewCell.class])
        {
            __weak typeof(self) weakSelf = self;
            [((TSBaseTableViewCell *)cell) highlightSearchResultCellForQuickReact:NO completion:^{
                weakSelf.scrollToMessageID = nil;
            }];
        }
        else
        {
            self.scrollToMessageID = nil;
        }
        if (self.isLoadingIndicatorInChatEnabled)
        {
            [self setActivitySpinnerWithText:nil showSpinner:NO];
        }
    }
    
    [self highlightCellIfTriggered:messageInfo.tsID forCell:cell];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    cell.transform = CGAffineTransformMakeScale(1, -1);
    [CATransaction commit];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = UITableViewAutomaticDimension;
    if (self.isFluidObjectEnabled)
    {
        NSDictionary *itemData = [self dataForRowAtIndexPath:indexPath inTableView:tableView];
        TSMessageInfo * _Nullable messageInfo = [self messageFromItemData:itemData];
        if (!messageInfo || [messageInfo isLastReadIndicatorMessage])
        {
            return cellHeight;
        }
        
        TSSMessage * _Nullable message = [TSSMessage messageForID:messageInfo.tsID andThreadID:messageInfo.threadID inManagedObjectContext:self.accountHandle.mainMOC];
        if ([message isTranscriptMessage]) // By design. Transcription is not shown as a stand-alone message, so we hide it.
        {
            return 0.0f;
        }
        
        if ([self.fluidService isFluidMessageWithInfo:messageInfo messageEntity:message fromAccount:self.accountHandle])
        {
            CGFloat maxComponentHeightRatio = (CGFloat)[self.accountHandle.actionContext.fluidMessageMaxHeightRatio doubleValue];
            CGFloat maxComponentHeight = self.view.bounds.size.height * maxComponentHeightRatio;
            cellHeight = [self.fluidService getCellHeight:messageInfo maxComponentHeight: maxComponentHeight];
            return cellHeight;
        }
    }
    
    return cellHeight;
}

#pragma mark - Cell Configuration

- (void)configureRevealableLabelForCard:(UITableViewCell *)cell withMessage:(TSMessageInfo *)message
{
    NSString *userID = message.userID;
    bool isLeftCell = !(message.isLocal.boolValue || [self.accountHandle.MRI compareString:userID]);
    
    TSRevealableView *revealableView = [self.tableView dequeueReusableRevealableViewWithIdentifier:TSkNibNameRevealableLabel];
    revealableView.legacyAppearanceProxy = self.legacyAppearanceProxy;
    
    if (revealableView)
    {
        TSRevealableLabel *revealableLabel = (TSRevealableLabel *)revealableView;
        [revealableLabel configureWithText:[message.arrivalTime axp_briefTimeInWordsWithFetchDay:NO withFetchTime:YES]];
        
        if ([cell isKindOfClass:TSChatRecordingCardViewCell.class])
        {
            [(TSChatRecordingCardViewCell *)cell setRevealableView:revealableLabel
                                                             style:TSRevealStyleSlide
                                                         direction:[TSUtilities isRightToLeftLayout] ? TSRevealDirectionRight : TSRevealDirectionLeft
                                                            anchor:(isLeftCell ? TSRevealAnchorLeft : TSRevealAnchorRight)];
        }
        else if ([cell isKindOfClass:TSChatCallingMessageViewCell.class])
        {
            [(TSChatCallingMessageViewCell *)cell setRevealableView:revealableLabel
                                                              style:TSRevealStyleOver
                                                          direction:[TSUtilities isRightToLeftLayout] ? TSRevealDirectionRight : TSRevealDirectionLeft
                                                             anchor:(isLeftCell ? TSRevealAnchorLeft : TSRevealAnchorRight)];
        }
    }
}

- (void) updateBubbleColors
{
    GradientObject *resultGradient = [[GradientObject alloc] init];
    [resultGradient addWithColor:TSTheme.current.chatMessageSentGradientStartColor at:0];
    [resultGradient addWithColor:TSTheme.current.chatMessageSentGradientMidColor at:0.25];
    [resultGradient addWithColor:TSTheme.current.chatMessageSentGradientEndColor at:1];
    self.bubbleGradient = resultGradient;
    
    id<PersonalizationManagerObjCBridge> personalizationManager = [ResolveProtocol(DIContainerRegistrar) accountDIContainerFor:self.accountHandle.userKey].dependenciesObjcBridge.personalizationManagerObjCBridge;
    if (personalizationManager.isPersonalizationEnabled) {
        NSString *themeId = [AXPCtx threadForID:self.threadID].themeId;
        GradientObject *themeGradient = [personalizationManager getMessageGradientObjectForThemeId:themeId isDarkTheme:self.legacyAppearanceProxy.isDarkTheme];
        if (themeGradient) {
            LogInfoAH(self.logger, @"Setting %@ theme", themeId);
            self.bubbleGradient = themeGradient;
        }
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self applyDynamicDecorationIfNeeded];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    if (self.dynamicDecorationType != DynamicDecorationTypeNone)
    {
        [tableView applyGradientDecorationForCell:cell at:indexPath gradient:self.bubbleGradient];
    }
    
    if (self.isScrollingToTop && indexPath.row == 0 && indexPath.section == 0)
    {
        self.isScrollingToTop = NO;
    }
    
    if ([cell isKindOfClass:TSSmartReplyCell.class])
    {
        TSSmartReplyCell *smartReplyCell = (TSSmartReplyCell *)cell;
        
        if ([self.accountHandle.ecsManager smartReplyRenderAnimationEnabled])
        {
            NSString *smartReplyID = [smartReplyCell getSmartReplyFirstWhisperID];
            if ([smartReplyID isEqualToString:self.animatedSmartReplyID])
            {
                return;
            }
            
            [smartReplyCell setDisplayAnimation];
            self.animatedSmartReplyID = smartReplyID;
        }
    }
    
    if (!self.isCurrentlyVisible) {
        self.needAcknowledgementForVisibleCells = YES;
        return;
    }
    
    [self acknowledgeMessageAtIndexPath:indexPath];
}

- (void) arrayTableViewControllerDidReloadTableView
{
    [super arrayTableViewControllerDidReloadTableView];
    [self applyDynamicDecorationIfNeeded];
}

- (void) arrayTableViewControllerDidUpdateTableView
{
    [super arrayTableViewControllerDidUpdateTableView];
    [self applyDynamicDecorationIfNeeded];
}

- (void)acknowledgeMessageAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.accountHandle.ecsManager.enablePriorityMessaging || !self.actionContext.allowPriorityMessages)
    {
        // we no longer need to check for urgent message.
        return;
    }
    
    if (self.threadType == TSThreadTypePrivateMeeting && !self.accountHandle.ecsManager.enablePriorityMessagingForMeetingChat)
    {
        return;
    }
    
    NSDictionary *itemData = [self dataForRowAtIndexPath:indexPath inTableView:self.tableView];
    TSMessageInfo *messageInfo = [self messageFromItemData:itemData];
    
    if (messageInfo.importanceLevel == TSImportantPriorityUrgent && !messageInfo.isSentByMe.boolValue)
    {
        TSSMessage *message = [AXPCtx messageForID:messageInfo.tsID andThreadID:messageInfo.threadID];
        if (message.acknowledgmentState == nil)
        {
            [self handleMarkAsAcknowledged:message.tsID threadID:self.threadID ackState:TSkAckStateRead];
        }
    }
}

- (void)configureConnectorCard:(TSChatConnectorViewCell*)cell
                   atIndexPath:(NSIndexPath*)indexPath
                   withMessage:(TSMessageInfo *)message
{
    NSString *botCardRenderingScenarioID = [self.accountHandle.logger logStartScenarioEventOfType:SCENARIO_BOT_CARDS_RENDERING];
    BOOL atLeastOneCardLoaded = NO;
    
    TSConnectorCard *connectorCard = nil;
    if (message.ts_botCardData)
    {
        id botCardData = [NSKeyedUnarchiver unarchiveObjectWithData:message.ts_botCardData];
        botCardData = [TSUtilities sanitizeBotCardData:botCardData];
        if (botCardData && [botCardData isKindOfClass:[NSArray class]])
        {
            for (id archivedCardData in (NSArray *)botCardData)
            {
                id botCard = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCardData];
                if (botCard && [botCard isKindOfClass:TSConnectorCard.class])
                {
                    connectorCard = botCard;
                    atLeastOneCardLoaded = YES;
                    break;
                }
            }
        }
        else
        {
            // This section was added for backward compatibility only and can be removed when we reset the DB
            if (botCardData && [botCardData isKindOfClass:TSConnectorCard.class])
            {
                connectorCard = botCardData;
                atLeastOneCardLoaded = YES;
            }
        }
    }
    
    cell.baseTableViewController = self;
    cell.indexPath = indexPath;
    cell.rootMessageId = message.tsID;
    cell.version = message.version ? message.version : @0;
    [cell.whenLabel setText:[message.arrivalTime axp_briefTimeInWordsWithFetchDay:NO withFetchTime:YES]];
    cell.whenLabel.font = [TSFont caption1];
    cell.whenLabel.textColor = self.legacyAppearanceProxy.cellDetailTextColor;
    [cell.whenLabel sizeToFit];
    
    CGFloat widthOfBotCard = CGRectGetWidth(self.tableView.bounds) - TSkBotChatCellEmptySpaceWidth;
    widthOfBotCard = MIN(widthOfBotCard, TSBotCardViewSize.width);
    cell.cardWidthConstraint.constant = widthOfBotCard;
    
    TSSMessage *msg = [AXPCtx messageForID:message.tsID andThreadID:self.threadID];
    [cell configureMessage:msg
                  withCard:connectorCard
         andIsFirstMessage:NO
               andIsUnRead:NO
           inDrillDownView:NO
                 withWidth:CGRectGetWidth(self.tableView.bounds)];
    
    [self.accountHandle.logger logScenarioStopEvent:botCardRenderingScenarioID status:atLeastOneCardLoaded ? ScenarioStatusOK : ScenarioStatusFailure];
}

- (void) configureRecordingCard:(TSChatRecordingCardViewCell*)cell
                    atIndexPath:(NSIndexPath*)indexPath
                    withMessage:(TSMessageInfo *)message
{
    cell.legacyAppearanceProxy = self.legacyAppearanceProxy;
    cell.baseTableViewController = self;
    cell.messageID = message.tsID;
    cell.threadID = message.threadID;
    cell.indexPath = indexPath;
    cell.fromUserID = message.userID;
    cell.title = self.title;
    
    [cell enableSaved:message.hasSavedMessage];
    [cell enableLikeImage:message.likeCount.unsignedIntegerValue withLikedByMe:message.isLikedByMe];
    
    [cell configureChatCellForRecordingCardWithMessageInfo:message accountHandle:self.accountHandle forcedCompactMode:self.isInCallRightPanel];
    [cell configureOptionsForRecordingMessage];
}

// TSBaseTableViewController override
- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
           withObject:(id)anObject
{
    // Chat view is no longer empty as we load a cell
    self.isTableEmpty = NO;
    
    if ([anObject isKindOfClass:[TSSMessage class]])
    {
        if ([cell isKindOfClass:TSChatMessageViewCell.class])
        {
            [self configureCell:(TSChatMessageViewCell*)cell atIndexPath:indexPath withMessageInfo:anObject];
        }
    }
}

#pragma mark - Overriden Method

- (void) addReactionAnimationView
{
    [self.stackView addSubview:self.reactionAnimationView];
}

#pragma mark - Read Receipts
- (NSInteger) getSeenByCountForMessage:(NSNumber*)msgArrivalTime
{
    NSInteger seenByCount = 0;
    for (NSNumber *consumptionHorizonTime in [self.allRecipientsConsumptionHorizons allValues])
    {
        if (consumptionHorizonTime.longLongValue >= msgArrivalTime.longLongValue)
        {
            seenByCount++;
        }
    }
    
    return seenByCount;
}

/// return a lisf of users' first name who have read the message
/// @param message the target message
/// @param seenByCount the count of people have read the message
/// @param totalCount total count of people in the group except self
- (NSString *) getSeenByList:(TSSMessage*)message
                 seenByCount:(NSInteger)seenByCount
                  totalCount:(NSInteger)totalCount
{
    if (seenByCount == 0 || seenByCount == totalCount)
    {
        return @"";
    }
    
    NSNumber *msgArrivalTime = message.ts_numericArrivalTime;
    NSMutableArray<NSString *> *seenByList = [NSMutableArray new];
    NSString *seeByListString;
    
    for (id key in self.allRecipientsConsumptionHorizons)
    {
        NSString *mri = (NSString *)key;
        if (seenByList.count == TSkReadReceiptSeenByListSize)
        {
            // seen by list contains enough users
            break;
        }
        if ([self.allRecipientsConsumptionHorizons objectForKey:key].longLongValue >= msgArrivalTime.longLongValue)
        {
            TSUserInfo *userInfo = [self userInfoForID:mri];
            if(userInfo && [userInfo.firstName isNotNilOrEmpty])
            {
                [seenByList addObject:userInfo.firstName];
            }
        }
    }
    
    seeByListString = [seenByList componentsJoinedByString:AXPLocalizedString(@"CommaSeparatorTemplate")];
    if (seenByCount > seenByList.count)
    {
        //attach +num to the end
        seeByListString = [NSString stringWithFormat:AXPLocalizedString(@"ChatMsgSeenByFormatExtra"), seeByListString, seenByCount - seenByList.count];
    }
    return seeByListString;
}

- (void) showSeenByListForArrivalTime:(NSNumber *)msgArrivalTime
{
    NSMutableArray<TSEntitySearchResultItem*> *readByEntityItemList = NSMutableArray.new;
    NSMutableArray<TSEntitySearchResultItem*> *sentToEntityItemList = NSMutableArray.new;
    
    for (NSString *recipientID in self.recipientIDs)
    {
        TSUserInfo *userInfo = [self userInfoForID:recipientID];
        if (userInfo && [userInfo.tsID isNotNilOrEmpty])
        {
            TSEntitySearchResultItem *entityItem = [[TSEntitySearchResultItem alloc] initWithItem:userInfo.tsID sort:userInfo.displayName type:TSkEntitySearchResultTypeUser];
            
            if (self.allRecipientsConsumptionHorizons[recipientID].longLongValue >= msgArrivalTime.longLongValue)
            {
                [readByEntityItemList addObject:entityItem];
            }
            else
            {
                [sentToEntityItemList addObject:entityItem];
            }
        }
    }
    
    [self addMessageReadStatusTelemetry];
    
    TSChatReadStatusViewController *readStatusVC = [[TSChatReadStatusViewController alloc] init];
    [readStatusVC willNavigateToView:@{
        TSkReadByRecipientList : readByEntityItemList,
        TSkSentToRecipientList : sentToEntityItemList
    }];
    
    if (IS_IPAD_REGULAR())
    {
        TSNavigationController *navigationController = [[TSNavigationController alloc] initWithRootViewController:readStatusVC];
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:navigationController
                           animated:YES
                         completion:nil];
    }
    else
    {
        [self.navigationController pushViewController:readStatusVC animated:YES];
    }
}

- (BOOL) isMessageSeenByAllForArrivalTime:(long long)msgArrivalTime
{
    if ([[self recipientIDs] count] != [self.allRecipientsConsumptionHorizons count])
    {
        // we do not have consumption horizon for all recipients
        return NO;
    }
    
    for (NSNumber *consumptionHorizonTime in [self.allRecipientsConsumptionHorizons allValues])
    {
        if (consumptionHorizonTime.longLongValue < msgArrivalTime)
        {
            return NO;
        }
    }
    
    return YES;
}

// computation done based on inverted tableview
- (void) computeIndexPathForLastSeen:(NSIndexPath **) lastSeenMsgIndexPath andForLastSentMsg:(NSIndexPath **) lastSentMsgIndexPath
{
    BOOL readReceiptsEnabled = [self readReceiptsEnabled];
    
    NSInteger sections = [self numberOfSections];
    for (int section = 0; section < sections; section++)
    {
        NSInteger rows = [self numberOfRowsInSection:section];
        for (int row = 0; row < rows; row++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row
                                                        inSection:section];
            
            NSDictionary *itemData = [self dataForRowAtIndexPath:indexPath
                                                     inTableView:self.tableView];
            
            TSMessageInfo *messageInfo = [self messageFromItemData:itemData];
            long long msgArrivalTime = messageInfo.arrivalTime.skypeTimeInterval;
            
            if (messageInfo.isSentByMe.boolValue && !messageInfo.isLocal.boolValue)
            {
                if (!(*lastSentMsgIndexPath)) {
                    *lastSentMsgIndexPath = indexPath;
                }
                
                if (readReceiptsEnabled && !(*lastSeenMsgIndexPath) && [self isMessageSeenByAllForArrivalTime:msgArrivalTime]) { // try searching only if read receipt is enabled
                    *lastSeenMsgIndexPath = indexPath;
                }
                
                if (*lastSentMsgIndexPath && (*lastSeenMsgIndexPath || !readReceiptsEnabled)) { // bail out as soon as we get the values
                    return;
                }
            }
        }
    }
}

- (void) addMessageReadStatusTelemetry
{
    [self.logger logPanelAction:TSkActionModuleNameChatCMSeenBy
                        outCome:TSkActionOutcomeNav
                        gesture:TSkActionGestureTap
                       scenario:TSkScenarioChatCMSeenBy
                   scenarioType:TSkScenarioTypeChatContextMenu
                 destinationuri:nil
           destinationUriParams:nil
                     moduleType:TSkActionModuleTypeButton
                    moduleState:nil
                  moduleSummary:nil
                      panelType:TSkPanelTypeChatContextMenu
                       panelUri:nil
                 panelUriParams:nil
                       threadId:self.threadID
                     threadType:nil];
}

#pragma mark -

- (BOOL) shouldCollapseCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return NO;
    }
    
    NSInteger offset = -1;
    
    NSDictionary *dictionary = [self dataForRowAtIndexPath:indexPath
                                               inTableView:self.tableView];
    TSMessageInfo *messageInfo = [self messageFromItemData:dictionary];
    
    
    NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:indexPath.row + offset
                                                     inSection:indexPath.section];
    NSDictionary *otherDictionary = [self dataForRowAtIndexPath:otherIndexPath
                                                    inTableView:self.tableView];
    TSMessageInfo *otherMessageInfo = [self messageFromItemData:otherDictionary];
    
    if (![otherMessageInfo.userID isEqualToString:messageInfo.userID])
    {
        return NO;
    }
    
    if ([messageInfo isMeetupMessage] && ![otherMessageInfo isMeetupMessage])
    {
        return NO;
    }
    
    if ([TSUser isBOT:messageInfo.userID]
        && [self isSentOnBehalfOfDifferentUsers:messageInfo.mentions andOther:otherMessageInfo.mentions])
    {
        return NO;
    }
    
    NSTimeInterval timeInterval = [otherMessageInfo.arrivalTime timeIntervalSinceDate:messageInfo.arrivalTime];
    BOOL isWithinCollapsingTime = (timeInterval <= TSkChatMessageCollapsingTimeInterval);
    if (!isWithinCollapsingTime)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)isSentOnBehalfOfDifferentUsers:(NSObject *)messageMentions
                              andOther:(NSObject *)otherMessageMentions
{
    NSString *messageOnBehalfOfMri = [self getOnBehalfOfMentionMri:messageMentions];
    NSString *otherMessageOnBehalfOfMri = [self getOnBehalfOfMentionMri:otherMessageMentions];
    if ([NSString isNilOrWhitespace:messageOnBehalfOfMri]
        && [NSString isNilOrWhitespace:otherMessageOnBehalfOfMri])
    {
        return NO;
    }
    return ![messageOnBehalfOfMri isEqualToString:otherMessageOnBehalfOfMri];
}

- (TSInterMessageBubbleSpacingType) messageBubbleSpacingTypeForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger offset = +1;
    
    NSDictionary *dictionary = [self dataForRowAtIndexPath:indexPath
                                               inTableView:self.tableView];
    TSMessageInfo *messageInfo = [self messageFromItemData:dictionary];
    
    NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:indexPath.row + offset
                                                     inSection:indexPath.section];
    NSDictionary *otherDictionary = [self dataForRowAtIndexPath:otherIndexPath
                                                    inTableView:self.tableView];
    if (!otherDictionary) {
        return TSInterMessageBubbleSpacingTypeCollapsed;
    }
    
    TSMessageInfo *otherMessageInfo = [self messageFromItemData:otherDictionary];
    
    if (otherMessageInfo.isControlMessage) {
        return TSInterMessageBubbleSpacingTypeCollapsed;
    }
    
    if (otherDictionary[TSkIsGroupSeparator]) {
        return TSInterMessageBubbleSpacingTypeUncollapsed;
    }
    
    if (![otherMessageInfo.userID isEqualToString:messageInfo.userID])
    {
        return TSInterMessageBubbleSpacingTypeUncollapsed;
    }
    
    if ([messageInfo isMeetupMessage] && ![otherMessageInfo isMeetupMessage])
    {
        return TSInterMessageBubbleSpacingTypeUncollapsed;
    }
    
    NSTimeInterval timeInterval = fabs([otherMessageInfo.arrivalTime timeIntervalSinceDate:messageInfo.arrivalTime]);
    BOOL isWithinCollapsingTime = (timeInterval <= TSkChatMessageCollapsingTimeInterval);
    if (!isWithinCollapsingTime)
    {
        return TSInterMessageBubbleSpacingTypeHalfCollapsed;
    }
    
    return TSInterMessageBubbleSpacingTypeCollapsed;
}

- (NSNumber *)heightModifiersForIndexPath:(NSIndexPath *)indexPath
{
    return @([self shouldCollapseCellAtIndexPath:indexPath]);
}

- (BOOL) shouldCollapseUserInfoForCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 1 == [self.tableView numberOfRowsInSection:indexPath.section])
    {
        return NO;
    }
    
    return [self shouldCollapseCellAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
}

// now return all the UIAccessibilityElement under the TetView due to UITextView accessibility change in iOS 13
- (NSArray *) configureTextMessageView:(UITextView *)textMessageView
                               forCell:(TSChatMessageViewCell*)cell
{
    textMessageView.attributedText = [textMessageView.attributedText attributedStringWithFontTextStyle:UIFontTextStyleBody
                                                                                           andFontType:TSkFontTypeRegular
                                                                                         biggerCapSize:YES];
    BOOL largeEmojis = [TSUxUtils makeLargerEmojiInTextView:textMessageView];
    
    if ([TSAccountManager.activeConfigHandle.ecsManager chatContentBackgroundEnabledOnECS] &&
        largeEmojis)
    {
        [cell setClearBubbleColor:YES];
    }
    
    textMessageView.hidden = (textMessageView.text.length == 0);
    
    textMessageView.adjustsFontForContentSizeCategory = YES;
    NSTextAlignment bestAlignment = [[textMessageView.attributedText accessibilityString:NO] bestTextAlignment];
    if (textMessageView.textAlignment != bestAlignment)
    {
        textMessageView.textAlignment = bestAlignment;
    }
    
    textMessageView.backgroundColor = cell.messageBubbleView.backgroundColor;
    for (UIView *subview in textMessageView.subviews)
    {
        if (subview.tag != TSkBlockquoteIndicatorViewTag)
        {
            subview.backgroundColor = cell.messageBubbleView.backgroundColor;
            subview.opaque = YES;
        }
    }
    
    textMessageView.delegate = self;
    NSArray *elements = [cell accessibilityElementsForTextView:textMessageView withContainer:nil];
    return elements;
}

- (void) populateMessageTextView:(UITextView *)messageTextView
            withAttributedString:(NSAttributedString *)attributedString
                      isLeftCell:(BOOL)isLeftCell
                       isBlocked:(BOOL)isBlocked
           messageFailedToUpload:(BOOL)messageFailed
{
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    
    [mutableAttributedString enumerateAttribute:NSAttachmentAttributeName
                                        inRange:NSMakeRange(0, mutableAttributedString.length)
                                        options:kNilOptions
                                     usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop)
     {
        if ([value isKindOfClass:[TSEmojiTextAttachment class]] && !isLeftCell)
        {
            TSEmojiTextAttachment *emojiAttachment = (TSEmojiTextAttachment *) value;
            id<EmojiManagerProtocol> emojiManager = self.accountHandle.emojiManagerProvider.emojiManager;
            UIImage *emojiImage = [emojiManager resizedImageToDefaultSizeFor:emojiAttachment.emojiClassType skinTone:emojiAttachment.skinTone logger:self.accountHandle.logger];
            emojiAttachment.image = emojiImage;
        }
        
        if ([value isKindOfClass:[TSMentionTextAttachment class]])
        {
            TSMentionTextAttachment *attachment = (TSMentionTextAttachment *)value;
            
            if (isLeftCell || isBlocked)
            {
                [attachment updateMentionImage];
            }
            else
            {
                [mutableAttributedString enumerateAttribute:TSkBlockquoteCustomTextAttributeName
                                                    inRange:range
                                                    options:kNilOptions
                                                 usingBlock:^(id value, NSRange range, BOOL *stop)
                 {
                    if (!value)
                    {
                        [attachment updateMentionImageWithForegroundColor: self.legacyAppearanceProxy.chatMessageSentTextColor];
                    }
                }];
            }
            
            bool mentionIsForMe = ([attachment.tsID isEqualToString:self.accountHandle.MRI]);
            
            if (mentionIsForMe || (!isLeftCell))
            {
                [attachment updateMentionImageWithFontType:TSkFontTypeBold];
            }
            
            NSMutableDictionary *newAttributes = NSMutableDictionary.new;
            
            // If the mention attachment is part of a block quote, preserve all attributes
            NSDictionary *previousAttachmentAttributes = [mutableAttributedString attributesAtIndex:range.location effectiveRange:nil];
            if (previousAttachmentAttributes && [previousAttachmentAttributes objectForKey:TSkBlockquoteCustomTextAttributeName])
            {
                newAttributes = previousAttachmentAttributes.mutableCopy;
            }
            
            [newAttributes setObject:attachment forKey:NSAttachmentAttributeName];
            [mutableAttributedString setAttributes:newAttributes range:range];
            
            [attachment updateMentionImageWithFontTextStyle:UIFontTextStyleBody];
        }
    }];
    
    [mutableAttributedString removeFixedHeightStyles];
    
    if (isLeftCell || isBlocked)
    {
        messageTextView.linkTextAttributes = @{ NSForegroundColorAttributeName: self.legacyAppearanceProxy.linkTextColor,
                                                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
        
        mutableAttributedString = [mutableAttributedString updateAttributedStringByReplacingColor:StylesheetManager.S.ColorPalette.black withColor:self.legacyAppearanceProxy.chatMessageReceivedTextColor];
        
        if ([self.legacyAppearanceProxy isDarkTheme])
        {
            [mutableAttributedString enumerateAttribute:NSBackgroundColorAttributeName
                                                inRange:NSMakeRange(0, mutableAttributedString.length)
                                                options:kNilOptions
                                             usingBlock:^(UIColor *_Nullable value, NSRange range, BOOL * _Nonnull stop)
             {
                if ([value compareWithColor:TSColor.webYellow] || [value compareWithColor:TSPaletteDefault.sharedPalette.yellow] || [value compareWithColor:TSPaletteDark.sharedPalette.yellow])
                {
                    [mutableAttributedString enumerateAttribute:NSForegroundColorAttributeName
                                                        inRange:range
                                                        options:kNilOptions
                                                     usingBlock:^(UIColor *_Nullable value, NSRange range, BOOL * _Nonnull stop)
                     {
                        //checking for a constant color White, so using TSColor instead of TSTheme
                        if ([value compareWithColor:TSPaletteDark.whiteColor])
                        {
                            [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:self.legacyAppearanceProxy.chatMessageReceivedHighlightSearchResultColor range:range];
                        }
                    }];
                }
            }];
        }
    }
    else
    {
        mutableAttributedString = [mutableAttributedString updateAttributedStringByReplacingColor:StylesheetManager.S.ColorPalette.black withColor: messageFailed ? self.legacyAppearanceProxy.chatMessageFailedTextColor : self.legacyAppearanceProxy.chatMessageSentTextColor];
        
        // Color exceptions
        // Code text that has a light background highlight should be dark text in the Sent chat bubble
        [mutableAttributedString enumerateAttribute:NSBackgroundColorAttributeName
                                            inRange:NSMakeRange(0, mutableAttributedString.length)
                                            options:kNilOptions
                                         usingBlock:^(UIColor *_Nullable value, NSRange range, BOOL * _Nonnull stop)
         {
            if ([value compareWithColor:self.legacyAppearanceProxy.htmlBackgroundColor])
            {
                [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:self.legacyAppearanceProxy.chatMessageSentCodeColor range:range];
            }
            
            if ([value compareWithColor:TSColor.webYellow] || [value compareWithColor:TSPaletteDefault.sharedPalette.yellow] || [value compareWithColor:TSPaletteDark.sharedPalette.yellow])
            {
                [mutableAttributedString enumerateAttribute:NSForegroundColorAttributeName
                                                    inRange:range
                                                    options:kNilOptions
                                                 usingBlock:^(UIColor *_Nullable value, NSRange range, BOOL * _Nonnull stop)
                 {
                    //checking for a constant color White, so using TSColor instead of TSTheme
                    if ([value compareWithColor:TSPaletteDark.whiteColor])
                    {
                        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:self.legacyAppearanceProxy.chatMessageSentHighlightedTextColor range:range];
                    }
                }];
            }
        }];
        
        // Set link text colors differently depending on being part of a block quote
        // Remove foreground color from UITextView link attributes. Otherwise it overrides the colors in the attributted string (bugs 406493 and 409202)
        // Add underline so it is visible as a link (especially data-detected "links" like phone numbers)  Matches actual link appearance
        
        NSMutableDictionary *newTextViewLinkAttributes = messageTextView.linkTextAttributes.mutableCopy;
        if (newTextViewLinkAttributes)
        {
            [newTextViewLinkAttributes removeObjectForKey:NSForegroundColorAttributeName];
            newTextViewLinkAttributes[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
            messageTextView.linkTextAttributes = newTextViewLinkAttributes;
        }
        else
        {
            messageTextView.linkTextAttributes = @{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
        }
        
        [mutableAttributedString enumerateAttribute:NSLinkAttributeName
                                            inRange:NSMakeRange(0, mutableAttributedString.length)
                                            options:kNilOptions
                                         usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop)
         {
            if (value)
            {
                [mutableAttributedString removeAttribute:@"CTForegroundColorFromContext" range:range];
                BOOL hasBackgroundColor = [mutableAttributedString attribute:NSBackgroundColorAttributeName atIndex:range.location effectiveRange:nil] != nil;
                [mutableAttributedString addAttribute:NSForegroundColorAttributeName
                                                value:!hasBackgroundColor ? self.legacyAppearanceProxy.chatMessageSentTextColor : self.legacyAppearanceProxy.linkTextColor
                                                range:range];
            }
        }];
    }
    
    messageTextView.attributedText = mutableAttributedString;
    NSTextAlignment bestAlignment = [[mutableAttributedString accessibilityString:NO] bestTextAlignment];
    if (bestAlignment != messageTextView.textAlignment) {
        messageTextView.textAlignment = bestAlignment;
    }
}

- (UITextView *) addMessageTextView:(NSAttributedString *)textMessage
                             inCell:(TSChatMessageViewCell*)cell
                         isLeftCell:(BOOL)isLeftCell
                          isBlocked:(BOOL)isBlocked
              messageFailedToUpload:(BOOL)messageFailed
{
    UITextView *messageTextView = [[UITextView alloc] init];
    [messageTextView setScrollEnabled:NO];
    [messageTextView setEditable:NO];
    
    for (UIGestureRecognizer *recognizer in messageTextView.gestureRecognizers)
    {
        // removes the default gesture recognizers provided by UIKit
        [messageTextView removeGestureRecognizer:recognizer];
    }
    
    [self populateMessageTextView:messageTextView withAttributedString:[TSUtilities removeLastNewLine:textMessage] isLeftCell:isLeftCell isBlocked:isBlocked messageFailedToUpload:messageFailed];
    
    [cell.messageStackView addArrangedSubview:messageTextView];
    [messageTextView.leadingAnchor constraintEqualToAnchor:cell.messageStackView.leadingAnchor constant:0.0].active = YES;
    [messageTextView.trailingAnchor constraintEqualToAnchor:cell.messageStackView.trailingAnchor constant:0.0].active = YES;
    
    NSArray *elements = [self configureTextMessageView:messageTextView forCell:cell];
    
    if (elements.count > 0)
    {
        NSMutableArray *accessibilityElements = cell.accessibilityElements.mutableCopy;
        [accessibilityElements addObjectsFromArray:elements];
        cell.accessibilityElements = accessibilityElements;
    }
    
    return messageTextView;
}

- (void)handleMessageReply:(NSAttributedString *)attributedString
                 messageID:(NSNumber *)messageID
                    inCell:(TSChatMessageViewCell *)cell
                isLeftCell:(BOOL)isLeftCell
                 isBlocked:(BOOL)isBlocked
     messageFailedToUpload:(BOOL)messageFailed
{
    __block NSUInteger lastLocation = 0;
    
    // Desktop may be able to send multiple reply blocks in one message in the future.  Break into messageStackView
    [attributedString enumerateAttribute:NSAttachmentAttributeName
                                 inRange:NSMakeRange(0, attributedString.length)
                                 options:kNilOptions
                              usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop)
     {
        if ([value isKindOfClass:TSMessageReplyTextAttachment.class])
        {
            if (range.location > 0)
            {
                NSAttributedString *substring = [attributedString attributedSubstringFromRange:NSMakeRange(lastLocation, range.location - lastLocation)];
                substring = [substring trimWhiteSpace];
                
                UITextView *textView = [self addMessageTextView:substring
                                                         inCell:cell
                                                     isLeftCell:isLeftCell
                                                      isBlocked:isBlocked
                                          messageFailedToUpload:messageFailed];
                
                textView.textContainerInset = UIEdgeInsetsMake(TSkMessageReplyTextViewVerticalInset, TSkMessageReplyTextViewHorizontalInset,
                                                               TSkMessageReplyTextViewVerticalInset, TSkMessageReplyTextViewHorizontalInset);
            }
            
            TSMessageReplyTextAttachment *attachment = value;
            TSMessageReplyViewModel *vm = [[TSMessageReplyViewModel alloc] initWithMessageReplyTextAttachment:attachment
                                                                                                     threadID:self.threadID];
            TSMessageReplyView *view = [TSMessageReplyView viewWithViewModel:vm composeDelegate:nil];
            view.legacyAppearanceProxy = self.legacyAppearanceProxy;
            
            [cell.messageStackView addArrangedSubview:view];
            [view.leadingAnchor constraintEqualToAnchor:cell.messageStackView.leadingAnchor].active = YES;
            [view.trailingAnchor constraintEqualToAnchor:cell.messageStackView.trailingAnchor].active = YES;
            
            cell.accessibilityElements = [cell.accessibilityElements arrayByAddingObject:view];
            
            lastLocation = range.location + range.length;
        }
    }];
    
    if (lastLocation < attributedString.length)
    {
        NSAttributedString *substring = [attributedString attributedSubstringFromRange:NSMakeRange(lastLocation, attributedString.length - lastLocation)];
        substring = [substring trimWhiteSpace];
        
        UITextView *textView = [self addMessageTextView:substring
                                                 inCell:cell
                                             isLeftCell:isLeftCell
                                              isBlocked:isBlocked
                                  messageFailedToUpload:messageFailed];
        
        textView.textContainerInset = UIEdgeInsetsMake(TSkMessageReplyTextViewVerticalInset, TSkMessageReplyTextViewHorizontalInset,
                                                       TSkMessageReplyTextViewVerticalInset, TSkMessageReplyTextViewHorizontalInset);
    }
}


- (void) buildComposeExtensionForLocalMsg:(NSAttributedString *)attributedString
                                     cell:(TSChatMessageViewCell *)cell
                               isLeftCell:(BOOL)isLeftCell
                                  message:(TSMessageInfo *)message
                     shouldShowSenderName:(BOOL)shouldShowSenderName
{
    // Now Compose Extensions can contain text as well
    // So if it does we should render the cell text view as well
    NSArray *botAttachments = [TSTextAttachmentFormatter botAttachments:attributedString];
    for (NSDictionary *botAttachmentDict in botAttachments)
    {
        NSRange range = [[botAttachmentDict valueForKey:@"range"] rangeValue];
        if (range.length > 0)
        {
            NSAttributedString *textMessage = [attributedString attributedSubstringFromRange:range];
            textMessage = [textMessage trimWhiteSpace];
            
            if ([textMessage.string isNotNilOrEmpty])
            {
                if ([message.attachmentClasses containsObject:TSMessageReplyTextAttachment.class])
                {
                    [self handleMessageReply:textMessage
                                   messageID:message.tsID
                                      inCell:cell
                                  isLeftCell:isLeftCell
                                   isBlocked:(message.policyViolationMessageState.integerValue == TSDLPStateBlocked ||
                                              message.policyViolationMessageState.integerValue == TSDLPStateWarning)
                       messageFailedToUpload:message.uploadDidTimeout];
                }
                else
                {
                    [self addMessageTextView:textMessage
                                      inCell:cell
                                  isLeftCell:isLeftCell
                                   isBlocked:(message.policyViolationMessageState.integerValue == TSDLPStateBlocked ||
                                              message.policyViolationMessageState.integerValue == TSDLPStateWarning)
                       messageFailedToUpload:message.uploadDidTimeout];
                }
                break;
            }
        }
    }
    
    // Now as we support multiple cards in single message we should iterate through all cards
    for (id cardInfo in [TSUtilities unarchiveBotCards:message.ts_botCardData])
    {
        if (([cardInfo isKindOfClass:TSCAdaptiveCard.class] || [cardInfo isKindOfClass:TSBotCard.class])
            || ([cardInfo isKindOfClass:TSAudioCard.class] && [self.accountHandle.ecsManager isAudioMessagesEnabled]))
        {
            TSBotCard *botCardInfo = (TSBotCard *)cardInfo;
            
            [self buildComposeExtensionsInternal:cell
                               withMessageEntity:nil
                                     withMessage:message
                              withMessageContent:attributedString
                               andBotAttachments:nil
                                        cardInfo:botCardInfo
                                      isLeftCell:isLeftCell
                            shouldShowSenderName:shouldShowSenderName];
        }
    }
}

- (void) buildComposeExtensions:(TSChatMessageViewCell*)cell
              withMessageEntity:(TSSMessage *)messageEntity
                    withMessage:(TSMessageInfo *)message
             withMessageContent:(NSAttributedString*)attributedString
                     isLeftCell:(BOOL)isLeftCell
           shouldShowSenderName:(BOOL)shouldShowSenderName
{
    [cell cleanupComposeExtensionsView];
    
    // Allows rendering of share location card in offline/sending state
    if (message.isLocal.boolValue)
    {
        [self buildComposeExtensionForLocalMsg:attributedString cell:cell isLeftCell:isLeftCell message:message shouldShowSenderName: shouldShowSenderName];
        return;
    }
    
    NSArray *botAttachments = [TSTextAttachmentFormatter botAttachments:attributedString];
    for (NSDictionary *botAttachmentDict in botAttachments)
    {
        NSRange range = [[botAttachmentDict valueForKey:@"range"] rangeValue];
        if (range.length > 0)
        {
            NSAttributedString *textMessage = [attributedString attributedSubstringFromRange:range];
            // Praise has a new line before the mentions , Hence remove the same if it exists
            textMessage = [[TSUtilities removeFirstNewLine:textMessage] trimWhiteSpace];
            if ([textMessage.string isNotNilOrEmpty])
            {
                if ([message.attachmentClasses containsObject:TSMessageReplyTextAttachment.class])
                {
                    [self handleMessageReply:textMessage
                                   messageID:message.tsID
                                      inCell:cell
                                  isLeftCell:isLeftCell
                                   isBlocked:(message.policyViolationMessageState.integerValue == TSDLPStateBlocked ||
                                              message.policyViolationMessageState.integerValue == TSDLPStateWarning)
                       messageFailedToUpload:message.uploadDidTimeout];
                }
                else if ([self isMessageInfoForMeetingChiclet:message])
                {
                    [self buildComposeExtensionsInternal:cell
                                       withMessageEntity:messageEntity
                                             withMessage:message
                                      withMessageContent:attributedString
                                       andBotAttachments:nil
                                                cardInfo:nil
                                              isLeftCell:isLeftCell
                                    shouldShowSenderName:shouldShowSenderName];
                }
                else
                {
                    [self addMessageTextView:textMessage
                                      inCell:cell
                                  isLeftCell:isLeftCell
                                   isBlocked:(message.policyViolationMessageState.integerValue == TSDLPStateBlocked ||
                                              message.policyViolationMessageState.integerValue == TSDLPStateWarning)
                       messageFailedToUpload:message.uploadDidTimeout];
                }
            }
        }
        
        TSBotTextAttachment *botAttachment = [botAttachmentDict valueForKey:@"attachment"];
        if (botAttachment)
        {
            NSArray *botCards = [TSUtilities unarchiveBotCards:message.ts_botCardData];
            for (id cardInfo in botCards)
            {
                if ([[botAttachment cardID] isEqualToString:[cardInfo cardClientId]])
                {
                    [self buildComposeExtensionsInternal:cell
                                       withMessageEntity:messageEntity
                                             withMessage:message
                                      withMessageContent:attributedString
                                       andBotAttachments:botAttachment
                                                cardInfo:cardInfo
                                              isLeftCell:isLeftCell
                                    shouldShowSenderName:shouldShowSenderName];
                }
            }
        }
    }
}

- (void) buildComposeExtensionsInternal:(TSChatMessageViewCell*)cell
                      withMessageEntity:(TSSMessage *)messageEntity
                            withMessage:(TSMessageInfo *)message
                     withMessageContent:(NSAttributedString*)attributedString
                      andBotAttachments:(TSBotTextAttachment *)botAttachment
                               cardInfo:(id)cardInfo
                             isLeftCell:(BOOL)isLeftCell
                   shouldShowSenderName:(BOOL)shouldShowSenderName
{
    NSMutableDictionary *buttonActionParams = [[NSMutableDictionary alloc] initWithDictionary:[message buildButtonActionParamsForChat:YES]];
    CGFloat widthOfCell = [self computeWidthOfCardView];
    
    id botCardModel = nil;
    TSBBackwardCompatibleCardsGenerator *backwardCompatibleCardsGenerator = [[TSBBackwardCompatibleCardsGenerator alloc] init];
    TSSMessage* msg = [AXPCtx messageForID:message.tsID andThreadID:message.threadID];
    if([backwardCompatibleCardsGenerator shouldRenderBotCardAsAdaptiveCardOrConnectorCard:msg])
    {
        botCardModel = [backwardCompatibleCardsGenerator getBotCardFromMessage:msg withCardClientID:[botAttachment cardID]];
    }
    UIView *botCardView = nil;
    NSString *appId = nil;
    NSString *contentType = nil;
    BOOL useDefaultBackground = YES;
    NSDictionary *adaptiveCardInfo = nil;
    
    if ([cardInfo isKindOfClass:TSBotCard.class] && !botCardModel)
    {
        TSBotCard *botCardInfo = (TSBotCard *)cardInfo;
        appId = botCardInfo.appId;
        contentType = botCardInfo.contentType;
        
        if ([botCardInfo.contentType compareString:TSBotCardContentTypeCodeSnippet])
        {
            // clear background for all extensions.
            if ([TSAccountManager.activeConfigHandle.ecsManager chatContentBackgroundEnabledOnECS] &&
                [TSTextAttachmentFormatter botAttachments:attributedString].count == attributedString.string.removeNewlines.length)
            {
                [cell setClearBubbleColor:NO];
            }
            
            TSMessageAttachmentView *codeSnippetView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass(TSMessageAttachmentView.class)
                                                                                                       owner:nil
                                                                                                     options:nil] firstObject];
            codeSnippetView.legacyAppearanceProxy = self.legacyAppearanceProxy;
            TSCodeSnippet *codeSnippet = ([botCardInfo isKindOfClass:TSCodeSnippet.class] ? (TSCodeSnippet *)botCardInfo : [TSCodeSnippet initWithDictionary:nil accountHandle:self.accountHandle]);
            
            MessageAttachmentViewModel *viewModel = [[MessageAttachmentViewModel alloc] initWithAccountHandle:self.accountHandle
                                                                                                  codeSnippet:codeSnippet];
            [codeSnippetView setUpWithViewModel:viewModel
                                backgroundColor:(isLeftCell ? self.legacyAppearanceProxy.chatMessageReceivedCodeSnippetBackgroundColor : self.legacyAppearanceProxy.chatMessageSentCodeSnippetBackgroundColor)
                                 viewController:(UIViewController *)self];
            botCardView = codeSnippetView;
        }
        else if([botCardInfo.contentType compareString:TSBotCardContentTypeAudioCard])
        {
            TSAudioCard *audioCard = (TSAudioCard *)botCardInfo;
            audioCard.accountHandle = self.accountHandle;
            NSString *audioId = NSUUID.UUID.UUIDString;
            audioCard.audioId = audioId;
            TSAudioAttachmentView *audioView = [TSAudioAttachmentView loadInstanceFromXIBWithAudioId:audioId panelInfo:self.currentPanelInfo];
            audioView.legacyAppearanceProxy = self.legacyAppearanceProxy;
            [audioView configureWithAudioCard:audioCard forMessage:message.tsID withViewController:self];
            [audioView hideDeleteButton:YES];
            
            // clear background for all extensions.
            if ([TSAccountManager.activeConfigHandle.ecsManager chatContentBackgroundEnabledOnECS] &&
                [TSTextAttachmentFormatter botAttachments:attributedString].count == attributedString.string.removeNewlines.length)
            {
                [cell setClearBubbleColor:NO];
                [audioView setCornerRadius:TSkLargeCornerRadius];
            }
            
            botCardView = audioView;
        }
        else
        {
            botCardView = [self configureBotCard:botCardInfo
                                       withWidth:widthOfCell
                                     messageInfo:message
                              buttonActionParams:buttonActionParams];
        }
        
        if (botCardView)
        {
            botCardInfo.isMessagingExtension = YES;
            [self configureDetailedBotCard:botCardInfo
                                  cardView:botCardView
                               messageInfo:message
                                    cellID:cell.uniqueId];
            
            [self.adaptiveCardsUtility addBorderAroundAdaptiveCardsView:botCardView];
        }
    }
    else if (self.accountHandle.policyManager.isTasksAdaptiveCardEnabled && [cardInfo isKindOfClass:TSCAdaptiveCard.class] && [message.contentItemId compareString:TSkShareTasksCardClientID] && [((TSCAdaptiveCard *) cardInfo) tasksItemData])
    {
        if (self.tasksCoordinator == nil)
        {
            self.tasksCoordinator = [[TSMessageTasksItemCoordinatorBridge alloc] initWithManageViewController:self accountHandle:self.accountHandle];
            [self.tasksCoordinator start];
        }
        
        TSTasksItemCardData *tasksItemData = [((TSCAdaptiveCard *) cardInfo) tasksItemData];
        
        MessageTasksItemCardConfig *config = [[MessageTasksItemCardConfig alloc] initWithTaskListScopeId:tasksItemData.taskListScopeId taskListTitle:tasksItemData.taskListTitle taskListId:tasksItemData.taskListId taskItems:tasksItemData.taskItems taskListSendingState:tasksItemData.taskListSendingState customImageUrl:tasksItemData.customImageUrl tapActionEnabled:self.accountHandle.policyManager.isTasksAdaptiveCardClickable];
        UIView *cardView = [self.tasksCoordinator itemCardViewWithIdentifier:message.tsID.stringValue config:config];
        botCardView = cardView;
        useDefaultBackground = NO;
    }
    else if ([cardInfo isKindOfClass:TSCAdaptiveCard.class] && [message.contentItemId compareString:TSkShareVaultCardClientID] && [((TSCAdaptiveCard *) cardInfo) vaultItemData])
    {
        if (self.vaultCoordinator == nil)
        {
            TSThread *thread = [AXPCtx threadForID:self.threadID];
            InstrumentationThreadProperties *threadProperties = [[InstrumentationThreadProperties alloc] initWithThreadId:self.threadID
                                                                                                               threadType:self.biThreadType
                                                                                                              threadTitle:self.title
                                                                                                            threadMembers:[NSNumber numberWithInteger:thread.memberCount]
                                                                                                                 chatType:self.biChatType];
            
            self.vaultCoordinator = [[TSMessageVaultItemCoordinatorBridge alloc] initWithAccountHandle:self.accountHandle
                                                                                  manageViewController:self
                                                                                      threadProperties:threadProperties];
            [self.vaultCoordinator start];
        }
        
        TSVaultItemCardData *vaultItemData = [((TSCAdaptiveCard *) cardInfo) vaultItemData];
        
        MessageVaultItemCardConfig *config = [[MessageVaultItemCardConfig alloc] initWithScopeId:vaultItemData.scopeId
                                                                                        secretId:vaultItemData.secretId
                                                                                     secretTitle:vaultItemData.secretTitle
                                                                                  secretCategory:vaultItemData.secretCategory
                                                                                   secretIconUrl:vaultItemData.secretIconUrl
                                                                                        sentByMe:message.isSentByMe.boolValue
                                                                                tapActionEnabled:self.accountHandle.policyManager.isChatVaultEnabled];
        UIView *cardView = [self.vaultCoordinator itemCardViewWithIdentifier:message.tsID.stringValue config:config];
        botCardView = cardView;
        useDefaultBackground = NO;
    }
    else if ([cardInfo isKindOfClass:TSCAdaptiveCard.class] && [message.contentItemId compareString:TSkVaultAccessCardClientID] && [((TSCAdaptiveCard *) cardInfo) vaultAccessData])
    {
        if (self.vaultCoordinator == nil)
        {
            TSThread *thread = [AXPCtx threadForID:self.threadID];
            InstrumentationThreadProperties *threadProperties = [[InstrumentationThreadProperties alloc] initWithThreadId:self.threadID
                                                                                                               threadType:self.biThreadType
                                                                                                              threadTitle:self.title
                                                                                                            threadMembers:[NSNumber numberWithInteger:thread.memberCount]
                                                                                                                 chatType:self.biChatType];
            
            self.vaultCoordinator = [[TSMessageVaultItemCoordinatorBridge alloc] initWithAccountHandle:self.accountHandle
                                                                                  manageViewController:self
                                                                                      threadProperties:threadProperties];
            [self.vaultCoordinator start];
        }
        
        TSVaultAccessCardData *data = [((TSCAdaptiveCard *) cardInfo) vaultAccessData];
        
        BOOL wasGrantedAccess = messageEntity.ts_messageSubType.intValue == TSkMessageSubTypeGrantedVaultAccess;
        BOOL isRequestCardType = data.cardType.intValue == VaultAccessCardTypeRequest;
        
        MessageVaultAccessCardConfig *config = [[MessageVaultAccessCardConfig alloc] initWithCardType:data.cardType.intValue
                                                                                              scopeId:self.threadID
                                                                                         userObjectId:data.userObjectId
                                                                                      userDisplayName:data.userDisplayName
                                                                                              message:data.message
                                                                                             sentByMe:message.isSentByMe.boolValue
                                                                                     wasGrantedAccess:wasGrantedAccess
                                                                                     tapActionEnabled:self.accountHandle.policyManager.isChatVaultEnabled];
        UIView *cardView = [self.vaultCoordinator accessCardViewWithIdentifier:message.tsID.stringValue config:config];
        botCardView = cardView;
        useDefaultBackground = NO;
        
        NSManagedObjectContext *moc = messageEntity.managedObjectContext ?: self.accountHandle.mainMOC;
        
        NSArray *messages = nil;
        if (isRequestCardType)
        {
            if (wasGrantedAccess == NO && messageEntity != nil)
            {
                messages = @[messageEntity];
            }
        }
        else
        {
            messages = [AXPCtx allRequestVaultAccessMessages:self.threadID inManagedObjectContext:moc];
        }
        
        for (TSSMessage *message in messages)
        {
            [self updateVaultAccessCard:message inManagedObjectContext:moc];
        }
    }
    else if (self.accountHandle.policyManager.isLocationWithLiveSharingEnabled && [cardInfo isKindOfClass:TSCAdaptiveCard.class] && [message.contentItemId compareString:TSkShareLocationCardClientID] && [((TSCAdaptiveCard *) cardInfo) liveLocationData])
    {
        if (self.liveLocationCoordinator == nil)
        {
            id<LocationDependencyRegistrarProtocol> locationDependencyRegistrar = ResolveOptionalProtocol(LocationDependencyRegistrarProtocol);
            self.liveLocationCoordinator = [[locationDependencyRegistrar userDependenciesWithAccountHandle:self.accountHandle]
                                            makeMessageLocationLiveCoordinatorBridgeWithThreadId:self.threadID
                                            fromViewController:self];
            [self.liveLocationCoordinator start];
        }
        
        TSLiveLocationCardData *liveLocationData = [((TSCAdaptiveCard *) cardInfo) liveLocationData];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(liveLocationData.latitude.doubleValue, liveLocationData.longitude.doubleValue);
        MessageLocationLiveCardConfig *config = [[MessageLocationLiveCardConfig alloc] initWithSessionId:liveLocationData.sessionId
                                                                                                deviceId:liveLocationData.deviceId
                                                                                                  userId:message.userID
                                                                                         userDisplayName:message.userName
                                                                                              coordinate:coordinate
                                                                                                sendDate:message.arrivalTime
                                                                                       rawExpirationDate:liveLocationData.expirationDate
                                                                                                isActive:liveLocationData.isLiveLocation];
        
        UIView *cardView = [self.liveLocationCoordinator cardViewWithIdentifier:message.tsID.stringValue config:config];
        botCardView = cardView;
        useDefaultBackground = NO;
    }
    else if (self.accountHandle.policyManager.isLocationWithLiveSharingEnabled && [cardInfo isKindOfClass:TSCAdaptiveCard.class] && [message.contentItemId compareString:TSkShareLocationCardClientID] && [((TSCAdaptiveCard *) cardInfo) staticLocationData])
    {
        if (self.staticLocationCoordinator == nil)
        {
            id<LocationDependencyRegistrarProtocol> locationDependencyRegistrar = ResolveOptionalProtocol(LocationDependencyRegistrarProtocol);
            self.staticLocationCoordinator = [[locationDependencyRegistrar userDependenciesWithAccountHandle:self.accountHandle] makeMessageStaticLocationCoordinatorBridgeWithThreadId:self.threadID fromViewController:self];
            [self.staticLocationCoordinator start];
        }
        TSLiveLocationCardData *staticLocationData = [((TSCAdaptiveCard *) cardInfo) placeLocationData] ?: [((TSCAdaptiveCard *) cardInfo) staticLocationData];
        UIView *cardView = [self.staticLocationCoordinator cardViewWithIdentifier:message.tsID.stringValue
                                                                         latitude:staticLocationData.latitude.doubleValue
                                                                        longitude:staticLocationData.longitude.doubleValue
                                                                            title:staticLocationData.title
                                                                          address:staticLocationData.address
                                                                          placeId:staticLocationData.placeId];
        botCardView = cardView;
        useDefaultBackground = NO;
    }
    else if ([cardInfo isKindOfClass:TSCAdaptiveCard.class]
             || [cardInfo isKindOfClass:TSConnectorCard.class]
             || botCardModel)
    {
        TSSMessage* msg = [AXPCtx messageForID:message.tsID andThreadID:message.threadID];
        
        if (!msg)
        {
            // fix for situations where the msg instance got updated with server tsID, hence we don't find the msg.
            msg =  [TSSMessage messageWithClientID:message.clientID
                                            fromID:self.accountHandle.MRI
                                          threadID:message.threadID
                            inManagedObjectContext:self.accountHandle.mainMOC];
        }
        
        if (msg)
        {
            NSNumber *msgID = msg.tsID.copy;
            NSNumber *editTime = msg.editTime.copy;
            NSDate *arrivalTime = msg.arrivalTime.copy;
            NSMutableString *key = [[self.adaptiveCardsUtility createKeyFromMessageID:msgID andTimeStamp:arrivalTime] mutableCopy];
            NSDictionary *itemData = [self dataForRowAtIndexPath:cell.indexPath inTableView:self.tableView];
            TSBotExecuteActionResponseHandler *executeActionResponse = itemData[TSkCardActionInvokeResponse];
            if ( [cardInfo respondsToSelector:@selector(cardClientId)])
            {
                [itemData setValue:[cardInfo cardClientId] forKey:TSkCardClientId];
                [key appendString: [cardInfo cardClientId]];
            }
            
            if(executeActionResponse)
            {
                [self.adaptiveCardsCache removeACRViewFromCacheWithKey:key];
            }
            
            id finalCardInfo = botCardModel ?: cardInfo;
            if ([finalCardInfo isKindOfClass:[TSCAdaptiveCard class]])
            {
                appId = [((TSCAdaptiveCard *)finalCardInfo).appId copy];
                contentType = TSBotCardContentTypeAdaptive;
            }
            else if([finalCardInfo isKindOfClass:[TSConnectorCard class]])
            {
                appId = [((TSConnectorCard *)finalCardInfo).appId copy];
                contentType = TSBotCardContentTypeConnector;
            }
            
            ACRView *acrView = [self.adaptiveCardsCache getAdaptiveCardsView:key];
            TSCAdaptiveCardsActionHandler *cardActionHandler = nil;
            
            if (acrView && round(acrView.bounds.size.width) != round(widthOfCell))
            {
                // Wrong width for the view. iPad rotated, etc.
                acrView = nil;
            }
            
            if (acrView)
            {
                cardActionHandler = [self.adaptiveCardsCache getAdaptiveCardsDelegateAndDeleteIfEditedWithKey:key
                                                                                             withLastEditTime:editTime
                                                                                                accountHandle:self.accountHandle];
                if (cardActionHandler)
                {
                    cardActionHandler.indexPath = cell.indexPath;
                }
                else
                {
                    acrView = nil;
                }
            }
            if (!acrView)
            {
                cardActionHandler = [[TSCAdaptiveCardsActionHandler alloc] init];
                cardActionHandler.threadID = self.threadID;
                cardActionHandler.messageID = msg.ts_rootMessageID.stringValue;
                cardActionHandler.messageVersion = msg.version.copy;
                cardActionHandler.indexPath = cell.indexPath;
                cardActionHandler.lastEditTime = editTime;
                cardActionHandler.actionHandlerDelegate = (id<TSCAdaptiveCardsActionProtocol>)self;
                
                /// this code is called when the card to be displayed is messageExtension
                cardActionHandler.isMessagingExtension = YES;
                cardActionHandler.panelType = TSkScenarioChat;
                cardActionHandler.cacheKey = key;
                
                cardActionHandler.botID = [AXPCtx botIdForAppID:appId inMoc:self.accountHandle.mainMOC] ?: msg.from.copy;
                cardActionHandler.executeActionResponse = executeActionResponse;
                cardActionHandler.memberCount = self.thread ? (self.thread.memberCount - self.thread.botCount) : 0;
                cardActionHandler.isBotOnlyOneOnOneChat = [self isPrivateChatWithBot];
                
                acrView = [self.adaptiveCardsUtility createAdaptiveCardViewFromBotCard:finalCardInfo
                                                                           withHandler:cardActionHandler
                                                                         withCardWidth:widthOfCell
                                                                         withCardIndex:0
                                                                        forMessageInfo:message];
                
                [self.adaptiveCardsCache addACRViewToCache:acrView withACRViewDelegate:cardActionHandler andKey:key];
                __weak typeof(self) weakSelf = self;
                [self.adaptiveCardsUtility setGestureDelegate:weakSelf forAdaptiveCardView:acrView];
                adaptiveCardInfo = [self.adaptiveCardsUtility getAdaptiveCardInfoForCardView:acrView withActionHandler:cardActionHandler];
                [self handleExecuteResponse:cardActionHandler
                               withCardView:acrView
                                messageInfo:message
                              executeAction:executeActionResponse];
            }
            
            botCardView = [self.adaptiveCardsUtility addBorderAroundAdaptiveCardsView:acrView];
            cell.adaptiveCardsActionHandler = cardActionHandler;
        }
    }
    else if ([self isMessageInfoForMeetingChiclet:message])
    {
        BOOL isSMBMessage = [self isSMBMessage];
        
        TSChatBubbleMeetingCardView *chatBubbleMeetingCardView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass(TSChatBubbleMeetingCardView.class) owner:nil options:nil] firstObject];
        chatBubbleMeetingCardView.legacyAppearanceProxy = self.legacyAppearanceProxy;
        
        NSArray <TSThreadProperty *> *tp = [TSThreadProperty threadPropertiesForThreadID:message.threadID andPropertyType:TSThreadPropertyTypeMeeting inManagedObjectContext:self.accountHandle.mainMOC];
        
        TSWeakify(self);
        BOOL isCalendarActionEnabled = NO;
        if (isLeftCell)
        {
            isCalendarActionEnabled = isSMBMessage && [self.accountHandle.policyManager isAddToCalendarActionEnabled];
        }
        
        [self.meetingChickletHelper configureChatBubbleMeetingCardView:chatBubbleMeetingCardView
                                                     withMessageEntity:messageEntity
                                                       withMessageInfo:message
                                               isCalendarActionEnabled:isCalendarActionEnabled
                                                  withThreadProperties:[tp firstObject]
                                                        withTapHandler:^{
            TSStrongifyAndReturnIfNil(self);
            /// We don't support tapping on meeting chiclet for SMB messages
            if (isSMBMessage)
            {
                return;
            }
            [self onMeetingChickletTapped:message];
        }
                                                  withButtonTapHandler:^(TSMeetingInviteBlock *inviteInfo, BOOL isUpdateCalendar) {
            TSStrongifyAndReturnIfNil(self);
            [self onCalendarActionTapped:inviteInfo meetingCardView:chatBubbleMeetingCardView isUpdateCalendar:isUpdateCalendar];
        }
                                                   withSetTitleHandler:^(NSString *title) {
            TSStrongifyAndReturnIfNil(self);
            [self addInviteLabelInChiclet:cell isRightCell:!isLeftCell labelText:title];
        }];
        botCardView = chatBubbleMeetingCardView;
    }
    
    if (botCardView)
    {
        if (useDefaultBackground)
        {
            botCardView.backgroundColor = self.legacyAppearanceProxy.adaptiveCardContentViewDefaultBackgroundColor;
        }
        
        /// In case of bot cards we want the message bubble padding same for all card types
        botCardView.clipsToBounds = YES;
        [cell.messageStackView addArrangedSubview:botCardView];
        cell.messageStackViewWidthConstraint.constant = widthOfCell;
        cell.messageStackViewWidthConstraint.active = YES;
        
        if ([TSTextAttachmentFormatter hasOnlyBotAttachments:attributedString] &&
            [TSAccountManager.activeConfigHandle.ecsManager chatContentBackgroundEnabledOnECS])
        {
            [cell setClearBubbleColor:NO];
        }
        
        NSMutableArray *accessibilityElements = cell.accessibilityElements.mutableCopy;
        [accessibilityElements addObject:botCardView];
        cell.accessibilityElements = accessibilityElements;
        
        if (!appId)
        {
            appId = ((TSBotCard *)cardInfo).appId;
        }
        [self logTelemetryForViewCard:appId cardType:contentType withCardInfo:adaptiveCardInfo messageId:message.tsID];
    }
}

-(void)addInviteLabelInChiclet:(TSChatMessageViewCell *)cell isRightCell:(BOOL)isRightCell labelText:(NSString *)labelText
{
    UILabel *inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.width, cell.height)];
    if(isRightCell)
    {
        inviteLabel.textColor = self.legacyAppearanceProxy.chatMessageSentTextColor;
    }
    inviteLabel.text = labelText;
    [cell.messageStackView addArrangedSubview:inviteLabel];
}

- (void)updateVaultAccessCard:(TSSMessage *)message inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSIndexPath *indexPath = self.itemLookupMap[message.tsID];
    if (indexPath == nil)
    {
        return;
    }
    
    TSMessageInfo *messageInfo = [self dataAtIndexPath:indexPath];
    NSArray *cards = [TSUtilities unarchiveBotCards:messageInfo.ts_botCardData];
    if (cards.count != 1)
    {
        return;
    }
    
    TSCAdaptiveCard *cardInfo = cards.firstObject;
    TSVaultAccessCardData *data = [((TSCAdaptiveCard *) cardInfo) vaultAccessData];
    
    if (data == nil)
    {
        return;
    }
    
    NSString *userID = data.userObjectId;
    __block NSNumber *messageID = message.tsID;
    
    [self.vaultCoordinator userNeedsAccessWithUserId:userID threadId:self.threadID completion:^(BOOL result) {
        if (result == NO)
        {
            DbReadWrite(SELECTOR_NAME(self), moc, ^ {
                TSSMessage *msg = [TSSMessage messageForID:messageID andThreadID:self.threadID inManagedObjectContext:moc];
                if (msg.ts_messageSubType.intValue != TSkMessageSubTypeGrantedVaultAccess)
                {
                    msg.ts_messageSubType = [NSNumber numberWithInt:TSkMessageSubTypeGrantedVaultAccess];
                    LogInfoAH(self.logger, @"Marking request from userId %@ to access vault as granted", userID);
                    
                    NSError *error = nil;
                    if (![self.accountHandle saveMocByResolvingConstraints:moc error:&error])
                    {
                        LogErrorAH(self.accountHandle.logger, @"Failed to save Message. Error:%@", error);
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        NSIndexPath *indexPath = self.itemLookupMap[messageID];
                        if (indexPath && [[self.tableView indexPathsForVisibleRows] containsObject:indexPath])
                        {
                            [self.tableView beginUpdates];
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            [self.tableView endUpdates];
                        }
                    });
                }
            });
        }
    }];
}

- (NSArray<NSIndexPath *> *)specialReloadIndexPaths
{
    NSIndexPath *lastSentIndexPath = nil;
    NSIndexPath *lastSeenIndexPath = nil;
    
    // Compute the indexPath for the cells that were showing seen or sent icons -- they should be refreshed as a special case
    [self computeIndexPathForLastSeen:&lastSeenIndexPath andForLastSentMsg:&lastSentIndexPath];
    
    NSMutableArray *results = [NSMutableArray new];
    [results addObjectIfNotNil:lastSentIndexPath];
    [results addObjectIfNotNil:lastSeenIndexPath];
    return results;
}

- (TSAudioAttachmentView *) getAudioAttachmentViewByCell:(TSChatMessageViewCell *)cell
{
    TSAudioAttachmentView *audioAttachment;
    if (![cell.messageStackView isHidden])
    {
        for (UIView *subview in cell.messageStackView.subviews)
        {
            if ([subview isKindOfClass:TSAudioAttachmentView.class])
            {
                audioAttachment = (TSAudioAttachmentView *)subview;
                break;
            }
        }
    }
    return audioAttachment;
}

- (NSMutableAttributedString*)replaceGifWithURLIfNeeded:(TSMessageInfo *)messageInfo
{
    NSMutableAttributedString *messageContent = messageInfo.attributedContent.mutableCopy;
    
    // In some regions/countries accepting terms is not allowed under age of consent, if that is the case we show the full url.
    // The user will see the gif as a hyperlink, tapping on it will open the external browser
    if ([self.accountHandle isUserAllowedToAcceptTerms] == NO)
    {
        if ([messageInfo.attachmentClasses containsObject:TSAnimatedTextAttachment.class] && messageInfo.attachmentClasses.count == 1)
        {
            [messageContent enumerateAttribute:NSAttachmentAttributeName
                                       inRange:NSMakeRange(0, messageContent.length)
                                       options:kNilOptions
                                    usingBlock:^(id _Nullable value, NSRange range, BOOL * _Nonnull stop)
             {
                if(([value isKindOfClass:[AXPTextAttachment class]]))
                {
                    AXPTextAttachment *imageAXPAttachment = (AXPTextAttachment*)value;
                    NSString *src = imageAXPAttachment.imageSrcUrl.absoluteString;
                    NSURL *url = [[NSURL alloc] initWithString:src];
                    if ([TSUtilities isGifProviderURL:url accountHandle:self.accountHandle])
                    {
                        [messageContent replaceCharactersInRange:range withString:src];
                    }
                }
            }];
        }
    }
    
    return messageContent;
}

- (void)configureCell:(TSChatMessageViewCell*)cell
          atIndexPath:(NSIndexPath*)indexPath
      withMessageInfo:(TSMessageInfo *)messageInfo
{
    cell.legacyAppearanceProxy = self.legacyAppearanceProxy;
    NSString *userID = messageInfo.userID;
    NSString *displayName = messageInfo.userName;
    TSUserInfo *person = [self userInfoForID:messageInfo.userID];
    
    cell.messageActionDelegate = (id<TSMessageActionDelegate, TSReactionDelegate>)self.contextOptionsHandler;
    
    if ([NSString isNilOrEmpty:displayName])
    {
        displayName = [person displayNameWithAdditionalInfo];
    }
    
    if ([displayName compareString:AXPLocalizedString(@"UnknownUser")] && [messageInfo.userName isNotNilOrEmpty])
    {
        // Use imdisplayname only as a workaround
        displayName = messageInfo.userName;
    }
    
    BOOL isLeftCell = YES;
    if (messageInfo.isLocal.boolValue || [self.accountHandle.MRI compareString:userID])
    {
        isLeftCell = NO;
        if([messageInfo.deliveryState isNotNilOrEmpty])
        {
            cell.deliveryStateLabel.hidden = NO;
            cell.deliveryStateLabel.font = [TSFont preferredFontForTextStyle:UIFontTextStyleFootnote ofType:TSkFontTypeItalic];
            if ([messageInfo.deliveryState compareString:TSkMessageDeliveryStateDeclinedCodeOne] ||
                [messageInfo.deliveryState compareString:TSkMessageDeliveryStateDeclinedCodeTwo] ||
                [messageInfo.deliveryState compareString:TSkMessageDeliveryStateDeclinedCodeThree])
            {
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MessageDeliveryStateDeclinedText");
            }
            else if ([messageInfo.deliveryState compareString:TSkMessageDeliveryStateDoNotDisturbCodeOne] ||
                     [messageInfo.deliveryState compareString:TSkMessageDeliveryStateDoNotDisturbCodeTwo])
            {
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MessageDeliveryStateDoNotDisturbText");
            }
            else if ([messageInfo.deliveryState compareString:TSkMessageDeliveryStateUnavailableOne] ||
                     [messageInfo.deliveryState compareString:TSkMessageDeliveryStateUnavailableTwo] ||
                     [messageInfo.deliveryState compareString:TSkMessageDeliveryStateUnavailableThree])
            {
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MessageDeliveryStateUnavailableText");
            }
            else if ([messageInfo.deliveryState compareString:TSkMessageDeliveryStateNotSupported])
            {
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MessageDeliveryStateNotSupportedText");
            }
            else if ([messageInfo.deliveryState compareString:TSkMessageDeliveryStateTenantNotSupportInterop])
            {
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MessageDeliveryStateTenantNotSupportInteropText");
            }
            else if ([messageInfo.deliveryState compareString:TSkMessageDeliveryStateNonePreferredEndpoint])
            {
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MessageDeliveryStateNonePreferredEndpointText");
            }
            else if ([messageInfo.deliveryState compareString:TSkMessageDeliveryStateUserNotFoundInBVD])
            {
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MessageDeliveryStateUserNotFoundInBvdText");
            }
            else if ([self.messageDeliveryStateErrorCodesSendFailed containsObject:messageInfo.deliveryState])
            {
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MessageSendingFailureText");
            }
            else if ([messageInfo.deliveryState compareString:TSkMessageDeliveryStateSMSNumberBlockedError] ||
                     [messageInfo.deliveryState compareString:TSkMessageDeliveryStateSMSNumberUnreachableError])
            {
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MsgDlryStPhNumUnrchbl");
            }
            else if ([messageInfo.deliveryState compareString:TSkMessageDeliveryStateSMSNumberInvalidFormatDestinationAddressError] ||
                     [messageInfo.deliveryState compareString:TSkMessageDeliveryStateSMSNumberDestinationNotSupportedError] ||
                     [messageInfo.deliveryState compareString:TSkMessageDeliveryStateSMSNumberDoesNotExistError])
            {
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MsgDlryStPhNumInvalid");
            }
            else if ([self.messageDeliveryStateErrorCodesContactAdmin containsObject:messageInfo.deliveryState])
            {
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MsgDlryStPhNumAdmn");
            }
            else if ([messageInfo.deliveryState compareString:TSkMessageDeliveryStateSMSFraudSenderBlockedByReceipientError] ||
                     [messageInfo.deliveryState compareString:TSkMessageDeliveryStateSMSFraudSpamDetectedError])
            {
                // Treat this as a success scenario. Do nothing
                cell.messageBubbleView.backgroundColor = self.legacyAppearanceProxy.chatMessageSentBackgroundColor;
                cell.deliveryStateLabel.hidden = YES;
            }
            else if ([messageInfo.deliveryState compareString:TSkTranscription])
            {
                cell.messageBubbleView.backgroundColor = self.legacyAppearanceProxy.chatMessageSentBackgroundColor;
            }
            else
            {
                LogErrorAH(self.logger, @"message delivery failed. State code: %@", messageInfo.deliveryState);
                cell.deliveryStateLabel.text = AXPLocalizedString(@"MessageDeliveryStateUnknownText");
            }
        }
        else
        {
            cell.messageBubbleView.backgroundColor = self.legacyAppearanceProxy.chatMessageSentBackgroundColor;
            cell.deliveryStateLabel.hidden = YES;
        }
    }
    
    BOOL isMeetingOrGroupChat = NO;
    // To Do: Make a check to see if there is a uniqueroster thread (different from current thread) with same members
    // This would allow showing profile pics in some of the 2 member group chats; thus avoid losing sender Info
    if ((self.threadType == TSThreadTypeGroupChat) || (self.threadType == TSThreadTypePrivateMeeting))
    {
        isMeetingOrGroupChat = YES;
    }
    
    cell.forcedCompactMode = self.isInCallRightPanel;
    [cell adjustLeadingConstraintWithIsMeetingOrGroupChat:isMeetingOrGroupChat];
    
    cell.baseTableViewController = self;
    cell.indexPath = indexPath;
    cell.messageID = messageInfo.tsID;
    cell.threadID = messageInfo.threadID;
    cell.fromUserID = messageInfo.userID;
    cell.fromDisplayName = displayName;
    
    [cell configureDLPMessageWithMessageInfo:messageInfo isSentByCurrentUser:!isLeftCell accountHandle:self.accountHandle];
    
    TSDLPState currentState = messageInfo.policyViolationMessageState.integerValue;
    
    // Use expectedConsumerUserType to identify if the user profile is not present locally, use displayName from messageInfo in that case
    NSString *expectedConsumerUserType = [TSUtilities consumerUserTypeExpectedForUserId:userID threadId:self.threadID accountHandle:self.accountHandle];
    
    if ([TSUser isSMSUser:cell.fromUserID]) {
        NSString *shortDisplayName = [TSUser shortDisplayNameFromString:displayName];
        cell.senderDisplayName = [NSString stringWithFormat:AXPLocalizedString(@"UserNameWithSMSLabel"), shortDisplayName];
    }
    else if (person.isGuestUser)
    {
        cell.senderDisplayName = [TSUtilities isValidPhoneNumber:displayName]
        ? displayName
        : [[TSDisplayableUserName fullName:displayName] abbreviatedFormWithGuestInfo];
    }
    else if (person.isFederatedUser || person.isExtendedDirectoryUser || person.isTypeOfTFLInterOpUser)
    {
        cell.senderDisplayName = [person shortDisplayNameWithAdditionalInfo];
    }
    else if ((person.displayName.length > 0) && ([NSString isNilOrEmpty:expectedConsumerUserType] || ![expectedConsumerUserType isEqualToString:TSkUserTypeTFLConsumer]))
    {
        cell.senderDisplayName = [person shortDisplayName];
    }
    else
    {
        cell.senderDisplayName = [TSUser shortDisplayNameFromString:displayName];
    }
    
    BOOL shouldCollapseUserInfo = NO;
    if (isLeftCell && isMeetingOrGroupChat)
    {
        shouldCollapseUserInfo = [self shouldCollapseUserInfoForCellAtIndexPath:indexPath];
    }
    
    [cell constrainTextViewWidth];
    
    BOOL shouldShowUserInfo = isLeftCell && !shouldCollapseUserInfo && (isMeetingOrGroupChat || (self.thread.isBotInOneOnOneChat && [person isBot]));
    
    BOOL isLiveLocationMessage = NO;
    if (self.accountHandle.policyManager.isLocationWithLiveSharingEnabled)
    {
        id cardInfo = [[TSUtilities unarchiveBotCards:messageInfo.ts_botCardData] firstObject];
        if ([cardInfo isKindOfClass:TSCAdaptiveCard.class] && [messageInfo.contentItemId compareString:TSkShareLocationCardClientID] && [((TSCAdaptiveCard *) cardInfo) liveLocationData])
        {
            // don't show user name if it's a live location message
            isLiveLocationMessage = YES;
        }
    }
    
    BOOL shouldShowSenderDisplayName = (shouldShowUserInfo && !(currentState == TSDLPStateWarning || currentState == TSDLPStateBlocked) && !isLiveLocationMessage);
    [cell configureSenderDisplayName:shouldShowSenderDisplayName];
    
    NSMutableAttributedString *messageContent = [self addChicletIfMeetingLink:messageInfo cell:cell];
    
    if ((currentState == TSDLPStateWarning || currentState == TSDLPStateBlocked) && !isLeftCell)
    {
        [messageContent addAttributes:@{ NSForegroundColorAttributeName : self.legacyAppearanceProxy.chatMessageReceivedTextColor } range:NSMakeRange(0, messageContent.string.length)];
    }
    
    // Iterate over the attributedText and find all the attachments with images
    // Cell is added as an observer for these images and has to update layout of text view when these images are loaded
    NSAttributedString *attributedString = nil;
    BOOL isDLPViolation = (currentState == TSDLPStateWarning) ? !isLeftCell : (currentState == TSDLPStateBlocked);
    if([messageInfo.messageContentType isEqualToString: @"media_callrecording"])
    {
        TSSMessage *messageProperties = [AXPCtx messageForID:messageInfo.tsID andThreadID:messageInfo.threadID];
        NSString *content = [messageProperties content];
        NSURL *url = [TSMeetingUtils getRecordingURL:content
                                       correlationId:[[NSUUID UUID] UUIDString]
                                       accountHandle:self.accountHandle];
        
        attributedString = [messageInfo.attributedContent attributedStringWithLink:url andFontTextStyle:UIFontTextStyleBody
                                                                       andFontType:TSkFontTypeRegular];
    }
    else
    {
        if (isDLPViolation)
        {
            if (!isLeftCell)
            {
                if (!(messageInfo.policyProperties.policyOriginalContentFetched.boolValue || [messageInfo.attributedContent.string isNotNilOrEmpty]))
                {
                    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
                    style.minimumLineHeight = TSkDLPMinimumLineHeight;
                    NSURL *getMessageLink = [NSURL URLWithString:[NSString stringWithFormat:@"dlp://getOriginalMessage?messageID=%@&threadID=%@", messageInfo.tsID, messageInfo.threadID]];
                    NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc]
                                                             initWithString:[NSString stringWithFormat:@"%@", AXPLocalizedString(@"DLPSeeOriginalMessage")]
                                                             attributes:@{
                        NSParagraphStyleAttributeName : style,
                        NSLinkAttributeName : getMessageLink
                    }];
                    messageContent = infoString;
                }
            }
            else
            {
                messageContent = nil;
            }
        }
        else
        {
            if ([NSString isNilOrEmpty:messageContent.string] && !([messageInfo hasAttachments] || [messageInfo hasComposeExtensions]))
            {
                messageContent = [[NSMutableAttributedString alloc] initWithString:@" "];
            }
        }
        attributedString = [messageContent attributedStringWithFontTextStyle:UIFontTextStyleBody
                                                                 andFontType:TSkFontTypeRegular
                                                               biggerCapSize:YES];
    }
    
    if ([self.accountHandle.ecsManager chatContentBackgroundEnabledOnECS] &&
        [TSTextAttachmentFormatter hasOnlyAttachmentsAndNoMentions:attributedString])
    {
        NSInteger emojiCount = [[TSTextAttachmentFormatter allEmojiAttachmentsInAttributedString:attributedString] count];
        NSInteger attachmentCount = 0;
        attachmentCount = [[TSTextAttachmentFormatter imageAttachments:attributedString] count] + [TSTextAttachmentFormatter videoAttachmentsInAttributedString:attributedString].count;
        
        BOOL messageContainsEmojis = emojiCount > 0;
        
        if (messageContainsEmojis)
        {
            //set clear background when emoji count is less than 4 and no images/videos are present.
            if (emojiCount < 4 && (emojiCount == attachmentCount))
            {
                [cell setClearBubbleColor:YES];
            }
        }
        else
        {
            //We are setting clear background color only for single attachment
            if (attachmentCount <= 1)
            {
                [cell setClearBubbleColor:NO];
            }
        }
    }
    
    if (isLeftCell)
    {
        if (messageInfo.hasMentionForMe)
        {
            cell.mentionLineView.hidden = NO;
            cell.mentionLineView.backgroundColor = self.legacyAppearanceProxy.mentionIndicatorLineColor;
        }
    }
    
    [self.attributedStringProcessor processAttributedString:attributedString forCellID:cell.uniqueId isChatCell:YES messageInfo:messageInfo];
    
    if (self.accountHandle.ecsManager.isImageCollageRenderEnabled)
    {
        attributedString = [attributedString stringByGroupingConsecutiveImagesWithMinimumImagesCount:self.accountHandle.ecsManager.imageCollageMinimumImages];
    }
    
    NSArray *uiElementsInTextView = NSArray.new;
    
    /// Configure and add bot card views to message bubble
    BOOL configuredBotCard = [self configureCardViews:cell isLeftCell:isLeftCell withMessageInfo:messageInfo shouldShowSenderName: shouldShowSenderDisplayName];
    
    if (!configuredBotCard &&
        ([messageInfo hasComposeExtensions] ||
         [messageInfo.attachmentClasses containsObject:TSMessageReplyTextAttachment.class] ||
         [self isMessageInfoForMeetingChiclet:messageInfo]))
    {
        [cell.messageTextView setHidden:YES];
        
        TSSMessage *message = [AXPCtx messageForID:messageInfo.tsID andThreadID:messageInfo.threadID];
        [self buildComposeExtensions:cell withMessageEntity:message withMessage:messageInfo withMessageContent:attributedString isLeftCell:isLeftCell shouldShowSenderName:shouldShowSenderDisplayName];
        [cell setupAnimations:cell.messageStackView threadID:self.threadID];
    }
    else
    {
        // TODO: (danboe) - controller should not know about cell.messageView - refactor:
        // - the configuation of messageView to the cell class
        cell.messageTextView.attributedText = nil;
        [self populateMessageTextView:cell.messageTextView withAttributedString:attributedString isLeftCell:isLeftCell isBlocked:(currentState == TSDLPStateWarning || currentState == TSDLPStateBlocked) messageFailedToUpload:messageInfo.uploadDidTimeout];
        uiElementsInTextView = [self configureTextMessageView:cell.messageTextView forCell:cell];
        
        cell.messageTextView.hidden = (cell.messageTextView.text.length == 0 || configuredBotCard);
        if (configuredBotCard)
        {
            cell.shouldHaveClearBackground = YES;
        }

        // Begin the animation
        [cell setupAnimation:cell.messageTextView threadID:self.threadID];
    }
    
    cell.messageTime = [messageInfo.arrivalTime axp_briefTimeInWordsWithFetchDay:NO withFetchTime:YES];
    
    TSRevealableView *revealableView = [self.tableView dequeueReusableRevealableViewWithIdentifier:TSkNibNameRevealableLabel];
    revealableView.legacyAppearanceProxy = self.legacyAppearanceProxy;
    
    if (revealableView)
    {
        TSRevealableLabel *revealableLabel = (TSRevealableLabel *)revealableView;
        [revealableLabel configureWithText:cell.messageTime];
        
        [cell setRevealableView:revealableLabel
                          style:(isLeftCell && !isMeetingOrGroupChat ? TSRevealStyleOver : TSRevealStyleSlide)
                      direction:[TSUtilities isRightToLeftLayout] ? TSRevealDirectionRight : TSRevealDirectionLeft
                         anchor:(isLeftCell ? TSRevealAnchorLeft : TSRevealAnchorRight)];
    }
    
    BOOL messageIsSent = !messageInfo.isLocal.boolValue;
    TSInterMessageBubbleSpacingType spacingType = [self messageBubbleSpacingTypeForCellAtIndexPath:indexPath];
    
    [cell setInterBubbleSpacingToType:spacingType];
    [cell enableEdited:(messageInfo.isEditedMessage && !(currentState == TSDLPStateWarning || currentState == TSDLPStateBlocked))];
    
    [cell enableTranslated:messageInfo.isTranslatedMessageForDisplay];
    
    [cell enableBlocked:isDLPViolation];
    [cell enableImportance:messageInfo isLeftCell:isLeftCell isDLPBlocked:(currentState == TSDLPStateWarning || currentState == TSDLPStateBlocked)];
    
    if (isLeftCell &&
        self.hasPromptedUserLessThanLimit &&
        [self isLastMessageSentByOthers:messageInfo] &&
        [TSQuickReactPromptManager.sharedInstance shouldPromptUserToQuickReact] &&
        [self shouldShowReactPromptForMessage:messageInfo.tsID])
    {
        [cell showQuickReactPrompt];
        self.isShowingQuickReactPrompt = YES;
    }
    
    [cell enableProfileImage:shouldShowUserInfo
                 asCollapsed:shouldCollapseUserInfo
        isMeetingOrGroupChat:isMeetingOrGroupChat
         isBotInOneToOneChat:self.thread.isBotInOneOnOneChat
               accountHandle:self.accountHandle];
    
    [cell enableSaved:messageInfo.hasSavedMessage];
    
    if (!isLeftCell)
    {
        BOOL shouldShowSuccess = NO;
        BOOL shouldShowReadReceipt = NO;
        BOOL shouldShowMessageState = NO;
        
        TSkMessageSendState messageSendState =  messageIsSent ?  TSkMessageSendStateSent : TSkMessageSendStateBeingSent;
        if (currentState == TSDLPStateBlocked)
        {
            messageSendState = TSkMessageSendStateBlocked;
        }
        else if (currentState == TSDLPStateWarning)
        {
            messageSendState = TSkMessageSendStateFlagged;
        }
        else if (messageIsSent)
        {
            NSIndexPath *lastSentIndexPath = nil;
            NSIndexPath *lastSeenIndexPath = nil;
            
            // compute the indexpath for the cell where we should show read receipt or msg sent sign.
            [self computeIndexPathForLastSeen:&lastSeenIndexPath andForLastSentMsg:&lastSentIndexPath];
            
            shouldShowSuccess = (indexPath.length == lastSentIndexPath.length && indexPath.row == lastSentIndexPath.row && indexPath.section == lastSentIndexPath.section);
            shouldShowReadReceipt = (indexPath.length == lastSeenIndexPath.length && indexPath.row == lastSeenIndexPath.row && indexPath.section == lastSeenIndexPath.section);
            
            if (shouldShowReadReceipt)
            {
                messageSendState = TSkMessageSendStateSeen;
            }
        }
        else if (!messageIsSent && messageInfo.uploadDidTimeout)
        {
            messageSendState = TSkMessageSendStateFailed;
        }
        
        // show msg status indicator if msg is being sent, failed, last successful sent msg, or last seen msg
        shouldShowMessageState = !messageIsSent || shouldShowReadReceipt || shouldShowSuccess || (currentState == TSDLPStateWarning || currentState == TSDLPStateBlocked);
        
        [cell configureMessageSendState:messageSendState
              shouldDisplayMessageState:shouldShowMessageState
                          accountHandle:self.accountHandle];
    }
    
    TSSMessage *message = [TSSMessage messageForID:messageInfo.tsID andThreadID:messageInfo.threadID inManagedObjectContext:self.accountHandle.mainMOC];
    if (self.isFluidObject) {
        TSFluidTablePreviewCell *fluidView = [self.fluidService getCell:messageInfo messageEntity:message chatDelegate:(id<TSFluidTablePreviewCellDelegate>)self.fluidTablePreviewCellHandler];
        [fluidView start:self.accountHandle msgInfo:messageInfo vcHeight:self.view.bounds.size.height];
        TSThread *thread = [AXPCtx threadForID:messageInfo.threadID];
        BOOL isOneOnOne = thread && [thread isOneOnOneChat];
        [cell addLoopComponentPreview:fluidView isSentByMe:[[message ts_isSentByMe] boolValue] isOnGroupChat:!isOneOnOne];
        [cell setClearBubbleColor:YES];
    }
    
    if ([messageInfo hasAttachments] && ((currentState == TSDLPStateWarning || currentState == TSDLPStateBlocked) ? (messageInfo.policyProperties.policyOriginalContentFetched.boolValue || [messageInfo.attributedContent.string isNotNilOrEmpty]) : YES))
    {
        // File attachments
        TSSMessage *message = [AXPCtx messageForID:messageInfo.tsID andThreadID:self.threadID];
        NSArray<UIView *> *fileAttachmentViews = [self fileAttachmentViewsForCell:cell indexPath:indexPath message:message withMessageInfo:messageInfo forLeftCell:isLeftCell];
        [cell addFileAttachmentViews:fileAttachmentViews];
    }
    
    BOOL showVideoLinkPreview = [messageInfo hasVideoLinkPreview] && self.accountHandle.policyManager.isYoutubeMessageEnabled;
    
    if ([messageInfo hasLinkPreview] && !showVideoLinkPreview && ((currentState == TSDLPStateWarning || currentState == TSDLPStateBlocked) ? (messageInfo.policyProperties.policyOriginalContentFetched.boolValue || [messageInfo.attributedContent.string isNotNilOrEmpty]) : YES))
    {
        [cell addLinkPreview:messageInfo.linkPreviewDict];
        [self invalidateHeightCacheForMessageID:messageInfo.tsID];
    }
    
    if (showVideoLinkPreview)
    {
        if (self.externalVideoMessagingCoordinator == nil)
        {
            self.externalVideoMessagingCoordinator = [[TSExternalVideoMessagingCoordinatorBridge alloc] initWithThreadId:self.threadID
                                                                                                          stringResolver:[TSSharedStringsResolver new]
                                                                                                      fromViewController:self];
            [self.externalVideoMessagingCoordinator start];
        }
        NSMutableArray<ExternalVideoConfigProps*> *videoPreviews = [NSMutableArray new];
        BOOL hasAcceptedTerms = [self.accountHandle.tenantDefaults boolForKey:TSkYoutubeTermsAccepted];
        
        for (NSDictionary *videoPreview in messageInfo.externalVideoPreviews)
        {
            if (!hasAcceptedTerms)
            {
                id<SharedStringsProtocol> sharedStrings = self.accountHandle.sharedStrings;
                TSWeakify(self);
                TermsCardView *termsCardView = [TermsCardView buildYouTubeTermsCardViewWithUrl:[NSURL URLWithString:videoPreview[TSkVideoUrlKey]]
                                                                                         title:videoPreview[TSkVideoTitleKey]
                                                                                  thumbnailUrl:[NSURL URLWithString:videoPreview[TSkVideoThumbnailKey]]
                                                                                 sharedStrings:sharedStrings
                                                                                   onSourceTap:^{
                    TSStrongifyAndReturnIfNil(self);
                    [self.accountHandle.tenantDefaults setBool:YES forKey:TSkYoutubeTermsAccepted];
                    [self reloadTable];
                }
                                                                                onTermsLinkTap:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TSkYouTubeTermsURL]
                                                       options:@{}
                                             completionHandler:nil];
                }];
                [termsCardView setNeedsLayout];
                [termsCardView layoutIfNeeded];
                [cell.messageStackView addArrangedSubview:termsCardView];
                continue;
            }
            ExternalVideoConfigProps *videoConfigProps = [[ExternalVideoConfigProps alloc]
                                                          initWithId:videoPreview[TSkVideoIdKey]
                                                          urlString:videoPreview[TSkVideoUrlKey]
                                                          rawType:videoPreview[TSkVideoTypeKey]
                                                          title:videoPreview[TSkVideoTitleKey]];
            [videoPreviews addObject:videoConfigProps];
        }
        
        if (hasAcceptedTerms)
        {
            UIView *cardView = [self.externalVideoMessagingCoordinator cardViewWithCardId:messageInfo.tsID.stringValue
                                                                  playFullscreenbyDefault:self.accountHandle.policyManager.shouldExternalVideoPlayFullscreenByDefault
                                                                            videoPreviews:videoPreviews];
            [cell.messageStackView addArrangedSubview:cardView];
            [cardView.leadingAnchor constraintEqualToAnchor:cell.messageStackView.leadingAnchor].active = YES;
            [cardView.trailingAnchor constraintEqualToAnchor:cell.messageStackView.trailingAnchor].active = YES;
        }
        
    }
    
    
    if (currentState != TSDLPStateBlocked)
    {
        BOOL isMeetingChiclet = [self isMessageInfoForMeetingChiclet:messageInfo];
        id<ReactionsViewDelegate> reactionsViewDelegate = [self.reactionsViewDelegateHandler conformsToProtocol:@protocol(ReactionsViewDelegate)] ? ((id<ReactionsViewDelegate>)self.reactionsViewDelegateHandler) : nil;
        [cell configureReactionsViewForMessage:messageInfo
                           withLeftCellMessage:isLeftCell
                             needCustomPadding:isMeetingChiclet
                individualReactionPillsEnabled:[self.experimentationService boolForAgentName:TSECSTeamName keyPath:TSECSChatEnableIndividualReactionPills defaultValue:NO]
                      canSendExpandedReactions:self.accountHandle.policyManager.canSendExpandedReactions
                                 accountHandle:self.accountHandle
                              reactionDelegate:reactionsViewDelegate];
        
        if ([TSTranslationManager isAutomaticChatTranslationSuggestionEnabled:self.accountHandle])
        {
            if (self.translationMode == TSTranslationModeSettingBeforeTranslating &&
                [messageInfo canShowTranslationIntelligentSuggestion])
            {
                [self setupTranslationIntelligentSuggestionsFor:messageInfo andCell:(TSChatMessageViewCell *)cell];
            }
            else
            {
                [cell clearIntelligentSuggestionsAccessibilityLabel];
            }
            
            if (self.translationMode == TSTranslationModeSettingAlwaysTranslate &&
                [messageInfo isTranslatedMessageForDisplay])
            {
                [self setupTranslationPreferencesIntelligentSuggestionsFor:messageInfo andCell:(TSChatMessageViewCell *)cell];
            }
        }
        
        if ([TSTranslationManager isAutomaticChatTranslationEnabled:self.accountHandle] || [TSTranslationManager isOnDemandChatTranslationEnabled:self.accountHandle])
        {
            if ([self.messageIDListToStartTranslationSpinner containsObject:cell.messageID])
            {
                [TSDispatchUtilities dispatchOnMainThread:^{
                    [cell startTranslationSpinner];
                }];
            }
            
            if ([self.messageIDListToStartTranslationSpinner containsObject:cell.messageID] == NO)
            {
                BOOL isTranslatedMessageForDisplay = messageInfo.isTranslatedMessageForDisplay;
                
                [TSDispatchUtilities dispatchOnMainThread:^{
                    [cell stopTranslationSpinner:true];
                    [cell enableTranslated:isTranslatedMessageForDisplay];
                }];
            }
            
            [cell configureTranslationErrorViewForMessage:messageInfo accountHandle:self.accountHandle];
        }
    }
    
    [cell updateAccessibilityLabelTextForMessage:messageInfo
                        withUIElementsInTextView:uiElementsInTextView
                                   accountHandle:self.accountHandle];
    
    [cell setNeedsLayout];
}


- (NSMutableAttributedString *)addChicletIfMeetingLink:(TSMessageInfo *)messageInfo cell:(TSChatMessageViewCell *)cell
{
    AssertMainThread();
    NSMutableAttributedString *messageContent = [self replaceGifWithURLIfNeeded:messageInfo];
    
    if([self.accountHandle.ecsManager isShareMeetingChicletEnabled])
    {
        NSArray *allComps = [messageContent.string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *meetingUrlString = @"";
        for (NSString *currStr in allComps) {
            
            meetingUrlString = currStr.removeWhitespaces;
            NSURL *meetingURL = [NSURL URLWithString:meetingUrlString];
            //Handling "https://teams.microsoft.com/l/meetup-join" kind of urls
            if (meetingURL && [meetingURL isSkypeTeamsLink] &&
                [[self.accountHandle policyManager] isPrivateMeetingEnabled] &&
                meetingURL.isRegularLinkToMeetupJoin) {
                
                NSString *threadID = meetingURL.pathComponents[3];
                
                TSMeetingItemViewData *eventData = [TSMeetingTabbedUXUtilities getEventDataForThreadId:threadID accountHandle:self.accountHandle];
                TSCalEventDetails *event = [TSCalEventDetails calEventDetailsForThread:threadID inManagedObjectContext:self.accountHandle.mainMOC];
                
                if(eventData)
                {
                    NSString *removeString = [NSString stringWithFormat:@"\n%@\n%@", meetingUrlString, AXPLocalizedString(@"shrLnkDsc")];
                    
                    NSRange removeRange = [messageContent.string rangeOfString:removeString];
                    if(removeRange.location != NSNotFound)
                    {
                        [messageContent deleteCharactersInRange:removeRange];
                    }
                    
                    NSRange removeLinkRange = [messageContent.string rangeOfString:meetingUrlString];
                    if(removeLinkRange.location != NSNotFound)
                    {
                        [messageContent deleteCharactersInRange:removeLinkRange];
                    }
                    
                    NSRange removeSuffixRange = [messageContent.string rangeOfString:AXPLocalizedString(@"shrLnkDsc")];
                    if(removeSuffixRange.location != NSNotFound)
                    {
                        [messageContent deleteCharactersInRange:removeSuffixRange];
                    }
                    
                    messageContent = [[messageContent trimTrailingWhiteSpace] mutableCopy];
                    
                    TSWeakify(self);
                    Chiclet *meetingChiclet = [Chiclet withAutoLayout];
                    [TSMeetingTabbedUXUtilities setMeetingChiclet:meetingChiclet
                                                    WithEventData:eventData
                                                            event:event
                                                  showCloseButton:NO
                                                            onTap:^{
                        
                        TSStrongifyAndReturnIfNil(self);
                        NSString *eventId = eventData.calendarEventId ?: event.tsID;
                        [TSMeetingCoordinator showMeetingDetailsWithId:eventId meetingStartTimeFromNotification:eventData.startTime fromSourceViewController:self withAccountHandle:self.accountHandle];
                    }
                                                        onJoinTap:^{
                        
                        TSStrongifyAndReturnIfNil(self);
                        [[TSUniversalLinkManager defaultManager] handleUniversalLink:meetingURL accountHandle:self.accountHandle];
                    }
                                                   onAccessoryTap:^{}];
                    
                    [cell addMeetingAttachmentView:meetingChiclet];
                }
            }
        }
    }
    
    return messageContent;
}

- (id<TSMessageAttachmentCacheProtocol>)attachmentCacheHelper
{
    if (!_attachmentCacheHelper)
    {
        _attachmentCacheHelper = [[TSMessageAttachmentHelper alloc] init];
    }
    return _attachmentCacheHelper;
}

- (NSArray<UIView *> *) fileAttachmentViewsForCell:(TSChatMessageViewCell *)cell
                                         indexPath:(NSIndexPath *)indexPath
                                           message:(TSSMessage*)message
                                   withMessageInfo:(TSMessageInfo *)messageInfo
                                       forLeftCell:(BOOL)isLeftCell
{
    NSMutableArray<UIView *> *attachedFileAttachmentViews = [NSMutableArray<UIView *> array];
    NSArray *documentAttachments = messageInfo.docAttachmentList;
    
    if ([documentAttachments count] > 0 && !message.deleteTime)
    {
        //build the slideshow data if needed
        // Compute slide show data for the cell and use that to setup the slide show
        AXSlideshowData *slideshowData = [self.slideshowHandler slideShowDataFromAttributedString:messageInfo.attributedContent];
        NSInteger imageIndex = slideshowData.slides.count;
        slideshowData = [self.slideshowHandler updateCurrentSlideShowData:slideshowData forMessage:message withMessageInfo:messageInfo];
        
        for (TSDocumentAttachment *attachment in documentAttachments)
        {
            attachment.messageInfo = messageInfo;
            if([attachment shouldHideAttachment])
            {
                LogInfoAH(self.logger, @"Hiding file attachment with fileID: %@ due to filechiclet state being set to hidden", attachment.fileID);
                continue;
            }
            if ([self.deletedFileList containsObject:attachment.fileID])
            {
                attachment.isDeletedFile = YES;
            }
            
            if ([attachment displayAsImage])
            {
                TSChatImageAttachmentView *attachedImageView = [[[NSBundle bundleForClass:[self class]]
                                                                 loadNibNamed:NSStringFromClass(TSChatImageAttachmentView.class)
                                                                 owner:nil options:nil] firstObject];
                attachedImageView.slideshowData = slideshowData;
                [attachedImageView configureWithDocumentAttachment:attachment
                                                        imageIndex:imageIndex
                                                   backgroundColor:self.legacyAppearanceProxy.clearColor
                                                         panelInfo:self.currentPanelInfo
                                           baseTableViewController:self];
                
                __weak typeof(self) weakSelf = self;
                __weak typeof(UIView) *baseView = cell.messageBubbleView;
                
                if (self.accountHandle.policyManager.isChatGallerySlideshowEnabled
                    && self.accountHandle.ecsManager.isChatGalleryImageFilesIncluded
                    && (!attachment.isAnimatedImage || self.accountHandle.ecsManager.isChatGalleryAnimatedImagesIncluded))
                {
                    __weak typeof(UIView) *sourceView = cell.internalContentView;
                    NSURL *imageURL = [NSURL URLWithString:attachment.previewUrl];
                    NSNumber *messageId = message.tsID;
                    
                    attachedImageView.tapAction = ^()
                    {
                        [TSDispatchUtilities dispatchOnMainThread:^{
                            [weakSelf launchSlideshowWithUrl:imageURL
                                                 inMessageId:messageId
                                                  sourceView:sourceView
                                                  imageIndex:1
                                                  imageCount:0];
                        }];
                    };
                }
                
                attachedImageView.longPressAction = ^(UIGestureRecognizer *recognizer)
                {
                    [weakSelf openPopupForMessageAtPath:indexPath withBaseView:baseView];
                };
                [attachedFileAttachmentViews addObject:attachedImageView];
                imageIndex = imageIndex + 1;
            }
            else
            {
                MessageAttachmentViewModel *attachmentViewModel = [[MessageAttachmentViewModel alloc] initWithAccountHandle:self.accountHandle
                                                                                                         documentAttachment:attachment
                                                                                                           topicInformation:nil
                                                                                                              correlationID:nil
                                                                                                            isInComposeArea:NO
                                                                                                                  panelInfo:self.currentPanelInfo];
                
                TSMessageAttachmentView *attachmentView = [[[NSBundle bundleForClass:[self class]]
                                                            loadNibNamed:NSStringFromClass(TSMessageAttachmentView.class)
                                                            owner:nil
                                                            options:nil] firstObject];
                attachmentView.legacyAppearanceProxy = self.legacyAppearanceProxy;
                
                UIColor *borderColor = isLeftCell ? self.legacyAppearanceProxy.chatMessageReceivedDocumentBorderColor : self.legacyAppearanceProxy.chatMessageSentDocumentBorderColor;
                BOOL isThumbnailPreviewOrInfoViewEnabled = self.accountHandle.policyManager.isFilesThumbnailPreviewEnabled || self.accountHandle.ecsManager.filesSizeInfoViewEnabled;
                
                [attachmentView setUpWithViewModel:attachmentViewModel
                                   backgroundColor:(isLeftCell ? self.legacyAppearanceProxy.chatMessageReceivedDocumentBackgroundColor : self.legacyAppearanceProxy.chatMessageSentDocumentBackgroundColor)
                                         textColor:(isLeftCell ? self.legacyAppearanceProxy.chatMessageReceivedDocumentTextColor : self.legacyAppearanceProxy.chatMessageSentDocumentTextColor)
                                       borderColor:(isThumbnailPreviewOrInfoViewEnabled ? self.legacyAppearanceProxy.clearColor : borderColor)
                                    viewController:(UIViewController *)self
                                   composeDelegate:nil];
                
                [attachedFileAttachmentViews addObject:[self getWrapperViewForAttachment:attachmentView
                                                                               messageId:messageInfo.tsID
                                                                        attributedString:messageInfo.attributedContent
                                                                            attachmentId:attachment.fileID]];
            }
        }
        
        return attachedFileAttachmentViews;
    }
    
    return nil;
}

- (UIView *)getWrapperViewForAttachment:(TSMessageAttachmentView *)attachmentView
                              messageId:(NSNumber *)messageId
                       attributedString:(NSAttributedString *)attributedString
                           attachmentId:(NSString *)attachmentId
{
    UIView *previewContentView = [UIView new];
    previewContentView.translatesAutoresizingMaskIntoConstraints = NO;
    previewContentView.layer.masksToBounds = YES;
    previewContentView.layer.borderWidth = TSkFileAttachmentShadowBorderWidth;
    previewContentView.layer.borderColor = self.legacyAppearanceProxy.defaultBorderColor.CGColor;
    BOOL shouldHaveLargeCornerRadius = ([TSTextAttachmentFormatter hasOnlyBotAttachments:attributedString] &&
                                        [TSAccountManager.activeConfigHandle.ecsManager chatContentBackgroundEnabledOnECS]);
    previewContentView.layer.cornerRadius = shouldHaveLargeCornerRadius ? TSkLargeCornerRadius : TSkDefaultCornerRadius;
    
    UIView *cachedAttachmentView = [self.attachmentCacheHelper cachedAttachmentViewFor:attachmentView
                                                                             messageId:messageId
                                                                          attachmentId:attachmentId];
    
    [previewContentView addSubview:cachedAttachmentView];
    cachedAttachmentView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [cachedAttachmentView.leadingAnchor constraintEqualToAnchor:previewContentView.leadingAnchor],
        [cachedAttachmentView.trailingAnchor constraintEqualToAnchor:previewContentView.trailingAnchor],
        [cachedAttachmentView.topAnchor constraintEqualToAnchor:previewContentView.topAnchor],
        [cachedAttachmentView.bottomAnchor constraintEqualToAnchor:previewContentView.bottomAnchor]]
    ];
    
    return previewContentView;
}

- (void) userPresenceStatusChanged
{
    if (!self.registeredForIdleProcessing)
    {
        self.registeredForIdleProcessing = YES;
        
        [[AXPIdleProcessor sharedIdleProcessor] registerDelegate:self forKey:[self keyForIdleProcessing]];
        if (!self.userPresenceObservationStarted)
        {
            // Process presence calls with a smaller interval only when the view is launched
            [[AXPIdleProcessor sharedIdleProcessor] setNextIdleInterval:1.0];
            self.userPresenceObservationStarted = YES;
        }
        
        LogVerboseAH(self.logger, @"Requested next idle in %@", [self keyForIdleProcessing]);
    }
}

- (void) updatePresenceStatus
{
    __weak TSChatViewController *weakSelf = self;
    if (self.recipientIDs && (self.threadType == TSThreadTypeGroupChat))
    {
        // group chat case
        [self updateTable:^{
            [weakSelf.tableView beginUpdates];
            for(TSChatMessageViewCell *cell in weakSelf.tableView.visibleCells)
            {
                if ([cell isKindOfClass:TSChatMessageViewCell.class] && !cell.userPresenceStatusView.hidden)
                {
                    // TODO: (danboe) - controller should not know about these 2 imageviews
                    // refactor to cell class
                    TSPresenceStatus status = [[TSPresenceService defaultService] presenceStatusForUser:cell.fromUserID];
                    PresenceStatus presenceStatus = [self presenceStatus: status];
                    
                    [cell.userPresenceStatusView updateViewWithStatus: presenceStatus];
                }
            }
            [weakSelf.tableView endUpdates];
        }];
    }
    else if (self.shouldShowPresenceOnTitle)
    {
        TSUserPresence *presence = [[TSPresenceService defaultService] userPresenceStatusForUser:[self.recipientIDs firstObject]];
        TSPresenceStatus status = [[TSPresenceService defaultService] presenceStatusForUser:[self.recipientIDs firstObject]];
        
        if (self.currentPresenceStatus != status ||
            ![NSDate isDate:presence.lastSeenAt equalToDate:self.currentPresenceSeenAt])
        {
            // only update when status icon or date needs to be changed
            self.currentPresenceStatus = status;
            self.currentPresenceSeenAt = presence.lastSeenAt;
            
            [TSDispatchUtilities dispatchOnMainThread:^{
                [weakSelf updateSubtitleText];
            }];
        }
    }
}

- (void)userPresenceSynced:(NSNotification *)notification
{
    NSSet *syncUserIDs = [NSSet setWithArray:(NSArray *)notification.object];
    if (syncUserIDs.count > 0)
    {
        TSWeakify(self);
        [TSDispatchUtilities dispatchOnMainThread:^{
            TSStrongifyAndReturnIfNil(self);
            
            if (self.shouldShowPresenceOnTitle)
            {
                [self updatePresenceStatus];
                [[NSNotificationCenter defaultCenter] postNotificationName:TSkUserPresenceUpdateFromChatOpen object:self.accountHandle];
                return;
            }
            
            for (UITableView *cell in self.tableView.visibleCells)
            {
                if ([cell isKindOfClass:TSChatMessageViewCell.class])
                {
                    TSChatMessageViewCell *messageViewCell = (TSChatMessageViewCell*)cell;
                    NSString *senderID = messageViewCell.fromUserID;
                    if ([senderID isNotNilOrEmpty] && [syncUserIDs containsObject:senderID])
                    {
                        [self updatePresenceStatus];
                        [[NSNotificationCenter defaultCenter] postNotificationName:TSkUserPresenceUpdateFromChatOpen object:self.accountHandle];
                        break;
                    }
                }
            }
        }];
    }
}

- (void) onIdle
{
    LogVerboseAH(self.logger, @"Processed idle in %@", [self keyForIdleProcessing]);
    
    [self updatePresenceStatus];
    
    // rely on super to unregist the delegate
    [super onIdle];
    
    self.registeredForIdleProcessing = NO;
}

- (BOOL)isNotificationIntentedForThisThread:(NSString *)threadId
{
    return [threadId isEqualToString:self.threadID];
}

- (void)processUploadProgressForVideoMessagesWithImageId:(NSString *)imageId
                                                progress:(float)progress
                                               indexPath:(NSIndexPath *)path
{
    TSWeakify(self)
    [self updateTable:^{
        TSStrongifyAndReturnIfNil(self)
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        TSMessageInfo *message = [self dataAtIndexPath:path];
        if (cell && message)
        {
            if ([cell isKindOfClass:TSChatMessageViewCell.class])
            {
                TSChatMessageViewCell *chatCell = (TSChatMessageViewCell *)cell;
                if (!chatCell.messageTextView.isHidden)
                {
                    NSAttributedString *attributedString = chatCell.messageTextView.attributedText;
                    [self updateVideoAttachmentsToLatestStateIn:attributedString textView:chatCell.messageTextView imageId:imageId progress:progress];
                }
            }
        }
    }];
}

// Bug # 176475: Workaround Intune Bug due to call to shouldInteractWithURL on super gets suppressed.
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    NSNumber *tappedMessageID = nil;
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell deepContainsSubview:textView])
        {
            TSMessageInfo *message = [self dataAtIndexPath:indexPath];
            tappedMessageID = message.tsID;
            break;
        }
    }
    
    return [self textView:(UITextView *)textView shouldInteractWithURL:URL inRange:characterRange interaction:interaction fromUserID:@"" tappedMessageID:tappedMessageID];
}

- (BOOL)textView:(UITextView *)textView
shouldInteractWithURL:(NSURL *)URL
         inRange:(NSRange)characterRange
     interaction:(UITextItemInteraction)interaction
      fromUserID:(NSString *)fromUserID
 tappedMessageID:(NSNumber *)tappedMessageID
{
    // Check if link is to This chat, if so doesn't need to navigate
    if ([self handledLinkToThisChat:URL tappedMessageID:tappedMessageID])
    {
        return NO;
    }
    
    NSDictionary *options = @{};
    TSThread *thread = [AXPCtx threadForID:self.threadID inMoc:self.accountHandle.mainMOC];
    if (self.accountHandle.ecsManager.enabledATPPolicyFeature && thread)
    {
        
        NSString *sourceID = self.threadID;
        
        NSMutableDictionary *sourceDetail = [NSMutableDictionary new];
        sourceDetail[TSkThreadID] = self.threadID;
        sourceDetail[TSkCount] = @([thread memberCount] - 1);
        
        options = @{
            TSkATPSourceId : sourceID?: @"",
            TSkATPSourceDetail : sourceDetail.jsonString
        };
    }
    
    return [ResolveProtocol(TSURLUtilityProtocol) shouldInteractWithURL:URL inRange:characterRange forTextView:textView accountHandle:self.accountHandle withOptions:options];
}

- (BOOL)handledLinkToThisChat:(NSURL *)url tappedMessageID:(NSNumber *)tappedMessageID
{
    NSArray *pathComponents = url.pathComponents;
    if ([url isLinkToChat])
    {
        NSString *threadID = pathComponents.count > 3 ? pathComponents[3] : nil;
        if (![threadID isEqualToString:self.threadID])
        {
            return NO;
        }
        
        NSString *messageID = pathComponents.count > 4 ? pathComponents[4] : nil;
        if (!messageID)
        {
            // Link to this chat, with no message ID, so handled with no scrolling
            return YES;
        }
        
        if ([[pathComponents lastObject] containsString: TSTabIDPrefix]) {
            return NO;
        }
        
        [self scrollToMessageID:[messageID asDecimalNumber] fromMessageID:tappedMessageID isMessageReply:NO];
        return YES;
    }
    return NO;
    
}

- (void)scrollToMessageID:(NSNumber *)messageID fromMessageID:(NSNumber *)fromMessageID isMessageReply:(BOOL)isMessageReply
{
    [self updateTable:^{
        TSSMessage *message = [AXPCtx messageForID:[messageID asDecimalNumber] andThreadID:self.threadID];
        if (message.isDeleted)
        {
            [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"DeletedMessageLabel")
                                         andMessage:AXPLocalizedString(@"DeletedMessageBody")
                                   andButtonContent:AXPLocalizedString(@"TSOK")
                                  andViewController:self];
            return;
        }
        
        self.scrollToMessageID = messageID;
        
        NSIndexPath *scrollToIndexPath = self.itemLookupMap[self.scrollToMessageID];
        if (scrollToIndexPath)
        {
            if ([[self.tableView indexPathsForVisibleRows] containsObject:scrollToIndexPath])
            {
                // If onscreen, scroll to middle and reload so triggers highlight animation
                [self.tableView scrollToRowAtIndexPath:scrollToIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                [self.tableView reloadRowsAtIndexPaths:@[scrollToIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            else
            {
                [self scrollToIndexPath:scrollToIndexPath forceTop:NO animated:YES];
                
                if (fromMessageID)
                {
                    [self.messageScrollBackStack addObject:fromMessageID];
                    [self.unreadIndicator updateLabelWithStringIdentifier:@"RtrnToMsg"];
                    
                    if (self.unreadIndicator.hidden)
                    {
                        [self showUnreadIndicator];
                    }
                }
            }
        }
        else if ([self numberOfSections] > 0)
        {
            NSNumber *lastMessageDate = self.lastMessageDate;
            self.lastMessageDate = [self itemsForSection:self.numberOfSections - 1].lastObject[@"arrivalTime"];
            
            // look at last msg date to prevent re-fetching same batch of messages again and again.
            if ((lastMessageDate && ![lastMessageDate isEqualToNumber:self.lastMessageDate]))
            {
                //Not found, need to load more items
                [self.messageFetchEngine getNextPageFromSyncDate:self.lastMessageDate];
                
                if (self.isLoadingIndicatorInChatEnabled)
                {
                    //Show loading indicator
                    [self setActivitySpinnerWithText:AXPLocalizedString(@"loadOldMsg")
                                         showSpinner:YES];
                }
            }
        }
        
        if (isMessageReply)
        {
            [self.logger logPanelAction:TSkActionModuleNameMessageReplyButton
                                outCome:TSkActionOutcomeNav
                                gesture:TSkActionGestureTap
                               scenario:TSkScenarioReplyNavigation
                           scenarioType:TSkScenarioTypeQuotedReply
                         destinationuri:@""
                   destinationUriParams:@""
                             moduleType:@""
                            moduleState:@""
                          moduleSummary:TSkScenarioReplyNavigation
                               threadId:self.threadID];
        }
    }];
}

- (void)stopPlayerIfPlaying
{
    if ([self isPlayerPlaying])
    {
        [self pausePlayer];
        [[NSNotificationCenter defaultCenter] postNotificationName:TSkAudioShouldStopNotification object:self];
    }
}

-(BOOL) tappedOnAttributedText:(UITapGestureRecognizer*)recognizer inTextView:(UITextView*)textView
{
    if ([TSUtilities isTableViewScrolling:self.tableView])
    {
        return YES;
    }
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    NSUInteger characterIndex = [layoutManager characterIndexForPoint:location
                                                      inTextContainer:textView.textContainer
                             fractionOfDistanceBetweenInsertionPoints:nil];
    
    if (characterIndex < textView.textStorage.length)
    {
        NSRange range;
        NSDictionary *attributes = [textView.attributedText attributesAtIndex:characterIndex effectiveRange:&range];
        
        if (attributes[NSLinkAttributeName])
        {
            NSURL *url = attributes[NSLinkAttributeName];
            if (self.accountHandle.ecsManager.filesPreviewLinksInTeamsEnabled &&
                [attributes[TSkCustomAttributeHyperLinkItemType] isKindOfClass:NSString.class] &&
                [attributes[TSkCustomAttributeHyperLinkItemType] isEqualToString:TSkFileHyperLinkItemType])
            {
                [TSUtilities openFilePreviewWithShareUrl:url.absoluteString
                                            withThreadID:self.threadID
                                           isTMRPlayback:NO
                                           accountHandle:self.accountHandle
                                          viewController:(UIViewController *)self];
                
                return YES;
            }
            if ([url.scheme isEqualToString:@"dlp"])
            {
                [self.logger logPanelAction:TSkActionModuleNameDLPSeeOriginalMessage
                                    outCome:TSkActionOutcomeView
                                    gesture:TSkActionGestureTap
                                   scenario:TSkScenarioDLPSeeOriginalMessage
                               scenarioType:TSkScenarioTypeDLP
                             destinationuri:nil
                       destinationUriParams:nil
                                 moduleType:nil
                                moduleState:nil
                              moduleSummary:nil
                                  panelType:TSkPanelTypeMessage
                                   panelUri:nil
                             panelUriParams:nil
                                   threadId:self.threadID
                                 threadType:nil];
                
                NSString *messageID = [url.absoluteString valueForQueryParameterKey:@"messageID"];
                NSString *threadID = [url.absoluteString valueForQueryParameterKey:@"threadID"];
                [self startRetrievingDLPMessageWithMessageId:messageID.asDecimalNumber threadId:threadID onSuccess:nil];
            }
            else
            {
                CGPoint pointOnTableView = [recognizer locationInView:self.tableView];
                NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointOnTableView];
                NSString *fromUserID = @"";
                NSNumber *tappedMessageID = nil;
                if (indexPath)
                {
                    TSMessageInfo *messageInfo = [self dataAtIndexPath:indexPath];
                    fromUserID = messageInfo.userID;
                    tappedMessageID = messageInfo.tsID;
                }
                [self textView:textView shouldInteractWithURL:url
                       inRange:range
                   interaction:UITextItemInteractionInvokeDefaultAction
                    fromUserID:fromUserID
               tappedMessageID:tappedMessageID];
            }
            return YES;
        }
        else if (attributes[NSAttachmentAttributeName])
        {
            NSTextAttachment *attach = attributes[NSAttachmentAttributeName];
            
            if ([attach isKindOfClass:TSMentionTextAttachment.class])
            {
                TSMentionTextAttachment *mentionAttachment = (TSMentionTextAttachment *)attach;
                if (mentionAttachment.mentionType == TSkMentionTypePerson ||
                    mentionAttachment.mentionType == TSkMentionTypeFederated ||
                    mentionAttachment.mentionType == TSkMentionTypeBot)
                {
                    if (textView == self.statusMessageBannerView.statusMessage)
                    {
                        [TSStatusMessageUtils logStatusMentionClickedEventWithAccountHandle:self.accountHandle];
                    }
                    [self stopPlayerIfPlaying];
                    [self openPeopleCardForUser:mentionAttachment.tsID withChatEnabled:YES];
                    return YES;
                }
                else if (mentionAttachment.mentionType == TSkMentionTypeWebhook)
                {
                    [self stopPlayerIfPlaying];
                    [self openPeopleCardForUser:mentionAttachment.tsID withChatEnabled:NO];
                    return YES;
                }
            }
            else if ([attach isKindOfClass:AXPTextAttachment.class])
            {
                // handling for rich video messages, if videoListing is enabled then videos are presend via slideShow
                if ([attach isKindOfClass:VideoTextAttachment.class] && ![self.accountHandle.ecsManager chatGalleryVideoListingEnabled])
                {
                    if (!self.accountHandle.policyManager.isVideoMessagingEnabled)
                    {
                        return YES;
                    }
                    
                    VideoTextAttachment *videoAttachment = (VideoTextAttachment *)attach;
                    NSError *err = nil;
                    NSString *scenarioID = [self.accountHandle.logger logStartScenarioEventOfType:@"OnePlayer_AMSVideo_Playback"
                                                                                   withProperties:@{
                        TSkIsChannelThread : @"NO"
                    }];
                    NSURL *amsURL = [videoAttachment getPlaybackURLForVideo:self.accountHandle error:&err];
                    if (err)
                    {
                        LogErrorAH(self.logger, @"Error while playing AMS videoes code %ld, domain %@", err.code, err.domain);
                        [self.accountHandle.logger logScenarioStopEvent:scenarioID status:ScenarioStatusFailure withError:err];
                        [TSAlertUtils presentAlertViewWithTitle:nil
                                                     andMessage:AXPLocalizedString(@"VdeoUnavblMsg")
                                               andButtonContent:AXPLocalizedString(@"TSOK")
                                              andViewController:self];
                    }
                    else
                    {
                        [[[OnePlayerHelper alloc] init] launchOnePlayerForAMSVideo:amsURL accountHandle:self.accountHandle
                                                                hostViewController:self
                                                                        scenarioID:scenarioID
                                                      onePlayerHostViewDescription:@""];
                    }
                    return YES;
                }
                
                AXPTextAttachment *axpAttach = (AXPTextAttachment*)attach;
                
                BOOL isCollageAttachment = [attach isKindOfClass:TSCollageTextAttachment.class];
                
                // default telemetry values for single images
                __block NSUInteger imageIndex = 0;
                __block NSUInteger imageCount = 1;
                
                if (axpAttach.state == AXPTextAttachmentStateRetryableError)
                {
                    // Clear state and retry if tap
                    axpAttach.state = AXPTextAttachmentStateDefault;
                    
                    [[TSImageRepository commonRepository] getDataForImageUrl:axpAttach.imageSrcUrl.absoluteString createThumbnail:YES accountHandle:self.accountHandle];
                    
                    return YES;
                }
                else if (axpAttach.state == AXPTextAttachmentStateFatalError)
                {
                    // Fatal error downloading image, can't retry or show
                    return YES;
                }
                else if (isCollageAttachment || (axpAttach.imageId && axpAttach.imageSrcUrl && !axpAttach.isEmojiImage.boolValue))
                {
                    // Compute slide show data for the cell and use that to setup the slide show
                    CGPoint rowLocation = [recognizer locationInView:self.tableView];
                    TSSMessage *message = nil;
                    TSMessageInfo *messageInfo = nil;
                    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:rowLocation];
                    if (path)
                    {
                        messageInfo = [self dataAtIndexPath:path];
                        message = [AXPCtx messageForID:messageInfo.tsID andThreadID:messageInfo.threadID];
                    }
                    
                    AXPTextAttachment *selectedAttachment = axpAttach;
                    
                    if (isCollageAttachment)
                    {
                        TSCollageTextAttachment *collage = (TSCollageTextAttachment *)axpAttach;
                        NSUInteger collageStringLength = [[NSAttributedString attributedStringWithAttachment:collage] length];
                        CGRect collageRect = [textView.layoutManager boundingRectForGlyphRange:NSMakeRange(characterIndex, collageStringLength) inTextContainer:textView.textContainer];
                        
                        CGPoint locationRelativeToTextView = [recognizer locationInView:textView];
                        CGPoint locationRelativeToAttachment = CGPointMake(locationRelativeToTextView.x - collageRect.origin.x, locationRelativeToTextView.y - collageRect.origin.y);
                        
                        selectedAttachment = [collage imageAttachmentAtPoint:locationRelativeToAttachment];
                        imageIndex = [collage imageIndexAtPoint:locationRelativeToAttachment];
                        imageCount = collage.numImages;
                    }
                    
                    if (self.accountHandle.policyManager.isChatGallerySlideshowEnabled
                        && (![selectedAttachment isKindOfClass:TSAnimatedTextAttachment.class] || self.accountHandle.ecsManager.isChatGalleryAnimatedImagesIncluded)
                        && ![TSUtilities isGifProviderURL:selectedAttachment.imageSrcUrl accountHandle:self.accountHandle]
                        && (selectedAttachment.imageSrcUrl && [message hasAttachmentWithUrl:selectedAttachment.imageSrcUrl])
                        && self.navigationController)
                    {
                        TSChatMessageViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
                        
                        __weak typeof(self) weakSelf = self;
                        [TSDispatchUtilities dispatchOnMainThread:^{
                            [weakSelf launchSlideshowWithUrl:selectedAttachment.imageSrcUrl
                                                 inMessageId:selectedAttachment.messageId
                                                  sourceView:cell.internalContentView
                                                  imageIndex:imageIndex
                                                  imageCount:imageCount];
                        }];
                    }
                    else
                    {
                        if ([selectedAttachment isKindOfClass:TSAnimatedTextAttachment.class] && ![TSUtilities allowGifDisplayForURL:selectedAttachment.imageSrcUrl accountHandle:self.accountHandle])
                        {
                            [self didTapOnDisabledGIF:(TSAnimatedTextAttachment *)selectedAttachment
                                           inTextView:textView
                                     atCharacterIndex:characterIndex
                                    withTapRecognizer:recognizer];
                            return YES;
                        }
                        
                        NSInteger imageIndex = 0;
                        AXSlideshowData* slideShowData = nil;
                        if (message && messageInfo)
                        {
                            slideShowData = [self.slideshowHandler slideShowDataFromAttributedString:messageInfo.attributedContent];
                            imageIndex = slideShowData.slides.count;
                            slideShowData = [self.slideshowHandler updateCurrentSlideShowData:slideShowData forMessage:message withMessageInfo:messageInfo];
                        }
                        else
                        {
                            NSAttributedString* attributedString = textView.attributedText;
                            slideShowData = [self.slideshowHandler slideShowDataFromAttributedString:attributedString];
                        }
                        
                        if (slideShowData != nil && slideShowData.slides.count > 0)
                        {
                            if (self.currentPanelInfo)
                            {
                                [self.logger logPanelAction:TSkActionModuleNamePreview
                                                    outCome:TSkActionOutcomePreview
                                                    gesture:TSkActionGestureTap
                                                   scenario:([selectedAttachment isKindOfClass:TSAnimatedTextAttachment.class]) ? TSkScenarioMessageGiphy : TSkScenarioMessageImage
                                               scenarioType:TSkScenarioTypePreview
                                             destinationuri:@""
                                       destinationUriParams:@""
                                                 moduleType:TSkScenarioTypeMessageImage
                                                moduleState:@""
                                              moduleSummary:@""
                                                  panelType:self.currentPanelInfo.type
                                                   panelUri:self.currentPanelInfo.uri
                                             panelUriParams:self.currentPanelInfo.uriParams
                                                   threadId:self.threadID
                                                 threadType:self.currentPanelInfo.threadType];
                            }
                            [self stopPlayerIfPlaying];
                            NSInteger index = [self.slideshowHandler imageIndexForImageUrlString:[selectedAttachment.originalImageSrcUrl absoluteString] forSlideshowData:slideShowData];
                            NSMutableDictionary *viewInfo = [@{
                                @"startIndex" : [NSString stringWithFormat:@"%ld", (long)index],
                                @"slideshowData" : slideShowData,
                            } mutableCopy];
                            UIAccessibilityElement *focusedElement = (UIAccessibilityElement *)textView;
                            if (focusedElement)
                            {
                                viewInfo[@"savedVOFocusElement"] = focusedElement;
                            }
                            
                            viewInfo[@"allowMeme"] =
                            @([self.composeViewController isMemesInputActionEnabled]);
                            
                            __weak typeof(self) weakSelf = self;
                            [TSDispatchUtilities dispatchOnMainThread:^{
                                [weakSelf performSegue:TSkSeguePushSlideshow withViewInfo:viewInfo];
                            }];
                        }
                        
                        return YES;
                    }
                }
            }
            else if ([attach isKindOfClass:TSTableTextAttachment.class])
            {
                if (self.currentPanelInfo)
                {
                    [self.logger logPanelAction:TSkActionModuleNamePreview
                                        outCome:TSkActionOutcomePreview
                                        gesture:TSkActionGestureTap
                                       scenario:TSkScenarioMessageTable
                                   scenarioType:TSkScenarioTypePreview
                                 destinationuri:@""
                           destinationUriParams:@""
                                     moduleType:TSkScenarioTypePreview
                                    moduleState:@""
                                  moduleSummary:@""
                                      panelType:self.currentPanelInfo.type
                                       panelUri:self.currentPanelInfo.uri
                                 panelUriParams:self.currentPanelInfo.uriParams
                                       threadId:self.threadID
                                     threadType:self.currentPanelInfo.threadType];
                }
                
                [self stopPlayerIfPlaying];
                TSHTMLViewController *htmlViewController = [TSHTMLViewController new];
                htmlViewController.supportLandscapeOniPhone = YES;
                htmlViewController.html = [NSString stringWithFormat:self.legacyAppearanceProxy.isDarkTheme ? TSkTableHTMLFormatStringDarkTheme : TSkTableHTMLFormatStringLightTheme, ((TSTableTextAttachment *)attach).htmlString];
                htmlViewController.title = AXPLocalizedString(@"HTMLTableViewTitle");
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:htmlViewController];
                [self presentViewController:navigationController animated:YES completion:nil];
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (void) tappedView:(UITapGestureRecognizer*)sender
{
    if ((self.emptyStateView.state == TSkEmptyStateContactSync) || (self.emptyStateView.state == TSkEmptyStateInviteFriends))
    {
        [self.view endEditing:YES];
    }
}

- (void) updateEmptyStateWith:(TSEmptyState *)emptyStateInfo
{
    TSEmptyStates emptyState = (self.shouldConfigureForMeetings ? TSkEmptyStatePrivateMeetingChat : TSkEmptyStateChats);
    NSDictionary *viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState:emptyState  options:@{
        TSkEmptyStateKey : emptyStateInfo
    }];
    [self showEmptyStateView:YES forEmptyState:emptyState withViewInfo:viewInfo];
}

#pragma mark - TSTranslatableMessageViewControllerProtocol

- (TSChatMessageViewCell *)getMessageCellWithMessageID:(NSNumber *)messageID threadID:(NSString *)threadID
{
    for (UITableViewCell *cell in self.tableView.visibleCells)
    {
        if ([cell isKindOfClass:TSChatMessageViewCell.class])
        {
            TSChatMessageViewCell *chatCell = (TSChatMessageViewCell *)cell;
            if (chatCell != nil && [chatCell.messageID isEqualToNumber:messageID] && [chatCell.threadID compareString:threadID])
            {
                return chatCell;
            }
        }
    }
    
    return nil;
}

#pragma mark - State preservation

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    if (self.threadID)
    {
        [coder encodeObject:self.threadID forKey:TSkThreadID];
    }
    
    if (self.recipientIDs)
    {
        [coder encodeObject:self.recipientIDs forKey:TSkRecipientIDs];
    }
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSMutableDictionary *viewInfo = NSMutableDictionary.dictionary;
    NSString *threadID = [coder decodeObjectForKey:TSkThreadID];
    NSArray *recipientIDs = [coder decodeObjectForKey:TSkRecipientIDs];
    
    if (threadID)
    {
        viewInfo[TSkThreadID] = threadID;
    }
    
    if (recipientIDs)
    {
        viewInfo[TSkRecipientIDs] = recipientIDs;
    }
    
    if ([viewInfo count])
    {
        self.loadedWithViewPreservation = YES;
        [self willNavigateToSelf:viewInfo];
    }
    
    [super decodeRestorableStateWithCoder:coder];
}

#pragma mark - Data

- (id) dataAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemData = [self dataForRowAtIndexPath:indexPath inTableView:self.tableView];
    return [self messageFromItemData:itemData];
}

- (TSMessageInfo *) messageFromItemData:(NSDictionary*)itemData
{
    if (itemData[TSkIsGroupSeparator] || itemData[TSkIsSmartReply] || itemData[TSkIsConsumptionHorizonLabel])
    {
        return nil;
    }
    
    NSNumber *messageID = nil;
    if (itemData != nil)
    {
        messageID = [itemData objectForKey:@"tsID"];
    }
    
    TSMessageInfo *message = [self.messageDictionary objectForKey:messageID];
    if (!message)
    {
        LogVerboseAH(self.logger, @"Could not find message, messageId = %@, threadId = %@", messageID, self.threadID);
    }
    
    return message;
}

- (TSSMessage *)messageForCellAtIndexPath:(NSIndexPath *)indexPath
{
    TSMessageInfo *messageInfo = [self dataAtIndexPath:indexPath];
    return [AXPCtx messageForID:messageInfo.tsID andThreadID:messageInfo.threadID];
}

- (void) resetMessages
{
    __weak TSChatViewController *weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        
        [weakSelf.dataLock lock];
        weakSelf.messageDictionary = NSDictionary.dictionary;
        weakSelf.viewItems = NSArray.array;
        weakSelf.lastMessageDate = @0;
        [weakSelf.dataLock unlock];
        
        [weakSelf setVisualItemsWasEmpty:YES];
    }];
}

- (void) loadInitialMessagePage
{
    [self loadInitialMessagePageWithForcedRefresh:NO];
}

- (void) loadInitialMessagePageWithForcedRefresh:(BOOL)forcedRefresh
{
    TSWeakify(self)
    [TSDispatchUtilities dispatchOnMainThread:^{
        TSStrongifyAndReturnIfNil(self)
        
        [[TSPresenceService defaultService] getPresenceOfUsers:self.recipientIDs withAccountHandle:self.accountHandle andCompletion:nil];
        [self resetMessages];
        
        if ([self.threadID isNotNilOrEmpty])
        {
            [self showEmptyStateView:NO];
            NSNumber *horizonTime = self.initialHorizonTime ?: [[AXPCtx conversationForID:self.threadID] userConsumptionHorizonTime];
            
            // Get first page of messages
            if (!self.messageFetchEngine || ![self.messageFetchEngine.threadID isEqualToString:self.threadID])
            {
                self.messageFetchEngine = [[TSChatViewFetchEngine alloc] initWithThreadID:self.threadID
                                                                           andHorizonTime:horizonTime
                                                                              andDelegate:self];
            }
            
            if (self.scrollToMessageID)
            {
                self.messageFetchEngine.pageSize = TSkChatViewLargePageSize;
            }
            
            self.messageFetchEngine.skipServerSync = self.isAnonymouslyJoinedToCall || self.didAnonJoinCallEnd;
            [self.messageFetchEngine getNextPageFromSyncDate:nil withForcedRefresh:forcedRefresh withHighPriority:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TSkItemSelectedInDetailViewNotification
                                                                object:self.accountHandle
                                                              userInfo:@{
                TSkKeyViewControllerClassName   : NSStringFromClass(TSChatViewController.class),
                TSkDetailViewItemID : self.threadID
            }];
            
            [self updateMemberConsumptionHorizonTime];
            [self syncLatestMemberConsumptionHorizon];
            
            if (self.createGroupPerformanceScenarioID)
            {
                [self.logger logScenarioStopEvent:self.createGroupPerformanceScenarioID status:ScenarioStatusOK];
                self.createGroupPerformanceScenarioID = nil;
            }
            
            [self updateChatHeaderViewVisibilityIfNeeded];
        }
        else
        {
            [self stopActivityIndicator];
        }
        
        [self matchMentionsToRecipients];
        [self checkShouldShowPresence];
    }];
}

- (void)setItemsData:(TSArrayTableSetItemsData *)data
{
    [super setItemsData:data];
    if (!self.initialItemsHasBeenLoaded && data.items.count > 0)
    {
        NSTimeInterval loadTime = [[NSDate date] timeIntervalSinceDate:self.loadStartTime];
        self.initialItemsHasBeenLoaded = YES;
        NSDictionary *metaData = [TSUtilities metaDataFromDataBagDictionary:@{
            @"loadTime" : @(loadTime),
            @"isChatDashboardPreheatEnabled": @(self.accountHandle.policyManager.isChatDashboardPreheatEnabled),
            @"isChatDashboardEnabled": @(self.accountHandle.policyManager.isChatDashboardTabEnabled)
        }];
        [self.accountHandle.logger logPanelView:TSkPanelTypeChatRender
                                       scenario:nil
                                   scenarioType:nil
                                       metaData:metaData];
        LogInfoAH(self.logger, @"Initial render time: %f", loadTime);
        if ([self.threadID isNotNilOrEmpty])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:TSkConversationLoaded
                                                                object:self.accountHandle
                                                              userInfo:@{TSkNotificationKeyForConversation: self.threadID}];
        }
        
    }
}

#pragma mark - Notification handlers

- (void) managedObjectContextsDidReset:(NSNotification *)notification
{
    [super managedObjectContextsDidReset:notification];
    [self resetMessages];
}

- (void) appWillEnterForeground: (NSNotification *) notification
{
    if ([self readReceiptsEnabled])
    {
        [self updateConsumptionHorizon];
    }
}

- (void) appWillResignActive: (NSNotification *) notification
{
    if (![self readReceiptsEnabled])
    {
        [self updateConsumptionHorizon];
    }
}

// Add the grouping timestamps into a messageList
- (NSArray<NSDictionary *> *)messageListWithGroupTimestamps:(NSArray<NSDictionary *> *)messageList
{
    NSMutableArray *resultArray = [NSMutableArray new];
    NSDate *groupDate = nil;
    NSString *groupDateDayString = nil;
    NSString *groupTitle = nil;
    
    // Need to iterate oldest to newest to insert in the correct spot; messageList is new->old so iterate in reverse
    for (NSDictionary *message in [messageList reverseObjectEnumerator])
    {
        // Should not contain any existing separators, but check just in case
        if (message[TSkIsGroupSeparator])
        {
            LogErrorAH(self.logger, @"found existing group separator");
            continue;
        }
        
        BOOL isRetentionPolicyMsg = [message[TSkBaseType] compareString:TSkMessageTypeRetentionPolicy];
        
        NSDate *arrivalTime = [message[TSkArrivalTime] dateFromSkypeDate];
        NSString *arrivalTimeDayString = [[arrivalTime dayString] uppercaseString];
        
        // If more than an N time between messages, or starting a new day = start a new grouping
        // Skip last-read indicator, so date header is after the last read line
        if ((fabs([arrivalTime timeIntervalSinceDate:groupDate]) > TSkSessionGroupingTimeoutMinutes * 60.0 ||
             ![arrivalTimeDayString isEqualToString:groupDateDayString]) &&
            !([message[TSkBaseType] compareString:TSkMessageTypeLastReadMsgIndicator] ||
              [message[TSkBaseType] compareString:TSkMessageTypePreviousConversationMsg] ||
              isRetentionPolicyMsg))
        {
            groupDate = arrivalTime;
            groupDateDayString = arrivalTimeDayString;
            groupTitle = [groupDate standardSortableDateTimeMillisecond];
            
            // Grouping separator cell
            // Needs a unique tsID for cell height caching, double message's ID so won't overlap any existing ID (plenty of space in longLong value)
            [resultArray insertObject:@{
                TSkIsGroupSeparator : @(YES),
                TSkSortDate : groupTitle,
                TSkArrivalTime : message[TSkArrivalTime],
                TSktsID : @([message[TSktsID] longLongValue] * 2),
                TSkVersion : message[TSkVersion] ?: @(0),
            } atIndex:0];
        }
        
        // For certain messages we don't want to show grouping date, however this date is used to sort sections of messages in chat
        NSMutableDictionary *updatedMessage = message.mutableCopy;
        updatedMessage[TSkSortDate] = isRetentionPolicyMsg ? [arrivalTime standardSortableDateTimeMillisecond] : groupTitle;
        
        
        // messageList is enumerated in reverse, insert at 0 to keep the original order when building the results
        [resultArray insertObject:updatedMessage atIndex:0];
    }
    
    return resultArray;
}

- (BOOL) animateNewItemInsert
{
    return self.accountHandle.ecsManager.isChatNewItemInsertAnimationEnabled;
}

- (BOOL)shouldExcludeMessageFromConversation:(TSSMessage *)message
{
    if ([message ts_botCardData] == nil) {
        return NO;
    }
    
    if ([message isConnectorMessage] && [message isDeleted])
    {
        return YES;
    }
    
    id cards = [NSKeyedUnarchiver unarchivedObjectOfClass:NSObject.class fromData:[message ts_botCardData] error:nil];
    if ([cards isKindOfClass: NSArray.class] && [(NSArray *)cards count] > 0)
    {
        id consentCard = [NSKeyedUnarchiver unarchivedObjectOfClass:NSObject.class fromData:[cards firstObject] error:nil];
        if ([consentCard isKindOfClass:TSFileConsentCard.class] && [message isDeleted])
        {
            return YES;
        }
    }
    return NO;
}

- (void) updateWithMessageList:(NSArray*)newMessageList withMessageDictionary:(NSDictionary *)messageDictionary
{
    [self stopScenarioMarker:NO messageDictionary:messageDictionary];
    __weak TSChatViewController *weakSelf = self;
    __block NSArray *messageList = [self messageListWithGroupTimestamps:newMessageList];
    
    if ([messageList count] == 0)
    {
        [TSDispatchUtilities dispatchOnMainThread:^{
            [weakSelf hideInvertedPulldownSpinner];
            [weakSelf stopActivityIndicator];
            if (self.isLoadingIndicatorInChatEnabled)
            {
                [weakSelf setActivitySpinnerWithText:nil showSpinner:NO];
            }
        }];
        return;
    }
    
    [self saveLastMessageID:messageList];
    
    [TSDispatchUtilities dispatchOnMainThread:^{
        if ([self readReceiptsEnabled] &&
            ![self isLastMessageSentByMe:messageList] &&
            (AXPApp.applicationState == UIApplicationStateActive))
        {
            [self updateConsumptionHorizon];
        }
        
        BOOL shouldUpdatePresenceStatusFromMessageList = ![self.viewItems count]; // update presence from message list only for the first time
        [self updateTable:^{
            
            [weakSelf hideInvertedPulldownSpinner];
            
            weakSelf.lastMessageDisplayTime = [[NSDate date] skypeTimeInterval];
            if (weakSelf.accountHandle.policyManager.isSmartReplyEnabled)
            {
                LogInfoAH(weakSelf.logger, @"SmartReply: last message id %@", messageList[0][TSktsID]);
                messageList = [weakSelf messageListWithSmartReply:messageList withMessageDictionary:messageDictionary];
            }
            if (weakSelf.accountHandle.policyManager.isMsgAnimationsEnabled)
            {
                weakSelf.hasUnreadMessages = [[AXPCtx conversationForID:self.threadID] hasUnreadMessages];
            }
            
            // Avoid flickering with redraws if view is already displaying the identical list
            if ([weakSelf isAlreadyDisplayingMessageList:messageList withMessageDictionary:messageDictionary])
            {
                return;
            }
            
            [weakSelf.dataLock lock];
            BOOL wasEmpty = (weakSelf.viewItems.count == 0);
            weakSelf.viewItems = messageList;
            weakSelf.messageDictionary = messageDictionary;
            [weakSelf.dataLock unlock];
            
            // Clear Adaptive Cards Cache for message updates fetched from Message Fetch engine
            if (![self.accountHandle.ecsManager optimiseAdaptiveCardCache])
            {
                [weakSelf clearAdaptiveCardCacheForMessageList:messageList];
            }
            
            [weakSelf updateTypingIndicatorStateForMessageList:messageList];
            [weakSelf updateConsumptionHorizonLabelCells];
            [weakSelf setVisualItemsWasEmpty:wasEmpty];
            
            BOOL isSFBChat = [weakSelf isSfBInteropChat];
            BOOL isSFCChat = [weakSelf isSfCInteropChat];
            BOOL showEmptyState = (isSFBChat || isSFCChat) && weakSelf.viewItems.count == 0;
            
            [weakSelf showEmptyStateView:showEmptyState];
            
            [weakSelf showJoinBannerIfRequiredFromMessageListUpdate];
            [weakSelf updateChatHeaderViewVisibilityIfNeeded];
            
            if (shouldUpdatePresenceStatusFromMessageList)
            {
                [weakSelf updatePresenceStatusIfRequiredFromMessageList:messageList];
            }
            else
            {
                [weakSelf updatePresenceStatus];
            }
            
            [weakSelf stopChatRenderScenarioMarker];
        }];
    }];
}

#pragma mark - TSMessageFetchEngineDelegate
- (void) updateTypingIndicatorStateForMessageList:(NSArray *)messages
{
    for (NSString *userID in self.userIdDict.allKeys)
    {
        NSString *clientMessageID = self.userIdDict[userID][TSKKeyClientMessageID];
        NSPredicate *predicate = nil;
        NSArray *filteredArray = nil;
        
        // Close typing indicator if there is any message after typing control msg from the user.
        NSNumber *msgArrivalTime = self.userIdDict[userID][TSKKeyMessageReceiveTime];
        predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND arrivalTime >= %@", userID, msgArrivalTime];
        
        filteredArray = [messages filteredArrayUsingPredicate:predicate];
        
        NSDictionary *messageInfo = [filteredArray firstObject];
        if (messageInfo)
        {
            LogVerboseAH(self.logger, @"[ChatVC]: clientID: %@ matched for userID: %@. removing typing indicator.", clientMessageID, userID);
            [self dismissTypingIndicatorForUser:messageInfo[TSKKeyUserID] didReceiveChatMessage:YES];
        }
    }
}

- (void) unreadMessagesAvailable
{
    __weak typeof(self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^
     {
        [weakSelf.messageScrollBackStack removeAllObjects];
        [weakSelf.unreadIndicator updateLabelWithStringIdentifier:@"NewMessagesLabel"];
        
        if (fequal(weakSelf.tableView.contentOffset.y, 0.0f) || weakSelf.tableView.contentOffset.y < 0)
        {
            // If user is viewing latest messages and a new message arrives,
            // Display it without showing the UnreadIndicator
            [weakSelf scrollToUnread:nil];
        }
        else if (weakSelf.unreadIndicator.hidden == YES)
        {
            [weakSelf showUnreadIndicator];
        }
    }];
}

- (void) setTranslationSpinnerWithMessageIDs:(NSArray<NSNumber *> *)messageIDs showSpinner:(BOOL)showSpinner
{
    if (showSpinner)
    {
        [self.messageIDListToStartTranslationSpinner addObjectsFromArray:messageIDs];
    }
    else
    {
        for (NSNumber *messageID in messageIDs)
        {
            [self.messageIDListToStartTranslationSpinner removeObject:messageID];
        }
    }
}

- (void) updateWithTranscriptMessages:(NSArray *)messages
{
    [self.transcriptViewModel updateTranscriptMessages:messages];
}

- (BOOL)shouldCompareSetItemsToSkipRefresh
{
    return YES;
}

- (void) setVisualItems
{
    [self setVisualItemsWasEmpty:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(![self.accountHandle.ecsManager isRefreshForAdaptiveCardsEnabled])
    {
        return;
    }
    
    for (UITableViewCell *cell in self.tableView.visibleCells)
    {
        if ([cell isKindOfClass:TSChatMessageViewCell.class])
        {
            TSChatMessageViewCell *chatMessageCell = (TSChatMessageViewCell *)cell;
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
            NSDictionary *itemData = [self dataForRowAtIndexPath:indexPath inTableView:self.tableView];
            TSMessageInfo *messageInfo = [self messageFromItemData:itemData];
            NSNumber *msgID = messageInfo.tsID.copy;
            NSDate *arrivalTime = messageInfo.arrivalTime.copy;
            NSMutableString *key = [[self.adaptiveCardsUtility createKeyFromMessageID:msgID andTimeStamp:arrivalTime] mutableCopy];
            NSString *cardClientId = itemData[TSkCardClientId];
            if ([cardClientId isValidString])
            {
                [key appendString:cardClientId];
            }
            TSCAdaptiveCardsActionHandler *cardActionHandler = [self.adaptiveCardsCache getAdaptiveCardsDelegateFromKey:[key copy]];
            UIView *cardView = [self.adaptiveCardsCache getAdaptiveCardsView:cardActionHandler.cacheKey];
            if(cardActionHandler.isMessagingExtension)
            {
                cardView = chatMessageCell.messageStackView;
            }
            
            if(!cardActionHandler || !cardView)
            {
                continue;
            }
            [self.adaptiveCardsUtility processCardRefresh:TSAdaptiveCardAutoRefreshOnScroll
                                              withHandler:cardActionHandler
                                             withCardView:cardView
                                           forMessageInfo:messageInfo
                                   forTableViewController:self];
        }
    }
}

- (void) setVisualItemsWasEmpty:(BOOL)wasEmpty
{
    __weak TSChatViewController *weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        // This will reload the tableView
        [weakSelf setItems:weakSelf.viewItems idKey:@"tsID" sectionKey:@"sortDate" animated:YES];
        
        // Reloading table can stop animation when scrolling to the top, re-issue scroll
        if (weakSelf.isScrollingToTop)
        {
            weakSelf.scrollToMessageID = nil;
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        if (weakSelf.scrollToMessageID)
        {
            NSIndexPath *scrollToIndexPath = weakSelf.itemLookupMap[weakSelf.scrollToMessageID];
            if (scrollToIndexPath)
            {
                LogInfoAH(weakSelf.logger, @"Chat scrollToMessage index %lu", [weakSelf rowIndexForIndexPath:scrollToIndexPath]);
                
                [weakSelf scrollToIndexPath:scrollToIndexPath forceTop:NO animated:!wasEmpty];
                [AXPInstrumentationManager.sharedInstance stopAppLaunchPerfScenarios:YES];
                if ([weakSelf.scrollToMessageScenarioID isNotNilOrEmpty])
                {
                    [weakSelf.accountHandle.logger logScenarioStopEvent:weakSelf.scrollToMessageScenarioID status:ScenarioStatusOK];
                    weakSelf.scrollToMessageScenarioID = nil;
                }
            }
            else if ([weakSelf numberOfSections] > 0)
            {
                NSNumber *lastMessageDate = weakSelf.lastMessageDate;
                weakSelf.lastMessageDate = [weakSelf itemsForSection:weakSelf.numberOfSections - 1].lastObject[@"arrivalTime"];
                
                // look at last msg date to prevent re-fetching same batch of messages again and again.
                if ((lastMessageDate && ![lastMessageDate isEqualToNumber:weakSelf.lastMessageDate]))
                {
                    //Not found, need to load more items
                    [weakSelf.messageFetchEngine getNextPageFromSyncDate:weakSelf.lastMessageDate];
                    if (weakSelf.isLoadingIndicatorInChatEnabled)
                    {
                        //Show loading indicator
                        [weakSelf setActivitySpinnerWithText:AXPLocalizedString(@"loadOldMsg")
                                                 showSpinner:YES];
                    }
                }
            }
        }
    }];
}

- (BOOL) supportsLastReadWatermark
{
    return YES;
}

- (BOOL) shouldShowNativeFederationChatMessageInMoc:(NSManagedObjectContext *)moc
{
    return self.isNativeFedChatEnabled && [self isSfBInteropChat] && [self isFederatedUserWithTeamsOnlyInMoc:moc];
}

- (BOOL) shouldShowPreviousFederationChatMessageInMoc:(NSManagedObjectContext *)moc
{
    TSThreadProperty *previousFederationProperty = [AXPCtx threadPropertyForThreadID:self.threadID andPropertyName:TSkThreadPropertyPreviousFederationThreadID inMoc:moc];
    NSString *previousFederationID = previousFederationProperty.propertyValue.asString;
    return self.isNativeFedChatEnabled && [self isOneToOneChat] && [self isFederatedUserWithTeamsOnlyInMoc:moc] && [previousFederationID isNotNilOrEmpty];
}

- (BOOL) shouldShowRetentionHorizonIndicator
{
    return self.accountHandle.ecsManager.isRetentionPruneEnabledOnECS;
}

#pragma mark - Unread indicator
- (void)loadLatestOnScroll
{
    // Fetch the new messages
    [self.messageFetchEngine fetchNewMessages];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissBotMenu];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL scrollingToNewMessages = self.scrollLastContentOffset.y > self.tableView.contentOffset.y;
    
    if (scrollingToNewMessages &&
        self.unreadIndicator.hidden == NO &&
        self.unreadIndicatorTapped == NO &&
        self.tableView.contentOffset.y < self.tableView.frame.size.height)
    {
        // If user scrolls to the first frame, then hide UnreadIndicator and display the new messages
        [self scrollToUnread:nil];
    }
    
    self.scrollLastContentOffset = self.tableView.contentOffset;
    
    if (self.typingIndicatorViewHeight.constant == 0)
    {
        float percentage = scrollView.contentOffset.y / TSkComposeViewShadowScrollThreshold;
        percentage = percentage > 1.0f ? 1.0f : percentage;
        percentage = percentage < 0.0f ? 0.0f : percentage;
        
        if (self.composeView.layer.shadowOpacity != percentage * self.legacyAppearanceProxy.composeShadowOpacity)
        {
            [self setTopShadowCompletionRatio:percentage];
        }
    }
    
    [self applyDynamicDecorationIfNeeded];
    [super scrollViewDidScroll:scrollView];
}

- (void) applyDynamicDecorationIfNeeded
{
    if (self.dynamicDecorationType != DynamicDecorationTypeNone) {
        [self.tableView applyGradientDecorationForVisibleCellsWithGradient:self.bubbleGradient];
    }
}

- (void) setTopShadowCompletionRatio:(CGFloat)completionRatio
{
    CGRect reducedFrame = CGRectMake(TSkComposeViewShadowEdgePadding, TSkComposeViewShadowVerticalOffset, self.composeView.frame.size.width - (TSkComposeViewShadowEdgePadding * 2), self.composeView.frame.size.height);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:reducedFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(TSkComposeViewShadowCornerRadius, TSkComposeViewShadowCornerRadius)];
    
    self.composeView.layer.shadowColor = self.legacyAppearanceProxy.composeShadowColor.CGColor;
    self.composeView.layer.shadowPath = roundedRect.CGPath;
    self.composeView.layer.shadowRadius = self.legacyAppearanceProxy.composeShadowRadius;
    self.composeView.superview.clipsToBounds = NO;
    self.composeView.layer.shadowOpacity = self.legacyAppearanceProxy.composeShadowOpacity * completionRatio;
}

#pragma mark = Push delegate support

- (BOOL) shouldDisplayNotification:(NSDictionary *)notificationInfo;
{
    NSDictionary *userInfo = notificationInfo[@"userInfo"];
    
    NSNumber *typeNumber = userInfo[TSkPushNotificationType];
    TSNotificationType type = (TSNotificationType)typeNumber.intValue;
    if (type == TSkNTSendFailed)
    {
        return YES;
    }
    
    if (userInfo[TSkThreadID] && self.threadID.length)
    {
        if ([self.threadID isEqualToString:userInfo[TSkThreadID]])
        {
            // Can send from 1 account to another on the same device, don't suppress
            TSAccountHandle *pushHandle = [TSAccountManager.sharedInstance accountHandleForAccount:userInfo[TSkAccountIdKey]
                                                                                          tenantId:userInfo[TSkTenantIdKey]];
            if (pushHandle && ![self.accountHandle isSame:pushHandle])
            {
                return YES;
            }
            
            return NO;
        }
    }
    return [super shouldDisplayNotification:notificationInfo];
}

#pragma mark - TSBotCardActionDelegate

// Called when the bot card is selected
- (void) botCardSelectedWithProperties:(NSDictionary*)actionParams withTapUrl:(NSString*)url
{
    if ([url isNotNilOrEmpty])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]
                                           options:@{}
                                 completionHandler:nil];
    }
}

- (void)botImageSelectedWithUrl:(NSURL *)url {
    // We have only single selected image here to be presented in full screen for pinch and zoom
    if( !url ) {
        return;
    }
    
    AXSlideshowData *slideShowData = [self.slideshowHandler slideShowDataFromImageUrls:@[url]];
    if (!slideShowData) {
        // If there is no slideshow data dont present full screen controller for image.
        return;
    }
    NSDictionary *viewInfo = @{
        @"slideshowData" : slideShowData,
    };
    
    __weak typeof(self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        [weakSelf performSegue:TSkSeguePushSlideshow withViewInfo:viewInfo];
    }];
}

- (void) scrollToBottomForBotMessage
{
    [self.tableView sam_scrollToTopAnimated:YES];
}

#pragma mark - TSProfileCardDelegate

- (void) emailButtonClicked:(NSString *)userUPN
{
    NSString *mailTo = [NSString stringWithFormat:@"mailto:%@", userUPN];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailTo]
                                       options:@{}
                             completionHandler:nil];
}

- (void) orgChartButtonClicked:(NSString *)userMRI
{
    TSUser* user = [AXPCtx userForID:userMRI inMoc:self.accountHandle.mainMOC];
    
    NSDictionary *finalDict = @{@"mri": [user tsID] ?: @"",
                                @"displayName": [user displayName] ?: @"",
                                @"principalName": [user userPrincipalName] ?: @"",
                                @"userIdType": @"mri",
                                @"jobTitle": [user jobTitle] ?: @""
    };
    
    [SDKModuleUtilities openModuleWithModuleId:TSkOrgChartModuleId
                                     andParams:[finalDict jsonString]
                            fromViewController:self
                                      scenario:TSkOrgChartModuleName];
}

- (void) chatButtonClicked:(NSString *)userMRI
{
    if ([userMRI isNotNilOrEmpty])
    {
        [self performSegue:TSkSeguePushChatMultiView
              withViewInfo:@{ TSkRecipientIDs : @[userMRI] }];
    }
}

- (void) callButtonClicked:(NSString *)userMRI withDisplayName:(NSString *)displayName
{
    NSString *scenarioName = [self placeOneToOneCallScenarioName];
    NSString *scenarioID = [[NSUUID UUID] UUIDString];
    NSString *correlationID = [TSkCorrelationTagPlaceCall stringByAppendingString:scenarioID];
    [self.accountHandle.logger logStartScenarioEventOfType:scenarioName
                                             correlationID:correlationID
                                                scenarioID:scenarioID
                                            withProperties:@{SCENARIO_SOURCE: @"profileCard"}];
    [TSCallNavigationUtilities showDelegatorsAndPlaceCallFrom:self
                                          isSendingLocalVideo:NO
                                                  containerId:nil
                                                 recipientIds:@[userMRI]
                                        recipientDisplayNames:@[displayName]
                                                correlationID:correlationID
                                                  isVoicemail:NO
                                                accountHandle:self.accountHandle
                                                     animated:YES
                                                   completion:nil];
}

- (void) videoCallButtonClicked:(NSString *)userMRI withDisplayName:(NSString *)displayName
{
    NSString *scenarioName = [self placeOneToOneCallScenarioName];
    NSString *scenarioID = [[NSUUID UUID] UUIDString];
    NSString *correlationID = [TSkCorrelationTagPlaceCall stringByAppendingString:scenarioID];
    [self.accountHandle.logger logStartScenarioEventOfType:scenarioName
                                             correlationID:correlationID
                                                scenarioID:scenarioID
                                            withProperties:@{SCENARIO_SOURCE: @"profileCard"}];
    
    [TSCallNavigationUtilities navigateAndStartCallFrom:self
                                    isSendingLocalVideo:YES
                                            containerId:self.threadID
                                          rootMessageId:@"0"
                                              messageID:nil
                                           recipientIds:@[userMRI]
                                  recipientDisplayNames:@[displayName]
                                          correlationID:correlationID
                                            isVoicemail:NO
                                               animated:YES
                                          accountHandle:self.accountHandle
                                         callParameters:nil
                                             completion:nil];
}

#pragma mark - TSFileConsentCardDelegate

- (AXPAppViewController *) orchestrationViewControllerForFileConsentCardView: (TSPFileConsentCardView *)consentView
{
    return self;
}

- (BOOL) fileConsentCardView: (TSPFileConsentCardView *)consentView
 shouldAcceptWithCardContent:(TSFileConsentCard *)cardContent
{
    /// We need to ensure that the bot is capable of file support and this request is legitimate.
    if ([self isPrivateChatWithBot])
    {
        return [TSPlatformConstants isBotAttachmentsAvailableForUserId:self.accountHandle.MRI
                                                                 botId:self.recipientIDs[0]
                                                               withMOC:self.accountHandle.mainMOC];
    }
    return NO;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && otherGestureRecognizer == self.longPressedOnCellGesture)
    {
        // giving priority to opening context menu, handle no long Presses until opening Context Menu fails
        // happens in case of adaptive cards, as adpative cards all gestures are long press, we dont want both gestures to happen
        return YES;
    }
    // if the table is being panned by clicking on an adaptive card then we should wait for the pan to fail then only invoke the adaptive card gesture
    // adaptive cards gesture are longpress gestures, so if the gesture is not self.longPressedOnCellGesture but is a longPressgesture
    // its an adaptive card long press gesture we shud then wait for the pan to fail, if its being panned
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && gestureRecognizer != self.longPressedOnCellGesture){
        return YES;
    }
    
    return NO;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass: [TSBotCardButton class]] && gestureRecognizer != self.longPressedOnCellGesture)
    {
        return NO;
    }
    else if (gestureRecognizer == self.tappedOnCellGesture)
    {
        CGPoint rowLocation = [touch locationInView:self.tableView];
        NSIndexPath *path = [self.tableView indexPathForRowAtPoint:rowLocation];
        if (path)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
            if ([cell isKindOfClass:TSChatMessageViewCell.class])
            {
                TSChatMessageViewCell *chatMessageCell = (TSChatMessageViewCell *)cell;
                if (![chatMessageCell.messageStackView isHidden])
                {
                    for (UIView *subview in [chatMessageCell.messageStackView subviews])
                    {
                        if (subview.tag == TSkAdaptiveCardIdentifierTag && [touch.view isDescendantOfView:subview])
                        {
                            return NO;
                        }
                        else if ([subview isKindOfClass:TSAudioAttachmentView.class] && [touch.view isDescendantOfView:subview])
                        {
                            return NO;
                        }
                    }
                }
                CGPoint location = [touch locationInView:chatMessageCell.linkPreviewStackView];
                if (CGRectContainsPoint(chatMessageCell.linkPreviewStackView.bounds, location) && chatMessageCell.linkPreviewStackView.subviews)
                {
                    return NO;
                }
                
                return YES;
            }
            else if ([cell isKindOfClass:TSSmartReplyCell.class])
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
        return NO;
    }
    else if (gestureRecognizer == self.doubleTappedOnCellGesture || gestureRecognizer == self.tripleTappedOnCellGesture)
    {
        CGPoint rowLocation = [touch locationInView:self.tableView];
        NSIndexPath *path = [self.tableView indexPathForRowAtPoint:rowLocation];
        if (path)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
            if ([cell isKindOfClass:TSChatMessageViewCell.class])
            {
                if ([TSConversation didUserLeaveChatwithThreadID:self.threadID] || self.isAnonymouslyJoinedToCall || self.didAnonJoinCallEnd || [self shouldDisableFedChatComposeOptions])
                {
                    return NO;
                }
                TSChatMessageViewCell *chatMessageCell = (TSChatMessageViewCell *)cell;
                CGPoint location = [touch locationInView:chatMessageCell.internalContentView];
                if (!CGRectContainsPoint(chatMessageCell.internalContentView.bounds, location))
                {
                    return NO;
                }
                location = [touch locationInView:chatMessageCell.linkPreviewStackView];
                if (CGRectContainsPoint(chatMessageCell.linkPreviewStackView.bounds, location))
                {
                    return NO;
                }
                location = [touch locationInView:chatMessageCell.fileAttachmentStackView];
                if (CGRectContainsPoint(chatMessageCell.fileAttachmentStackView.bounds, location))
                {
                    return NO;
                }
                if (![chatMessageCell.messageStackView isHidden])
                {
                    for (UIView *subview in [chatMessageCell.messageStackView subviews])
                    {
                        if ([subview isKindOfClass:TSAudioAttachmentView.class] && [touch.view isDescendantOfView:subview])
                        {
                            TSAudioAttachmentView *audioAttachmentView = (TSAudioAttachmentView *)subview;
                            CGPoint location = [touch locationInView:audioAttachmentView.playButton];
                            if (CGRectContainsPoint(audioAttachmentView.playButton.bounds, location))
                            {
                                return NO;
                            }
                        }
                    }
                }
            }
            else
            {
                return NO;
            }
        }
    }
    else if (gestureRecognizer == self.tappedOnEmptyStateGesture && (self.emptyStateView.state != TSkEmptyStateContactSync) && (self.emptyStateView.state != TSkEmptyStateInviteFriends))
    {
        return NO;
    }
    return YES;
}

- (void) updateChatMessages:(NSNotification*) notification
{
    // There is a notification that tells us that some translation settings have changed while being on the Chat.
    // We need to refresh the translation mode to ensure it is the correct value,
    // and refresh the chat taking into account the most updated settings.
    self.translationMode = [TSTranslationManager getTranslationModeSetting:self.accountHandle];
    
    NSNumber *lastMessageDate = @0;
    [self.dataLock lock];
    NSDictionary *lastItem = [self.viewItems lastObject];
    if (lastItem)
    {
        lastMessageDate = lastItem[@"arrivalTime"];
    }
    [self.dataLock unlock];
    
    if (!lastMessageDate)
    {
        return;
    }
    
    if (self.translationMode == TSTranslationModeSettingAlwaysTranslate)
    {
        // Auto translate all messages.
        [self.messageFetchEngine translateMessagesMoreRecentThan:lastMessageDate];
    }
    else
    {
        // Refresh chat messages.
        [self.messageFetchEngine getMessageList:lastMessageDate
                                  includeLatest:YES
                                            moc:self.accountHandle.mainMOC
                                     completion:^(NSMutableArray<TSSMessage *> * _Nonnull messageObjectList, NSError *error)
         {
            __weak typeof(self) weakSelf = self;
            for (TSSMessage *message in messageObjectList)
            {
                NSIndexPath *indexPath = weakSelf.itemLookupMap[message.tsID];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
}

- (void) refreshData
{
    if (!self.threadID)
    {
        LogWarningAH(self.logger, @"threadID not set yet. can't load more message");
        return;
    }
    
    // load-more only after the initial load
    if (!self.hasAppeared)
    {
        return;
    }
    
    NSNumber *lastMessageDate = @0;
    
    [self.dataLock lock];
    NSUInteger viewItemCount = self.viewItems.count;
    NSDictionary *lastItem = [self.viewItems lastObject];
    if (lastItem)
    {
        lastMessageDate = lastItem[@"arrivalTime"];
    }
    [self.dataLock unlock];
    
    if (!lastMessageDate)
    {
        return;
    }
    
    // Avoid loading the same page if last msg date/ msg count hasn't changed
    if ((self.lastMessageDate && ![self.lastMessageDate isEqualToNumber:lastMessageDate]) || (self.lastViewItemCount != viewItemCount))
    {
        self.lastMessageDate = lastMessageDate;
        self.lastViewItemCount = viewItemCount;
        
        LogVerboseAH(self.logger, @"loading message older than :%@ currentViewItemCount:%lu", lastMessageDate, (unsigned long)viewItemCount);
        [self.messageFetchEngine getNextPageFromSyncDate:self.lastMessageDate];
        
        [self showInvertedPulldownSpinner];
    }
}

- (BOOL)accessibilityScroll:(UIAccessibilityScrollDirection)direction
{
    return [self handleAccessibilityReviseScrolling:direction];
}

- (void) setThreadID:(NSString *)threadID
{
    _threadID = threadID;
    
    // Cache chat id in the MRU for sync order
    if (![NSString isNilOrEmpty:threadID])
    {
        [self.accountHandle.mruCache addChatIDToMRU:self.threadID];
    }
    
    [self updateThreadInfo];
    self.outerViewController.biThreadType = self.biThreadType;
    // sync native/previous federation thread if needed
    if ([threadID isNotNilOrEmpty])
    {
        [TSDispatchUtilities dispatchOnMainThread:^
         {
            [self nativeFederationChatPreFetch];
            [self updateDisabledReason];
        }];
    }
    
    // Pass the threadID to outerViewController iff toView is hidden and not in group adding participants phase;
    // else this threadID may not be the final threadID.
    __weak typeof(self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        if ([threadID isNotNilOrEmpty])
        {
            TSConversation *conversation = [AXPCtx conversationForID:threadID];
            self.isV2Thread = conversation.isV2Conversation;
            
            if ([weakSelf.toView isHidden] && self.groupChatCreationState != TSGroupChatCreationStateAddingParticipants)
            {
                [weakSelf.outerViewController didReceiveThreadID:threadID withThreadType:weakSelf.biThreadType chatType:weakSelf.biChatType];
            }
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([threadID isNotNilOrEmpty] && strongSelf)
        {
            // reinit the mentions fetcher so we can now use it to get relevant results.
            strongSelf.composeViewController.mentionsFetcher = [[TSMentionsFetcher alloc] initWithThreadID:threadID
                                                                                             accountHandle:strongSelf.accountHandle
                                                                                                  delegate:strongSelf.composeViewController];
        }
    }];
}

- (void) updateThreadInfo
{
    __weak typeof (self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        __strong typeof (self) strongSelf = weakSelf;
        [strongSelf calculateThreadType];
        [strongSelf checkShouldShowPresence];
        [strongSelf chatConversationsUpdated:nil];
        if (strongSelf.isViewLoaded)
        {
            [strongSelf.composeViewController setupToolbars];
            [strongSelf.composeViewController restoreCurrentDraft];
        }
        [strongSelf extractBIThreadAndChatType];
        strongSelf.currentPanelInfo = [strongSelf biPanelInfo];
        [strongSelf updateThreadTelemetryProperties];
    }];
}

- (void) updateThreadTelemetryProperties
{
    [[self.accountHandle.logger teamChannelThreadInfo] setObject:self.threadID ?: @"" forKey:TSkTelemetryThreadID];
    [[self.accountHandle.logger teamChannelThreadInfo] setObject:self.biThreadType ?: @"" forKey:TSkTelemetryThreadType];
    [[self.accountHandle.logger teamChannelThreadInfo] setObject:self.biChatType ?: @"" forKey:TSkTelemetryChatType];
    [[self.accountHandle.logger teamChannelThreadInfo] setObject:self.biThreadMembersCount.stringValue ?: @"" forKey:TSkTelemetryThreadMembers];
}

- (void) setShouldShowPresenceOnTitle:(BOOL)shouldShowPresenceOnTitle
{
    _shouldShowPresenceOnTitle = shouldShowPresenceOnTitle;
    TSWeakify(self)
    [TSDispatchUtilities dispatchOnMainThread:^{
        TSStrongifyAndReturnIfNil(self)
        TSDropdownWithPresenceTitleView *titleView = self.titleView;
        titleView.userMri = [self.recipientIDs firstObject];
        titleView.presenceEnabled = shouldShowPresenceOnTitle;
    }];
}

- (void) setCurrentPresenceStatus:(TSPresenceStatus)presenceStatus
{
    if (_currentPresenceStatus != presenceStatus)
    {
        _currentPresenceStatus = presenceStatus;
        TSWeakify(self)
        [TSDispatchUtilities dispatchOnMainThread:^{
            TSStrongifyAndReturnIfNil(self)
            [self updateSubtitleText];
        }];
    }
}

- (BOOL) isBotConversationBlocked
{
    TSThreadProperty *threadProperty = [AXPCtx threadPropertyForThreadID:self.threadID
                                                         andPropertyName:TSkThreadPropertyMessagingDisabled
                                                                   inMoc:self.accountHandle.mainMOC];
    if (threadProperty)
    {
        NSString *isConversationBlocked = (NSString *)threadProperty.propertyValue;
        if (isConversationBlocked.boolValue)
        {
            return YES;
        }
    }
    
    return NO;
}

// Used to check if 1:1 chats with user is disabled (generic flag) - currently used for IB policy
- (BOOL) isConversationDisabled
{
    if (!self.threadID)
    {
        return NO;
    }
    
    TSThreadProperty *threadProperty = [AXPCtx threadPropertyForThreadID:self.threadID
                                                         andPropertyName:TSkThreadPropertyIsDisabled
                                                                   inMoc:self.accountHandle.mainMOC];
    if (threadProperty)
    {
        NSNumber *isDisabled = (NSNumber *)threadProperty.propertyValue;
        if (isDisabled.boolValue)
        {
            return YES;
        }
    }
    
    return NO;
}

- (NSDictionary *) fetchDisabledReason
{
    if (!self.threadID)
    {
        return nil;
    }
    
    TSThreadProperty *threadProperty = [AXPCtx threadPropertyForThreadID:self.threadID
                                                         andPropertyName:TSkThreadPropertyDisabledReason
                                                                   inMoc:self.accountHandle.mainMOC];
    if (!threadProperty)
    {
        return nil;
    }
    
    NSDictionary *disabledReason = (NSDictionary *)threadProperty.propertyValue;
    if (!disabledReason || ![disabledReason isKindOfClass:NSDictionary.class])
    {
        return nil;
    }
    
    return disabledReason;
}

- (void) updateDisabledReason
{
    self.disabledReason = [self fetchDisabledReason];
}

- (NSString *) getDisabledReasonProp:(NSString *)propName
{
    if (!self.disabledReason || ![self.disabledReason isKindOfClass:NSDictionary.class])
    {
        return nil;
    }
    
    NSString *value = self.disabledReason[propName];
    return [value isKindOfClass:NSString.class] ? value : nil;
}

- (NSString *) disabledReasonCode
{
    return [self getDisabledReasonProp:TSkThreadPropertyDisabledReasonCode];
}

- (NSString *) disabledReasonUserId
{
    return [self getDisabledReasonProp:TSkThreadPropertyDisabledReasonUserId];
}

- (BOOL) hasDisabledReason
{
    return [self.disabledReasonCode isNotNilOrEmpty];
}

- (NSString *) localizedDisabledReasonForUserName:(NSString *)name
{
    NSString *reason = [self disabledReasonCode];
    
    if ([reason isEqualToString:TSkThreadPropertyDisabledReasonCodeOptedOut])
    {
        return [NSString stringWithFormat:AXPLocalizedString(@"ChatDisabledMessageOptedOut"), name];
    }
    if ([reason isEqualToString:TSkThreadPropertyDisabledReasonCodeDeprovisioned])
    {
        return [NSString stringWithFormat:AXPLocalizedString(@"ChatDisabledMessageDeprovisioned"), name];
    }
    if ([reason isEqualToString:TSkThreadPropertyDisabledReasonCodeClaimed])
    {
        return [NSString stringWithFormat:AXPLocalizedString(@"ChatDisabledMessageClaimed"), name];
    }
    
    return AXPLocalizedString(@"ChatDisabledMessage");
}

- (NSString *) localizedDisabledComposerButton
{
    NSString *reason = [self disabledReasonCode];
    
    if ([reason isEqualToString:TSkThreadPropertyDisabledReasonCodeDeprovisioned])
    {
        return AXPLocalizedString(@"ChatDisabledMessageDeprovisionedButton");
    }
    if ([reason isEqualToString:TSkThreadPropertyDisabledReasonCodeClaimed])
    {
        return AXPLocalizedString(@"ChatDisabledMessageClaimedButton");
    }
    
    return nil;
}

#pragma mark - BotsSSO related methods

- (void)startSilentAuthForBotSSOWithNotification:(NSNotification *)notification
{
    TSThread *thread = [AXPCtx threadForID:self.threadID];
    NSString *botID = [thread botIdFromBotChat];
    
    /// Start silent auth and show banner if this fails
    [self.ssoAuthManager getAuthTokenSilentlyForBotId:botID
                                             threadId:self.threadID
                                    completionHandler:nil];
}

#pragma mark - TSPlatformAuthManagerProtocol

- (AXPAppViewController *)ssoOrchestrationViewController
{
    return self;
}

#pragma mark - TypingIndicatorView related methods

- (void) controlTypingMessageReceived:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSString *userID  = [info objectForKey:TSKKeyUserID];
    
    if (self.isAnonymouslyJoinedToCall)
    {
        LogInfoAH(self.logger, @"Anon user; dropping control/typing message. userID:%@", [userID scrubMriIfPII:self.accountHandle]);
        return;
    }
    
    if ([NSString isNilOrEmpty:userID])
    {
        LogInfoAH(self.logger, @"control/typing msg dropped. userID is nil.");
        return;
    }
    
    NSString *conversationID = [info objectForKey:TSKKeyConversationID];
    
    if ([conversationID isEqualToString:self.threadID])
    {
        NSString *clientMessageID = [info objectForKey:TSKKeyClientMessageID];
        NSNumber *msgArrrivalTime = [info objectForKey:TSKKeyMessageReceiveTime];
        [self showTypingIndicatorForConversation:conversationID withClientMessageID:clientMessageID msgArrivalTime:msgArrrivalTime andUserID:userID];
    }
}

- (void) showTypingIndicatorForConversation:(NSString *)conversationID
                        withClientMessageID:(NSString *)clientMessageID
                             msgArrivalTime:(NSNumber *)msgArrivalTime
                                  andUserID:(NSString *)userID
{
    NSDictionary *messageInfo = @{TSKKeyMessageReceiveTime : msgArrivalTime,
                                  TSKKeyClientMessageID    : clientMessageID};
    // if client sends multiple posts, we keep on updating the message recieve time and clientMessageID
    [self.userIdDict setObject:messageInfo forKey:userID];
    [self updateTypingIndicator];
    // cancel any previously queued method call for dismissing the typing indicator
    [self cancelTypingIndicatorPerformRequestForUser:userID];
    [self performSelector:@selector(dismissTypingIndicatorForUser:)
               withObject:userID
               afterDelay:[TSUser isBOT:userID] ? TSkBotsTypingIndicatorDisplayDurationInSeconds : TSkTypingIndicatorDisplayDurationInSeconds];
}

- (void) updateTypingIndicator
{
    BOOL shouldDisplayTypingIndicatorView = YES;
    NSArray *userIDs = self.userIdDict.allKeys;
    NSString *aggregatedUserNamesString = [TSNameUtils getAggregatedNamesForUserIDs:userIDs
                                                                       withFullName:NO
                                                                      withFirstName:YES
                                                                      withGuestInfo:YES
                                                                       withFallBack:nil
                                                                   sortUserIDsFirst:nil
                                                           withManagedObjectContext:self.accountHandle.mainMOC
                                                                        isForAlerts:NO
                                                                 withCorrelationTag:TSkCorrelationTagUserSyncTypingIndicator];
    NSInteger userCount = userIDs.count;
    NSString *displayedString = nil;
    switch (userCount)
    {
        case 0:
            displayedString = @"";
            shouldDisplayTypingIndicatorView = NO;
            break;
        default:
            displayedString = aggregatedUserNamesString;
            break;
    }
    
    self.composeView.layer.shadowOpacity = 0.0f;
    
    CGFloat currentHeight = self.typingIndicatorViewHeight.constant;
    if (shouldDisplayTypingIndicatorView && (currentHeight == TSkTypingIndicatorViewMinimumHeight))
    {
        // show typing indicator view
        [self updateTypingIndicatorForUserIDs:userIDs shouldDisplayTypingIndicatorView:shouldDisplayTypingIndicatorView andDisplayString:displayedString];
        [self setTypingIndicatorVisibility:shouldDisplayTypingIndicatorView completion:nil];
    }
    else
    {
        // add or remove avatar from the typing indicator view.
        [self updateTypingIndicatorForUserIDs:userIDs
             shouldDisplayTypingIndicatorView:shouldDisplayTypingIndicatorView
                             andDisplayString:displayedString];
        return;
    }
}

- (void) updateTypingIndicatorForUserIDs:(NSArray *)userIDs
        shouldDisplayTypingIndicatorView:(BOOL)shouldDisplayTypingIndicatorView
                        andDisplayString:(NSString *)displayString
{
    __weak typeof(self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        [weakSelf.typingIndicatorView setTypingIndicatorLabelText:displayString];
        [weakSelf showAvatarImagesForUserCurrentlyTyping:userIDs];
        [weakSelf.typingIndicatorView showTypingIndicatorAnimation:shouldDisplayTypingIndicatorView];
    }];
}

- (void) showAvatarImagesForUserCurrentlyTyping:(NSArray *)uniqueUserIDs
{
    TSChatTypingIndicatorView *typingIndicatorView = self.typingIndicatorView;
    NSInteger userCount = uniqueUserIDs.count;
    
    if (userCount == 0) // if count of user currently typing is 0, hide all the avatars.
    {
        for (AXPImageView *userAvatarImageView in typingIndicatorView.userAvatarImageCollection)
        {
            [typingIndicatorView setStateHidden:YES forImageView:userAvatarImageView];
        }
        return;
    }
    
    NSString * user = nil;
    for (unsigned int avatarImageIndex = 0; avatarImageIndex < typingIndicatorView.userAvatarImageCollection.count; avatarImageIndex++)
    {
        AXPImageView * userAvatarImageView = typingIndicatorView.userAvatarImageCollection[avatarImageIndex];
        if (avatarImageIndex < userCount)
        {
            user = uniqueUserIDs[avatarImageIndex];
            [typingIndicatorView setStateHidden:NO forImageView:userAvatarImageView];
            [self.accountHandle.photoManager setImageForUserID:user inImageView:userAvatarImageView withIMDisplayName:nil withMask:NO];
        }
        else
        {
            [typingIndicatorView setStateHidden:YES forImageView:userAvatarImageView];
        }
    }
}

- (void) dismissTypingIndicatorForUser:(NSString *)userID
{
    [self dismissTypingIndicatorForUser:userID
                  didReceiveChatMessage:NO];
}

- (void) dismissTypingIndicatorForUser:(NSString *)userID
                 didReceiveChatMessage:(BOOL)didReceiveChatMessage
{
    NSNumber *currentTime = [NSNumber numberWithLongLong:[NSDate date].skypeTimeInterval];
    NSNumber *messageReceiveTime = self.userIdDict[userID][TSKKeyMessageReceiveTime];
    if ((currentTime.longLongValue - messageReceiveTime.longLongValue >= TSkTypingIndicatorDisplayDurationInMilliSeconds) || didReceiveChatMessage)
    {
        NSUInteger index = [self.userIdDict.allKeys indexOfObject:userID];
        if (index != NSNotFound)
        {
            // implies we will remove all avatars; close the typing indicator with animation
            if (self.userIdDict.allKeys.count == 1)
            {
                __weak typeof(self) weakSelf = self;
                [self setTypingIndicatorVisibility:NO completion:^(BOOL finished) {
                    [weakSelf removeUserWithUserID:userID atIndex:index];
                }];
            }
            else
            {
                [self removeUserWithUserID:userID atIndex:index];
            }
        }
    }
}

- (void ) removeUserWithUserID:(NSString *)userID
                       atIndex:(NSUInteger)index
{
    TSChatTypingIndicatorView *typingIndicatorView = self.typingIndicatorView;
    NSUInteger maxAvatarCount = typingIndicatorView.userAvatarImageCollection.count;
    
    if (index < maxAvatarCount)
    {
        AXPImageView *userAvatarImageView = typingIndicatorView.userAvatarImageCollection[index];
        [typingIndicatorView setStateHidden:YES forImageView:userAvatarImageView];
    }
    [self cancelTypingIndicatorPerformRequestForUser:userID];
    [self.userIdDict removeObjectForKey:userID];
    [self updateTypingIndicator];
}

- (void) animatePushDownWithCompletion:(void (^ __nullable)(BOOL finished)) completion
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration: TSkTypingIndicatorPushDownAnimationDuration
                          delay: TSkTypingIndicatorPushDownAnimationDelay
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
        weakSelf.typingIndicatorViewHeight.constant = TSkTypingIndicatorViewFinalHeight;
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        if(completion)
        {
            completion(finished);
        }
    }];
}

// When we collapse typing indicator, we prevent typing indicator expansion animation.
-(void) setTypingIndicatorVisibility:(BOOL)shouldDisplayTypingIndicatorView
                          completion:(void (^ __nullable)(BOOL finished))completion
{
    if (!self.isTypingIndicatorCollapseAnimationInProgress)
    {
        self.isTypingIndicatorCollapseAnimationInProgress = !shouldDisplayTypingIndicatorView;
        [self.view layoutIfNeeded];
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration: TSkTypingIndicatorAnimationSpeedAmount
                              delay: 0
             usingSpringWithDamping: TSkTypingIndicatorAnimationSpringDamping
              initialSpringVelocity: 0
                            options: UIViewAnimationOptionPreferredFramesPerSecond30
                         animations: ^{
            weakSelf.typingIndicatorViewHeight.constant = shouldDisplayTypingIndicatorView ? TSkTypingIndicatorViewMaximumHeight : TSkTypingIndicatorViewMinimumHeight;
            [weakSelf.view layoutIfNeeded];
        }
                         completion:^(BOOL finished) {
            [weakSelf.typingIndicatorView setShadowHidden:!shouldDisplayTypingIndicatorView];
            if(shouldDisplayTypingIndicatorView)
            {
                if (!self.isTypingIndicatorCollapseAnimationInProgress)
                {
                    [weakSelf animatePushDownWithCompletion:completion];
                }
            }
            else
            {
                if (completion)
                {
                    completion(finished);
                    self.isTypingIndicatorCollapseAnimationInProgress = NO;
                }
            }
        }];
    }
}

- (void) cancelTypingIndicatorPerformRequestForAllUsers
{
    for (NSString *userdID in self.userIdDict.allKeys)
    {
        [self cancelTypingIndicatorPerformRequestForUser:userdID];
    }
}

- (void) cancelTypingIndicatorPerformRequestForUser:(NSString *)userID
{
    if ([userID isNotNilOrEmpty])
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTypingIndicatorForUser:) object:userID];
    }
}

- (NSDictionary *) getViewInfoForOneOnOneSMSWithRecipientId:(NSString *)recipientID
{
    NSString *userDisplayName = [self getOutOfNetworkUserDisplayName:recipientID];
    
    NSMutableDictionary *viewInfoConfig = [@{
        TSkOneToOneDisplayNameLabelKey: userDisplayName ?: AXPLocalizedString(@"UnknownUser"),
        TSkOneToOneUserMriKey: recipientID,
        TSkHidePersonalizationCard: @(self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants)
    } mutableCopy];
    
    return viewInfoConfig;
}

- (NSDictionary *) getViewInfoForOffNetworkWelcomeCardWithRecipientId:(NSString *)recipientID
{
    NSString *userDisplayName = [self getOutOfNetworkUserDisplayName:recipientID];
    UIImage *userAvatar = [self getOutOfNetworkUserAvatar:recipientID];
    NSString *phoneNo = [self getOutOfNetworkUserPhoneNumber:recipientID];
    NSMutableDictionary *viewInfoConfig = [@{TSkOneToOneDisplayNameLabelKey: userDisplayName ?: AXPLocalizedString(@"UnknownUser"),
                                             TSkOneToOneUserMriKey: recipientID,
                                             TSkOffNetworkPhoneNumberKey: phoneNo ?: @"",
                                             TSkOffNetworkActionButtonLabelKey: AXPLocalizedString(@"InvUsrLbl")} mutableCopy];
    
    if (userAvatar)
    {
        viewInfoConfig[TSkOneToOneThumbnailKey] = userAvatar;
    }
    
    return viewInfoConfig;
}

- (NSDictionary *) getViewInfoForOneOnOneChatWithRecipientId:(NSString *)recipientID
{
    NSMutableDictionary *viewInfoConfig = [@{
        TSkOneToOneUserMriKey: recipientID,
        TSkHidePersonalizationCard: @(self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants)
    } mutableCopy];
    TSUser *user = [TSUser userForID:recipientID inManagedObjectContext:self.accountHandle.mainMOC];
    if (user)
    {
        UIImage *profileImage = [TSPeopleUtils getCachedProfileImageForUser:user];
        if (profileImage)
        {
            [viewInfoConfig setValue:profileImage forKey:TSkOneToOneThumbnailKey];
        }
    }
    return viewInfoConfig;
}

- (BOOL) shouldShowOneToOneWelcomeCard
{
    return (self.recipientIDs.count == 1) && self.accountHandle.policyManager.isOneToOneChatWelcomeCardEnabled;
}

- (BOOL) shouldShowGroupWelcomeCard
{
    return (self.recipientIDs.count > 1) && self.accountHandle.policyManager.isGroupChatWelcomeCardEnabled;
}

- (BOOL) shouldInitiate2WaySMSChatWithRecipient:(NSString *)recipientID
{
    return self.accountHandle.policyManager.isOneOnOneTwoWaySMSEnabled &&
    [self isOutOfNetworkUser:recipientID] &&
    [self isTwoWaySMSUser:recipientID] &&
    ![[TSPhoneNumberUtils sharedInstance]
      doesPhoneNumberRequireConsent:[self getOutOfNetworkUserPhoneNumber:recipientID]
      smsRequiredConsentPrefixes:self.accountHandle.policyManager.smsRequiredConsentPrefixes];
}

- (BOOL) shouldInitiateInvitationForRecipient:(NSString *)recipientID
{
    return self.accountHandle.policyManager.isUserInviteEnabled &&
    [self isOutOfNetworkUser:recipientID] &&
    [[TSPhoneNumberUtils sharedInstance]
     doesPhoneNumberRequireConsent:[self getOutOfNetworkUserPhoneNumber:recipientID]
     smsRequiredConsentPrefixes:self.accountHandle.policyManager.smsRequiredConsentPrefixes];
}

#pragma mark TSBaseTableViewController
- (void) showEmptyStateView:(BOOL)show
{
    if (!show)
    {
        [super showEmptyStateView:NO];
        self.tableView.accessibilityElementsHidden = NO;
    }
    
    NSDictionary * viewInfo = nil;
    TSEmptyStates emptyState;
    [self adjustEmptyStateView:NO];
    if ([TSNetworkStatusManager sharedInstance].isReachable)
    {
        // configure empty state view for sfb and sfc chats
        if ([self isSfbOrSfcInteropChat])
        {
            viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState: TSkEmptyStateSfBChat];
            emptyState = TSkEmptyStateSfBChat;
        }
        else if ([self isOneOnOneFedChatWithFedChatCreationDisabled])
        {
            // Remove check once Fed Chat Creation is enabled from TfL.
            viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState:TSKEmptyStateNull];
            emptyState = TSKEmptyStateNull;
        }
        else if ([self shouldShowOneToOneWelcomeCard])
        {
            NSString *recipientID = [self.recipientIDs firstObject];
            
            if ([self shouldInitiate2WaySMSChatWithRecipient:recipientID])
            {
                emptyState = TSkEmptyStateOneToOneChatWelcomeCard;
                viewInfo = [self getViewInfoForOneOnOneSMSWithRecipientId:recipientID];
            }
            else if ([self singleOffNetworkUserInviteFlowEnabled])
            {
                viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState:TSKEmptyStateNull];
                emptyState = TSKEmptyStateNull;
            }
            else if ([self shouldInitiateInvitationForRecipient:recipientID])
            {
                emptyState = TSkEmptyStateOffNetworkWelcomeCard;
                viewInfo = [self getViewInfoForOffNetworkWelcomeCardWithRecipientId:recipientID];
                self.composeView.hidden = YES;
                self.tableView.accessibilityElementsHidden = YES;
            }
            else
            {
                emptyState = TSkEmptyStateOneToOneChatWelcomeCard;
                viewInfo = [self getViewInfoForOneOnOneChatWithRecipientId:recipientID];
            }
        }
        else if ([self shouldShowGroupWelcomeCard])
        {
            viewInfo = @{
                TSkGroupCountLabelKey: [NSString stringWithFormat:AXPLocalizedString(@"TagMemberCount"), [[NSNumberFormatter alloc] stringFromNumber:@(self.recipientIDs.count)]],
                TSkGroupChatInfoLabelKey:self.offlineRecipientsStatusString ?: @"",
                TSkGroupAvatarIsEditableKey: @(self.accountHandle.groupTraits.customAvatarForGroupEnabled),
                TSkShowSmartReplyButtons: @(self.shouldShowSuggestions),
                TSkHidePersonalizationCard: @(self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants),
            };
            emptyState = TSkEmptyStateGroupChatWelcomeCard;
        }
        else
        {
            if (self.shouldConfigureForMeetings && [NSString isNilOrEmpty:self.threadID])
            {
                NSDictionary *options = self.emptyStateForMeetings ? @{ TSkEmptyStateKey : self.emptyStateForMeetings } : nil;
                viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState: TSkEmptyStatePrivateMeetingChat options:options];
                emptyState = TSkEmptyStatePrivateMeetingChat;
            }
            else if (self.groupChatCreationState == TSGroupChatCreationStateStart && [NSString isNilOrEmpty:self.threadID])
            {
                NSMutableDictionary *groupChatCreationInfo = [[NSMutableDictionary alloc] init];
                groupChatCreationInfo[TSkGroupAvatarThumbnailKey] = self.emptyStateView.avatarImage;
                groupChatCreationInfo[TSkGroupAvatarIsEditableKey] = @(self.accountHandle.groupTraits.customAvatarForGroupEnabled);
                viewInfo = groupChatCreationInfo;
                emptyState = TSkEmptyStateFullPageGroupChatWelcomeCard;
            }
            else if (self.accountHandle.policyManager.shouldShowInviteFriendsEmptyState)
            {
                emptyState = TSkEmptyStateInviteFriends;
                void (^actionBlock)(void) = ^{
                    [TSInviteUtility.sharedInstance openInviteFlowFromViewController:AXPAppViewController.activeViewController
                                                          shareOptionsViewController:AXPAppViewController.activeViewController
                                                                       withPanelType:TSkEmptyStatePanelType
                                                                            panelUri:TSkEmptyStatePanelType
                                                                      andModuleState:nil
                                                                  inviteLinkComplete:nil];
                };
                viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState:TSkEmptyStateInviteFriends options:@{TSkActionBlockKey:actionBlock}];
                [self adjustEmptyStateView:YES];
                [self.view endEditing:YES];
            }
            else if (self.accountHandle.policyManager.shouldShowContactSyncEmptyState
                     && !self.accountHandle.deviceContactsSync.isDeviceContactsSyncEnabled
                     && self.accountHandle.deviceContactsSync.hasShownDeviceContactSyncModal)
            {
                emptyState = TSkEmptyStateContactSync;
                TSWeakify(self);
                void (^actionBlock)(void) = ^{
                    TSStrongify(self);
                    [self.accountHandle.deviceContactsSync enableContactsSync:[AXPAppViewController activeViewController]
                                                                       source:@"chatCreationContactSyncEmptyState"
                                                                  moduleState:TSkActionModuleStateChatEmptyState
                                                               withCompletion:nil];
                    [self updateEmptyStateView:NO];
                };
                viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState:TSkEmptyStateContactSync options:@{TSkActionBlockKey:actionBlock}];
                [self adjustEmptyStateView:YES];
                [self.view endEditing:YES];
            }
            else if ([self.accountHandle.policyManager isGroupCreationWithTemplatesEnabled] && [TSGttUtils chatListEntryPointTemplatesWithAccountHandle: self.accountHandle].count > 0)
            {
                emptyState = TSkEmptyStateGroupTemplates;
                viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState:emptyState options:nil];
                [self adjustEmptyStateView:YES];
                [self.view endEditing:YES];
            }
            else if (self.isChatWithSelf)
            {
                viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState: TSkEmptyStateChatWithSelf];
                emptyState = TSkEmptyStateChatWithSelf;
            }
            else if (self.threadNotFound)
            {
                viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState: TSkEmptyStateChatsOffline];
                emptyState = TSkEmptyStateChatsOffline;
            }
            else
            {
                // Do not show empty state if none of the above conditions are met.
                viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState:TSKEmptyStateNull];
                emptyState = TSKEmptyStateNull;
            }
        }
    }
    else
    {
        viewInfo = [self.accountHandle.emptyStateConfigurationFactory.emptyStateConfiguration getViewInfoForEmptyState: TSkEmptyStateChatsOffline];
        emptyState = TSkEmptyStateChatsOffline;
    }
    [self showEmptyStateView:show
               forEmptyState:emptyState
                withViewInfo:viewInfo];
}

- (void) showBannerAboutOffNetworkOrFedMsgPolicyIfNeeded
{
    NSString *statusMessage = self.offlineRecipientsStatusString;
    
    BOOL shouldShowInviteBanner = ([self singleOffNetworkUserInviteFlowEnabled] ||
                                   [self shouldShowGroupWelcomeCard] ||
                                   self.isGuardiansChat ||
                                   ([self shouldShowOneToOneWelcomeCard] &&
                                    [self shouldInitiate2WaySMSChatWithRecipient:[self.recipientIDs firstObject]]) ||
                                   self.accountHandle.policyManager.isTfwTflFedChatCreationOnTfwEnabled);
    BOOL shouldShowFedBannerOnTfl = !self.threadID && self.isRosterWithFederatedUser && self.accountHandle.policyManager.isTfwTflFedChatConsumptionPhase2OnTflEnabled;
    
    if (shouldShowInviteBanner && self.threadID == nil && [statusMessage isNotNilOrEmpty])
    {
        [self displayStatusMessageBannerViewWithStatusMessage:statusMessage];
    }
    else if(shouldShowFedBannerOnTfl)
    {
        TSWeakify(self);
        [TSDispatchUtilities dispatchOnMainThread:^{
            TSStrongifyAndReturnIfNil(self);
            [self.statusMessageBannerView setStatusMessageAttributedText:[self.federationInfoUtil getFedUserMsgPolicyStringFor:AXPLocalizedString(@"FedMsgRltdPlcyStatusText")]];
            
            TSWeakify(self);
            self.statusMessageBannerView.dismissBannerAction = ^{
                TSStrongifyAndReturnIfNil(self);
                [self removeStatusMessageBannerView];
            };
            
            self.statusMessageBannerView.tappedOnBannerTextView = ^{
                TSStrongifyAndReturnIfNil(self);
                CGPoint location = [self.statusMessageBannerView.attributedTextGestureRecognizer locationInView:self.statusMessageBannerView.statusMessage];
                
                if([self.federationInfoUtil didSelectLinkIn:self.statusMessageBannerView.statusMessage locationTapped:location])
                {
                    [self.federationInfoUtil openExternalAccessPolicyURLFor:self isBannerOnTfl:self.accountHandle.policyManager.isTfwTflFedChatConsumptionOnTflEnabled];
                }
            };
            
            [self.statusMessageBannerView setHidden:NO];
        }];
    }
    else
    {
        [self updateStatusBannerState];
    }
}

- (void) updateStatusBannerState
{
    if ([self shouldShowStatusMessageBannerView])
    {
        [self constructAndShowStatusMessageBannerView:YES];
    }
    else
    {
        [self removeStatusMessageBannerView];
    }
}

- (NSString *) offlineRecipientsStatusString
{
    if (self.offNetworkRecipientCount > 0)
    {
        NSMutableArray *smsNames = [[NSMutableArray alloc] init];
        NSMutableArray *emailNames = [[NSMutableArray alloc] init];
        for (NSString *recipientId in self.recipientsUserInfo)
        {
            NSDictionary *info = self.recipientsUserInfo[recipientId];
            if ([TSChatViewController isSmsUser:info])
            {
                [smsNames addObject:[self getUserDisplayNameFromInfo:info WithFallbackKey:TSkItemInfoPhone]];
            }
            else if ([TSChatViewController isEmailUser:info])
            {
                [emailNames addObject:[self getUserDisplayNameFromInfo:info WithFallbackKey:TSkItemInfoEmail]];
            }
        }
        
        if (smsNames.count > 0 && emailNames.count > 0)
        {
            if(smsNames.count == 1 && emailNames.count == 1)
            {
                return [NSString stringWithFormat:AXPLocalizedString(@"InvWelcomeMixTwo"), smsNames[0], emailNames[0]];
            }
            return [NSString stringWithFormat:AXPLocalizedString(@"InvWelcomeMixMany"), @(smsNames.count + emailNames.count)];
        }
        if (smsNames.count > 0)
        {
            if(smsNames.count == 1)
            {
                return [NSString stringWithFormat:AXPLocalizedString(@"InvWelcomeSms"), smsNames[0]];
            }
            if(smsNames.count == 2)
            {
                return [NSString stringWithFormat:AXPLocalizedString(@"InvWelcomeSmsTwo"), smsNames[0], smsNames[1]];
            }
            return [NSString stringWithFormat:AXPLocalizedString(@"InvWelcomeSmsMany"), @(smsNames.count)];
        }
        if (emailNames.count > 0)
        {
            if(emailNames.count == 1)
            {
                return [NSString stringWithFormat:AXPLocalizedString(@"InvWelcomeEmail"), emailNames[0]];
            }
            if(emailNames.count == 2)
            {
                return [NSString stringWithFormat:AXPLocalizedString(@"InvWelcomeEmailTwo"), emailNames[0], emailNames[1]];
            }
            return [NSString stringWithFormat:AXPLocalizedString(@"InvWelcomeEmailMany"), @(emailNames.count)];
        }
    }
    return nil;
}

- (NSString *) getUserDisplayNameFromInfo:(NSDictionary *)info WithFallbackKey:(NSString *)fallbackKey
{
    if (![NSString isNilOrEmpty:info[TSkEDUserNameKey]])
    {
        return info[TSkItemInfoPhone];
    }
    else if(![NSString isNilOrEmpty:info[TSkUserDisplayName]])
    {
        return info[TSkUserDisplayName];
    }
    if(![NSString isNilOrEmpty:info[fallbackKey]])
    {
        return info[fallbackKey];
    }
    return AXPLocalizedString(@"UnknownUser");
}

+ (BOOL) isSmsUser:(NSDictionary *)info
{
    return ![NSString isNilOrEmpty:info[TSkItemInfoPhone]];
}

+ (BOOL) isEmailUser:(NSDictionary *)info
{
    return ![NSString isNilOrEmpty:info[TSkItemInfoEmail]];
}

- (NSInteger) offNetworkRecipientCount
{
    if (self.isGuardiansChat && self.recipientsUserInfo == nil)
    {
        self.recipientsUserInfo = [self buildGuardiansRecipientsUserInfo];
    }
    
    int count = 0;
    for (NSString *recipientId in self.recipientsUserInfo)
    {
        NSDictionary *info = self.recipientsUserInfo[recipientId];
        
        if ([info[TSkSearchResultItemType] isNotNilOrWhitespace] &&
            ([TSChatViewController isSmsUser:info] || [TSChatViewController isEmailUser:info]))
        {
            count++;
        }
    }
    return count;
}

- (BOOL) shouldShowSuggestions
{
    return self.offNetworkRecipientCount == 0;
}

- (void) showEmptyStateView:(BOOL)show
              forEmptyState:(TSEmptyStates)emptyState
               withViewInfo:(NSDictionary *)viewInfo
{
    [self.emptyStateView configureForEmptyState:emptyState
                                       viewInfo:viewInfo];
    
    if (!show)
    {
        self.tableView.accessibilityElementsHidden = NO;
    }
    
    [super showEmptyStateView:show];
}

- (void) handleMarkAsUnread:(TSSMessage *)message
{
    UIScrollView *scrollView = self.tableView;
    CGPoint currentPosition = scrollView.contentOffset;
    self.freezeConsumptionHorizonBookmarkReset = YES;
    BOOL isEnableEnhancedTelemetry = self.accountHandle.policyManager.isEnableEnhancedTelemetry;
    NSDictionary *metadata = nil;
    if([message.from hasPrefix:TSBotPrefix])
    {
        TSPTelemetryConstructBridge *telemetryConstruct = [[TSPTelemetryConstructBridge alloc] initWithBotId:message.from name:@""];
        TSPlatformTelemetryInputData *inputParams = [[[[[[[[TSPTelemetryInputDataBuilder alloc]
                                                           initWithAccountHandle:self.accountHandle
                                                           moc:self.accountHandle.mainMOC]
                                                          withThreadId:self.threadID]
                                                         withAppId:message.from]
                                                        withBotId:message.from]
                                                       withAppScenarioCapability:TSPTelemetryScenarioCapabilityBot]
                                                      withTelemetryConstructBridge:telemetryConstruct]
                                                     build];
        if (inputParams)
        {
            metadata = [[[TSPTelemetryData alloc] initWithInputData:inputParams] toDictionary];
        }
    }
    [self.logger logPanelAction:isEnableEnhancedTelemetry ? TSkMarkStatusUnreadChat :  TSkActionModuleNameMessageMarkUnreadButton
                        outCome:TSkActionOutcomeSubmit
                        gesture:TSkActionGestureTap
                       scenario:TSkScenarioMessageMarkUnread
                   scenarioType:TSkScenarioTypeReadMsgs
                 destinationuri:@""
           destinationUriParams:@""
                     moduleType:isEnableEnhancedTelemetry ? TSkActionModuleTypeChatList : @""
                    moduleState:@""
                  moduleSummary:@""
                      panelType:isEnableEnhancedTelemetry ? TSkPanelTypeChatList : TSkPanelTypeChat
                       panelUri:TSkPanelUriConversation
                 panelUriParams:nil
                    panelRegion:TSkRegionMain
                       threadId:self.threadID
                     threadType:self.biThreadType
                  threadMembers:self.biThreadMembersCount
                          tabId:nil
                        tabType:nil
                     tabOrdinal:nil
                       metaData:metadata
                  moduleNameNew:TSkMarkStatusUnreadChat
                     outComeNew:TSkActionOutcomeSubmit
                  moduleTypeNew:TSkActionModuleTypeChatList
                   panelTypeNew:TSkPanelTypeChatList
                 panelRegionNew:TSkRegionMain
                 targetThreadId:self.threadID
               targetThreadType:self.biThreadType
                     tabTypeNew:nil
                       workLoad:TSkActionChatlistWorkLoad
                    subWorkLoad:TSkActionChatListSubWorkLoad
                        appName:TSkAppNameChat];
    __weak typeof(self) weakSelf = self;
    [[TSUserActionsManager sharedInstance] performMarkLastReadOnMessage:message.tsID
                                                               inThread:message.threadID
                                                            forScenario:USER_ACTION_MARK_UNREAD
                                                         withProperties:nil
                                                             isV2Thread:self.isV2Thread
                                                          accountHandle:self.accountHandle
                                                         withCompletion:^(NSError *err, TSAResult *res)
     {
        __strong typeof(weakSelf) sself = weakSelf;
        
        if (!err)
        {
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, AXPLocalizedString(@"TSUserActionMarkUnreadAnnouncement"));
            
            [sself fixInitialHorizonTimeAndReload];
            
            // for user feedback
            sself.tableView.contentOffset = currentPosition;
            
            NSString *threadID = sself.threadID;
            if ([threadID isNotNilOrEmpty])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:TSkConversationMarkedUnreadFromChat
                                                                    object:self.accountHandle
                                                                  userInfo:@{TSkNotificationKeyForConversation: threadID}];
            }
            NSString *userId = message.from;
            if ([userId hasPrefix:TSBotPrefix]) {
                NSManagedObjectContext *moc = self.accountHandle.privateMOC;
                TSWeakify(self);
                DbReadWrite(SELECTOR_NAME(self), moc, ^
                            {
                    TSStrongifyAndReturnIfNil(self);
                    TSPTelemetryConstructBridge *telemetryConstruct = [[TSPTelemetryConstructBridge alloc] initWithBotId:userId name:@""];
                    TSPlatformTelemetryInputData *inputParams = [[[[[[[TSPTelemetryInputDataBuilder alloc]
                                                                      initWithAccountHandle:self.accountHandle moc:moc]
                                                                     withThreadId:self.threadID]
                                                                    withAppId:userId]
                                                                   withAppScenarioCapability:TSPTelemetryScenarioCapabilityBot]
                                                                  withTelemetryConstructBridge:telemetryConstruct]
                                                                 build];
                    NSDictionary *databag = nil;
                    if (inputParams)
                    {
                        databag = [[[TSPTelemetryData alloc] initWithInputData:inputParams] toDictionary];
                    }
                    [self.logger logPanelAction:isEnableEnhancedTelemetry ? TSkMarkStatusUnreadChat : TSkActionModuleNameMarkAsUnread
                                        outCome:isEnableEnhancedTelemetry ? TSkActionOutcomeSubmit :  TSkActionOutcomeInspect
                                        gesture:TSkActionGestureTap
                                       scenario:TSkScenarioMarkAsUnread
                                   scenarioType:TSkScenarioMarkAsUnread
                                 destinationuri:@""
                           destinationUriParams:@""
                                     moduleType:isEnableEnhancedTelemetry ? TSkActionModuleTypeChatList :  TSkActionModuleTypeMessage
                                    moduleState:@""
                                  moduleSummary:@""
                                      panelType:isEnableEnhancedTelemetry ? TSkPanelTypeChatList : self.currentPanelInfo.type
                                       panelUri:self.currentPanelInfo.uri
                                 panelUriParams:self.currentPanelInfo.uriParams
                                    panelRegion:TSkRegionMain
                                       threadId:self.threadID
                                     threadType:self.currentPanelInfo.threadType
                                  threadMembers:self.biThreadMembersCount
                                          tabId:nil
                                        tabType:nil
                                     tabOrdinal:nil
                                       metaData:databag
                                  moduleNameNew:TSkMarkStatusUnreadChat
                                     outComeNew:TSkActionOutcomeSubmit
                                  moduleTypeNew:TSkActionModuleTypeChatList
                                   panelTypeNew:TSkPanelTypeChatList
                                 panelRegionNew:TSkRegionMain
                                 targetThreadId:self.threadID
                               targetThreadType:self.currentPanelInfo.threadType
                                     tabTypeNew:nil
                                       workLoad:TSkActionChatlistWorkLoad
                                    subWorkLoad:TSkActionChatListSubWorkLoad
                                        appName:TSkAppNameChat];
                });
            }
        }
        else if ([AXPUtilities isNetworkOfflineError:err])
        {
            [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"TSGenericOfflineErrorTitle")
                                         andMessage:AXPLocalizedString(@"TSGenericOfflineErrorBody")
                                   andButtonContent:AXPLocalizedString(@"TSOK")
                                  andViewController:sself];
        }
        else
        {
            LogErrorAH(self.logger, "Failed to mark unread. error code: %zd, error domain: %@", err.code, err.domain);
            [TSAlertUtils presentAlertViewWithTitle:@""
                                         andMessage:AXPLocalizedString(@"MarkUnreadFailed")
                                   andButtonContent:AXPLocalizedString(@"OK")
                                  andViewController:sself];
        }
    }];
}

- (void) handleMarkAsAcknowledged:(NSNumber *)messageID threadID:(NSString *)threadID ackState:(NSString *)ackState
{
    if (self.isCurrentlyVisible)
    {
        __weak typeof(self) weakSelf = self;
        [[TSUserActionsManager sharedInstance] performMarkAcknowledgedOnMessage:(NSNumber *)messageID
                                                                       threadID:(NSString *)threadID
                                                                       ackState:(NSString *)ackState
                                                                  accountHandle:self.accountHandle
                                                                 withCompletion:^(NSError *err, TSAResult *res) {
            if (err)
            {
                LogErrorAH(weakSelf.logger, "Failed to mark ack. error code: %zd, error domain: %@", err.code, err.domain);
                return;
            }
            
            [weakSelf.accountHandle.logger logPanelView:weakSelf.currentPanelInfo.type
                                               scenario:TSkActionScenerioUrgentMessageAckChat
                                           scenarioType:TSkScenarioTypePriorityNotification
                                             moduleName:TSkActionModuleNameChat
                                             moduleType:nil
                                             threadType:nil];
        }];
    }
    
}

- (void) markAlertsAsRead
{
    if (![self.threadID isNotNilOrEmpty])
    {
        LogVerboseAH(self.logger, @"[ChatVC]: nil threadID, skip mark alert as read.");
        return;
    }
    [TSAlertViewModel markUnreadAlertsForThread:self.threadID accountHandle:self.accountHandle];
}

- (BOOL) isChatForAnonymousCall
{
    return self.isAnonymouslyJoinedToCall;
}

- (void) adaptiveCardImageDownloaded:(NSNotification *) notification
{
    TSWeakify(self);
    [self updateTable:^{
        TSStrongifyAndReturnIfNil(self);
        NSNumber *messageID = notification.object;
        NSIndexPath *indexPath = [messageID isKindOfClass:NSNumber.class] ? self.itemLookupMap[messageID] : nil;
        [self invalidateHeightCacheForMessageID:messageID];
        
        if (indexPath && [self dataForRowAtIndexPath:indexPath inTableView:self.tableView]) {
            [self removeCachedAdaptiveCardForIndexPath:indexPath];
            // Pinning the firstObject of the view helps prevent the view from jumpimg around
            TSWeakify(self);
            [self pinIndexPath:self.tableView.indexPathsForVisibleRows.firstObject forTableUpdate:^{
                TSStrongifyAndReturnIfNil(self);
                if ([self.tableView numberOfSections] == [self numberOfSections])
                {
                    TSWeakify(self);
                    [UIView performWithoutAnimation:^{
                        TSStrongifyAndReturnIfNil(self);
                        TSWeakify(self);
                        [self.tableView performUpdates:^{
                            TSStrongifyAndReturnIfNil(self);
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } withCompletion:nil];
                    }];
                }
                else
                {
                    LogInfoAH(self.accountHandle.logger,@"AdaptiveCardImageDownloaded: TableView reload pending. Skipping reload row.");
                }
            }];
        }
        else {
            LogInfoAH(self.accountHandle.logger,@"AdaptiveCardImageDownloaded: Invalid indexPath");
            TSWeakify(self);
            [self pinIndexPath:self.tableView.indexPathsForVisibleRows.firstObject forTableUpdate:^{
                TSStrongifyAndReturnIfNil(self);
                if ([self.tableView numberOfSections] == [self numberOfSections])
                {
                    [self.tableView performUpdates:nil withCompletion:nil];
                }
            }];
        }
    }];
}

- (void) removeCachedAdaptiveCardForIndexPath:(NSIndexPath *)indexPath{
    // Since the cards are cached when once created with empty Images
    // the bot card height is taken from config and constrained to the value in config (i.e. 210)
    // After the image is downloaded the cache does not create a new card and gives back the same big card
    // removing the same card from the cache so that the card can be recreated with new image
    NSDictionary *itemData = [self dataForRowAtIndexPath:indexPath inTableView:self.tableView];
    TSMessageInfo *message = [self messageFromItemData:itemData];
    TSSMessage* msg = [AXPCtx messageForID:message.tsID andThreadID:message.threadID];
    NSNumber *msgID = msg.tsID.copy;
    NSDate *arrivalTime = msg.arrivalTime.copy;
    NSString *key = [self.adaptiveCardsUtility createKeyFromMessageID:msgID andTimeStamp:arrivalTime];
    [self.adaptiveCardsCache removeACRViewFromCacheWithKey:key];
    [self invalidateHeightCacheForMessageID:msgID];
    NSArray *botAttachments = [TSTextAttachmentFormatter botAttachments:message.attributedContent];
    for (NSDictionary *botAttachmentDict in botAttachments)
    {
        TSBotTextAttachment *botAttachment = [botAttachmentDict valueForKey:@"attachment"];
        if (botAttachment)
        {
            NSArray *botCards = [TSUtilities unarchiveBotCards:message.ts_botCardData];
            for (id cardInfo in botCards)
            {
                if ([[botAttachment cardID] isEqualToString:[cardInfo cardClientId]])
                {
                    NSString * cardKey = [key stringByAppendingString:[cardInfo cardClientId]];
                    [self.adaptiveCardsCache removeACRViewFromCacheWithKey:cardKey];
                }
            }
        }
    }
}

- (void)imageLoaded:(NSNotification *)notification
{
    NSString *imageID = [notification.userInfo objectForKey:TSkDownsizedImageDownloadId] ?: [notification.userInfo objectForKey:TSkImageDownloadId];
    
    [self updateTable:^{
        // Checks for images as attached documents that have now downloaded
        for (UITableViewCell *cell in self.tableView.visibleCells)
        {
            if ([cell isKindOfClass:TSChatMessageViewCell.class])
            {
                TSChatMessageViewCell *chatCell = (TSChatMessageViewCell *)cell;
                for (UIView *attachmentView in chatCell.fileAttachmentViews)
                {
                    if ([attachmentView isKindOfClass:TSChatImageAttachmentView.class])
                    {
                        TSChatImageAttachmentView *attachmentImageView = (TSChatImageAttachmentView *)attachmentView;
                        if ([attachmentImageView.attachedURL.absoluteString compareString:imageID])
                        {
                            BOOL heightChanged = [[notification.userInfo objectForKey:TSkImageHeightChanged] boolValue];
                            if (heightChanged)
                            {
                                // Image height changed, refresh the row, since whole table needs to adjust for this row's new height
                                [self invalidateHeightCacheForMessageID:chatCell.messageID];
                                NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
                                if (indexPath)
                                {
                                    __weak typeof(self) weakSelf = self;
                                    [self pinIndexPath:indexPath forTableUpdate:^
                                     {
                                        [weakSelf.tableView beginUpdates];
                                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                        [weakSelf.tableView endUpdates];
                                    }];
                                }
                                else
                                {
                                    LogVerboseAH(self.logger, @"indexPath not found for cell");
                                }
                            }
                            else
                            {
                                // Image height unchanged, only need to update views within the cell
                                [cell setNeedsUpdateConstraints];
                                [cell updateConstraintsIfNeeded];
                                [cell setNeedsLayout];
                            }
                        }
                    }
                }
            }
        }
    }];
}

#pragma mark - Highlighting search results

- (void)sizeCategoryDidChange:(NSNotification *)notification
{
    // Clear cached highlight attributes if text size changes
    _searchHighlightAttributes = nil;
    
    __weak typeof (self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        weakSelf.typingIndicatorView.typingIndicatorLabel.font = [TSFont footnote];
    }];
}

- (NSDictionary *)searchHighlightAttributes
{
    if (!_searchHighlightAttributes)
    {
        // These attributes should match those in TSMessageTableViewCell that shows search result items
        _searchHighlightAttributes = @{ NSFontAttributeName : [TSFont preferredFontForTextStyle:UIFontTextStyleBody
                                                                                         ofType:TSkFontTypeBold],
                                        NSBackgroundColorAttributeName:self.legacyAppearanceProxy.highlightedSearchBackgroundColor,
                                        NSForegroundColorAttributeName:self.legacyAppearanceProxy.highlightedSearchTextColor };
    }
    return _searchHighlightAttributes;
}

- (void) memberConsumptionHorizonUpdated:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSString *threadID = info[TSKKeyConversationID];
    
    if ([self.threadID compareString:threadID]) {
        [self updateMemberConsumptionHorizonTime];
    }
}

- (void) updateMemberConsumptionHorizonTime
{
    if (![self readReceiptsEnabled])
    {
        LogVerboseAH(self.logger, @"read receipts disabled");
        return;
    }
    
    NSString *threadID = self.threadID;
    NSManagedObjectContext *moc = self.accountHandle.highPriMOC;
    
    TSWeakify(self);
    DbReadWrite(SELECTOR_NAME(self), moc, ^{
        TSStrongifyAndReturnIfNil(self);
        
        TSThreadProperty *threadProperty = [AXPCtx threadPropertyForThreadID:threadID
                                                             andPropertyName:TSkMemberConsumptionHorizon
                                                                       inMoc:moc];
        
        if (threadProperty && [threadProperty.propertyValue isKindOfClass:NSDictionary.class])
        {
            NSMutableDictionary *allConsumptionHorizons = NSMutableDictionary.new;
            for (NSString *recipientMri in self.recipientIDs)
            {
                NSDictionary *dict = (NSDictionary *)threadProperty.propertyValue;
                NSString *consumptionHorizon = [dict valueForKey:recipientMri];
                
                NSArray<NSString *> *components = [consumptionHorizon componentsSeparatedByString:@";"];
                if (components.count == 3)
                {
                    [allConsumptionHorizons setValue:[[components firstObject] asDecimalNumber] forKey:recipientMri];
                }
                else
                {
                    LogWarningAH(self.logger, @"consumption horizon ill-format: %@", consumptionHorizon);
                }
            }
            
            if ([self.allRecipientsConsumptionHorizons isEqualToDictionary:allConsumptionHorizons])
            {
                return;
            }
            
            self.allRecipientsConsumptionHorizons = allConsumptionHorizons;
            
            // updateTable dispatches to the main thread internally...
            [self updateTable:^{
                NSMutableArray *indexPaths = [[self.tableView indexPathsForVisibleRows] mutableCopy];
                if ([self.accountHandle.ecsManager smartReplyEnabledOnECS] && self.viewItems.count > 0 && self.viewItems[0][TSkIsSmartReply])
                {
                    NSIndexPath *smartReplyIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [indexPaths removeObject:smartReplyIndexPath];
                }
                
                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            [self updateConsumptionHorizonLabelCells];
        }
        else
        {
            LogInfoAH(self.logger, @"consumption horizon empty for all chat participants");
        }
    });
}

// This method should not be called very frequently - only when user enters chat
- (void) syncLatestMemberConsumptionHorizon
{
    if (![self readReceiptsEnabled]) {
        LogVerboseAH(self.logger, @"read receipts disabled");
        return;
    }
    
    NSString *correlationID = [NSString stringWithFormat:TSkCorrelationTagGetMemberConsumptionHorizon, NSUUID.UUID.UUIDString];
    TSAction *getConsHorizonAction = [self.actionContext actionOfClass:TSNAGetConsumptionHorizon.class
                                                        fromDictionary:@{
        TSkThreadID      : self.threadID,
        TSkCorrelationID : correlationID,
        @"statusMessage" : [NSString stringWithFormat:@"fetching consumption horizon for chat container %@", self.threadID],                                                                 }
                                                        withCompletion:nil];
    __weak typeof(self) weakSelf = self;
    [getConsHorizonAction executeActionChain:[NSString stringWithFormat:@"fetching consumption horizon for chat container %@", self.threadID]
                              withCompletion:^(TSAction *action, TSAResult *result, NSError *err)
     {
        [weakSelf updateMemberConsumptionHorizonTime];
    }];
}

- (BOOL) shouldShowReadByInContextMenuForMsg:(TSSMessage*)message
{
    if (([[message ts_isSentByMe] boolValue] || self.accountHandle.policyManager.shouldShowReadByInContextMenuForAllMessage) && ![message.isLocal boolValue])
    {
        if (self.accountHandle.policyManager.shouldShowReadByInContextMenuForAllMessage && [self.recipientIDs count] == 1)
        {
            return NO;
        }
        if ((self.threadType == TSThreadTypeGroupChat || self.threadType == TSThreadTypePrivateMeeting))
        {
            return [self readReceiptsEnabled];
        }
    }
    
    return NO;
}

- (BOOL) readReceiptsEnabled
{
    if ([NSString isNilOrEmpty:self.threadID])
    {
        return NO;
    }
    
    if ([self.recipientIDs count] >= self.readReceiptsMaxParticipants || [NSArray isNilOrEmpty:self.recipientIDs])
    {
        return NO;
    }
    
    if ((self.threadType == TSThreadTypeOneOnOneChat) || (self.threadType == TSThreadTypeGroupChat))
    {
        return [self.accountHandle.userSettingsManager readReceiptsEnabled];
    }
    else if (self.threadType == TSThreadTypePrivateMeeting)
    {
        return [self.accountHandle.ecsManager meetingReadReceiptsEnabled];
    }
    
    return NO;
}

- (BOOL) supportsViewPersistence
{
    return ([self.accountHandle.ecsManager viewRestorationEnabled]);
}

- (BOOL) shouldShowReactPromptForMessage:(NSNumber *)msgID
{
    if (![self.accountHandle.ecsManager doubleTapToLikeEnabled])
    {
        return NO;
    }
    
    TSSMessage *message = [AXPCtx messageForID:msgID andThreadID:self.threadID];
    
    if (message.isDeleted)
    {
        return NO;
    }
    
    if ([[message isLocal] boolValue])
    {
        return NO;
    }
    
    if (message.policyViolationMessageState.integerValue == TSDLPStateBlocked && !message.ts_isSentByMe.boolValue)
    {
        return NO;
    }
    
    if ([[message reactionsSummary] count] > 0)
    {
        return NO;
    }
    
    if ([self.contextOptionsHandler supportReactionForMessage:message])
    {
        return (![message.myReaction isNotNilOrEmpty]);
    }
    
    return NO;
}

- (BOOL) isLastMessageSentByOthers:(TSMessageInfo *)messageInfo
{
    if (messageInfo.tsID.intValue == self.lastMessageID.intValue)
    {
        return !messageInfo.isSentByMe.boolValue;
    }
    
    return NO;
}

// This method assumes messageList is in desc order. latest msg first
- (void) saveLastMessageID:(NSArray *)messageList
{
    if ([[messageList firstObject] isKindOfClass:NSDictionary.class])
    {
        NSDictionary *viewItem = (NSDictionary *)[messageList firstObject];
        self.lastMessageID = [viewItem valueForKey:@"tsID"];
    }
}

// This method assumes messageList is in desc order. latest msg first
- (BOOL) isLastMessageSentByMe:(NSArray *)messageList
{
    BOOL isLastMessageSentByMe = NO;
    if ([[messageList firstObject] isKindOfClass:NSDictionary.class])
    {
        NSDictionary *viewItem = (NSDictionary *)[messageList firstObject];
        isLastMessageSentByMe = [self isMessageSentByMe:viewItem];
    }
    
    return isLastMessageSentByMe;
}

- (BOOL)isMessageSentByMe:(NSDictionary *)viewItem
{
    NSString *userMri = [[viewItem valueForKey:@"userID"] asString];
    NSString *myMri = self.accountHandle.MRI;
    return [userMri isNotNilOrEmpty] && [userMri compareString:myMri];
}

- (BOOL) isTwoWaySMSUser:(NSString *)recipientID
{
    NSDictionary *userInfo = self.recipientsUserInfo[recipientID];
    if (!userInfo)
    {
        return NO;
    }
    
    NSString *phoneNumber = userInfo[TSkItemInfoPhone];
    if (!phoneNumber)
    {
        return NO;
    }
    
    return [[TSPhoneNumberUtils sharedInstance] isPhoneNumber2WaySMSEnabled:phoneNumber];
}

- (BOOL)singleOffNetworkUserInviteFlowEnabled
{
    if (self.recipientIDs.count == 1)
    {
        BOOL singleOffNetworkUser = [self isOutOfNetworkUser:self.recipientIDs.firstObject];
        return singleOffNetworkUser && self.accountHandle.policyManager.isOffNetworkSingleUserInviteEnabled;
    }
    return NO;
}

- (BOOL) isOutOfNetworkUser:(NSString *)recipientID
{
    NSDictionary *userInfo = self.recipientsUserInfo[recipientID];
    if (!userInfo)
    {
        return NO;
    }
    
    // for convenience and to minimize code changes. Only out-of network users will set searchResultItemType. For ex: DeviceContactType
    // any existing TSUser doesn't need to provide extra userInfoAttributes as it can be fetched from the localDB.
    if ([userInfo[TSkSearchResultItemType] isNotNilOrWhitespace])
    {
        return YES;
    }
    
    return NO;
}

- (NSString *) getOutOfNetworkUser:(NSString *)infoKey from:(NSString *)recipientID
{
    NSDictionary *userInfo = self.recipientsUserInfo[recipientID];
    NSString *infoValue = userInfo[infoKey];
    
    if (infoValue == nil)
    {
        LogErrorAH(self.logger,
                   @"%@ attribute was not set for (out of network) userId: %@",
                   infoKey,
                   [recipientID scrubPIIWithAccountHandle:self.accountHandle forceScrubbing:YES]
                   );
    }
    
    return [infoValue isNotNilOrWhitespace] ? infoValue : nil;
}

- (NSString *) getOutOfNetworkUserDisplayName:(NSString *)recipientID
{
    return [self getOutOfNetworkUser:TSkDisplayName from:recipientID];
}

- (NSString *) getOutOfNetworkUserPhoneNumber:(NSString *)recipientID
{
    NSDictionary *userInfo = self.recipientsUserInfo[recipientID];
    NSString *phone = userInfo[TSkPhoneNumber];
    
    return [phone isNotNilOrWhitespace] ? phone : nil;
}

- (UIImage *) getOutOfNetworkUserAvatar:(NSString *)recipientID
{
    NSDictionary *userInfo = self.recipientsUserInfo[recipientID];
    NSString *searchUserType = userInfo[TSkSearchResultItemType];
    
    // we can expect profile image only for device contacts
    if (![searchUserType isEqualToString:TSkDeviceContactSearchType])
    {
        return nil;
    }
    
    return userInfo[TSkUserProfileImage];
}

#pragma mark - TSChatMessageViewCellDelegate

- (BOOL)shouldAllowReplyToChat
{
    BOOL disableCompose = NO;
    [self placeHolderTextForComposeViewController:&disableCompose];
    return !disableCompose;
}

- (void) handleMessageSwipeReply:(NSNumber *)messageID threadID:(NSString *)threadID
{
    AXPPanelInfo *currentPanelInfo = [self biPanelInfo];
    if (currentPanelInfo)
    {
        [self.logger logPanelAction:TSkActionModuleNameMessageReplyButton
                            outCome:TSkActionOutcomeSubmit
                            gesture:TSkActionGestureSwipe
                           scenario:TSkScenarioReplyFromSwipe
                       scenarioType:TSkScenarioTypeQuotedReply
                     destinationuri:@""
               destinationUriParams:@""
                         moduleType:TSkModuleTypeCompose
                        moduleState:@""
                      moduleSummary:TSkActionModuleSummaryMessageReply
                          panelType:currentPanelInfo.type
                           panelUri:currentPanelInfo.uri
                     panelUriParams:currentPanelInfo.uriParams
                           threadId:self.threadID
                         threadType:currentPanelInfo.threadType
                           metaData:nil];
    }
    
    __weak typeof(self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        [weakSelf handleMessageReply:[AXPCtx messageForID:messageID andThreadID:threadID]];
    }];
}

- (BOOL)canQuoteMessageID:(NSNumber *)messageID
{
    if (self.composeViewController.hasAudioMessage ||
        (![self isTfLInterOpOrOffNetworkFedChat] && !self.composeViewControllerShouldShowComposeExtension))
    {
        return NO;
    }
    
    if ([TSConversation didUserLeaveChatwithThreadID:self.threadID] || [self shouldDisableFedChatComposeOptions])
    {
        return NO;
    }
    
    TSMessageInfo *message = [self.messageDictionary objectForKey:messageID];
    
    return (![message isLocal].boolValue &&
            ![message isControlMessage] &&
            ![message isMeetingMessage] &&
            ![message isMeetNowMeetingMessage] &&
            ![message isMeetupMessage] &&
            ![message isRecordingMessage] &&
            ![message isUserDeletedMessage] &&
            ![message isSystemDeletedMessage]);
}

- (void)didTapTranscriptionPreviewWithMessageInfo:(TSMessageInfo *)messageInfo
{
    NSString *threadID = self.threadID;
    NSManagedObjectContext *moc = self.accountHandle.highPriMOC;
    NSString *title = [self getNavTitle];
    TSAccountHandle* accountHandle = self.accountHandle;
    TSMeetingInfo *meetingInfo = [[TSMeetingInfo alloc] initWithJson:(NSDictionary *)self.thread.meeting];
    TSWeakify(self);
    DbReadWrite(SELECTOR_NAME(self), moc, ^{
        TSStrongifyAndReturnIfNil(self);
        TSConversation *conversation = [AXPCtx conversationForID:threadID inMOC:moc];
        BOOL isChannel = conversation.isChannelThread;
        [TSDispatchUtilities dispatchOnMainThread:^{
            TSTranscriptDetailCoordinatorBridge* coordinator = [[TSTranscriptDetailCoordinatorBridge alloc] initWithBaseNavigationController:self.navigationController messageInfo:messageInfo isChannel:isChannel title:title accountHandle:accountHandle meetingInfo:meetingInfo];
            self.transcriptDetailCoordinator = coordinator;
            [self.transcriptDetailCoordinator start];
        }];
    });
}

#pragma mark - TSFullScreenComposeViewControllerDelegate

- (void) fullScreenComposeViewController:(TSBaseComposeViewController *)composeViewController
                     willFinishComposing:(NSDictionary *)composeInfo
                              completion:(void (^)(NSError *, NSNumber *, NSString *, NSString *, NSString *))completion
{
    [self composeViewController:composeViewController
            willFinishComposing:composeInfo
                     completion:completion];
}

- (void) didFinishFullScreenComposing:(TSBaseComposeViewController *)composeViewController
                        withMessageID:(NSNumber *)messageID
                          andThreadID:(NSString*)threadID
                           scenarioID:(NSString *)scenarioID
                        correlationID:(NSString *)correlationID
{
    [self composeViewControllerDidFinishComposing:composeViewController
                                    withMessageID:messageID
                                      andThreadID:threadID
                                       scenarioID:scenarioID
                                    correlationID:correlationID
                                  dismissComposer:NO];
}

- (NSString *) placeholderTextForFullScreenCompose
{
    BOOL disableCompose = NO;
    return [self.delegate placeHolderTextForComposeViewController:&disableCompose];
}

- (BOOL) isTextToEmoticonEnabled
{
    return TSSharedManagers.ecsConfigurationManager.isTextToEmoticonEnabled;
}

#pragma mark Meeting join banner view

- (BOOL)shouldShowMeetingOrGroupCallJoinBannerView
{
    //Hiding Banner in CIFX testing
    if([TSSharedManagers.buildConfigurationManager isCIFxTesting])
    {
        return NO;
    }
    return [self.threadID isNotNilOrEmpty] &&
    (self.threadType == TSThreadTypePrivateMeeting || self.threadType == TSThreadTypeGroupChat);
}

- (void)constructAndShowMeetingJoinBannerView
{
    if (!self.meetingBannerView)
    {
        self.meetingBannerView = [[TSMeetingBannerView alloc] initWithThreadId:self.threadID accountHandle:self.accountHandle];
        self.meetingBannerView.legacyAppearanceProxy = self.legacyAppearanceProxy;
    }
    
    [self.customBannerViewContainer addArrangedSubview:self.meetingBannerView];
    self.customBannerViewHeightConstraint.constant = TSkMeetingJoinBannerViewHeight;
    [self showJoinBannerIfRequired];
}

- (void)showJoinBannerIfRequired
{
    if (!self.didAnonJoinCallEnd)
    {
        if (self.threadType == TSThreadTypeGroupChat)
        {
            [self showGroupChatJoinBannerIfRequired];
        }
        else if (self.threadType == TSThreadTypePrivateMeeting)
        {
            [self showMeetingJoinBannerIfRequired];
        }
    }
}

- (void) showJoinBannerIfRequiredFromMessageListUpdate
{
    TSMessageInfo *message = [self.messageDictionary objectForKey:self.lastMessageID];
    if ([message isMeetupMessage])
    {
        [self showJoinBannerIfRequired];
    }
}

- (void)showGroupChatJoinBannerIfRequired
{
    if ([self.accountHandle.policyManager isCallingAllowed])
    {
        NSString *threadID = self.threadID;
        NSManagedObjectContext *moc = self.accountHandle.highPriMOC;
        TSWeakify(self);
        DbReadWrite(SELECTOR_NAME(self), moc, ^{
            TSStrongifyAndReturnIfNil(self);
            TSConversation *conversation = nil;
            if (![NSString isNilOrWhitespace:threadID])
            {
                conversation = [AXPCtx conversationForID:threadID inMOC:moc];
            }
            
            BOOL shouldShowJoinBanner = NO;
            if (conversation)
            {
                // Hide the banner if the user has left the chat, group
                // calls are disabled, or if an associated call exists.
                shouldShowJoinBanner = ![conversation didUserLeaveChat] &&
                ![[TSCallManager sharedInstance] callForCallThreadId:threadID];
            }
            
            // Block for hiding the banner.
            void (^hideBannerBlock)(void) = ^{
                [TSDispatchUtilities dispatchOnMainThread:^{
                    TSStrongifyAndReturnIfNil(self);
                    if (self.accountHandle.ecsManager.shouldShowMeetingBannerDefaultState)
                    {
                        [self.meetingBannerView transitionToDefaultState];
                    }
                    
                    if (self.customBannerViewContainer.hidden != YES && ![self shouldShowChatViewBannerForFederatedChat])
                    {
                        self.customBannerViewContainer.hidden = YES;
                        [self.composeViewController applyMaxLineCountToBodyTextView];
                    }
                    
                    [self updateNavigationRightBarItemsAnimated:NO];
                }];
            };
            
            if (shouldShowJoinBanner)
            {
                // Fetch details to verify showing the banner.
                void (^detailsBlock)(TSMeetingCallDetails *, NSError *) = ^(TSMeetingCallDetails *details, NSError *error) {
                    TSStrongifyAndReturnIfNil(self);
                    if (error)
                    {
                        LogWarningAH(self.logger, @"TSChatViewController.showGroupChatJoinBannerIfRequired: Error occured while fetching details.");
                    }
                    
                    if ([NSString isNilOrWhitespace:details.threadID] ||
                        [NSString isNilOrWhitespace:details.rootMessageID] ||
                        [NSString isNilOrWhitespace:details.awareness])
                    {
                        hideBannerBlock();
                    }
                    else
                    {
                        [TSDispatchUtilities dispatchOnMainThread:^{
                            TSStrongifyAndReturnIfNil(self);
                            [self.meetingBannerView transitionToMeetingInProgress];
                            if (self.customBannerViewContainer.hidden != NO)
                            {
                                LogInfoAH(self.logger, @"TSChatViewController.showGroupChatJoinBannerIfRequired: Show banner for group chat.");
                                self.customBannerViewContainer.hidden = NO;
                                [self.composeViewController applyMaxLineCountToBodyTextView];
                            }
                            
                            [self updateNavigationRightBarItemsAnimated:NO];
                        }];
                    }
                };
                
                [[TSMeetingCallDetailsProvider sharedInstance] fetchDetailsForThreadID:threadID
                                                                         rootMessageID:@"0"
                                                                             messageID:nil
                                                                              tenantID:nil
                                                                           organizerID:nil
                                                                           meetingData:nil
                                                                              callType:TSGroupCall
                                                                                   moc:moc
                                                                            completion:detailsBlock];
            }
            else
            {
                // Skip fetching details if hiding the banner.
                hideBannerBlock();
            }
        });
    }
}

- (void)showMeetingJoinBannerIfRequired
{
    NSString *threadID = self.threadID;
    NSManagedObjectContext *moc = self.accountHandle.highPriMOC;
    TSWeakify(self);
    DbReadWrite(SELECTOR_NAME(self), moc, ^{
        TSStrongifyAndReturnIfNil(self);
        TSConversation *conversation = nil;
        if (![NSString isNilOrWhitespace:threadID])
        {
            conversation = [AXPCtx conversationForID:threadID inMOC:moc];
        }
        
        BOOL shouldShowJoinBanner = NO;
        if (conversation)
        {
            // Hide the banner if not a private meeting, private meetings
            // or scheduled meet now are disabled, or if an associated call exists.
            shouldShowJoinBanner = [conversation isPrivateMeeting] &&
            ([self.accountHandle.policyManager isPrivateMeetingEnabled] || [self.accountHandle.policyManager isScheduledMeetNowEnabled]) &&
            ![[TSCallManager sharedInstance] callForCallThreadId:threadID];
        }
        
        NSString *meetingData = nil;
        if (shouldShowJoinBanner)
        {
            // Hide the banner if the meeting is canceled.
            TSThread *thread = [AXPCtx threadForID:threadID inMoc:moc];
            shouldShowJoinBanner = thread && ![thread isCanceledMeeting];
            
            if (shouldShowJoinBanner) {
                meetingData = [thread meetingsMeetingData];
            }
        }
        
        // Block for hiding the banner.
        void (^hideBannerBlock)(void) = ^{
            [TSDispatchUtilities dispatchOnMainThread:^{
                TSStrongifyAndReturnIfNil(self);
                if (self.accountHandle.ecsManager.shouldShowMeetingBannerDefaultState)
                {
                    [self.meetingBannerView transitionToDefaultState];
                }
                
                if (self.customBannerViewContainer.hidden != YES && ![self shouldShowChatViewBannerForFederatedChat])
                {
                    self.customBannerViewContainer.hidden = YES;
                    [self.composeViewController applyMaxLineCountToBodyTextView];
                }
            }];
        };
        
        if (shouldShowJoinBanner)
        {
            // Fetch details to verify showing the banner.
            void (^detailsBlock)(TSMeetingCallDetails *, NSError *) = ^(TSMeetingCallDetails *details, NSError *error) {
                TSStrongifyAndReturnIfNil(self);
                if (error)
                {
                    LogWarningAH(self.logger, @"TSChatViewController.showMeetingJoinBannerIfRequired: Error occured while fetching details.");
                }
                
                if (([NSString isNilOrWhitespace:details.threadID] ||
                     [NSString isNilOrWhitespace:details.rootMessageID] ||
                     [NSString isNilOrWhitespace:details.organizerID] ||
                     [NSString isNilOrWhitespace:details.tenantID])
                    && [NSString isNilOrWhitespace:meetingData])
                {
                    LogWarningAH(self.logger, @"TSChatViewController.showMeetingJoinBannerIfRequired: Can't join meeting: thread ID: %@, root message ID: %@, organizer ID: %@, tenant ID: %@, has meetingData: %@.",
                                 details.threadID,
                                 details.rootMessageID,
                                 details.organizerID,
                                 details.tenantID,
                                 @([NSString isNilOrWhitespace:meetingData]));
                    
                    hideBannerBlock();
                }
                else
                {
                    BOOL didUserLeave = [TSConversation didUserLeaveChatwithThreadID:threadID inMoc:moc];
                    BOOL isCallInProgress = ![NSString isNilOrWhitespace:details.awareness];
                    [TSDispatchUtilities dispatchOnMainThread:^{
                        TSStrongifyAndReturnIfNil(self);
                        BOOL shouldTransitToMeetingInProgress = isCallInProgress && !didUserLeave;
                        if (shouldTransitToMeetingInProgress)
                        {
                            [self.meetingBannerView transitionToMeetingInProgress];
                        }
                        else
                        {
                            if (self.accountHandle.ecsManager.shouldShowMeetingBannerDefaultState)
                            {
                                [self.meetingBannerView transitionToDefaultState];
                            }
                        }
                        
                        if (self.customBannerViewContainer.hidden != NO)
                        {
                            // We hide the banner if default banner is not supported by ECS(default value is YES), or if user is no longer part of chat thread,
                            // and we are switching from inProgress to default banner
                            BOOL shouldHideBanner = !shouldTransitToMeetingInProgress && (!self.accountHandle.ecsManager.shouldShowMeetingBannerDefaultState || didUserLeave);
                            LogInfoAH(self.logger, @"TSChatViewController.showMeetingJoinBannerIfRequired: %@ banner for meeting.", shouldHideBanner ? @"hide" : @"show");
                            self.customBannerViewContainer.hidden = shouldHideBanner;
                            [self.composeViewController applyMaxLineCountToBodyTextView];
                        }
                    }];
                }
            };
            
            [[TSMeetingCallDetailsProvider sharedInstance] fetchDetailsForThreadID:threadID
                                                                     rootMessageID:@"0"
                                                                         messageID:nil
                                                                          tenantID:nil
                                                                       organizerID:nil
                                                                       meetingData:meetingData
                                                                          callType:TSMeetingCall
                                                                               moc:moc
                                                                        completion:detailsBlock];
        }
        else
        {
            // Skip fetching details if hiding the banner.
            hideBannerBlock();
        }
    });
}

#pragma mark Live location

- (BOOL) isSharingLiveLocation
{
    return self.accountHandle.policyManager.isLocationWithLiveSharingEnabled &&
    [[ResolveProtocol(LocationDependencyRegistrarProtocol) userDependenciesWithAccountHandle:self.accountHandle].sharingSessionRepositoryBridge isActivelySharingInGroupId:self.threadID];
}

- (BOOL) shouldShowLocationBanner
{
    return ([self isSharingLiveLocation] &&
            self.customBannerViewContainer.isHidden &&
            !self.didDismissLocationBanner &&
            [self.locationBannerCoordinator shouldDisplayBanner] &&
            !(IS_LANDSCAPE() && IS_IPHONE()));
}

- (void) updateLocationBannerVisibility
{
    BOOL shouldShowLocationBanner = [self shouldShowLocationBanner];
    if (shouldShowLocationBanner)
    {
        [self constructLiveLocationBannerIfNecessary];
    }
    self.locationBannerViewContainer.hidden = !shouldShowLocationBanner;
    self.locationBannerContainerHeightConstraint.constant = shouldShowLocationBanner ? TSkLocationBannerViewHeight : 0;
}

- (void) constructLiveLocationBannerIfNecessary
{
    if (!self.locationBannerView)
    {
        self.locationBannerView = [self.locationBannerCoordinator bannerView];
        [self.locationBannerViewContainer addSubview:self.locationBannerView withEdgeInsets:UIEdgeInsetsZero];
    }
}

#pragma mark TSLocationBannerDelegate

- (void)locationBannerDidTapDismiss
{
    self.didDismissLocationBanner = YES;
    [self updateLocationBannerVisibility];
}

- (void)locationBannerDidTapNotificationSettings
{
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                     options:@{}
                           completionHandler:nil];
}

- (void)didStopSharingLiveLocation
{
    [self updateLocationBannerVisibility];
}

- (void)didStartSharingLiveLocation
{
    [self updateLocationBannerVisibility];
}

#pragma mark Meeting chat mute state

- (BOOL)shouldShowMeetingChatMuteStateBanner
{
    if (self.threadType == TSThreadTypePrivateMeeting
        && self.accountHandle.ecsManager.meetingChatMuteSettingsEnabledOnECS
        && self.accountHandle.ecsManager.showMeetingChatMuteSettingsNotificationEnabledOnECS)
    {
        BOOL hasUserActedOnBanner = [[self.accountHandle.tenantDefaults objectForKey:TSkChatMutedBannerUserHandledKey] boolValue];
        return !hasUserActedOnBanner && [[self.accountHandle.tenantDefaults objectForKey:TSkChatMutedBannerShownCountKey] integerValue] < TSkChatMutedBannerShowMaxCount;
    }
    
    return NO;
}

- (void)constructAndShowChatMuteStatusBannerView:(BOOL)isUnmuted
{
    if (isUnmuted)
    {
        self.chatMuteStateBannerView = [[TSChatMuteStatusChangeBannerView alloc] initWithState:TSChatMuteStatusBannerStateUnmuted];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf removeChatMuteStateBannerView];
        });
    }
    else
    {
        self.chatMuteStateBannerView = [[TSChatMuteStatusChangeBannerView alloc] initWithState:TSChatMuteStatusBannerStateSomeChatsMuted];
        NSInteger count = [[self.accountHandle.tenantDefaults objectForKey:TSkChatMutedBannerShownCountKey] integerValue];
        [self.accountHandle.tenantDefaults setObject:@(count+1) forKey:TSkChatMutedBannerShownCountKey];
        
        __weak typeof(self) weakSelf = self;
        self.chatMuteStateBannerView.viewSettingsButtonAction = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.accountHandle.tenantDefaults setObject:@(YES) forKey:TSkChatMutedBannerUserHandledKey];
            [strongSelf removeChatMuteStateBannerView];
            [AXPApp navigateToMeetingChatsMuteSettingsFrom:strongSelf];
        };
        
        self.chatMuteStateBannerView.dismissBannerAction = ^{
            [weakSelf.accountHandle.tenantDefaults setObject:@(YES) forKey:TSkChatMutedBannerUserHandledKey];
            [weakSelf removeChatMuteStateBannerView];
        };
    }
    
    [[self.customBannerViewContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // TODO: (suryap) Remove existing banner views from the container
    // Increase the userDefaults counter
    [self.customBannerViewContainer addArrangedSubview:self.chatMuteStateBannerView];
    self.customBannerViewContainer.hidden = NO;
    [self.chatMuteStateBannerView setNeedsLayout];
    [self.chatMuteStateBannerView layoutIfNeeded];
    self.customBannerViewHeightConstraint.constant = self.chatMuteStateBannerView.contentContainerHeight;
}

- (BOOL)shouldShowFederatedThreadWithBlockedUserBanner
{
    return ![TSConversation didUserLeaveChatwithThreadID:self.threadID] && self.isRosterWithBlockedTenantFedUser;
}

- (BOOL)shouldShowChatViewBannerForFederatedChat
{
    if (!self.chatBannerView)
    {
        return NO;
    }
    
    return (self.chatBannerView.chatBannerType == TSkFederatedChatWithBlockedUsers
            || self.chatBannerView.chatBannerType == TSkFederatedChatWithSfBUsers
            || (self.chatBannerView.chatBannerType == TSkFederatedChatMessageRelatedPolicy && !self.hasCancelledFedInfoBanner));
}

- (void)removeChatMuteStateBannerView
{
    if (self.chatMuteStateBannerView)
    {
        __weak typeof(self) weakSelf = self;
        [TSDispatchUtilities dispatchOnMainThread:^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.customBannerViewContainer removeArrangedSubview:strongSelf.chatMuteStateBannerView];
            strongSelf.chatMuteStateBannerView = nil;
            strongSelf.customBannerViewContainer.hidden = YES;
            if ([strongSelf shouldShowMeetingOrGroupCallJoinBannerView])
            {
                [strongSelf constructAndShowMeetingJoinBannerView];
            }
        }];
    }
}

- (void) unmuteChatIfRequired
{
    __weak typeof(self) weakSelf = self;
    [TSCallUtilities unmuteConversationBasedOnMeetingChatMuteSetting:self.threadID
                                                       accountHandle:self.accountHandle
                                             unmuteCompletionHandler:^
     {
        [TSDispatchUtilities dispatchOnMainThread:^{
            [weakSelf constructAndShowChatMuteStatusBannerView:YES];
            [weakSelf setIsMuted:NO];
        }];
    }];
}

#pragma mark Status Message Banner View

- (BOOL) shouldShowStatusMessageBannerView
{
    return ((self.threadType == TSThreadTypeOneOnOneChat || self.threadType == TSThreadTypeGroupChat)
            && [self.accountHandle.ecsManager enableStatusNoteV2]
            && [self.accountHandle.ecsManager enableBannerInStatusNoteV2]
            && self.recipientIDs.count < self.maxGroupChatParticipantsForFanout);
}

- (void) constructAndShowStatusMessageBannerView:(BOOL)showBanner
{
    if (!showBanner)
    {
        [self removeStatusMessageBannerView];
    }
    else
    {
        NSString *statusMessage = nil;
        NSMutableArray *arrayOfUserPresenceWithPinnedStatusMessage = [[NSMutableArray alloc] init];
        NSMutableArray *userIDs = [[NSMutableArray alloc] init];
        for (id recipient in self.recipientIDs)
        {
            TSUserPresence *presence = [[TSPresenceService defaultService] userPresenceStatusForUser:recipient];
            if ([presence.customStatusMessage isNotNilOrEmpty] && [presence.customStatusMessage containsString:TSkPinnedNote])
            {
                TSUser *user = [AXPCtx userForID:recipient];
                if (![user isUnknownUser])
                {
                    [arrayOfUserPresenceWithPinnedStatusMessage addObject: presence];
                    [userIDs addObject:recipient];
                }
            }
        }
        
        if (arrayOfUserPresenceWithPinnedStatusMessage.count > 0)
        {
            statusMessage = [self configureStatusMessage:arrayOfUserPresenceWithPinnedStatusMessage];
        }
        else
        {
            [self removeStatusMessageBannerView];
        }
        
        if ([statusMessage isNotNilOrEmpty])
        {
            bool userDismissedBanner = NO;
            if ([self.threadID isNotNilOrEmpty]) // new chat, dont check if previously dismissed
            {
                [self cleanUpBannerDismissals];
                NSString *bannerDismissalHash = [self generateHashForBannerDismiss:userIDs];
                userDismissedBanner = [self checkIfUserDismissedBanner:bannerDismissalHash];
            }
            // If user has not dismissed banner or if the dismissal has expired -> show banner, else -> remove banner
            if (userDismissedBanner)
            {
                [self removeStatusMessageBannerView];
            }
            else
            {
                NSString *statusMessageAccessibility = [statusMessage removeAllHtmlTags];
                self.statusMessageBannerView.statusMessage.accessibilityLabel = statusMessageAccessibility;
                
                NSDictionary * metaData = [TSUtilities metaDataFromDataBagDictionary:@{
                    TSkStatusBannerNumPinnedStatuses:[NSString stringWithFormat:@"%lu", (unsigned long)arrayOfUserPresenceWithPinnedStatusMessage.count],
                    TSkStatusBannerConversationId:self.threadID ? : @"creating new chat",
                    TSkStatusBannerNumChatMembers:[NSString stringWithFormat:@"%lu", (unsigned long)self.recipientIDs.count],
                    TSkStatusBannerNumOfSavedBannerDismissals:[NSString stringWithFormat:@"%lu", (unsigned long)[[[self.accountHandle.tenantDefaults valueForKey:TSkChatStatusMessageBannerMutedKey] valueForKey:self.threadID] count]]
                }];
                
                [self updateStatusMessageBannerViewWithUserIDs:userIDs
                                       andDisplayStatusMessage:statusMessage
                                                  withMetaData:metaData];
            }
        }
    }
    [self configureContentInset];
}

- (void) setContentInset: (UIEdgeInsets) insets
{
    // Added for awareness since content inset may be modified by parent classes
    [super setContentInset:insets];
}

- (void) removeStatusMessageBannerView
{
    [TSDispatchUtilities dispatchOnMainThread:^{
        if (self.statusMessageBannerView && !self.statusMessageBannerView.isHidden) {
            [self.statusMessageBannerView setHidden:YES];
            [self configureContentInset];
        }
    }];
}

- (void) updateInactiveGuardiansBanner
{
    if (self.accountHandle.ecsManager.isGuardianTeacherChatEnabled &&
        [self inactiveGuardiansBannerEnabled] &&
        self.inactiveGuardiansDisplayNames.count > 0)
    {
        self.inactiveGuardiansBannerView = [self inactiveGuardiansBanner];
        NSString *bannerLabel;
        
        if (self.inactiveGuardiansDisplayNames.count == 1)
        {
            bannerLabel = [NSString stringWithFormat:AXPLocalizedString(@"InactGrdBnrSgl2"),
                           self.inactiveGuardiansDisplayNames.firstObject];
        }
        else
        {
            bannerLabel = [NSString stringWithFormat:AXPLocalizedString(@"InactGrdBnrPlr2"),
                           [self.inactiveGuardiansDisplayNames componentsJoinedByString:AXPLocalizedString(@"CommaSeparatorTemplate")]];
        }
        [self.inactiveGuardiansBannerView setViewDataWithMessage:bannerLabel];
        
        [self.inactiveGuardiansBannerView setHidden: NO];
        [self.view addSubview:self.inactiveGuardiansBannerView];
        
        NSInteger addIndex = [self.stackView.arrangedSubviews indexOfObject:self.encryptionMessageView];
        if (addIndex != NSNotFound)
        {
            [self.stackView insertArrangedSubview:self.inactiveGuardiansBannerView atIndex:addIndex + 1];
        }
        
        [self.logger logPanelView:TSkPanelTypeChat scenario:TSkScenarioGuardianChatGuardianRemovedBanner scenarioType:TSkScenarioTypeGuardianChatNoParent];
    }
    else
    {
        [self.inactiveGuardiansBannerView setHidden:YES];
    }
}

- (void) updateStatusMessageBannerViewWithUserIDs:(NSArray * _Nonnull)userIDs
                          andDisplayStatusMessage:(NSString * _Nonnull)statusMessage
                                     withMetaData:(NSDictionary * _Nonnull)metaData
{
    __weak typeof(self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        [weakSelf.statusMessageBannerView setStatusMessageText:statusMessage accountHandle:weakSelf.accountHandle];
        
        weakSelf.statusMessageBannerView.dismissBannerAction = ^{
            [weakSelf removeStatusMessageBannerView];
            [TSStatusMessageUtils logStatusBannerDismissedEvent:metaData accountHandle:weakSelf.accountHandle];
            
            // self.threadID may be nil for new chats, we dont want to generate a hash if the chat has not been created yet.
            if ([weakSelf.threadID isNotNilOrEmpty])
            {
                NSString *bannerDismissalHash = [weakSelf generateHashForBannerDismiss:userIDs];
                [weakSelf userDismissedBanner:bannerDismissalHash];
            }
        };
        weakSelf.statusMessageBannerView.tappedOnBannerTextView = ^{
            [weakSelf tappedOnAttributedText:weakSelf.statusMessageBannerView.attributedTextGestureRecognizer inTextView:weakSelf.statusMessageBannerView.statusMessage];
        };
        [self.statusMessageBannerView setHidden:NO];
        [self.stackView sendSubviewToBack:self.statusMessageBannerView];
        [TSStatusMessageUtils logStatusBannerShownEvent:metaData accountHandle:self.accountHandle];
    }];
}

// Just display a simple status message without userids
- (void) displayStatusMessageBannerViewWithStatusMessage:(NSString *)statusMessage
{
    if ([statusMessage isNotNilOrEmpty]){
        __weak typeof(self) weakSelf = self;
        [TSDispatchUtilities dispatchOnMainThread:^{
            [weakSelf.statusMessageBannerView setStatusMessageText:statusMessage accountHandle:weakSelf.accountHandle];
            
            weakSelf.statusMessageBannerView.dismissBannerAction = ^{
                [weakSelf removeStatusMessageBannerView];
            };
            [weakSelf.statusMessageBannerView setHidden:NO];
        }];
    }
}

// Clean up objects in dictionary with expired Dismissal Times
- (void) cleanUpBannerDismissals
{
    NSMutableArray *objectsToBeRemoved = [[NSMutableArray alloc] init];
    NSMutableDictionary *statusMessageBannerMutedDict = [[self.accountHandle.tenantDefaults valueForKey:TSkChatStatusMessageBannerMutedKey] mutableCopy] ?: [[NSMutableDictionary alloc] init];
    NSMutableDictionary *convIdDict = [[statusMessageBannerMutedDict valueForKey:self.threadID] mutableCopy] ?: [[NSMutableDictionary alloc] init];
    for (NSString *key in convIdDict)
    {
        NSDate *bannerDismissedTime = [convIdDict sam_safeObjectForKey:key];
        
        NSDate *bannerDismissedExpiry = (self.threadType == TSThreadTypeOneOnOneChat) ? [bannerDismissedTime dateByAddingDays:self.oneOnOneChatBannerDismissTimeFrameInDays] :
        [bannerDismissedTime dateByAddingDays:self.groupChatBannerDismissTimeFrameInDays];
        
        if ([bannerDismissedExpiry compare:[NSDate date]] == NSOrderedAscending)
        {
            [objectsToBeRemoved addObject:key];
        }
    }
    [convIdDict removeObjectsForKeys:objectsToBeRemoved];
    [statusMessageBannerMutedDict setObject:convIdDict forKey:self.threadID];
    [self.accountHandle.tenantDefaults setObject:statusMessageBannerMutedDict forKey:TSkChatStatusMessageBannerMutedKey];
}

- (NSString * _Nonnull) generateHashForBannerDismiss:(NSArray * _Nonnull)userIDs
{
    NSMutableString *mriAndStatusHash = [[NSMutableString alloc] initWithString:[self.threadID stringByAppendingString:self.accountHandle.MRI]];
    // Hash is concatenation of convID + currentUserMRI + (each user's MRI in the chat with pinned statuses sorted by MRI)
    if (userIDs.count > 1)
    {
        NSArray *sortedUserIDs = [[userIDs sortedArrayUsingSelector:@selector(localizedCompare:)] mutableCopy];
        for(NSString *userID in sortedUserIDs)
        {
            // Only care about MRI because if there are multiple users, it will show the default banner in which case even if their message changes, we would still see the default multiple user banner so we will not display banner again on message change.
            [mriAndStatusHash appendString:userID];
        }
    }
    else // Hash is concatenation of convID + currentUserMRI + (user's MRI in the chat + their pinned statuses + post time)
    {
        TSUserPresence *presence = [[TSPresenceService defaultService] userPresenceStatusForUser:[userIDs firstObject]];
        // If one user, we care about the message because it will be shown so if user changes it, we do want to show the banner again due to change in message.
        [mriAndStatusHash appendString:[userIDs firstObject]];
        [mriAndStatusHash appendString:presence.customStatusMessage];
        [mriAndStatusHash appendString:presence.customStatusMessageTime];
    }
    return [mriAndStatusHash sam_MD5Digest];
}

- (BOOL) checkIfUserDismissedBanner:(NSString * _Nonnull)bannerDismissalHash
{
    NSDictionary *statusMessageBannerMutedDict = [self.accountHandle.tenantDefaults valueForKey:TSkChatStatusMessageBannerMutedKey];
    NSDictionary *convIdDict = [statusMessageBannerMutedDict valueForKey:self.threadID];
    
    return ([convIdDict sam_safeObjectForKey:bannerDismissalHash]) ? YES : NO;
}

- (void) userDismissedBanner:(NSString * _Nonnull)bannerDismissalHash
{
    NSMutableDictionary *statusMessageBannerMutedDict = [[self.accountHandle.tenantDefaults valueForKey:TSkChatStatusMessageBannerMutedKey] mutableCopy];
    NSMutableDictionary *convIdDict = [[statusMessageBannerMutedDict valueForKey:self.threadID] mutableCopy];
    if (convIdDict.count == self.bannerDismissDictMaxCount)
    {
        NSDate *oldestBannerDismissed = [NSDate dateWithTimeIntervalSince1970:(double)TSkNeverExpiryDateInMilliseconds/1000];
        NSString *keyOfOldestBannerDismissed = nil;
        for (NSString *key in convIdDict)
        {
            NSDate *bannerDismissedTime = [convIdDict sam_safeObjectForKey:key];
            
            if (bannerDismissedTime < oldestBannerDismissed)
            {
                oldestBannerDismissed = bannerDismissedTime;
                keyOfOldestBannerDismissed = key;
            }
        }
        [convIdDict removeObjectForKey:keyOfOldestBannerDismissed];
        
    }
    [convIdDict setObject:[NSDate date] forKey:bannerDismissalHash];
    [statusMessageBannerMutedDict setObject:convIdDict forKey:self.threadID];
    [self.accountHandle.tenantDefaults setObject:statusMessageBannerMutedDict forKey:TSkChatStatusMessageBannerMutedKey];
}

- (NSString *)configureStatusMessage:(NSArray *)arrayOfUserPresenceWithPinnedStatusMessage
{
    NSString *statusMessage = nil;
    TSUser *personA = [AXPCtx userForID:[[arrayOfUserPresenceWithPinnedStatusMessage firstObject] valueForKey:@"userMri"]];
    if (arrayOfUserPresenceWithPinnedStatusMessage.count == 1)
    {
        NSString *statusOf = [NSString stringWithFormat:AXPLocalizedString(@"StsMsgBanner1Sts"), personA.shortDisplayName];
        
        // Create Mention Attachment for "Status Of User: " then convert back to html string
        TSMentionTextAttachment *mentionAttachment = [[TSMentionTextAttachment alloc] initWithID:personA.tsID
                                                                                     mentionType:TSkMentionTypePerson
                                                                                  displayingName:statusOf
                                                                             withBackgroundColor:self.view.backgroundColor
                                                                                     andFontInfo:[TSFont mentionFontInfoForFont:[TSFont footnote]]];
        NSAttributedString *atMentionString = [NSAttributedString attributedStringWithAttachment:mentionAttachment];
        
        TSConnectorTextAttachmentDelegate *textAttachment = [[TSConnectorTextAttachmentDelegate alloc] init];
        NSString *html = [atMentionString HTMLStringWithAttachmentDelegate:textAttachment
                                                  withDefaultFontTextStyle:UIFontTextStyleFootnote
                                                          withDefaultColor:self.legacyAppearanceProxy.primaryTextColor
                                                                    logger:self.logger];
        
        NSString *userStatusMessage = [[arrayOfUserPresenceWithPinnedStatusMessage firstObject] valueForKey:@"customStatusMessage"];
        
        // Format = "Status of Jane D.: status Message"
        statusMessage = [NSString stringWithFormat:@"%@ %@",html, userStatusMessage];
        statusMessage = [statusMessage removeAttachmentCharacter];
    }
    else
    {
        TSUser *personB = [AXPCtx userForID:[[arrayOfUserPresenceWithPinnedStatusMessage objectAtIndex:1] valueForKey:@"userMri"]];
        if (arrayOfUserPresenceWithPinnedStatusMessage.count == 2)
        {
            statusMessage = [NSString stringWithFormat:AXPLocalizedString(@"StsMsgBanner2Sts"), personA.shortDisplayName, personB.shortDisplayName];
        }
        else
        {
            statusMessage = [NSString stringWithFormat: AXPLocalizedString(@"StsMsgBannerMultiSts"),
                             personA.shortDisplayName,
                             personB.shortDisplayName,
                             [TSUtilities stringForNumber:(unsigned long long)arrayOfUserPresenceWithPinnedStatusMessage.count - 2]];
        }
    }
    return statusMessage;
}

- (void)startRetrievingDLPMessageWithMessageId:(NSNumber *)messageId threadId:(NSString *)threadId onSuccess:(nullable void (^)(BOOL shouldOpenContextMenu))completion
{
    __block BOOL shouldOpenContextMenu = YES;
    UIAlertController *statusAlertController = [TSAlertUtils alertControllerWithTitle:nil
                                                                              message:AXPLocalizedString(@"DLPFetchingBlockedMessageText")];
    [statusAlertController addAction:[UIAlertAction actionWithTitle:AXPLocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                      {
        shouldOpenContextMenu = NO;
    }]];
    [self presentViewController:statusAlertController animated:YES completion:nil];
    
    __weak typeof(self) weakSelf = self;
    [self.dlpViewModel getOriginalBlockedMessageWithId:messageId threadId:threadId completion:^(NSError *error)
     {
        [TSDispatchUtilities dispatchOnMainThread:^{
            [statusAlertController dismissViewControllerAnimated:YES completion:^
             {
                if (error)
                {
                    UIAlertController *alert = [TSAlertUtils alertControllerWithTitle:nil
                                                                              message:AXPLocalizedString(@"DLPRetrieveBlockedMessageFailText")];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:AXPLocalizedString(@"OK") style:UIAlertActionStyleCancel handler:nil]];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
                else
                {
                    if (completion)
                    {
                        completion(shouldOpenContextMenu);
                    }
                }
            }];
        }];
    }];
}

- (void) groupCallDialog:(BOOL)video
{
    UIAlertController * alert = [TSAlertUtils alertControllerWithTitle:AXPLocalizedString(@"GroupCallConfirmCallTitle")
                                                               message:AXPLocalizedString(@"GroupCallConfirmCallMessage")];
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction *actionCall = [UIAlertAction actionWithTitle:AXPLocalizedString(@"CallButtonTitle")
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
        [weakSelf startAudioOrVideoCall:video];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:AXPLocalizedString(@"Cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
        [self.logger logPanelAction:video ? TSkActionModuleNameVideoButton : TSkActionModuleNameAudioButton
                            outCome:TSkActionOutcomeSubmit
                            gesture:TSkActionGestureTap
                           scenario:video ? SCENARIO_CALL_CANCEL_VIDEO_CALL : SCENARIO_CALL_CANCEL_AUDIO_CALL
                       scenarioType:TSkScenarioTypeGroupCall
                     destinationuri:nil
               destinationUriParams:nil
                         moduleType:TSkActionModuleTypeButton
                        moduleState:nil
                      moduleSummary:nil
                          panelType:TSkPanelTypeChat
                           panelUri:nil
                     panelUriParams:nil
                           threadId:self.threadID
                         threadType:TSkThreadTypeGroupChat];
    }];
    [alert addAction:actionCall];
    [alert addAction:actionCancel];
    
    alert.preferredAction = actionCall;
    
    [[self navigationController] presentViewController:alert animated:YES completion:nil];
}

- (void) startAudioOrVideoCall:(BOOL)video
{
    NSString *scenarioName;
    if (video)
    {
        scenarioName = SCENARIO_CALL_START_VIDEO_CALL;
        if ([self isSfBInteropChat])
        {
            scenarioName = SCENARIO_CALL_START_VIDEO_CALL_SFB;
        }
        else if ([self isSfCInteropChat])
        {
            scenarioName =  SCENARIO_CALL_START_VIDEO_CALL_SFC;
        }
    }
    else
    {
        scenarioName = SCENARIO_CALL_START_AUDIO_CALL;
        if ([self isSfBInteropChat])
        {
            scenarioName = SCENARIO_CALL_START_AUDIO_CALL_SFB;
        }
        else if ([self isSfCInteropChat])
        {
            scenarioName =  SCENARIO_CALL_START_AUDIO_CALL_SFC;
        }
        
        if (self.accountHandle.ecsManager.multipleNumberCallingEnabled && self.accountHandle.policyManager.isPSTNCallingSupported &&
            self.threadType == TSThreadTypeOneOnOneChat)
        {
            TSAlertController *alertController = [self composeMultiPhoneNumberActionSheet:video scenarioName:scenarioName];
            if (alertController && alertController.actions.count > 1)
            {
                TSWeakify(self)
                [alertController presentFromViewController:self
                                      withAnchorViewOnIpad:self.voiceCallButton
                                                completion:^{
                    TSStrongifyAndReturnIfNil(self)
                    [self.accountHandle.logger logPanelView:TSkPanelTypeCallOrMeetUpLive
                                                   scenario:TSkScenarioShownMultiNumberSheet
                                               scenarioType:TSkScenarioTypeMultiNumber
                                                 moduleName:TSKActionModuleNameMultiNumberActionSheet moduleType:TSkActionModuleTypeView
                                                 threadType:nil];
                }];
                return;
            }
        }
        
    }
    
    [self placeCall:video scenarioName:scenarioName phoneNumber:nil];
}

- (TSAlertController*)composeMultiPhoneNumberActionSheet:(BOOL)video scenarioName:(NSString*)scenarioName
{
    if (self.recipientIDs.count == 0)
    {
        LogInfoAH(self.logger, @"Calling: TSChatViewController: ComposeMultiPhoneNumberActionSheet: recipeitIDs 0");
        return nil;
    }
    
    TSUser *user = [TSUser userForID:self.recipientIDs.firstObject inManagedObjectContext:self.accountHandle.mainMOC];
    
    TSAlertController *alertController = [TSAlertController alertControllerWithTitle:[NSString stringWithFormat:AXPLocalizedString(@"CallMultiPhoneNumberLabel"), user.displayName] message:nil];
    
    TSWeakify(self)
    TSAlertAction *teamsCall = [TSAlertAction actionWithTitle:AXPLocalizedString(@"Call")
                                                     subtitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
                                                   iconSymbol:[[IconSymbolTypeObjcBridge alloc] initWithSymbol:IconSymbolCall]
                                                    iconStyle:IconSymbolStyleRegular
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(TSAlertAction * action)
                                {
        TSStrongifyAndReturnIfNil(self)
        [self placeCall:video scenarioName:scenarioName phoneNumber:nil];
    }];
    teamsCall.accessibilityLabel = AXPLocalizedString(@"AudioCall");
    [alertController addAction:teamsCall];
    
    NSString *accessibilityFormat;
    if (![NSString isNilOrEmpty:user.mobile])
    {
        TSAlertAction *mobileCall = [TSAlertAction actionWithTitle:user.mobile
                                                          subtitle:AXPLocalizedString(@"PeopleCardMobile")
                                                        iconSymbol:[[IconSymbolTypeObjcBridge alloc] initWithSymbol:IconSymbolDialpad]
                                                         iconStyle:IconSymbolStyleRegular
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(TSAlertAction * action)
                                     {
            TSStrongifyAndReturnIfNil(self)
            [self placeCall:video scenarioName:scenarioName phoneNumber:user.mobile];
        }];
        accessibilityFormat = AXPLocalizedString(@"MobileCallAccessibilityFormat");
        mobileCall.accessibilityLabel = [NSString stringWithFormat:accessibilityFormat, user.mobile];
        [alertController addAction:mobileCall];
    }
    if (![NSString isNilOrEmpty:user.homeNumber])
    {
        TSAlertAction *homeCall  = [TSAlertAction actionWithTitle:user.homeNumber
                                                         subtitle:AXPLocalizedString(@"PeopleCardHome")
                                                       iconSymbol:[[IconSymbolTypeObjcBridge alloc] initWithSymbol:IconSymbolDialpad]
                                                        iconStyle:IconSymbolStyleRegular
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(TSAlertAction * action)
                                    {
            TSStrongifyAndReturnIfNil(self)
            [self placeCall:video scenarioName:scenarioName phoneNumber:user.homeNumber];
        }];
        accessibilityFormat = AXPLocalizedString(@"HomeCallAccessibilityFormat");
        homeCall.accessibilityLabel = [NSString stringWithFormat:accessibilityFormat, user.homeNumber];
        [alertController addAction:homeCall];
    }
    
    if (![NSString isNilOrEmpty:user.telephoneNumber])
    {
        TSAlertAction *workCall  = [TSAlertAction actionWithTitle:user.telephoneNumber
                                                         subtitle:AXPLocalizedString(@"PeopleCardWork")
                                                       iconSymbol:[[IconSymbolTypeObjcBridge alloc] initWithSymbol:IconSymbolBuilding]
                                                        iconStyle:IconSymbolStyleRegular
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(TSAlertAction * action)
                                    {
            TSStrongifyAndReturnIfNil(self)
            [self placeCall:video scenarioName:scenarioName phoneNumber:user.telephoneNumber];
        }];
        accessibilityFormat = AXPLocalizedString(@"WrkCllA11yFmt");
        workCall.accessibilityLabel = [NSString stringWithFormat:accessibilityFormat, user.telephoneNumber];
        [alertController addAction:workCall];
    }
    
    return alertController;
}

- (void)placeCall:(BOOL)video scenarioName:(NSString*)scenarioName phoneNumber:(NSString*)phoneNumber
{
    NSUUID *callUUID = [NSUUID UUID];
    if (![NSString isNilOrEmpty:phoneNumber])
    {
        [TSCallNavigationUtilities showDelegatorsAndPlacePSTNCallFrom:self
                                                             toNumber:phoneNumber
                                                 withEmergencyContent:nil
                                                        correlationID:scenarioName
                                                        accountHandle:self.accountHandle
                                                              callUUID:callUUID
                                                           completion:nil];
    }
    else
    {
        [self.logger logPanelAction:video ? TSkActionModuleNameVideoButton : TSkActionModuleNameAudioButton
                            outCome:TSkActionOutcomeSubmit
                            gesture:TSkActionGestureTap
                           scenario:scenarioName
                       scenarioType:self.threadType == TSThreadTypeGroupChat ? TSkScenarioTypeGroupCall : TSkScenarioTypeOneOnOneCall
                     destinationuri:nil
               destinationUriParams:nil
                         moduleType:TSkActionModuleTypeButton
                        moduleState:nil
                      moduleSummary:nil
                          panelType:TSkPanelTypeChat
                           panelUri:nil
                     panelUriParams:nil
                           threadId:self.threadID
                         threadType:self.threadType == TSThreadTypeGroupChat ? TSkThreadTypeGroupChat : TSkThreadTypeOneOnOneChat
                           callType:[TSCallUtilities biCallTypeStringForCallType:(self.threadType == TSThreadTypeGroupChat) ? TSGroupCall : TSOneOnOneCall meetingType:TSCallMeetingTypeUndefined]
                             callId:[callUUID.UUIDString lowercaseString]];
        
        
        [self resolveThreadAndPlaceCallWithVideo:video callUUID:callUUID];
    }
}

- (BOOL)isGroupCall
{
    return (self.threadType == TSThreadTypeGroupChat ||
            (self.threadType == TSThreadTypeUnknown && self.recipientIDs.count >= 2));
}

- (BOOL)isAudioAndVideoCallButtonEnabled
{
    return [self isGroupChatSmallEnoughToCall] && ![self isOneOnOneSMSChat] && ![self disableFedChatCallingIfNeeded];
}

- (BOOL)isGroupChatSmallEnoughToCall
{
    return self.recipientIDs.count < self.maxGroupChatParticipantsForGroupCall;
}

- (BOOL)isOneOnOneSMSChat
{
    if (!self.accountHandle.policyManager.isOneOnOneTwoWaySMSEnabled)
    {
        return NO;
    }
    
    if (self.recipientIDs.count != 1)
    {
        return NO;
    }
    
    if (!self.isOneToOneChat)
    {
        return NO;
    }
    
    NSString *recipient = [self.recipientIDs firstObject];
    return [TSUser isSMSUser:recipient];
}

- (BOOL)isComposerActionEnabled:(NSString *)actionName
{
    if (!self.isOneOnOneSMSChat)
    {
        return YES;
    }
    
    if (self.accountHandle.policyManager.oneOnOneTwoWaySMSEnabledComposerFeatures == nil)
    {
        return NO;
    }
    
    return [self.accountHandle.policyManager.oneOnOneTwoWaySMSEnabledComposerFeatures containsObject:actionName];
}

- (void)matchMentionsToRecipients
{
    // New chat mode can add recipient, @mention them, then remove that user before creating the chat
    __block NSMutableAttributedString *mutableAttributedString = [self.composeViewController.textBody.attributedText mutableCopy];
    
    [mutableAttributedString enumerateAttribute:NSAttachmentAttributeName
                                        inRange:NSMakeRange(0, mutableAttributedString.length)
                                        options:kNilOptions
                                     usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop)
     {
        if ([value isKindOfClass:[TSMentionTextAttachment class]])
        {
            TSMentionTextAttachment *attachment = (TSMentionTextAttachment *)value;
            
            if (![self.recipientIDs containsObject:attachment.tsID])
            {
                NSAttributedString *textName = [[NSAttributedString alloc] initWithString:attachment.displayName
                                                                               attributes:self.composeViewController.textBody.typingAttributes];
                
                [mutableAttributedString replaceCharactersInRange:range withAttributedString:textName];
            }
        }
    }];
    
    self.composeViewController.textBody.attributedText = mutableAttributedString;
}

#pragma mark - Class methods
+ (TSChatViewController *) instantiateFromStoryboard
{
    NSString *storyboardIdentifier = [NSString stringWithFormat:TSkStoryboardIdentifierFormatString,
                                      TSkStoryboardNameChats,
                                      NSStringFromClass(TSChatViewController.class)];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:TSkStoryboardNameChats bundle:[NSBundle bundleForClass:[self class]]];
    
    return (TSChatViewController *)[storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
}

#pragma mark - TSMobilityPolicyDelegate implementation

- (void)handleCallingDisabledDueToMobilityPolicyUpdate
{
    __weak typeof(self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        [weakSelf updateNavigationRightBarItems];
    }];
}

#pragma mark - UIAccessibilityCustomRotor implementation
- (UIAccessibilityCustomRotorItemResult *)searchRotorItemWithPredicate:(UIAccessibilityCustomRotorSearchPredicate *)predicate
{
    if (self.numberOfSections < 1)
    {
        return nil;
    }
    
    UIAccessibilityElement *element = (UIAccessibilityElement *)predicate.currentItem.targetElement;
    
    NSIndexPath *searchStartIndexPath = nil;
    
    BOOL down = predicate.searchDirection == UIAccessibilityCustomRotorDirectionNext;
    NSInteger direction = down ? -1 : 1;
    
    // Find the index path where to start the search
    if (element && [[element accessibilityContainer] isKindOfClass:TSChatGroupTimestampCell.class])
    {
        // Focus already on a TSChatGroupTimestampCell
        UITableViewCell *cell = [element accessibilityContainer];
        NSIndexPath *currentIndexPath = [self.tableView indexPathForCell:cell];
        searchStartIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + direction inSection:currentIndexPath.section];
    }
    else
    {
        // Focus not on a TSChatGroupTimestampCell
        if (element)
        {
            // Hit test visible cells
            UIView *currentTargetView = (UIView *)predicate.currentItem.targetElement;
            CGRect targetFrame = currentTargetView.accessibilityFrame;
            CGRect targetFrameInTableVIew = [self.tableView convertRect:targetFrame fromCoordinateSpace:[[UIScreen mainScreen] coordinateSpace]];
            
            for (UITableViewCell *visibleCell in [self.tableView visibleCells])
            {
                CGRect cellFrame = visibleCell.frame;
                
                if (CGRectContainsRect(cellFrame, targetFrameInTableVIew))
                {
                    searchStartIndexPath = [self.tableView indexPathForCell:visibleCell];
                    break;
                }
            }
        }
    }
    
    NSIndexPath *resultIndexPath = [self findNextGroupTimeStampCell:searchStartIndexPath down:down];
    
    if (!resultIndexPath)
    {
        // No next group timestamp cells in the requested direction
        return nil;
    }
    
    // Scroll target cell into view
    // NOTE - TSCustomUITableView contains some code to prevent problematic VO scrolls in our inverted table views
    //        This code needs to be temporarily disabled here
    TSCustomUITableView *customTableView = nil;
    if ([self.tableView isKindOfClass:TSCustomUITableView.class])
    {
        customTableView = (TSCustomUITableView *)self.tableView;
        customTableView.suppressVOScroll = NO;
    }
    
    UITableViewScrollPosition scrollPosition = down ? UITableViewScrollPositionMiddle : UITableViewScrollPositionBottom;
    [self.tableView scrollToRowAtIndexPath:resultIndexPath atScrollPosition:scrollPosition animated:NO];
    [self.tableView layoutIfNeeded];
    
    if (customTableView)
    {
        customTableView.suppressVOScroll = YES;
    }
    
    UITableViewCell<TSRotorAccessibilityElementProtocol> *targetCell = [self.tableView cellForRowAtIndexPath:resultIndexPath];
    
    // Make sure we have actual cell that has a focusable element
    if (!targetCell)
    {
        LogWarningAH(self.logger, @"Cell not initialized for row %lu in section %lu", (long)resultIndexPath.row, (long)resultIndexPath.section);
        return nil;
    }
    else if (![targetCell conformsToProtocol:@protocol(TSRotorAccessibilityElementProtocol)])
    {
        LogWarningAH(self.logger, @"Cell does not conform to TSRotorAccessibilityElementProtocol protocol for row %lu in section %lu", (long)resultIndexPath.row, (long)resultIndexPath.section);
        return nil;
    }
    
    return [[UIAccessibilityCustomRotorItemResult alloc] initWithTargetElement:targetCell.rotorAccessibilityElement targetRange:nil];
}

- (NSIndexPath *)findNextGroupTimeStampCell:(NSIndexPath *)startIndexPath down:(BOOL)down
{
    if (!startIndexPath)
    {
        return nil;
    }
    
    NSInteger direction = down ? -1 : 1;
    NSIndexPath *currentIndexPath;
    
    if (startIndexPath.section == NSNotFound)
    {
        // Start from beginning, where "beginning" depends on direction
        NSInteger startingSection = down ? self.numberOfSections-1 : 0;
        NSInteger startingRow = down ? [self numberOfRowsInSection:startingSection] - 1 : 0;
        currentIndexPath = [NSIndexPath indexPathForRow:startingRow inSection:startingSection];
    }
    else
    {
        currentIndexPath = [NSIndexPath indexPathForRow:startIndexPath.row inSection:startIndexPath.section];
    }
    
    NSIndexPath *resultIndexPath = nil;
    
    // Search for the next group time stamp cell in the swipe direction
    while (currentIndexPath.section >= 0 && currentIndexPath.section < [self numberOfSections] && !resultIndexPath)
    {
        while (currentIndexPath.row >= 0 &&currentIndexPath.row < [self numberOfRowsInSection:currentIndexPath.section] && !resultIndexPath)
        {
            NSDictionary *itemData = [self dataForRowAtIndexPath:currentIndexPath inTableView:self.tableView];
            
            if (itemData[TSkIsGroupSeparator])
            {
                resultIndexPath = currentIndexPath;
            }
            
            currentIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + direction inSection:currentIndexPath.section];
        }
        
        NSInteger nextSection = currentIndexPath.section + direction;
        NSInteger nextSectionRow = down ? [self numberOfRowsInSection:nextSection] - 1 : 0;
        currentIndexPath = [NSIndexPath indexPathForRow:nextSectionRow inSection:nextSection];
    }
    
    return resultIndexPath;
}

#pragma mark -  Layout Methods
- (void) relayoutStackView {
    [self relayoutStackViewToWidth: self.view.bounds.size.width];
}

- (void) relayoutStackViewToWidth:(CGFloat)targetWidth {
    self.stackViewWidthConstraint.constant = [TSUtilities condensedWidthForWidth: targetWidth];
    [self.stackView setNeedsLayout];
}

#pragma mark - SfC Interop chat block state change method

- (void)reloadForSfCInteropChatBlockStateChange
{
    // Update calling buttons
    [self updateNavigationRightBarItems];
    
    // Update compose UI
    [self.composeViewController updateComposeViewState];
    [self configureDisabledStateView];
    
    // Update navigation subtitle
    [self updateTitleText];
    [self updateCustomTitle:NO];
    if ([TSUtilities isContactBlockingEnabled:self.accountHandle])
    {
        [self reloadTable];
    }
}

#pragma mark - private telemetry helpers

- (void) stopScenarioMarker:(BOOL)stopNotificationLaunchScenario messageDictionary:(NSDictionary *)messageDictionary
{
    [self addScenarioPropertiesForTranslation:messageDictionary];
    [TSUtilities logCacheRankInfo:self.threadMruCacheRank forScenarioID:self.scenarioMarkerID forHandle:self.accountHandle];
    
    [self.accountHandle.logger logScenarioStopEvent:self.scenarioMarkerID status:ScenarioStatusOK];
    [self.accountHandle.logger logScenarioStopEvent:self.navScenarioID status:ScenarioStatusOK];
    [AXPInstrumentationManager.sharedInstance stopAppLaunchPerfScenarios:stopNotificationLaunchScenario];
}

- (void) addScenarioPropertiesForTranslation:(NSDictionary *)messageDictionary
{
    if ([TSTranslationManager isAutomaticChatTranslationEnabled:self.accountHandle] || [TSTranslationManager isOnDemandChatTranslationEnabled:self.accountHandle])
    {
        if (messageDictionary.count)
        {
            NSInteger translatedMessageCount = 0;
            
            for (TSMessageInfo *messageInfo in messageDictionary.allValues)
            {
                if ([messageInfo isTranslatedMessageForDisplay])
                {
                    translatedMessageCount++;
                }
            }
            
            if (translatedMessageCount > 0)
            {
                [self.accountHandle.logger addScenarioProperties:self.scenarioMarkerID
                                                      properties:@{
                    TSkScenarioPropertyNameTranslatedMessageCount : [[NSNumber numberWithInteger:translatedMessageCount] stringValue]
                }];
            }
        }
    }
}

- (void) startScenarioMarker
{
    if ([self.threadID isNotNilOrEmpty] || (self.recipientIDs && self.groupChatCreationState == TSGroupChatCreationStateNoOp))
    {
        self.scenarioName = SCENARIO_CHAT_SWITCH;
        NSMutableDictionary *properties = [self.accountHandle.logger teamChannelThreadInfo] ?: NSMutableDictionary.new;
        if ([self.scenarioEntryPoint isNotNilOrEmpty])
        {
            [properties setValue:self.scenarioEntryPoint forKey:TSkEntryPoint];
        }
        
        self.scenarioMarkerID = [self.accountHandle.logger logStartScenarioEventOfType:self.scenarioName
                                                                        withProperties:properties];
    }
}

- (void) logTelemetryForViewCard:(NSString*)appIdOrBotId cardType:(NSString*)cardType withCardInfo:(NSDictionary *)cardInfo messageId:(NSNumber *)messageId
{
    [self.platformTelemetryLogger logTelemetryForViewCardWithAppId:appIdOrBotId
                                                          cardType:cardType
                                                      withCardInfo:cardInfo
                                                         messageId:messageId
                                                          panelUri:self.currentPanelInfo.uri
                                                    panelUriParams:self.currentPanelInfo.uriParams];
}

- (NSDictionary *) addNewChatCompleteTelemetry
{
    NSInteger offNetwork = 0;
    NSInteger deviceContact = 0;
    NSInteger suggestedContact = 0;
    NSInteger emailCount = 0;
    NSInteger phoneCountOneWay = 0;
    NSInteger phoneCountTwoWay = 0;
    
    for (NSString *recipientId in self.recipientsUserInfo) {
        NSDictionary *info = self.recipientsUserInfo[recipientId];
        if ([info[TSkSearchResultItemType] isEqual:TSkDeviceContactSearchType])
        {
            deviceContact++;
        }
        else
        {
            suggestedContact++;
        }
        if (![NSString isNilOrEmpty:info[TSkUserDisplayName]] ||
            ([info[TSkSearchResultItemType] isEqual:TSkAnonymousUserWithPhoneSearchType] && ![NSString isNilOrEmpty:info[TSkItemInfoPhone]]) ||
            ([info[TSkSearchResultItemType] isEqual:TSkAnonymousUserWithEmailSearchType] && ![NSString isNilOrEmpty:info[TSkItemInfoEmail]]))
        {
            offNetwork++;
            
            if (![NSString isNilOrEmpty:info[TSkItemInfoPhone]])
            {
                [[TSPhoneNumberUtils sharedInstance] isPhoneNumber2WaySMSEnabled:info[TSkItemInfoPhone]] ? phoneCountTwoWay++ : phoneCountOneWay++;
            }
            else if (![NSString isNilOrEmpty:info[TSkItemInfoEmail]])
            {
                emailCount++;
            }
        }
    }
    
    NSDictionary *dataBagProperties = @{
        @"totalContactsSelected" : [NSNumber numberWithInteger:self.recipientIDs.count],
        @"onNetworkContactsSelected" : [NSNumber numberWithInteger:self.recipientIDs.count - offNetwork],
        TSkOffNetworkContactsSelected : [NSNumber numberWithInteger:offNetwork],
        TSkInviteEmailCountAttribute: [NSNumber numberWithInteger:emailCount],
        TSkPhoneCountOneWay: [NSNumber numberWithInteger:phoneCountOneWay],
        TSkPhoneCountTwoWay: [NSNumber numberWithInteger:phoneCountTwoWay],
        TSkDeviceContactsSelectedKey :  [NSNumber numberWithInteger:deviceContact],
        TSkSuggestedContactsSelectedKey : [NSNumber numberWithInteger:suggestedContact],
        TSkTotalContactsSelectedKey : [NSNumber numberWithInteger:(deviceContact + suggestedContact)],
        @"hasCustomAvatar" : [NSNumber numberWithBool:self.hasCustomGroupAvatar],
        @"groupAvatarEditPressed" : [NSNumber numberWithBool:self.groupAvatarEditPressed],
        @"groupNameRequiredPromptShown" : [NSNumber numberWithBool:self.groupNameRequiredPromptShown],
        TSkHasCustomNameKey : [NSNumber numberWithBool:[self.topicName isNotNilOrEmpty]],
        @"suggestedMessageTapped" : [NSNumber numberWithBool:self.welcomeCardDidPressSmartReplyButton],
        @"isGroupOverride" : [NSNumber numberWithBool: self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants],
        @"chatCreationEntryPoint" : [self getNewChatScenarioEntryPoint],
        TSkIsNewChat : @YES,
        TSkIsSmsChat: @([self isSMSChat]),
        @"chatType" : self.groupChatCreationState == TSGroupChatCreationStateAddingParticipants || self.recipientIDs.count > 1 ? @"group" : @"oneToOne",
        TSkNewGroupWelcomeScreenTypeKey : @(self.accountHandle.ecsManager.newGroupWelcomeScreenType),
        TSkUntitledGroupCreationEnabledKey : @(self.accountHandle.ecsManager.isUntitledNewGroupAllowed)
    };
    
    return dataBagProperties;
}

- (void) startChatRenderScenarioMarker
{
    self.chatRenderScenarioId = [self.accountHandle.logger logStartScenarioEventOfType:TSkScenarioChatRenderTime];
}

- (void) stopChatRenderScenarioMarker
{
    if ([self.threadID isValidString] && [self.chatRenderScenarioId isValidString])
    {
        [self.accountHandle.logger addScenarioProperties:self.chatRenderScenarioId properties:@{TSkEntryPoint: self.scenarioEntryPoint ?: @""}];
        [TSUtilities logCacheRankInfo:self.threadMruCacheRank forScenarioID:self.chatRenderScenarioId forHandle:self.accountHandle];
        
        [self.accountHandle.logger logScenarioStopEvent:self.chatRenderScenarioId status:ScenarioStatusOK];
        self.chatRenderScenarioId = nil;
    }
}

- (BOOL) isNewGroupThread
{
    switch (self.groupChatCreationState)
    {
        case TSGroupChatCreationStateAddingParticipants:
            return self.recipientIDs.count > 0;
            break;
        case TSGroupChatCreationStateInChatWithCompose:
            return self.recipientIDs.count > 1;
            break;
        default:
            break;
    }
    return NO;
}

- (NSString *) getNewChatScenarioEntryPoint
{
    return self.scenarioEntryPoint ?: @"";
}

- (BOOL) getChatCreated
{
    return [self.threadID length] || self.chatTabSetActive;
}

- (void) bannerOffsetDidChange:(CGFloat)bannerOffset
{
    self.stackViewTopConstraint.constant = bannerOffset;
    [self.stackView updateConstraints];
}

- (NSString *)placeOneToOneCallScenarioName
{
    NSString *scenarioName = SCENARIO_CALL_PLACE_CALL;
    
    if ([self isSfCInteropChat])
    {
        scenarioName = SCENARIO_CALL_PLACE_CALL_SFC;
    }
    else if ([self isSfBInteropChat])
    {
        scenarioName = SCENARIO_CALL_PLACE_CALL_SFB;
    }
    
    return scenarioName;
}


#pragma mark - Getters
/**
 *  Getter for error codes from message delivery states to show sending failed
 *
 *  @return A set of error codes from message delivery states to show sending failed
 */
- (NSSet *)messageDeliveryStateErrorCodesSendFailed
{
    static dispatch_once_t onceToken;
    static NSSet *errorCodes;
    dispatch_once(&onceToken, ^{
        errorCodes = [NSSet setWithArray:@[TSkMessageDeliveryStateSMSInfraNoHandlerError,
                                           TSkMessageDeliveryStateSMSInfraBrokenDeliveryReportError,
                                           TSkMessageDeliveryStateSMSInfraMessageExpiredError,
                                           TSkMessageDeliveryStateSMSInfraConnectionError,
                                           TSkMessageDeliveryStateSMSInfraInternalError,
                                           TSkMessageDeliveryStateSMSInfraNoRouteError,
                                           TSkMessageDeliveryStateSMSBillingPriceNotFoundError,
                                           TSkMessageDeliveryStateSMSNoSourceAddressError,
                                           TSkMessageDeliveryStateSMSAggregatorTransientServiceError,
                                           TSkMessageDeliveryStateSMSAggregatorPermanentServiceError,
                                           TSkMessageDeliveryStateSMSAggregatorMessageExpiredError,
                                           TSkMessageDeliveryStateSMSAggregatorSpamBlockedError,
                                           TSkMessageDeliveryStateSMSAggregatorMiscError,
                                           TSkMessageDeliveryStateSMSUncategorizedError]];
    });
    return errorCodes;
}

/**
 *  Getter for error codes from message delivery states to show contact admin
 *
 *  @return A set of error codes from message delivery states to show contact admin
 */
- (NSSet *)messageDeliveryStateErrorCodesContactAdmin
{
    static dispatch_once_t onceToken;
    static NSSet *errorCodes;
    dispatch_once(&onceToken, ^{
        errorCodes = [NSSet setWithArray:@[TSkMessageDeliveryStateSMSInfraInsufficientFundsError,
                                           TSkMessageDeliveryStateSMSFraudUserAccountBlockedError,
                                           TSkMessageDeliveryStateSMSFraudRecipientBlockedError,
                                           TSkMessageDeliveryStateSMSFraudSenderBlockedError,
                                           TSkMessageDeliveryStateSMSFraudSMSVelocityReachedError,
                                           TSkMessageDeliveryStateSMSNumberInvalidFormatSourceAddressError]];
    });
    return errorCodes;
}

- (TSMeetingChickletHelper *)meetingChickletHelper
{
    //lazy initialization
    if (!_meetingChickletHelper)
    {
        _meetingChickletHelper = [[TSMeetingChickletHelper alloc] init];
        _meetingChickletHelper.legacyAppearanceProxy = self.legacyAppearanceProxy;
    }
    return _meetingChickletHelper;
}

- (void)onMeetingChickletTapped:(TSMessageInfo *)messageInfo
{
    [self.accountHandle.logger logPanelAction:TSkActionModuleNameMeetingDetailFullPage
                                      outCome:TSkActionOutcomeNav
                                      gesture:TSkActionGestureTap
                                     scenario:SCENARIO_MEETING_DETAIL_SCHEDULED_MEETING
                                 scenarioType:TSkScenarioTypeCalendarEvent
                               destinationuri:nil
                         destinationUriParams:nil
                                   moduleType:TSkActionModuleTypeButton
                                  moduleState:nil
                                moduleSummary:nil
                                    panelType:TSkPanelTypeChat
                                     panelUri:nil
                               panelUriParams:nil
                                     threadId:self.threadID
                                   threadType:nil];
    
    if (!([messageInfo isMeetupMessage] || [messageInfo isScheduledMeetingMessage]))
    {
        LogInfoAH(self.logger, "TSChatViewController::onMeetingChickletTapped: Not a meeting message.");
        return;
    }
    
    TSSMessage *messageEntity;
    if ([messageInfo.baseType compareString:TSkMessageBaseTypeRichText]
        && ([messageInfo.messageContentType compareString:TSMessageContentTypeMediaCard]
            || [messageInfo.messageContentType compareString:TSMessageContentTypeHTML]))
    {
        messageEntity = [TSSMessage messageForID:messageInfo.tsID andThreadID:messageInfo.threadID
                          inManagedObjectContext:self.accountHandle.mainMOC];
    }
    
    if (!messageEntity)
    {
        LogInfoAH(self.logger, "TSChatViewController::onMeetingChickletTapped: messageEntity is nil");
        return;
    }
    
    NSData *meetingData = [messageEntity.meetingTitle dataUsingEncoding:NSUTF8StringEncoding];
    if (!meetingData)
    {
        LogInfoAH(self.logger, "TSChatViewController::onMeetingChickletTapped: meetingData is nil");
        return;
    }
    
    NSError *jsonError;
    TSMeetingInfo *meetingInfo;
    NSDictionary *meetingDict = [NSJSONSerialization JSONObjectWithData:meetingData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jsonError];
    meetingDict = [meetingDict dictionaryByRemovingNullValues];
    if (jsonError || !meetingDict)
    {
        NSInteger errorCode = jsonError ? [jsonError code] : 0;
        LogWarningAH(self.logger, @"TSChatViewController::onMeetingChickletTapped: Failed to process meeting info for message. Code:%zd", errorCode);
        return;
    }
    
    meetingInfo = [[TSMeetingInfo alloc] initWithJson:(NSDictionary *)[meetingDict objectForKey:TSKScheduledMeetingInfo]];
    
    NSDictionary *viewInfo = [TSMeetingTabbedUXUtilities getViewInfoForMeetingDetails:meetingInfo.exchangeId
                                                                             threadId:messageInfo.threadID
                                                                        accountHandle:self.accountHandle];
    if (viewInfo == nil)
    {
        LogErrorAH(self.logger, @"TSChatViewController::onMeetingChickletTapped: Failed to retrieve viewInfo");
        return;
    }
    
    if ([self.accountHandle.policyManager joinMeetingOnChickletTap])
    {
        NSString *meetingJoinUrl = [meetingDict objectForKey:@"meetingJoinUrl"];
        if (![meetingJoinUrl isNotNilOrEmpty])
        {
            LogWarningAH(self.logger, @"TSChatViewController::onMeetingChickletTapped: meetingJoinUrl is not available.");
            return;
        }
        
        NSURL *url = [NSURL URLWithString:meetingJoinUrl];
        if (!url)
        {
            LogWarningAH(self.logger, @"TSChatViewController::onMeetingChickletTapped: url is nil.");
            return;
        }
        
        if ([TSUtilities isSkypeTeamsURL:url] &&
            [[TSUniversalLinkManager defaultManager] isSupportedUrlForTeams:url withAccountHandle: self.accountHandle] &&
            [[TSUniversalLinkManager defaultManager] canNavigateToSupportedURL:url accountHandle:self.accountHandle])
        {
            BOOL isHandled = [[TSUniversalLinkManager defaultManager] handleUniversalLink:url accountHandle:self.accountHandle];
            if (!isHandled)
            {
                LogErrorAH(self.logger, @"TSChatViewController::onMeetingChickletTapped: url not handled.");
            }
        }
        else
        {
            LogErrorAH(self.logger, @"TSChatViewController::onMeetingChickletTapped: url not supported.");
        }
    }
    else
    {
        [self performSegue:TSkSeguePushMeetingDetails withViewInfo:viewInfo];
    }
}

-(BOOL)isSMBMessage
{
    return self.accountHandle.policyManager.isSMBCalendarSyncEnabled && ![TSUtilities getConsumerGroupIdFromThreadId:self.threadID inMoc:self.accountHandle.mainMOC];
}

-(void)onCalendarActionTapped:(TSMeetingInviteBlock *)inviteBlock
              meetingCardView:(TSChatBubbleMeetingCardView *)meetingCardView
             isUpdateCalendar:(BOOL)isUpdateCalendar
{
    // When an occurrence in a recurring meeting is cancelled, import api has to be called from ImportEventToCalendarAction class.
    if ([inviteBlock.isCancelled boolValue] && ![inviteBlock.eventType isEqualToString:TSkOccurrence])
    {
        [self removeFromCalendarTapped:inviteBlock meetingCardView:meetingCardView];
    }
    else
    {
        [self onAddToCalendarTapped:inviteBlock meetingCardView:meetingCardView isUpdateCalendar:isUpdateCalendar];
    }
}

-(void)onAddToCalendarTapped:(TSMeetingInviteBlock *)inviteBlock
             meetingCardView:(TSChatBubbleMeetingCardView *)meetingCardView
            isUpdateCalendar:(BOOL)isUpdateCalendar
{
    // Not show alert when an occurrence in a recurring meeting is cancelled. Import api has to be called from ImportEventToCalendarAction class.
    if ([self shouldShouldPrivacyAlert] && !inviteBlock.isCancelled)
    {
        [self showPrivacyAlert:inviteBlock meetingcardView:meetingCardView isUpdateCalendar:isUpdateCalendar];
    }
    else
    {
        [self addToCalendar:inviteBlock meetingCardView:meetingCardView isUpdateCalendar:isUpdateCalendar];
    }
    [self logTelemetryForAddToCalendar:TSkActionScenarioNameAddToCalendarInMeetingChiclet scenarioType:TSkScenarioTypeNav];
}

-(void) removeFromCalendarTapped:(TSMeetingInviteBlock *)inviteBlock meetingCardView:(TSChatBubbleMeetingCardView *)meetingCardView
{
    TSWeakify(self);
    [self.eventOperationsHelper deleteCalendarEvent:self.calendarEventDetailsViewData withEventID:inviteBlock.iCalUid completion:^(TSAResult *result, NSError *error) {
        [TSDispatchUtilities dispatchOnMainThread:^{
            TSStrongifyAndReturnIfNil(self);
            NotificationBanner *toastBanner = [NotificationBanner withAutoLayout];
            if (error)
            {
                NSString *errorCode = [error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey];
                LogErrorAH(self.logger, @"Calling: TSChatViewController.removeFromCalendarTapped: deleteMeeting API call failure :errorCode: %@ , domain:%@ , httpStatusCode:%ld", errorCode, error.domain, (long)error.code);
                // Show error toast
                [toastBanner setViewDataWithTitle:AXPLocalizedString(@"rmvFrmClndrFlrTtl") message:AXPLocalizedString(@"rmvFrmClndrFlrMsg") icon:[[IconSymbolTypeObjcBridge alloc] initWithCoreSymbol:IconSymbolCoreErrorCircle]];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:TSkMeetingDetailsEdited
                                                                    object:nil
                                                                  userInfo:@{ TSkMeetingDetailsEditedResetSelection : @YES }];
                // Show success toast
                [toastBanner setViewDataWithTitle:AXPLocalizedString(@"rmvFrmClndrSccs") message:NULL icon:[[IconSymbolTypeObjcBridge alloc] initWithSymbol:IconSymbolCalendarCheckmark]];
            }
            [meetingCardView stopLoader];
            [toastBanner showWithView:self.messagesView presentationStyle:NotificationBannerPresentationStyleToast];
        }];
    }];
}

- (void)addToCalendar:(TSMeetingInviteBlock *)inviteBlock
      meetingCardView:(TSChatBubbleMeetingCardView *)meetingCardView
     isUpdateCalendar:(BOOL)isUpdateCalendar
{
    NSString *threadId = self.threadID ?: @"";
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
        @"ICalUid": inviteBlock.iCalUid ?: @"",
        @"MeetingTitle": inviteBlock.meetingTitle ?: @"",
        @"JoinUrl" : inviteBlock.joinUrl ?: @"",
        @"Location" : inviteBlock.location ?: @"",
        @"RsvpTo" : inviteBlock.rsvpTo ?: @"",
        @"Body" : inviteBlock.body ?: @"",
        @"StartTime" : inviteBlock.startTime ?: @"",
        @"EndTime" : inviteBlock.endTime ?: @"",
        @"IsCancelled" : inviteBlock.isCancelled,
        @"OrganizerDisplayName" : inviteBlock.organizerDisplayName ?: @"",
        @"timeZoneId" : inviteBlock.timeZoneId ?: @"",
        TSkEventRecurrenceRangeKey: inviteBlock.eventRecurrenceRange ?: @{},
        TSkEventRecurrencePatternKey: inviteBlock.eventRecurrencePattern ?: @{},
        TSkEventTypeKey: inviteBlock.eventType ?: @"",
        TSkOriginalStartTimeKey: inviteBlock.originalStartTime ?: @"",
        TSkConversationIdKey: threadId
    }];
    
    ConnectedCalendarRepoHelper *repoHelper = [[ConnectedCalendarRepoHelper alloc] initWithAccountHandle:self.accountHandle];
    NSString *connectedAccountId = [repoHelper getConnectedAccountIDFromLocal];
    if([connectedAccountId isNotNilOrEmpty] && [repoHelper getCurrentlyConnectedCalendar] == CalendarTypeGoogle)
    {
        [dict setObject:connectedAccountId forKey:TSkConnectedAccountID];
    }
    
    NSMutableDictionary *requestBody = [NSMutableDictionary dictionaryWithDictionary:@{
        @"requestBody": dict}];
    
    TSWeakify(self);
    TSAction *action = [self.accountHandle.actionContext actionOfClass:[ImportEventToCalendarAction class]
                                                        fromDictionary:requestBody
                                                        withCompletion:nil];
    
    [action executeActionChain:@"ImportEventToCalendarAction: add to calendar"
                withCompletion:^(TSAction *action, TSAResult *result, NSError *err) {
        
        TSStrongifyAndReturnIfNil(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            NotificationBanner *toastBanner = [NotificationBanner withAutoLayout];
            if(err)
            {
                NSString *title = isUpdateCalendar ? AXPLocalizedString(@"updtClndrFlrTtl") : AXPLocalizedString(@"adToClndrFlrTtl");
                NSString *message = isUpdateCalendar ? AXPLocalizedString(@"updtClndrFlrMsg") : AXPLocalizedString(@"adToClndrFlrMsg");
                [toastBanner setViewDataWithTitle:title message:message icon:[[IconSymbolTypeObjcBridge alloc] initWithCoreSymbol:IconSymbolCoreErrorCircle]];
                LogErrorAH(action.accountHandle.logger, @"TSChatViewController:onAddToCalendarTapped: Import event to calendar API call failure : errorCode:%@ , httpStatusCode:%ld , errorDomain:%@",[err.userInfo valueForKey:NSLocalizedFailureReasonErrorKey], (long)err.code, err.domain);
            }
            else
            {
                NSString *title = isUpdateCalendar ? AXPLocalizedString(@"updtClndrSccs") : AXPLocalizedString(@"adToClndrSccs");
                [toastBanner setViewDataWithTitle:title message:NULL icon:[[IconSymbolTypeObjcBridge alloc] initWithSymbol:IconSymbolCalendarCheckmark]];
            }
            [meetingCardView stopLoader];
            [toastBanner showWithView:self.messagesView presentationStyle: NotificationBannerPresentationStyleToast];
        });
    }];
}

- (BOOL)isMessageInfoForMeetingChiclet:(TSMessageInfo *)messageInfo
{
    BOOL isMeetingMsg = self.accountHandle.ecsManager.showMeetingChicletInGroupChat &&
    ([messageInfo isMeetupMessage] || [messageInfo isScheduledMeetingMessage]);
    
    if (!isMeetingMsg && messageInfo.attributedContent.length > 0)
    {
        /// If the message is to update/cancel an existing meeting, chiclet should be shown.
        NSDictionary *htmlDic = [messageInfo.attributedContent HTMLAttributesAtIndex:0];
        NSString *meetingItemType = [htmlDic valueForKey:TSkMeetingItemType];
        if ([meetingItemType containsString:TSkMeetingUpdated] || [meetingItemType containsString:TSkMeetingCancelled]) {
            return YES;
        }
    }
    return isMeetingMsg;
}

- (BOOL)shouldHideToLineInPreChat
{
    return self.shouldMultiSelectParticipants;
}

- (BOOL)isStartOfNonBifurcatedFlow
{
    return self.shouldUseFlowV2 && self.isMultiSelectParticipantsInProgress;
}

#pragma mark - GMMemeGenViewControllerDelegate

- (void)memeGeneratorDidCancel:(GMMemeGenViewController *)memeGenerator
{
    [memeGenerator.navigationController popViewControllerAnimated:YES];
}

- (void)memeGeneratorDidFinish:(GMMemeGenViewController *)memeGenerator
           withMemeImageObject:(NSObject *)memeImageObject
             sourceImageObject:(NSObject *)sourceImageObject
               sendImmediately:(BOOL)sendImmediately
{
    if (memeImageObject && [memeImageObject isKindOfClass:[NSData class]]
        && self.composeViewController)
    {
        TSWeakify(self)
        
        NSData *imageData = (NSData *) memeImageObject;
        
        if ([imageData isGIFData])
        {
            [self.composeViewController
             attachAnimatedImageData:imageData
             ofType:TSkImageFileTypeGif
             sourceURL:nil
             withPreviewURL:nil
             andSourceSize:[[[UIImage alloc] initWithData:imageData] size]
             sendImmediately:sendImmediately
             accessibilityLabel:nil
             withCompletion:^{
                TSStrongifyAndReturnIfNil(self)
                [self.navigationController dismissViewControllerAnimated:YES
                                                              completion:nil];
            }];
        }
        else
        {
            [self.composeViewController
             attachImageData:imageData
             forLocalIdentifier:nil
             ofType:TSkImageFileTypeJpeg
             sourceURL:nil
             becomeFirstResponder:YES
             sendImmediately:sendImmediately
             withCompletion:^{
                TSStrongifyAndReturnIfNil(self)
                [self.navigationController dismissViewControllerAnimated:YES
                                                              completion:nil];
            }];
        }
    }
    else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showWaitForGroupTemplateCreation
{
    // TODO: @jofuria Task 1687149: Move wait to create group view to TeamsUI
    // https://domoreexp.visualstudio.com/MSTeams/_workitems/edit/1687149
    TSExperimentGroupTemplateCreate groupTemplateExperimentType = self.accountHandle.policyManager.groupCreationWithTemplateExperimentationValue;
    if (groupTemplateExperimentType == TSExperimentGroupTemplateCreateDisabled || groupTemplateExperimentType == TSExperimentGroupTemplateCreateNameAndLandInChat || self.accountHandle.policyManager.isGroupTemplatesWithPeoplePickerEnabled)
    {
        return;
    }
    
    CGFloat padding = TSkWaitForGroupTemplateCreationPadding;
    CGFloat imageSize = TSkWaitForGroupTemplateCreationImageSize;
    UIImage *image = [self.groupTemplateCoordinator defaultGroupAvatar];
    
    self.waitForGroupTemplateCreationContainer = [UIStackView withAutoLayout];
    self.waitForGroupTemplateCreationContainer.axis = UILayoutConstraintAxisVertical;
    self.waitForGroupTemplateCreationContainer.alignment = UIStackViewAlignmentCenter;
    self.waitForGroupTemplateCreationContainer.distribution = UIStackViewDistributionFill;
    self.waitForGroupTemplateCreationContainer.spacing = padding;
    
    self.groupTemplateImage = [UIImageView withAutoLayout];
    [self.groupTemplateImage setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    self.groupTemplateImage.image = image;
    
    UILabel *statusMessage = [UILabel withAutoLayout];
    [statusMessage setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    statusMessage.text = [self.groupTemplateCoordinator waitForCreationMessage];
    statusMessage.textColor = self.legacyAppearanceProxy.primaryTextColor;
    statusMessage.font = TSFont.headline;
    statusMessage.numberOfLines = 2;
    statusMessage.lineBreakMode = NSLineBreakByWordWrapping;
    statusMessage.textAlignment = NSTextAlignmentCenter;
    [statusMessage sizeToFit];
    self.groupTemplatePreparingLabel = statusMessage;
    
    UIView *topSpacer = [UIView withAutoLayout];
    topSpacer.backgroundColor = UIColor.clearColor;
    [topSpacer setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    UIView *bottomSpacer = [UIView withAutoLayout];
    bottomSpacer.backgroundColor = UIColor.clearColor;
    [bottomSpacer setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    [self.waitForGroupTemplateCreationContainer addArrangedSubview:topSpacer];
    [self.waitForGroupTemplateCreationContainer addArrangedSubview:self.groupTemplateImage];
    [self.waitForGroupTemplateCreationContainer addArrangedSubview:self.groupTemplatePreparingLabel];
    [self.waitForGroupTemplateCreationContainer addArrangedSubview:bottomSpacer];
    [self.view addSubview:self.waitForGroupTemplateCreationContainer];
    
    NSArray *constraints = @[
        [topSpacer.heightAnchor constraintEqualToAnchor:bottomSpacer.heightAnchor multiplier:TSkWaitForGroupTemplateCreationVerticalRatio],
        [self.waitForGroupTemplateCreationContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:padding],
        [self.waitForGroupTemplateCreationContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-padding],
        [self.waitForGroupTemplateCreationContainer.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:padding],
        [self.view.bottomAnchor constraintEqualToAnchor:self.waitForGroupTemplateCreationContainer.bottomAnchor constant:padding],
        [self.groupTemplateImage.widthAnchor constraintEqualToAnchor:self.groupTemplateImage.heightAnchor],
        [self.groupTemplateImage.widthAnchor constraintEqualToConstant:imageSize]
    ];
    [self.view addConstraints:constraints];
}

- (void)updateSfcInteropChatBlockView
{
    if (!self.sfcInteropChatBlockViewController && self.threadID)
    {
        if ([self.accountHandle.actionContext isSfCInteropEnabled] && [TSUtilities isSfCInteropChatByThreadId:self.threadID])
        {
            if (![TSSFCInteropOrTFLChatBlockAcceptViewController isAcceptedSfCInteropOrTFLChatForThread:self.threadID accountHandle:self.accountHandle]
                || ![TSSFCInteropOrTFLChatBlockAcceptViewController isBlockedSfCInteropOrTFLChatForThread:self.threadID recipientMri:self.recipientIDs.firstObject accountHandle:self.accountHandle])
            {
                self.sfcInteropChatBlockViewController = [[TSSFCInteropOrTFLChatBlockAcceptViewController alloc] initWithViewController:self
                                                                                                                              forThread:self.threadID
                                                                                                                           recipientMri:self.recipientIDs.firstObject
                                                                                                                          accountHandle:self.accountHandle];
            }
        }
        else if ((self.accountHandle.policyManager.isInviteFreeEnabled || self.accountHandle.policyManager.isTfwTflFedChatConsumptionPhase2OnTfwEnabled) && [self isOneToOneChat])
        {
            if (![TSSFCInteropOrTFLChatBlockAcceptViewController isAcceptedSfCInteropOrTFLChatForThread:self.threadID accountHandle:self.accountHandle])
            {
                LogInfoAH(self.logger, @"Thread ID - %@ in not in accepted state.", self.threadID);
                self.sfcInteropChatBlockViewController = [[TSSFCInteropOrTFLChatBlockAcceptViewController alloc] initWithViewController:self
                                                                                                                              forThread:self.threadID
                                                                                                                           recipientMri:self.recipientIDs.firstObject
                                                                                                                          accountHandle:self.accountHandle];
            }
        }
    }
}

- (void)updateChatHeaderViewVisibilityIfNeeded
{
    if (self.accountHandle.policyManager.isHeaderActionViewInNewChatEnabled && self.stackView)
    {
        if (![self shouldShowChatHeaderView])
        {
            if (self.chatHeaderCoordinator)
            {
                [self.stackView removeArrangedSubview:self.chatHeaderCoordinator.headerView];
                [self.chatHeaderCoordinator.headerView removeFromSuperview];
                self.chatHeaderCoordinator = nil;
            }
            [self.outerViewController updateInviteBannerVisibility];
        }
        else if (self.chatHeaderCoordinator)
        {
            [self.chatHeaderCoordinator updateStatusIfNeeded];
        }
        else
        {
            NSString *groupTemplateId = nil;
            if (self.accountHandle.policyManager.isGroupCreationWithTemplatesEnabled)
            {
                groupTemplateId = [AXPCtx threadForID:self.threadID inMoc:self.accountHandle.mainMOC].groupTemplateId;
            }
            TSWeakify(self);
            self.chatHeaderCoordinator = [[TSChatHeaderCoordinator alloc] initWithAccountHandle:self.accountHandle
                                                                                       threadID:self.threadID
                                                                                groupTemplateId:groupTemplateId
                                                                                didTapShareLink:^
                                          {
                TSStrongify(self)
                UIViewController *parentVC = self.parentViewController;
                if ([parentVC isKindOfClass:TSChatMultiViewController.class])
                {
                    TSChatMultiViewController *chatMultiVC = (TSChatMultiViewController *)parentVC;
                    [chatMultiVC shareLinkToChatWithPanelType:TSkPanelTypeChatHeaderEmptyState];
                }
            }
                                                                               didTapAddMembers:^
                                          {
                TSStrongify(self)
                UIViewController *parentVC = self.parentViewController;
                if ([parentVC isKindOfClass:TSChatMultiViewController.class])
                {
                    TSChatMultiViewController *chatMultiVC = (TSChatMultiViewController *)parentVC;
                    [chatMultiVC addMembersToChatWithInstrumentationSource:TSkPanelTypeChatHeaderEmptyState];
                }
            }
                                                                                 didTapSayHello:^
                                          {
                TSStrongify(self)
                [self didTapChatHeaderSayHelloButton];
            }];
            [self.stackView insertArrangedSubview:self.chatHeaderCoordinator.headerView atIndex:0];
            
            [self.chatHeaderCoordinator updateStatusIfNeeded];
        }
    }
}

- (BOOL)shouldShowChatHeaderView
{
    if (self.shouldHideChatHeaderContainer ||
        !self.accountHandle.policyManager.isHeaderActionViewInNewChatEnabled)
    {
        return NO;
    }
    
    if ([NSString isNilOrEmpty:self.threadID] ||
        self.thread == nil ||
        ![self.thread containsMember:self.accountHandle.MRI])
    {
        return NO;
    }
    
    if (![self.thread isGroupChat])
    {
        self.shouldHideChatHeaderContainer = YES;
        return NO;
    }
    
    if (self.keyboardHeight > 0)
    {
        return NO;
    }
    
    TSConversation *conversation = [AXPCtx conversationForID:self.threadID];
    
    if ([conversation didUserLeaveChat])
    {
        return NO;
    }
    
    // If a conversation has a last message time but the messages for a thread are nil/empty, that
    // means the messages aren't loaded yet.
    if ([conversation ts_lastMessageTime] && ([self.thread messages] == nil || [[self.thread messages] count] == 0))
    {
        return NO;
    }
    
    if ([self.chatHeaderCoordinator hasRemovedHeroTile])
    {
        self.shouldHideChatHeaderContainer = YES;
        return NO;
    }
    
    CGFloat heightForHeroTile = self.view.height - self.tableView.contentSize.height;
    // Hide hero tile if not enough available room in chat window
    if (heightForHeroTile < TSChatHeaderCoordinator.defaultViewHeight)
    {
        self.shouldHideChatHeaderContainer = YES;
        return NO;
    }
    
    NSInteger messageCount = 0;
    for (TSSMessage* message in [self.thread messages])
    {
        // check for any messages other than control messages
        if (![message.ts_messageBaseType compareString:TSkMessageBaseTypeThreadActivity])
        {
            // if we find messages, set shouldHideChatHeaderContainer flag so we can avoid extra DB queries
            messageCount += 1;
            if (messageCount > self.accountHandle.policyManager.maxMessagesBeforeHidingChatHeaderActionView)
            {
                self.shouldHideChatHeaderContainer = YES;
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)didTapChatHeaderSayHelloButton
{
    id<EmojiManagerProtocol> emojiManager = self.accountHandle.emojiManagerProvider.emojiManager;
    TSEmojiTextAttachment *emojiAttachment = [emojiManager getEmojiTextAttachmentFor:@"hi" skinTone:nil logger:self.accountHandle.logger];
    if (emojiAttachment)
    {
        [self sendMessageWithEmojiAttachment:emojiAttachment];
    }
    else
    {
        [emojiManager loadEmojiTextAttachmentFor:@"hi" skinTone:nil logger:self.accountHandle.logger callback:^(TSEmojiTextAttachment * _Nullable attachment) {
            [TSDispatchUtilities dispatchOnMainThread:^{
                [self sendMessageWithEmojiAttachment:attachment];
            }];
        }];
    }
}

- (void)sendMessageWithEmojiAttachment:(TSEmojiTextAttachment *)emojiAttachment
{
    if (emojiAttachment == nil)
    {
        [self.accountHandle.logger logWarning:@"Attempted to send message with emoji attachment but attachment was nil"];
        return;
    }
    
    emojiAttachment.imageSize = CGSizeMake([TSUtilities fluentEmojiScaledDimension], [TSUtilities fluentEmojiScaledDimension]);
    NSAttributedString *attributedText = [NSMutableAttributedString attributedStringWithAttachment:emojiAttachment];
    NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    [attributedMessage addAttributes:self.composeViewController.defaultAttributedStringAttributes range:NSMakeRange(0, attributedText.length)];
    [self.composeViewController updateComposeText:attributedMessage];
    [self.composeViewController submitMessage];
    
    self.shouldHideChatHeaderContainer = YES;
    [self updateChatHeaderViewVisibilityIfNeeded];
}

- (void) taskModuleCompletedWithResult:(TSTaskModuleResult *)taskResult
                             forParams:(TSTaskModuleParams *)params
{
    if ([taskResult.botResponse isKindOfClass:NSDictionary.class])
    {
        NSDictionary *cardJSON = (NSDictionary *)taskResult.botResponse;
        cardJSON = [[cardJSON safeValueForKeyPathOrNil:@"composeExtension.attachments"] firstObject];
        if (!cardJSON)
        {
            LogErrorAH(self.accountHandle.logger, "Could not create card as the bot response is empty");
            return;
        }
        TSWeakify(self);
        [TSDispatchUtilities dispatchOnMainThread:^{
            TSStrongifyAndReturnIfNil(self);
            [self.composeViewController setSelectedCard:cardJSON appID:params.taskInfo.appId botID:params.taskInfo.completionBotId];
        }];
    }
}

- (void) epTaskModuleCompletedWithResult:(EPTaskModuleResult *)taskResult
                               forParams:(EPTaskModuleParams *)params
{
    
    if ([taskResult.botResponse isKindOfClass:NSDictionary.class])
    {
        NSDictionary *cardJSON = (NSDictionary *)taskResult.botResponse;
        cardJSON = [[cardJSON safeValueForKeyPathOrNil:EPTaskModuleConstants.composeExtensionAttachments] firstObject];
        if (!cardJSON)
        {
            LogErrorAH(self.accountHandle.logger, "Could not create card as the bot response is empty");
            return;
        }
        TSWeakify(self);
        [TSDispatchUtilities dispatchOnMainThread:^{
            TSStrongifyAndReturnIfNil(self);
            [self.composeViewController setSelectedCard:cardJSON
                                                  appID:params.launchInfo.appId
                                                  botID:params.taskInfo.completionBotId];
        }];
    }
}

/// Function to trigger refresh for adaptive card v2 specifically for messaging extensions on task module close
- (void) taskModuleCloseWithParams:(TSTaskModuleParams *)params
{
    TSCAdaptiveCardsActionHandler *cardActionHandler = [self.adaptiveCardsCache getAdaptiveCardsDelegateFromKey:params.cardCacheKey];
    if (![self.accountHandle.ecsManager isRefreshForAdaptiveCardsOnClosingTaskModuleEnabled]
        || !(cardActionHandler && cardActionHandler.isACv2Card && cardActionHandler.isMessagingExtension))
    {
        LogErrorAH(self.accountHandle.logger, "Could not refresh card on task module close");
        return;
    }
    
    /// check if bot is allowed to invoke refresh and return if  bot id list is not empty and not whitelisted
    NSArray *botIDs = [self.accountHandle.ecsManager botIdsAllowedToInvokeRefreshOnClosingTaskModule];
    if (![NSArray isNilOrEmpty:botIDs] && ![botIDs containsObject:cardActionHandler.botID])
    {
        LogErrorAH(self.accountHandle.logger, "Could not refresh card on task module close as bot id is not whitelisted");
        return;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cardActionHandler.indexPath];
    if ([cell isKindOfClass:TSChatMessageViewCell.class])
    {
        TSChatMessageViewCell *chatMessageCell = (TSChatMessageViewCell *)cell;
        UIView *cardView = chatMessageCell.messageStackView;
        [self.adaptiveCardsUtility processCardRefresh:TSAdaptiveCardRefreshOnTaskModuleClose
                                          withHandler:cardActionHandler
                                         withCardView:cardView
                                       forMessageInfo:nil
                               forTableViewController:nil];
    }
}

- (void)conversationDeleted:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSSet *updatedConversationList = [userInfo objectForKey:TSkNotificationKeyForConversations];
    if ([updatedConversationList containsObject:self.threadID])
    {
        TSWeakify(self);
        [TSDispatchUtilities dispatchOnMainThread:^{
            TSStrongifyAndReturnIfNil(self);
            [self backButtonTapped:nil];
        }];
    }
}

- (void)threadUpdated:(NSNotification *)notification
{
    //Check if chat disabled meeting option changed
    NSString *notifThreadId = [[notification userInfo] objectForKey:TSKKeyConversationID];
    if ([self.threadID length] && notifThreadId && [notifThreadId isEqualToString:self.threadID])
    {
        [TSDispatchUtilities dispatchOnMainThread:^{
            TSThread *thread = [AXPCtx threadForID:self.threadID];
            TSThreadProperty *awarenessProperty = nil;
            if (self.threadType == TSThreadTypePrivateMeeting)
            {
                awarenessProperty = [AXPCtx threadPropertyForThreadID:self.threadID
                                                      andPropertyName:TSkThreadPropertyPrivateMeetingAwareness
                                                                inMoc:self.accountHandle.mainMOC];
            }
            if(thread && [thread isDisabledChatWithInProgressMeetingOption:YES meetingInProgress:awarenessProperty ? awarenessProperty.propertyValue : NO] && !self.forceEnableChat)
            {
                [self disableChatAndUpdateComposeView:YES];
            }
            else
            {
                [self disableChatAndUpdateComposeView:NO];
            }
        }];
    }
}

#pragma mark - Telemetry

- (void) checkLogTelemetryForBotChatLoad
{
    if (self.recipientIDs.count != 1)
    {
        return;
    }
    
    NSString *userID = self.recipientIDs.firstObject;
    if (!self.isTelemetryLoggedForBotChat && [userID hasPrefix:TSBotPrefix])
    {
        self.isTelemetryLoggedForBotChat = YES;
        [self.platformTelemetryLogger logTelemetryForBotChatLoadWithBotId:userID];
        
    }
}

#pragma mark - LensSDKHelper delegate

- (void) imagesEditedByLensSDK:(NSArray<UIImage *> *)images
{
    for (UIImage *image in images)
    {
        [self.composeViewController attachImageData:UIImageJPEGRepresentation(image, 1.0)
                                 forLocalIdentifier:nil
                                             ofType:TSkImageFileTypeJpeg
                                          sourceURL:nil
                               becomeFirstResponder:YES
                                    sendImmediately:NO
                                     withCompletion:nil];
    }
}

#pragma mark - Show Tagging By Shifts Tool Tip

- (void) showTaggingByShiftsTooltipIfRequired
{
    if ([self shouldShowTaggingByShiftsTooltip])
    {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:AXPLocalizedString(@"EtrNmFrAtvShftGrp"), self.activeScheduledTagName]
                                                                                    attributes:@{NSFontAttributeName : [TSFont subheadline],
                                                                                               }];
        self.toViewController.taggingByShiftsTooltip = message;
        self.taggingByShiftsToolTipView = [TSTooltipView tooltipWithAttributedMessage:message
                                                                      backgroundColor:self.legacyAppearanceProxy.actionBrandDefaultColor
                                                                       pointDirection:TSPointDirectionUp
                                                                            tapAction:nil];
        [self.view addSubview:self.taggingByShiftsToolTipView];
        
        [self.taggingByShiftsToolTipView setPointTo:CGPointMake(TSkTaggingByShiftsTooltipPointerX,0)];
        self.taggingByShiftsToolTipView.tooltipLabel.textAlignment = NSTextAlignmentNatural;
        [self.taggingByShiftsToolTipView alignLeadingToView:self.toView
                                                     offset:TSkTaggingByShiftsTooltipLeadingConstraint];
        [self.taggingByShiftsToolTipView alignTopToView:self.toView
                                                 offset:TSkTaggingByShiftsTooltipTopConstraint];
        [self.taggingByShiftsToolTipView setWidth:TSkTaggingByShiftsTooltipWidth priority:UILayoutPriorityRequired];
        
        // Fade in
        self.taggingByShiftsToolTipView.alpha = 0.0;
        TSWeakify(self);
        [UIView animateWithDuration:TSkTooltipShowHideTime animations:^{
            TSStrongifyAndReturnIfNil(self);
            self.taggingByShiftsToolTipView.alpha = 1.0;
        } completion:^(BOOL finished) {
            // After delay, fade out
            [UIView animateWithDuration:TSkTooltipShowHideTime delay:TSkTooltipAutoHideDelay options:UIViewAnimationOptionAllowUserInteraction animations:^{
                // Alpha of 0.1 rather than 0 to allow user interaction while animation is delayed
                self.taggingByShiftsToolTipView.alpha = 0.1;
            } completion:^(BOOL finished) {
                [self.taggingByShiftsToolTipView removeFromSuperview];
                self.taggingByShiftsToolTipView = nil;
            }];
        }];
    }
}

- (BOOL) shouldShowTaggingByShiftsTooltip
{
    return ([self.accountHandle.tagManager isTargetedChatsEnabled] &&
            [self.accountHandle.policyManager scheduledTagsEnabled] &&
            [self.activeScheduledTagName isNotNilOrEmpty]);
}

#pragma mark - Msg Animations
- (void) setupMsgAnimationFor:(TSMessageInfo *)messageInfo andCell:(TSChatMessageViewCell *)messageCell
{
    if (self.mAnimationCoordinator == nil)
    {
        id<MADependencyRegistrarProtocol> animationDependencyRegistrar = ResolveProtocol(MADependencyRegistrarProtocol);
        
        self.mAnimationCoordinator = [[animationDependencyRegistrar userDependenciesWithAccountId:self.accountHandle.accountId tenantId:self.accountHandle.tenantId]
                                      makeAnimationCoordinatorBridgeFromViewController:self
        ];
        [self.mAnimationCoordinator start];
        UIView *maCanvasView = [self.mAnimationCoordinator getCanvasView];
        [self.view insertSubview:maCanvasView belowSubview:self.composeView];
        maCanvasView.translatesAutoresizingMaskIntoConstraints = NO;
        [maCanvasView setHidden:YES];
        [maCanvasView.bottomAnchor constraintEqualToAnchor:self.composeView.bottomAnchor].active = YES;
        [maCanvasView.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
        [maCanvasView.leadingAnchor constraintEqualToAnchor:self.tableView.leadingAnchor].active = YES;
        [maCanvasView.topAnchor constraintEqualToAnchor:self.tableView.topAnchor].active = YES;
        
    }
    if (messageInfo.isConversationMessage)
    {
        NSDictionary *emojisAttachments = [TSTextAttachmentFormatter allEmojiAttachmentsInAttributedString:messageInfo.attributedContent];
        BOOL hasEmojis = ([emojisAttachments count] > 0);
        NSString *messageText = messageInfo.attributedContent.string;
        
        if (hasEmojis)
        {
            messageText = @"";
            for(NSString *emojiId in emojisAttachments)
            {
                TSEmojiTextAttachment *emoji = emojisAttachments[emojiId];
                messageText = [messageText stringByAppendingString:emoji.altText];
            }
        }
        [self.mAnimationCoordinator playAnimationIfNeededWithMsgText:messageText
                                                          identifier:messageInfo.tsID.stringValue
                                                            threadId:self.threadID
                                                   enabledAnimations:self.accountHandle.policyManager.msgAnimationsList ?: @[]
                                                   animationWillPlay:^{
            [((TSBaseTableViewCell *)messageCell) highlightSearchResultCellForQuickReact:NO completion:nil];
        }];
    }
}

- (void)handleLaunchImmersiveReader:(NSArray<TSSMessage *>*) messages
{
    [self.contextOptionsHandler handleLaunchImmersiveReader:messages chatName:self.topicName];
}

- (void)launchSlideshowWithUrl:(NSURL *)imageUrl
                   inMessageId:(NSNumber *)messageId
                    sourceView:(UIView *)sourceView
                    imageIndex:(NSUInteger)imageIndex
                    imageCount:(NSUInteger)imageCount

{
    TSThread *thread = [AXPCtx threadForID:self.threadID inMoc:self.accountHandle.mainMOC];
    InstrumentationThreadProperties *threadProperties = [[InstrumentationThreadProperties alloc] initWithThreadId:self.threadID
                                                                                                       threadType:self.biThreadType
                                                                                                      threadTitle:nil
                                                                                                    threadMembers:@(thread.memberCount)
                                                                                                         chatType:self.biChatType];
    
    [self stopPlayerIfPlaying];
    
    TSWeakify(self)
    UIViewController * (^loadMemeController)(UIImage *image) = ^UIViewController * (UIImage *image) {
        TSStrongifyAndReturnValueIfNil(self, nil)
        
        UIViewController *controller = nil;
        
        if (image)
        {
            GMMemeGenViewController *memeController =
            [[GMMemeGenViewController alloc] initWithImage:image
                                                sourceType:TSkMemeMetadataSourceTypeSlideshow
                                                  threadId:self.threadID
                                             accountHandle:self.accountHandle];
            memeController.delegate = self;
            [memeController setupBackButton];
            
            controller = memeController;
        }
        
        return controller;
    };
    
    void (^updateStatusBar)(UIStatusBarStyle, BOOL) = ^void(UIStatusBarStyle style, BOOL hidden) {
        TSStrongifyAndReturnIfNil(self)
        
        UIViewController *parentVC = self.parentViewController;
        if ([parentVC isKindOfClass:TSChatMultiViewController.class])
        {
            [(TSChatMultiViewController *)parentVC updateStatusBarWithStyle:style hidden:hidden];
        }
    };
    
    TSGalleryMediaAuthorizerBridge *authorizerBridge = [[TSGalleryMediaAuthorizerBridge alloc] initWithMediaAuthorizer:[MediaAuthorizer sharedInstance]
                                                                                                         accountHandle:self.accountHandle];
    self.gallerySlideshowCoordinator = [[TSChatGallerySlideshowCoordinatorBridge alloc]
                                        initWithAccountHandle:self.accountHandle
                                        threadProperties:threadProperties
                                        excludedShareActivityTypes:TSSharedManagers.intuneManager.isSaveToPhotoLibraryAllowed ? @[] : @[ UIActivityTypeSaveToCameraRoll ]
                                        tappedMessageId:messageId
                                        tappedSrcUrl:imageUrl
                                        navigationController:self.navigationController
                                        reverseSlideOrder:self.isInvertedView
                                        updateStatusBar:updateStatusBar
                                        loadMemeController:[self.composeViewController isMemesInputActionEnabled] ? loadMemeController : nil
                                        onDismiss:^{
        updateStatusBar(UIStatusBarStyleDefault, false);
        if (sourceView)
        {
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, sourceView);
        }
    }
                                        mediaSharingRouter:[[GalleryMediaSharingRouter alloc] initWithAccountHandle:self.accountHandle presentingViewController:self helperDelegate:self]
                                        allowImageEditing:self.accountHandle.ecsManager.imageEditingEnabled
                                        mediaAuthorizer:authorizerBridge
                                        mediaStripEnabled:self.accountHandle.policyManager.chatGalleryMediaStripEnabled];
    
    [self.gallerySlideshowCoordinator start];
    
    NSDictionary *metaData = [TSUtilities metaDataFromDataBagDictionary:
                              @{
        @"launchSource" : TSkGallerySlideshowLaunchSourceChat,
        @"imageIndex" : @(imageIndex + 1),
        @"imageCount" : @(imageCount)
    }];
    
    [self.logger logPanelAction:TSkActionModuleNameGalleryImageChatMessageEntryPoint
                        outCome:TSkActionOutcomeNav
                        gesture:TSkActionGestureTap
                       scenario:TSkScenarioLaunchSlideshow
                   scenarioType:TSkScenarioTypeGallery
                 destinationuri:nil
           destinationUriParams:nil
                     moduleType:TSkActionModuleNameGalleryImageChatMessage
                    moduleState:nil
                  moduleSummary:nil
                      panelType:nil
                       panelUri:nil
                 panelUriParams:nil
                       threadId:self.threadID
                     threadType:nil
                        tabType:nil
                     tabOrdinal:nil
                       metaData:metaData];
}

- (NSDictionary *)guardiansChatThreadInfo
{
    return (self.isGuardiansChat
            ? @{ TSkIsGuardiansChat: @(YES),
                 TSkAADGroupID: self.guardiansAadGroupId ?: @"",
                 TSKKeyUserID: self.guardiansUserId ?: @"",
              }
            : nil);
}

#pragma mark - Translator Intelligent Suggestions
- (void) setupTranslationIntelligentSuggestionsFor:(TSMessageInfo *)messageInfo andCell:(TSChatMessageViewCell *)messageCell
{
    if (messageInfo.policyViolationMessageState.integerValue == TSDLPStateBlocked)
    {
        // No IS view should be provided.
        return;
    }
    
    // Initialize the Intelligent Suggestions coordinator.
    if (self.translationIntelligentSuggestionsCoordinator == nil)
    {
        self.translationIntelligentSuggestionsCoordinator = [[TSTranslationIntelligentSuggestionsCoordinatorBridge alloc]
                                                             initWithAccountHandle:self.accountHandle
                                                             fromViewController:self];
        
        [self.translationIntelligentSuggestionsCoordinator start];
    }
    
    BOOL isMessageTranslated = [messageInfo isTranslatedMessageForDisplay];
    BOOL needToShowTurnOnAutomaticTranslationButton = [messageInfo canShowTurnOnAutomaticTranslationIntelligentSuggestion];
    BOOL needToShowNeverTranslateButton = [messageInfo canShowNeverTranslateIntelligentSuggestion];
    
    if (!isMessageTranslated)
    {
        [self.logger logPanelView:TSkScenarioTypeTranslationIntelligentSuggestions
                         scenario:TSkScenarioNameTranslationIntelligentSuggestionsTranslateShown
                     scenarioType:TSkScenarioTypeTranslationIntelligentSuggestions
                       moduleName:TSkModuleNameTranslationIntelligentSuggestionsTranslateButton
                       moduleType:TSkScenarioTypeTranslationIntelligentSuggestions
                       threadType:nil];
    }
    
    NSString *languageName = nil;
    if (needToShowNeverTranslateButton)
    {
        languageName = [TSTranslationLanguageManager getLanguageDisplayNameWithLanguageID:messageInfo.ts_contentLanguageID accountHandle:messageInfo.accountHandle];
        [self.logger logPanelView:TSkScenarioTypeTranslationIntelligentSuggestions
                         scenario:TSkScenarioNameTranslationIntelligentSuggestionsNeverTranslateShown
                     scenarioType:TSkScenarioTypeTranslationIntelligentSuggestions
                       moduleName:TSkModuleNameTranslationIntelligentSuggestionsNeverTranslateButton
                       moduleType:TSkScenarioTypeTranslationIntelligentSuggestions
                       threadType:nil];
    }
    
    if (needToShowTurnOnAutomaticTranslationButton)
    {
        [self.logger logPanelView:TSkScenarioTypeTranslationIntelligentSuggestions
                         scenario:TSkScenarioNameTranslationIntelligentSuggestionsAutoTranslateShown
                     scenarioType:TSkScenarioTypeTranslationIntelligentSuggestions
                       moduleName:TSkModuleNameTranslationIntelligentSuggestionsAutoTranslateButton
                       moduleType:TSkScenarioTypeTranslationIntelligentSuggestions
                       threadType:nil];
    }
    
    if (!isMessageTranslated || needToShowTurnOnAutomaticTranslationButton || (needToShowNeverTranslateButton && ![NSString isNilOrEmpty:languageName]))
    {
        BOOL needToShowFeedbackButton = [TSTranslationManager isTranslationFeedbackEnabled:self.accountHandle];
        TranslationIntelligentSuggestionsConfigProps *config = [[TranslationIntelligentSuggestionsConfigProps alloc] initWithIsMessageTranslated:isMessageTranslated || self.isTranslationInProgress
                                                                                                                         isLanguageSeenFirstTime:needToShowNeverTranslateButton
                                                                                                                                    languageName:languageName
                                                                                                                             showTurnOnAutomatic:needToShowTurnOnAutomaticTranslationButton && !self.isAutomaticTranslationButtonTapped
                                                                                                                showChangeTranslationPreferences:NO
                                                                                                                                showFeedbackIcon:needToShowFeedbackButton];
        
        UIView *translatorIntelligentSuggestionsView = [self.translationIntelligentSuggestionsCoordinator configureTranslationIntelligentSuggestionsViewWithConfig:config];
        [messageCell configureTranslationIntelligentSuggestionsView:translatorIntelligentSuggestionsView];
    }
    else
    {
        [messageCell clearIntelligentSuggestionsAccessibilityLabel];
    }
}

- (void) setupTranslationPreferencesIntelligentSuggestionsFor:(TSMessageInfo *)messageInfo andCell:(TSChatMessageViewCell *)messageCell
{
    BOOL needToShowNeverTranslateButton = [messageInfo canShowNeverTranslateIntelligentSuggestion];
    BOOL needToShowChangeTranslationPreferencesButton = [messageInfo canShowChangeTranslationPreferencesIntelligentSuggestion];
    
    NSString *languageName = nil;
    if (needToShowNeverTranslateButton)
    {
        languageName = [TSTranslationLanguageManager getLanguageDisplayNameWithLanguageID:messageInfo.ts_contentLanguageID accountHandle:messageInfo.accountHandle];
        [self.logger logPanelView:TSkScenarioTypeTranslationIntelligentSuggestions
                         scenario:TSkScenarioNameTranslationIntelligentSuggestionsNeverTranslateShown
                     scenarioType:TSkScenarioTypeTranslationIntelligentSuggestions
                       moduleName:TSkModuleNameTranslationIntelligentSuggestionsNeverTranslateButton
                       moduleType:TSkScenarioTypeTranslationIntelligentSuggestions
                       threadType:nil];
    }
    
    if (needToShowChangeTranslationPreferencesButton)
    {
        [self.logger logPanelView:TSkScenarioTypeTranslationIntelligentSuggestions
                         scenario:TSkScenarioNameTranslationIntelligentSuggestionsChangeSettingsShown
                     scenarioType:TSkScenarioTypeTranslationIntelligentSuggestions
                       moduleName:TSkModuleNameTranslationIntelligentSuggestionsChangeSettings
                       moduleType:TSkScenarioTypeTranslationIntelligentSuggestions
                       threadType:nil];
    }
    
    if (needToShowNeverTranslateButton || needToShowChangeTranslationPreferencesButton)
    {
        // Initialize the Intelligent Suggestions coordinator.
        if (self.translationIntelligentSuggestionsCoordinator == nil)
        {
            self.translationIntelligentSuggestionsCoordinator = [[TSTranslationIntelligentSuggestionsCoordinatorBridge alloc]
                                                                 initWithAccountHandle:self.accountHandle
                                                                 fromViewController:self];
            
            [self.translationIntelligentSuggestionsCoordinator start];
        }
        
        TranslationIntelligentSuggestionsConfigProps *config = [[TranslationIntelligentSuggestionsConfigProps alloc] initWithIsMessageTranslated:YES
                                                                                                                         isLanguageSeenFirstTime:needToShowNeverTranslateButton
                                                                                                                                    languageName:languageName
                                                                                                                             showTurnOnAutomatic:NO
                                                                                                                showChangeTranslationPreferences:needToShowChangeTranslationPreferencesButton
                                                                                                                                showFeedbackIcon:NO];
        
        UIView *translatorIntelligentSuggestionsView = [self.translationIntelligentSuggestionsCoordinator configureTranslationIntelligentSuggestionsViewWithConfig:config];
        [messageCell configureTranslationIntelligentSuggestionsView:translatorIntelligentSuggestionsView];
    }
    else
    {
        [messageCell clearIntelligentSuggestionsAccessibilityLabel];
    }
}

- (void) tappedOnTranslateButton:(NSNumber *)messageID
{
    if (messageID)
    {
        TSSMessage *message = [TSSMessage messageForID:messageID andThreadID:self.threadID inManagedObjectContext:self.accountHandle.mainMOC];
        
        if (message)
        {
            if (!UIAccessibilityIsVoiceOverRunning())
            {
                self.isTranslationInProgress = YES;
                
                NSIndexPath *indexPath = self.itemLookupMap[message.tsID];
                if (indexPath)
                {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            
            [self.contextOptionsHandler actionSelected:TSkMessageActionTranslateChatMessage forMessage:message passedView:nil];
            
            if (!UIAccessibilityIsVoiceOverRunning())
            {
                self.isTranslationInProgress = NO;
            }
            
            [self.logger logPanelAction:TSkScenarioTypeTranslationIntelligentSuggestions
                                outCome:TSkActionOutcomeSubmit
                                gesture:TSkActionGestureTap
                               scenario:TSkScenarioNameTranslationIntelligentSuggestionsTranslate
                           scenarioType:TSkScenarioTypeTranslationIntelligentSuggestions
                         destinationuri:nil
                   destinationUriParams:nil
                             moduleType:nil
                            moduleState:nil
                          moduleSummary:nil
                              panelType:nil
                               panelUri:nil
                         panelUriParams:nil
                             threadType:nil];
        }
    }
}

- (void) tappedOnNeverTranslateButton:(NSNumber *)messageID
{
    if (messageID)
    {
        TSSMessage *message = [TSSMessage messageForID:messageID andThreadID:self.threadID inManagedObjectContext:self.accountHandle.mainMOC];
        if (message)
        {
            [TSTranslationLanguageManager addToNeverTranslateLanguageWithLanguageID:message.ts_contentLanguageID
                                                                      accountHandle:self.accountHandle];
            
            // Stop showing the Never translate {language} button. Need to reload this specific message to it gets reconfigured.
            NSIndexPath *indexPath = self.itemLookupMap[message.tsID];
            if (indexPath)
            {
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            
            NSString *languageName = [TSTranslationLanguageManager getLanguageDisplayNameWithLanguageID:message.ts_contentLanguageID
                                                                                          accountHandle:self.accountHandle];
            
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:AXPLocalizedString(@"TrsltnSttgsBttn")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                [self tappedOnTranslationSettings:TSkScenarioNameTranslationIntelligentSuggestionsSettingsNeverTranslate];
            }];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:AXPLocalizedString(@"TSOK")
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
            
            [TSAlertUtils presentAlertViewWithTitle:[NSString stringWithFormat:AXPLocalizedString(@"TrsltnNvrTrsltLng"), languageName]
                                         andMessage:[NSString stringWithFormat:AXPLocalizedString(@"TrsltnModNvrIsMdl"), languageName]
                                    andAlertActions:@[ok, action]
                                  andViewController:[AXPAppViewController activeViewController]];
            
            [self.logger logPanelAction:TSkScenarioTypeTranslationIntelligentSuggestions
                                outCome:TSkActionOutcomeSubmit
                                gesture:TSkActionGestureTap
                               scenario:TSkScenarioNameTranslationIntelligentSuggestionsNeverTranslate
                           scenarioType:TSkScenarioTypeTranslationIntelligentSuggestions
                         destinationuri:nil
                   destinationUriParams:nil
                             moduleType:nil
                            moduleState:nil
                          moduleSummary:nil
                              panelType:nil
                               panelUri:nil
                         panelUriParams:nil
                             threadType:nil];
        }
    }
}

- (void) tappedOnTurnOnAutomaticTranslationsButton:(NSNumber *)messageID
{
    if (messageID)
    {
        [TSTranslationManager setAutomaticTranslationMode:self.accountHandle];
        
        TSSMessage *message = [TSSMessage messageForID:messageID andThreadID:self.threadID inManagedObjectContext:self.accountHandle.mainMOC];
        if (message)
        {
            __weak typeof(self) weakSelf = self;
            
            self.isAutomaticTranslationButtonTapped = YES;
            
            // Stop showing the Turn on Automatic Translation button. Need to reload this specific message to it gets reconfigured.
            NSIndexPath *indexPath = self.itemLookupMap[message.tsID];
            if (indexPath)
            {
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            self.isAutomaticTranslationButtonTapped = NO;
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:AXPLocalizedString(@"TrsltnSttgsBttn")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf updateChatMessages:nil];
                [weakSelf tappedOnTranslationSettings:TSkScenarioNameTranslationIntelligentSuggestionsSettingsAutoTranslate];
            }];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:AXPLocalizedString(@"TSOK")
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf updateChatMessages:nil];
            }];
            
            [TSAlertUtils presentAlertViewWithTitle:AXPLocalizedString(@"TrsltnModTrnOnIsMdlTtl")
                                         andMessage:AXPLocalizedString(@"TrsltnModTrnOnIsMdl")
                                    andAlertActions:@[ok, action]
                                  andViewController:[AXPAppViewController activeViewController]];
            
            [self.logger logPanelAction:TSkScenarioTypeTranslationIntelligentSuggestions
                                outCome:TSkActionOutcomeSubmit
                                gesture:TSkActionGestureTap
                               scenario:TSkScenarioNameTranslationIntelligentSuggestionsAutoTranslate
                           scenarioType:TSkScenarioTypeTranslationIntelligentSuggestions
                         destinationuri:nil
                   destinationUriParams:nil
                             moduleType:nil
                            moduleState:nil
                          moduleSummary:nil
                              panelType:nil
                               panelUri:nil
                         panelUriParams:nil
                             threadType:nil];
        }
    }
}

- (void) tappedOnTranslationSettings:(NSString *)scenario
{
    [TSDispatchUtilities dispatchOnMainThread:^
     {
        AXPSettingsViewController *settingsVC = [[AXPSettingsViewController alloc] init];
        [settingsVC willNavigateToView:@{
            @"dataSource" : [AXPApp translationSettingsSections],
            @"isPresented" : @(YES),
            @"viewId" : @"Settings_translation",
            TSkKeyTitle : AXPLocalizedString(@"TrsltnSttngTtl")
        }];
        
        TSPresentedNavigationController *navigationController = [[TSPresentedNavigationController alloc] initWithRootViewController:settingsVC];
        [[AXPAppViewController rootViewController] presentViewController:navigationController animated:YES completion:nil];
    }];
    
    [self.logger logPanelAction:TSkScenarioTypeTranslationIntelligentSuggestions
                        outCome:TSkActionOutcomeSubmit
                        gesture:TSkActionGestureTap
                       scenario:scenario
                   scenarioType:TSkScenarioTypeTranslationIntelligentSuggestions
                 destinationuri:nil
           destinationUriParams:nil
                     moduleType:nil
                    moduleState:nil
                  moduleSummary:nil
                      panelType:TSkPanelTypeIsActiveSettingPrompt
                       panelUri:nil
                 panelUriParams:nil
                     threadType:nil];
}

- (void) tappedOnFeedbackButton:(NSNumber *)messageID
{
    if (messageID)
    {
        TSSMessage *message = [TSSMessage messageForID:messageID andThreadID:self.threadID inManagedObjectContext:self.accountHandle.mainMOC];
        
        UIViewController *activeViewController = [AXPAppViewController activeOrPresentedViewController];
        if (!activeViewController)
        {
            return;
        }
        
        NSString *version = [TSSharedManagers.appPropertiesManager versionBuild];
        NSString *sessionId = AXPInstrumentationManager.sharedInstance.sessionId;
        NSString *deviceType = [AXPUtilities deviceModelName:[AXPDeviceCapabilities currentDevice].deviceModel];
        FeedbackClientData *clientData = [[FeedbackClientData alloc] initWithClientVersion:version ?: @""
                                                                                      ring:[self.accountHandle.tenantDefaults stringForKey:TSkRingKey]
                                                                                   osBuild:[[UIDevice currentDevice] systemVersion] ?: @""
                                                                                  tenantId:self.accountHandle.tenantId
                                                                            loggableUserId:self.accountHandle.account.userObjectId ?: @""
                                                                                deviceType:deviceType ?: @""
                                                                          processSessionId:sessionId ?: @""
                                                                                  deviceId:[AXPDeviceCapabilities.currentDevice deviceId]
                                                                                branchName:[AXPCtx.appConfig stringForConfigKeyPath:@"BranchName"]];
        
        TSTranslationFeedbackDelegate *feedbackDelegate = [[TSTranslationFeedbackDelegate alloc] initWithAccountHandle:self.accountHandle
                                                                                                              threadId:message.threadID
                                                                                                            threadType:self.biThreadType
                                                                                                    lastMessageContent:[message previewTextWithUserMri:self.accountHandle.MRI]
                                                                                                   isMessageTranslated:NO
                                                                                                 messageSourceLanguage:message.ts_contentLanguageID];
        
        FeedbackUserDependencies *userDependencies = [ResolveProtocol(FeedbackDependencyRegistrarProtocol) userDependenciesWithAccountId:self.accountHandle.accountId tenantId:self.accountHandle.tenantId];
        
        OcvFeedbackData *ocvFeedbackData = [[OcvFeedbackData alloc] initWithAppId:self.accountHandle.policyManager.appId
                                                                         surveyId:TranslatorLanguageDetectionOcvSurveyId
                                                               feedbackClientData:clientData
                                                             feedbackScenarioType:FeedbackScenarioTypeSurvey];
        OcvFeedbackManager *ocvFeedbackManager = [userDependencies createOcvFeedbackManagerWithOcvFeedbackData:ocvFeedbackData];
        
        [userDependencies showFeedbackFormFromViewController:activeViewController
                                             feedbackManager:ocvFeedbackManager
                                           feedbackOperation:feedbackDelegate
                                            feedbackScenario:FeedbackScenarioHasListOfOptions
                                            dismissThreshold:nil
                                                onDisableSnS:nil
                                   shouldShowDisableSnSAlert:NO];
    }
}

- (NSDictionary *)buildGuardiansRecipientsUserInfo
{
    NSMutableDictionary *recipientsUserInfo = [NSMutableDictionary new];
    for (NSString *recipient in self.recipientIDs)
    {
        if ([self.guardiansRecipientEmails containsObject:recipient])
        {
            recipientsUserInfo[recipient] = @{
                TSkRole: TSkUserTypeUser,
                TSkSearchResultItemType: TSkAnonymousUserWithEmailSearchType,
                TSkItemInfoEmail: recipient,
                TSkDisplayName : recipient,
            };
        }
        else if ([self.guardiansRecipientPhones containsObject:[self trimSMSPrefix:recipient]])
        {
            recipientsUserInfo[recipient] = @{
                TSkRole: TSkUserTypeUser,
                TSkSearchResultItemType: TSkAnonymousUserWithPhoneSearchType,
                TSkItemInfoPhone: recipient,
                TSkDisplayName : [self trimSMSPrefix:recipient],
            };
        }
        else
        {
            TSUser *user = [TSUser userForID:recipient
                      inManagedObjectContext:self.accountHandle.mainMOC];
            recipientsUserInfo[recipient] = @{
                TSkRole: TSkUserTypeUser,
                TSkUserMRI: recipient,
                TSkDisplayName: user.displayName ?: @"",
                TSkSearchResultItemType: @"",
            };
        }
    }
    
    return recipientsUserInfo;
}

#pragma mark - Loading indicator
- (void)setActivitySpinnerWithText:(NSString *)text showSpinner:(BOOL)showSpinner
{
    __weak typeof(self) weakSelf = self;
    [TSDispatchUtilities dispatchOnMainThread:^{
        
        if (showSpinner)
        {
            [weakSelf stopActivityIndicator];
            if (!weakSelf.activitySpinnerWithText) {
                weakSelf.activitySpinnerWithText = [TSUtilities activitySpinnerWithText:text];
                [weakSelf.view addSubview:weakSelf.activitySpinnerWithText];
            }
            [weakSelf.activitySpinnerWithText.centerXAnchor constraintEqualToAnchor:weakSelf.view.centerXAnchor].active = YES;
            [weakSelf.activitySpinnerWithText.centerYAnchor constraintEqualToAnchor:weakSelf.view.centerYAnchor].active = YES;
            weakSelf.activitySpinnerWithText.hidden = NO;
        }
        else if (weakSelf.activitySpinnerWithText)
        {
            weakSelf.activitySpinnerWithText.hidden = YES;
            [weakSelf.activitySpinnerWithText removeFromSuperview];
            weakSelf.activitySpinnerWithText = nil;
        }
    }];
}

- (BOOL)isInviteByPhoneOrEmailAvailableForRecipientInfo:(NSDictionary *)recipientInfo
{
    // New guardian chats can override and allow invite by phone/email
    return (self.isGuardiansChat &&
            self.threadID == nil &&
            ![TSUser isValidUserMRI:recipientInfo[TSkUserMRI]]);
}

- (void)addGuardianRecipients
{
    for (NSString *recipientID in self.recipientIDs)
    {
        NSString *recipient = recipientID.copy;
        BOOL isEmail = [self.guardiansRecipientEmails containsObject:recipient];
        BOOL isPhone = [self.guardiansRecipientPhones containsObject:recipient];
        BOOL isExternal = (isEmail || isPhone);
        
        NSString *displayName = recipient;
        if (!isExternal)
        {
            TSUser *user = [TSUser userForID:recipient
                      inManagedObjectContext:self.accountHandle.mainMOC];
            displayName = user.displayName;
        }
        
        NSDictionary *recipientInfo = @{ TSkSearchResultItemType: isExternal ? TSkExternalContactType : @"",
                                         TSkRole: TSkUserTypeUser,
                                         TSkDisplayName: displayName ?: @"" };
        
        if (isPhone)
        {
            recipient = [TSGroupChatSMSUserPrefix stringByAppendingString:recipient];
        }
        
        [self.toViewController addRecipientID:recipient
                               withAttributes:recipientInfo
                                   addAsGuest:NO];
    }
}

#pragma mark - TSChatMessageContextOptionsProviderDelegate

- (NSDictionary<NSString *,NSNumber *> *)getAllRecipientsConsumptionHorizons
{
    return self.allRecipientsConsumptionHorizons;
}

- (NSString *)getBiThreadType
{
    return self.biThreadType;
}

- (AXPPanelInfo * _Nonnull)getCurrentPanelInfo
{
    return self.currentPanelInfo;
}

- (UIViewController *)getCurrentViewController
{
    return (UIViewController *)self;
}

- (NSDictionary *)getMessageDictionary
{
    return self.messageDictionary;
}

- (UIViewController *)getParentViewController
{
    return (UIViewController *)self.parentViewController;
}

- (NSArray *)getRecipientIDs
{
    return self.recipientIDs;
}

- (nullable UITableView *)getTableView
{
    return self.tableView;
}

- (BOOL)isThreadV2Type
{
    return self.isV2Thread;
}

- (BOOL)limitComposeOptnInFedChat
{
    return self.shouldLimitComposeOptnInFedChat;
}

- (BOOL)fedChatComposeOptionsDisabled
{
    return [self shouldDisableFedChatComposeOptions];
}

- (NSString *)threadIdForThread
{
    return self.threadID;
}

- (TSThreadType)threadTypeForThread
{
    return self.threadType;
}

- (void)updateFreezeConsumptionHorizonBookmarkReset:(BOOL)value
{
    self.freezeConsumptionHorizonBookmarkReset = value;
}

- (void)reactionPickerDidPressSearch:(UIView *)searchView
{
    TSWeakify(self)
    [self dismissViewControllerAnimated:YES completion:^{
        [UIView performWithoutAnimation:^{
            TSStrongifyAndReturnIfNil(self)
            [self.view addSubview:searchView];
            
            NSLayoutConstraint *bottom = [searchView.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor constant:0];
            
            [NSLayoutConstraint activateConstraints: @[
                [searchView.heightAnchor constraintEqualToConstant:TSkEmojiSearchBarHeight],
                [searchView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                [searchView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                bottom]
            ];
        }];
    }];
}

- (TSBaseComposeViewController *)getComposeViewController
{
    return self.composeViewController;
}

- (NSDictionary *)appendAdditionalParametersToEditControllerBeforePresentingWithViewInfo:(NSDictionary *)viewInfo
{
    if (![self isPrivateChatWithBot])
    {
        return viewInfo;
    }
    
    /// For bot only chat we do not want to share the file with participants
    /// This flag will be checked in TSFileUploadManager to bypass that step.
    NSMutableDictionary *newInfo = [viewInfo mutableCopy];
    newInfo[TSkEditViewArgIsBotOnlyChat] = @YES;
    return [newInfo copy];
}

- (void)handleMessageReply:(TSSMessage*)message
{
    if (!message)
    {
        LogErrorAH(self.logger, @"Reply to Message, message is nil");
        return;
    }
    
    TSMessageReplyViewModel *replyObject = [[TSMessageReplyViewModel alloc] initWithThreadID:message.threadID messageID:message.tsID];
    
    [self.composeViewController.composeContentHandler addContent:replyObject];
    
    [self.composeViewController configureSendButton:YES];
    
    [self.composeViewController.textBody becomeFirstResponder];
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.composeViewController.textBody);
}

- (void)showDashboardPinnedItemsCoachMarkIfNeeded
{
    return [self.coachMarkManager showDashboardPinnedItemsCoachMarkIfNeeded];
}

- (nonnull NSArray<NSDictionary *> *)getMessageActionsAt:(nullable NSIndexPath *)indexPath
{
    return self.messageActions;
}

- (BOOL)isFreVOAnnouncementInProgress
{
    return self.freVOAnnouncementInProgress;
}

- (void)updateExecutingMessageDeletionForUser:(BOOL)value
{
    self.executingMessageDeletionForUser = value;
}

- (void)updateFreVOAnnouncementInProgress:(BOOL)value
{
    self.freVOAnnouncementInProgress = value;
}

- (nullable NSDictionary *)getViewRestorationInfo
{
    return self.viewRestorationInfo;
}

- (void)updateMessageDictionary:(NSDictionary *)newValues
{
    self.messageDictionary = newValues;
}

- (nullable NSDictionary *)dataObjectForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath inTableView:(UITableView * _Nonnull)tableView
{
    return [self dataForRowAtIndexPath:indexPath inTableView:tableView];
}

#pragma mark - TSFluidTablePreviewCellInChatProviderDelegate

- (nonnull TSChatMessageContextOptionsHandler *)getContextOptionsHandler
{
    return (TSChatMessageContextOptionsHandler *)self.contextOptionsHandler;
}

#pragma mark - TSChatMessageLongPressProviderDelegate methods

- (nonnull TSCAdaptiveCardCache *)getAdaptiveCardsCache
{
    return self.adaptiveCardsCache;
}

- (nonnull TSCAdaptiveCardUtility *)getAdaptiveCardsUtility
{
    return self.adaptiveCardsUtility;
}

- (nullable id<TSMessageActionDelegate, TSReactionDelegate>)getActionDelegateHandler
{
    return (id<TSMessageActionDelegate, TSReactionDelegate>)self.contextOptionsHandler;
}

- (nullable UIViewController *)getPopupDisplayController
{
    return (UIViewController *)self;
}

@end
