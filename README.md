# Collator
An Xcode plugin that alphabetizes property names.

## Example

*Before*
```
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstName;
@property (nonatmoic, strong) NSString *lastName;
@property (nonatomic, weak) UIImage *profileImage;
```
*After*
```
@property (nonatomic, strong) NSString *firstName;
@property (nonatmoic, strong) NSString *lastName;
@property (nonatomic, weak) UIImage *profileImage;
@property (nonatomic, strong) NSString *username;
```

##Notes
Arbitrary comments and whitespace are supported and are carried along with the property following the comment or whitespace.
