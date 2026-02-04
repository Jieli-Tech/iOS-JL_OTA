//
//  ServiceUUIDInputVC.m
//  JL_OTA
//
//  Created by EzioChan on 2025/12/1.
//  Copyright © 2025 Zhuhia Jieli Technology. All rights reserved.
//

#import "ServiceUUIDInputVC.h"

@interface ServiceUUIDInputVC () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSArray<NSString *> *initialUUIDs;

@end

@implementation ServiceUUIDInputVC

- (instancetype)initWithInitialUUIDs:(NSArray<NSString *> *)initialUUIDs {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _initialUUIDs = [initialUUIDs copy];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _initialUUIDs = @[];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        // Fallback on earlier versions
        self.view.backgroundColor = [UIColor whiteColor];
    }
    self.title = kJL_TXT("gatt_uuid_title");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kJL_TXT("cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kJL_TXT("save") style:UIBarButtonItemStyleDone target:self action:@selector(saveTapped)];

    [self configureUI];
    [self prefillInitialData];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - UI Setup
- (void)configureUI {
    self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.textView.delegate = self;
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    if (@available(iOS 13.0, *)) {
        self.textView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    } else {
        // Fallback on earlier versions
        self.textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    self.textView.layer.cornerRadius = 8.0;
    self.textView.textContainerInset = UIEdgeInsetsMake(12, 8, 12, 8);
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.returnKeyType = UIReturnKeyDone;

    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.placeholderLabel.text = kJL_TXT("gatt_uuid_placeholder");
    if (@available(iOS 13.0, *)) {
        self.placeholderLabel.textColor = [UIColor secondaryLabelColor];
    } else {
        // Fallback on earlier versions
        self.placeholderLabel.textColor = [UIColor lightGrayColor];
    }
    self.placeholderLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tipsLabel.text = kJL_TXT("gatt_uuid_tips");
    if (@available(iOS 13.0, *)) {
        self.tipsLabel.textColor = [UIColor secondaryLabelColor];
    } else {
        // Fallback on earlier versions
        self.tipsLabel.textColor = [UIColor lightGrayColor];
    }
    self.tipsLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.confirmButton setTitle:kJL_TXT("confirm") forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.confirmButton addTarget:self action:@selector(saveTapped) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.textView];
    [self.view addSubview:self.placeholderLabel];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.confirmButton];

    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.textView.topAnchor constraintEqualToAnchor:guide.topAnchor constant:20.0],
        [self.textView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:16.0],
        [self.textView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:-16.0],
        [self.textView.heightAnchor constraintEqualToConstant:180.0],

        [self.placeholderLabel.leadingAnchor constraintEqualToAnchor:self.textView.leadingAnchor constant:12.0],
        [self.placeholderLabel.topAnchor constraintEqualToAnchor:self.textView.topAnchor constant:12.0],

        [self.tipsLabel.topAnchor constraintEqualToAnchor:self.textView.bottomAnchor constant:12.0],
        [self.tipsLabel.leadingAnchor constraintEqualToAnchor:self.textView.leadingAnchor],
        [self.tipsLabel.trailingAnchor constraintEqualToAnchor:self.textView.trailingAnchor],

        [self.confirmButton.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:16.0],
        [self.confirmButton.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor constant:-16.0],
        [self.confirmButton.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor constant:-16.0],
        [self.confirmButton.heightAnchor constraintEqualToConstant:44.0],

        [self.tipsLabel.bottomAnchor constraintEqualToAnchor:self.confirmButton.topAnchor constant:-16.0],
    ]];
}

- (void)prefillInitialData {
    if (self.initialUUIDs.count == 0) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.textView.text = [self.initialUUIDs componentsJoinedByString:@"\n"];
        self.placeholderLabel.hidden = YES;
    }
}

#pragma mark - Actions
- (void)cancelTapped {
    if (self.onCancel) { self.onCancel(); }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveTapped {
    NSString *raw = self.textView.text ?: @"";
    NSError *error = nil;
    NSArray<NSString *> *uuids = [self parseAndValidate:raw error:&error];
    if (uuids) {
        if (self.onSave) { self.onSave(uuids); }
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"[Settings] Invalid GATT UUID input: %@", error.localizedDescription);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:kJL_TXT("gatt_uuid_error_title") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:kJL_TXT("ok_button") style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = !((textView.text ?: @"").length == 0);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self saveTapped];
        return NO;
    }
    return YES;
}

#pragma mark - Validation
- (NSArray<NSString *> *)parseAndValidate:(NSString *)input error:(NSError **)error {
    NSMutableCharacterSet *separators = [[NSCharacterSet characterSetWithCharactersInString:@","] mutableCopy];
    [separators formUnionWithCharacterSet:[NSCharacterSet newlineCharacterSet]];
    NSArray<NSString *> *rawParts = [input componentsSeparatedByCharactersInSet:separators];
    NSMutableArray<NSString *> *parts = [NSMutableArray array];
    for (NSString *item in rawParts) {
        NSString *s = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (s.length > 0) { [parts addObject:s]; }
    }

    if (parts.count == 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"com.jieli.ota.uuidinput" code:1 userInfo:@{NSLocalizedDescriptionKey: kJL_TXT("gatt_uuid_error_empty")}];
        }
        return nil;
    }

    NSString *hyphenPattern = @"^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$";
    NSString *shortPattern = @"^(?:[0-9a-fA-F]{4}|[0-9a-fA-F]{8}|[0-9a-fA-F]{32})$";

    NSMutableArray<NSString *> *normalized = [NSMutableArray array];
    NSMutableArray<NSString *> *invalids = [NSMutableArray array];
    for (NSString *p in parts) {
        if ([self string:p matchesRegex:hyphenPattern] || [self string:p matchesRegex:shortPattern]) {
            [normalized addObject:p.uppercaseString];
        } else {
            [invalids addObject:p];
        }
    }

    if (invalids.count > 0) {
        if (error) {
            NSString *joined = [invalids componentsJoinedByString:@"\n"];
            NSString *message = [NSString stringWithFormat:kJL_TXT("gatt_uuid_error_invalid_fmt"), joined];
            *error = [NSError errorWithDomain:@"com.jieli.ota.uuidinput" code:2 userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:normalized];
    return set.array;
}

- (BOOL)string:(NSString *)s matchesRegex:(NSString *)pattern {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:s];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


@end
