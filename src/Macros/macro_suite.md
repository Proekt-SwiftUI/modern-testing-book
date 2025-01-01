# @Suite

<!-- Перевод -->

/// Declare a test suite.
///
/// - Parameters:
///   - traits: Zero or more traits to apply to this test suite.
///
/// A test suite is a type that contains one or more test functions. Any
/// copyable type (that is, any type that is not marked `~Copyable`) may be a
/// test suite.
///
/// The use of the `@Suite` attribute is optional; types are recognized as test
/// suites even if they do not have the `@Suite` attribute applied to them.
///
/// When adding test functions to a type extension, do not use the `@Suite`
/// attribute. Only a type's primary declaration may have the `@Suite` attribute
/// applied to it.
///
/// ## See Also
///
/// - <doc:OrganizingTests>

```swift
@attached(member) @attached(peer)
@_documentation(visibility: private)
public macro Suite(
  _ traits: any SuiteTrait...
) = #externalMacro(module: "TestingMacros", type: "SuiteDeclarationMacro")

```
