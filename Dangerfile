
has_source_changes = !git.added_files.grep(/Source/).empty?
has_test_changes = !git.modified_files.grep(/Tests/).empty?

warn("This is a large pull request! Can you break it up into multiple smaller ones instead?") if git.lines_of_code > 500

# Changelog entries are required for changes to library files.
no_changelog_entry = !git.modified_files.include?("CHANGELOG.md")

if has_source_changes && no_changelog_entry
  warn("There's no changelog entry. Do you need to add one?.")
end

if has_source_changes && !has_test_changes
	warn("Library files were updated without test coverage.  Consider updating or adding tests to cover changes.")
end

# Run danger-prose to lint and check spelling.
markdown_files = (git.added_files.grep(%r{.*\.md/}) + git.modified_files.grep(%r{.*\.md/}))

unless markdown_files.empty?
  prose.lint_files markdown_files
  prose.language = "en-us"
  prose.ignored_words = ["JSQDataSourcesKit", "jessesquires", "enum", "enums", "CocoaPods"]
  prose.ignore_acronyms = true
  prose.ignore_numbers = true
  prose.check_spelling markdown_files
end

# Run SwiftLint

swiftlint.verbose = true
swiftlint.config_file = './.swiftlint.yml'
swiftlint.lint_files(inline_mode: true, fail_on_error: true)
