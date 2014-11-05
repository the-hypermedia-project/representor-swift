task :bootstrap do
  sh 'gem install xcpretty'

  # xctasks doesn't yet have project support in a release
  sh 'gem install specific_install'
  sh 'gem specific_install https://github.com/layerhq/xctasks'
end

begin
  require 'xctasks/test_task'

  task default: :test

  XCTasks::TestTask.new(:test) do |task|
    task.project = 'HypermediaResource.xcodeproj'
    task.runner = :xcpretty

    task.subtask(test: 'HypermediaResource') do |osx|
      osx.sdk = :macosx
    end
  end
rescue LoadError
end

