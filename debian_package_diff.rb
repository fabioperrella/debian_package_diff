#!/usr/bin/env ruby

def main
  package_name = ARGV[0]
  version1 = ARGV[1]
  version2 = ARGV[2]

  puts "comparando pacote #{package_name} #{version1} e #{version2}"
  # download_packages(package_name, version1, version2)

  puts "==> comparando se existem arquivos a mais em algum pacote..."
  system "debdiff #{package_name}_#{version1}_amd64.deb #{package_name}_#{version2}_amd64.deb"

  puts "==> comparando se existem arquivos com conteudo diferente em cada pacote..."
  system "debdiff #{package_name}_#{version1}.dsc #{package_name}_#{version2}.dsc"

  puts "fim"
end

def download_packages(package_name, version1, version2)
  base_url = "http://pacotes.linux.locaweb.com.br/ft_saas_squeeze/debian/pool/main/#{package_name[0]}/#{package_name}"
  [version1, version2].each do |version|
    [".dsc", ".tar.gz", "_amd64.deb"].each do |ext|
      `wget #{base_url}/#{package_name}_#{version}#{ext}`
    end
  end
end

main()