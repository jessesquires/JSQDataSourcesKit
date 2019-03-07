
has_app_changes = !git.added_files.grep(/Source.*\.swift/).empty?
has_test_changes = !git.modified_files.grep(/Tests/.*\.swift/).empty?

###
### Specific files to watch
###

# CI related files to watch for changes.
@DANGER_CI_CD_FILES = ['.travis.yml', 'Dangerfile']

# Dependency files to watch for changes.
@DANGER_DEPENDENCY_FILES = ['Gemfile', 'JSQDataSourcesKit.podspec']

# determine if any of the files were modified
def didModify(files_array)
	did_modify_files = false
	files_array.each do |file_name|
		if git.modified_files.include?(file_name) || git.deleted_files.include?(file_name)
			did_modify_files = true
		end
	end
	return did_modify_files
end

warn('Changes to CI/CD files') if didModify(@DANGER_CI_CD_FILES)
warn('Changes to dependency related files') if didModify(@DANGER_DEPENDENCY_FILES)

# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
not_declared_trivial = !(github.pr_title.include? "#trivial")

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

###
### Auto label
###
if github.pr_title.include? "[WIP]"
	auto_label.wip=(github.pr_json["number"])
else
	auto_label.remove("WIP")
	# If you want to delete label
	# auto_label.delete("WIP")
end

###
### General warnings
###

# Warn when there is a big PR
warn("Big PR, try to keep changes smaller if you can") if git.lines_of_code > 500

# Changelog entries are required for changes to library files.
no_changelog_entry = !git.modified_files.include?("CHANGELOG.md")

if has_app_changes && no_changelog_entry && not_declared_trivial && !temp_skip_changelog
  warn("Any changes to library code should be reflected in the Changelog. Please consider adding a note there and adhere to the [Changelog Guidelines](https://github.com/jessesquires/JSQDataSourcesKit/CHANGELOG.md).")
end

if has_app_changes && !has_test_changes
	warn("Library files were updated without test coverage.  Consider updating or adding tests to cover changes.")
end


# Run SwiftLint

# Note: The argument "--force-exclude" is passed to SwiftLint by the danger-swiftlint plugin
#       But this SwiftLint argument doesn't work properly & has issues.
#       So instead, we re-disable it, and filter the list of files manually :-/
files_to_lint = (git.modified_files - git.deleted_files) + git.added_files
files_to_lint.reject! { |f| f.start_with?('scripts/', 'docs/') }
swiftlint.lint_files(files_to_lint,
	additional_swiftlint_args: '--no-force-exclude'
)
