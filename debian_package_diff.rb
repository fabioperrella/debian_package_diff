#!/usr/bin/env ruby
require 'tmpdir'
require 'fileutils'
TEMPDIR = "tmp"
REPOSITORY_URL = "http://pacotes.linux.locaweb.com.br/ft_saas_squeeze/debian/pool/main"
include FileUtils

class DebianPackageDiff

  def initialize(package_name, version1, version2)
    @package_name = package_name
    @version1 = version1
    @version2 = version2
  end

  def compare
    puts "comparando pacote #{@package_name} #{@version1} e #{@version2}"
    remove_packages
    download_packages
    compare_packages
    puts "fim"
  end

  private

  def compare_packages
    puts "==> comparando se existem arquivos a mais em algum pacote..."
    system "debdiff #{TEMPDIR}/#{@package_name}_#{@version1}_amd64.deb #{TEMPDIR}/#{@package_name}_#{@version2}_amd64.deb"

    puts "==> comparando se existem arquivos com conteudo diferente em cada pacote..."
    system "debdiff #{TEMPDIR}/#{@package_name}_#{@version1}.dsc #{TEMPDIR}/#{@package_name}_#{@version2}.dsc"
  end

  def download_packages
    mkdir_p TEMPDIR
    base_url = "#{REPOSITORY_URL}/#{@package_name[0]}/#{@package_name}"
    [@version1, @version2].each do |version|
      [".dsc", ".tar.gz", "_amd64.deb"].each do |ext|
        `wget -P #{TEMPDIR} #{base_url}/#{@package_name}_#{version}#{ext}`
      end
    end
  end

  def remove_packages
    rm_rf TEMPDIR
  end
end

DebianPackageDiff.new(*ARGV).compare