#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'Zhip.xcodeproj'
project = Xcodeproj::Project.open(project_path)

zhip_target = project.targets.find { |t| t.name == 'Zhip' }
tests_target = project.targets.find { |t| t.name == 'ZhipTests' }

def ensure_group(parent, name, path)
  existing = parent.children.find { |c| c.display_name == name && c.is_a?(Xcodeproj::Project::Object::PBXGroup) }
  return existing if existing
  parent.new_group(name, path)
end

def add_file_once(group, path, target)
  abs = File.expand_path(path)
  existing = group.files.find { |f| f.real_path.to_s == abs }
  ref = existing || group.new_reference(path)
  unless target.source_build_phase.files_references.include?(ref)
    target.add_file_references([ref])
  end
  ref
end

sources_group = project.main_group.find_subpath('Sources', true)
app_group = sources_group.find_subpath('Application', true)
di_group = ensure_group(app_group, 'DI', 'DI')
add_file_once(di_group, 'Sources/Application/DI/Container.swift', zhip_target)

tests_group = project.main_group.find_subpath('Tests', true) || project.main_group.find_subpath('ZhipTests', true)
# Prefer 'Tests' group if present, else create
tests_group ||= project.main_group.new_group('Tests', 'Tests')

helpers_group = ensure_group(tests_group, 'Helpers', 'Helpers')
Dir.glob('Tests/Helpers/*.swift').each do |f|
  add_file_once(helpers_group, f, tests_target)
end

tt_group = ensure_group(tests_group, 'Tests', 'Tests')
di_tests_group = ensure_group(tt_group, 'DI', 'DI')
use_cases_tests_group = ensure_group(tt_group, 'UseCases', 'UseCases')
vm_tests_group = ensure_group(tt_group, 'ViewModels', 'ViewModels')

Dir.glob('Tests/Tests/DI/*.swift').each { |f| add_file_once(di_tests_group, f, tests_target) }
Dir.glob('Tests/Tests/UseCases/*.swift').each { |f| add_file_once(use_cases_tests_group, f, tests_target) }
Dir.glob('Tests/Tests/ViewModels/*.swift').each { |f| add_file_once(vm_tests_group, f, tests_target) }

# Top-level new test file
['Tests/Tests/BalanceLastUpdatedFormatterTests.swift'].each do |f|
  add_file_once(tt_group, f, tests_target)
end

project.save
puts "Saved project."
