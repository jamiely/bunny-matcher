require 'plist'

class ProjectVersion
  attr_accessor :build, :version
  def self.from_plist_hash(hash)
    proj = ProjectVersion.new
    proj.build = hash['CFBundleVersion']
    proj.version = hash['CFBundleShortVersionString']
    proj
  end
end

class ProjectVersionProcessor
  def initialize(proj_ver)
    @project_version = proj_ver
  end
  def bump_build
    num = @project_version.build.to_f
    num += 0.1
    num.round(1).to_s
  end
end

class ProjectPlist
  attr_accessor :data, :filepath
  def self.from_file(filename)
    proj = ProjectPlist.new
    proj.filepath = filename
    proj.data = Plist::parse_xml filename
    proj
  end
  def set(key, value)
    @data[key] = value
  end
  def write!
    File.open(@filepath, 'w') do |f|
      f.write(@data.to_plist)
    end
  end
end

task :bump do
	plist = ProjectPlist.from_file("BunnyMatcher/BunnyMatcher-Info.plist")
  proj_ver = ProjectVersion.from_plist_hash(plist.data)
  processor = ProjectVersionProcessor.new proj_ver
  next_build = processor.bump_build
  plist.set 'CFBundleVersion', next_build
  plist.write!

  puts "CFBundleVersion bumped from #{proj_ver.build} to #{next_build}"
end
