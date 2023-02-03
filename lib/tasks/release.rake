namespace :release do
  desc "Create a release package"
  task tarball: :environment do
    require "fast_ignore"

    extend FileUtils

    dry_run = ENV.key?("DRY_RUN")
    verbose = ENV.key?("VERBOSE")
    signing_key = ENV.fetch("SIGNING_KEY", nil)
    version = ENV.fetch("VERSION", nil)
    version = version.delete_prefix("v") if version

    pkg_dir = Bundler.root.join("pkg")
    base_filename = ["eveops-commerce", version].compact.join("-")

    rm_rf(pkg_dir, verbose: verbose, noop: dry_run)
    mkdir_p(pkg_dir, verbose: verbose, noop: dry_run)

    create_archive("release", ignore_files: [".releaseignore"], gitignore: false, dry_run:, verbose:, pkg_dir:, base_filename:, signing_key:)
    create_archive("source", suffix: "source", ignore_files: [".sourceignore"], dry_run:, verbose:, pkg_dir:, base_filename:, signing_key:)
  end

  desc "Upload assets to a GitHub release"
  task upload: :environment do
    version = ENV.fetch("VERSION")
    dry_run = ENV.key?("DRY_RUN")
    asset_paths = Dir[Bundler.root.join("pkg/*.tar.gz*")]

    upload_cmd = "gh release upload #{version} #{asset_paths.join(" ")} --clobber -R eveops/commerce"
    dry_run ? puts(upload_cmd) : system(upload_cmd)
  end
end

def create_archive(name, base_filename:, pkg_dir:, suffix: nil, ignore_files: nil, gitignore: true, verbose: false, dry_run: false, signing_key: nil)
  staging_dir = File.join(pkg_dir, name)
  archive_dir = File.join(staging_dir, "eveops-commerce")

  src_files = FastIgnore.new(relative: true, root: Bundler.root, gitignore:, ignore_files:).to_a
  src_dirs = src_files.each_with_object(Set.new) { |p, s| s.add(File.join(archive_dir, File.dirname(p))) }

  rm_rf(staging_dir, verbose: verbose, noop: dry_run)
  mkdir_p(archive_dir, verbose: verbose, noop: dry_run)

  src_dirs.each { |dir| mkdir_p(dir, verbose: verbose, noop: dry_run) }
  src_files.to_a.each do |path|
    dest_path = File.join(archive_dir, path)
    cp_r(Bundler.root.join(path), File.dirname(dest_path), verbose: verbose, noop: dry_run)
  end

  filename = "#{[base_filename, suffix].compact.join("-")}.tar.gz"

  archive_cmd = "cd #{staging_dir} && tar -czf #{filename} eveops-commerce/"
  sign_cmd = "cd #{staging_dir} && gpg --detach-sign -a --default-key #{signing_key}! ./#{filename} 2>/dev/null"
  checksum_cmd = "cd #{staging_dir} && sha256sum #{filename} > #{filename}.sha256"
  mv_cmd = "mv #{staging_dir}/#{filename}* #{pkg_dir}"

  if dry_run
    puts archive_cmd
    puts sign_cmd if signing_key
    puts checksum_cmd
    puts mv_cmd
  else
    system(archive_cmd)
    system(sign_cmd) if signing_key
    system(checksum_cmd)
    system(mv_cmd)
  end
end
