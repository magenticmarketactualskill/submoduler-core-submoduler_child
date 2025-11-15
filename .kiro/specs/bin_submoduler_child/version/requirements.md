# Requirements Document - Child Version Command

## Introduction

This document specifies the requirements for the Submoduler Child version command, which displays and manages version information for the child submodule.

## Glossary

- **Submoduler Child**: A command-line tool for managing operations within a SubmoduleChild repository
- **Version Command**: A command that displays or updates version information
- **SubmoduleChild**: A git repository with .gitmodules and .submoduler.ini file where [default] submodule_child=true
- **Semantic Versioning**: A versioning scheme using MAJOR.MINOR.PATCH format
- **Version File**: A Ruby file (lib/*/version.rb) containing the VERSION constant

## Requirements

### Requirement 1: Display Current Version

**User Story:** As a developer, I want to see the current version, so that I know which version I'm working on

#### Acceptance Criteria

1. WHEN the developer runs "bin/submoduler_child.rb version", THE Submoduler Child SHALL display the current version number
2. THE Submoduler Child SHALL read the version from lib/*/version.rb file
3. THE Submoduler Child SHALL display the version in MAJOR.MINOR.PATCH format
4. IF the version file does not exist, THEN THE Submoduler Child SHALL display an error message
5. THE Submoduler Child SHALL display the gem name along with the version

### Requirement 2: Update Version Number

**User Story:** As a developer, I want to update the version number, so that I can prepare for a new release

#### Acceptance Criteria

1. THE Submoduler Child SHALL support a --bump flag with values: major, minor, patch
2. WHEN the developer runs "bin/submoduler_child.rb version --bump patch", THE Submoduler Child SHALL increment the patch version
3. WHEN the developer runs "bin/submoduler_child.rb version --bump minor", THE Submoduler Child SHALL increment the minor version and reset patch to 0
4. WHEN the developer runs "bin/submoduler_child.rb version --bump major", THE Submoduler Child SHALL increment the major version and reset minor and patch to 0
5. THE Submoduler Child SHALL update the version.rb file with the new version

### Requirement 3: Validate Version Format

**User Story:** As a developer, I want version validation, so that I maintain proper semantic versioning

#### Acceptance Criteria

1. THE Submoduler Child SHALL validate that the version follows MAJOR.MINOR.PATCH format
2. THE Submoduler Child SHALL ensure all version components are non-negative integers
3. IF the version format is invalid, THEN THE Submoduler Child SHALL display an error message
4. THE Submoduler Child SHALL preserve any pre-release or build metadata in the version
5. WHEN updating the version, THE Submoduler Child SHALL display both old and new versions

### Requirement 4: Display Version History

**User Story:** As a developer, I want to see version history, so that I can track version changes

#### Acceptance Criteria

1. THE Submoduler Child SHALL support a --history flag
2. WHEN the developer runs "bin/submoduler_child.rb version --history", THE Submoduler Child SHALL display git tags
3. THE Submoduler Child SHALL filter tags that match version patterns (v*.*.*)
4. THE Submoduler Child SHALL display tags in reverse chronological order
5. THE Submoduler Child SHALL show the commit message for each version tag
