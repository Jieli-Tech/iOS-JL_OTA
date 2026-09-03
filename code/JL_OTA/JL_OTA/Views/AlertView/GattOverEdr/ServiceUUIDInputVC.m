//
//  ServiceUUIDInputVC.m
//  JL_OTA
//
//  Created by EzioChan on 2025/12/1.
//  Copyright © 2025 Zhuhia Jieli Technology. All rights reserved.
//

#import "ServiceUUIDInputVC.h"
#import "Masonry.h"

@interface ServiceUUIDInputVC () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) NSArray<NSString *> *initialUUIDs;

@end

@implementation ServiceUUIDInputVC

- (instancetype)initWithInitialUUIDs:(NSArray<NSString *> *)initialUUIDs {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _initialUUIDs = [initialUUIDs copy];
        if (_initialUUIDs.count == 0) {
            _initialUUIDs = @[@"AE00"];
        }
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

    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tipsLabel.text = kJL_TXT("gatt_uuid_tips");
    if (@available(iOS 13.0, *)) {
        self.tipsLabel.textColor = [UIColor secondaryLabelColor];
    } else {
        // Fallback on earlier versions
        self.tipsLabel.textColor = [UIColor lightGrayColor];
    }
    self.tipsLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];


    [self.view addSubview:self.textView];
    [self.view addSubview:self.placeholderLabel];
    [self.view addSubview:self.tipsLabel];

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20.0);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(16.0);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-16.0);
        } else {
            make.top.equalTo(self.view.mas_top).offset(20.0);
            make.left.equalTo(self.view.mas_left).offset(16.0);
            make.right.equalTo(self.view.mas_right).offset(-16.0);
        }
        make.height.mas_equalTo(180.0);
    }];

    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView.mas_left).offset(12.0);
        make.top.equalTo(self.textView.mas_top).offset(12.0);
    }];


    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(12.0);
        make.left.equalTo(self.textView.mas_left);
        make.right.equalTo(self.textView.mas_right);
    }];
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
