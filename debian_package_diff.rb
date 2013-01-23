#!/usr/bin/env ruby
require 'tmpdir'
require 'fileutils'
TEMPDIR = "tmp"
include FileUtils

def main
  package_name = ARGV[0]
  version1 = ARGV[1]
  version2 = ARGV[2]

  puts "comparando pacote #{package_name} #{version1} e #{version2}"
  remove_packages
  download_packages(package_name, version1, version2)
  compare_packages(package_name, version1, version2)

  puts "fim"
end

def compare_packages(package_name, version1, version2)
  puts "==> comparando se existem arquivos a mais em algum pacote..."
  system "debdiff #{TEMPDIR}/#{package_name}_#{version1}_amd64.deb #{TEMPDIR}/#{package_name}_#{version2}_amd64.deb"

  puts "==> comparando se existem arquivos com conteudo diferente em cada pacote..."
  system "debdiff #{TEMPDIR}/#{package_name}_#{version1}.dsc #{TEMPDIR}/#{package_name}_#{version2}.dsc"
end

def download_packages(package_name, version1, version2)
  mkdir_p "tmp"
  base_url = "http://pacotes.linux.locaweb.com.br/ft_saas_squeeze/debian/pool/main/#{package_name[0]}/#{package_name}"
  [version1, version2].each do |version|
    [".dsc", ".tar.gz", "_amd64.deb"].each do |ext|
      `wget -P tmp #{base_url}/#{package_name}_#{version}#{ext}`
    end
  end
end

def remove_packages
  rm_rf "tmp"
end

main()