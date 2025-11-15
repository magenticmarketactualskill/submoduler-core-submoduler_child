# Requirements Document - Child Status Command

## Introduction

This document specifies the requirements for the Submoduler Child status command, which displays the git status of the child submodule repository.

## Glossary

- **Submoduler Child**: A command-line tool for managing operations within a SubmoduleChild repository
- **Status Command**: A command that displays git status information
- **SubmoduleChild**: A git repository with .gitmodules and .submoduler.ini file where [default] submodule_child=true
- **Working Tree**: The current state of files in a git repository
- **Dirty Repository**: A repository with uncommitted changes

## Requirements

### Requirement 1: Display Child Status

**User Story:** As a developer working in a child submodule, I want to see the repository status, so that I know if there are uncommitted changes

#### Acceptance Criteria

1. WHEN the developer runs "bin/submoduler_child.rb status", THE Submoduler Child SHALL display the git status of the current repository
2. THE Submoduler Child SHALL indicate if the working tree is clean
3. THE Submoduler Child SHALL list modified files in the repository
4. THE Submoduler Child SHALL list untracked files in the repository
5. THE Submoduler Child SHALL indicate if there are staged changes

### Requirement 2: Display Branch Information

**User Story:** As a developer, I want to see branch information, so that I know which branch I'm working on

#### Acceptance Criteria

1. THE Submoduler Child SHALL display the current branch name
2. THE Submoduler Child SHALL indicate if the branch is ahead of the remote
3. THE Submoduler Child SHALL indicate if the branch is behind the remote
4. THE Submoduler Child SHALL display the number of commits ahead or behind
5. IF the branch has no remote tracking, THEN THE Submoduler Child SHALL indicate this

### Requirement 3: Format Status Output

**User Story:** As a developer, I want clear, formatted status output, so that I can quickly understand the repository state

#### Acceptance Criteria

1. THE Submoduler Child SHALL use visual indicators (✓, ✗) for clean and dirty status
2. THE Submoduler Child SHALL use color coding for different status types
3. THE Submoduler Child SHALL group files by status (modified, untracked, staged)
4. WHEN the repository is clean, THE Submoduler Child SHALL display a success message
5. THE Submoduler Child SHALL display a summary line with total file counts

### Requirement 4: Handle Status Errors

**User Story:** As a developer, I want clear error messages for status failures, so that I can troubleshoot issues

#### Acceptance Criteria

1. IF git is not available, THEN THE Submoduler Child SHALL display an error message
2. IF the current directory is not a git repository, THEN THE Submoduler Child SHALL display an error message
3. IF git status fails, THEN THE Submoduler Child SHALL display the specific error
4. WHEN errors occur, THE Submoduler Child SHALL exit with a non-zero status code
5. THE Submoduler Child SHALL provide suggestions for common error scenarios
