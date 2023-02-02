namespace :release do
  desc "Create a release package"
  task package: :environment do
    require "fast_ignore"

    extend FileUtils

    dry_run = ENV.key?("DRY_RUN")
    version = ENV.fetch("VERSION", nil)
    version = version.delete_prefix('v') if version

    root_dir = Bundler.root
    dist_dir = File.join(root_dir, "dist")
    pkg_dir = File.join(dist_dir, "pkg")
    archive_dir = File.join(pkg_dir, "eve_commerce")
    archive_filename = ["eve_commerce", version].compact.join("-")

    release_files = FastIgnore.new(relative: true, root: Bundler.root, gitignore: false, ignore_files: [".releaseignore"]).to_a
    release_dirs = release_files.each_with_object(Set.new) { |p, s| s.add(File.join(archive_dir, File.dirname(p))) }

    rm_rf(pkg_dir, verbose: true, noop: dry_run)
    mkdir_p(pkg_dir, verbose: true, noop: dry_run)
    rm_rf(archive_dir, verbose: true, noop: dry_run)
    mkdir_p(archive_dir, verbose: true, noop: dry_run)

    release_dirs.each { |dir| mkdir_p(dir, verbose: true, noop: dry_run) }
    release_files.to_a.each do |path|
      dest_path = File.join(archive_dir, path)
      cp_r(Bundler.root.join(path), File.dirname(dest_path), verbose: true, noop: dry_run)
    end

    system("cd #{pkg_dir} && zip -vr #{archive_filename}.zip eve_commerce/")
    system("cd #{pkg_dir} && tar -czvf #{archive_filename}.tar.gz eve_commerce/")
    system("cd #{pkg_dir} && tar -cjvf #{archive_filename}.tar.bz2 eve_commerce/")
  end
end
