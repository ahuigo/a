---
layout: page
title:	brew dev
category: blog
description: 
---
# Preface

# rule
brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb

	require 'formula'

	class Sshpass < Formula
	  url 'http://sourceforge.net/projects/sshpass/files/sshpass/1.05/sshpass-1.05.tar.gz'
	  homepage 'http://sourceforge.net/projects/sshpass'
	  sha256 'c3f78752a68a0c3f62efb3332cceea0c8a1f04f7cf6b46e00ec0c3000bc8483e'

	  def install
		system "./configure", "--disable-debug", "--disable-dependency-tracking",
							  "--prefix=#{prefix}"
		system "make install"
	  end

	  def test
		system "sshpass"
	  end
	end

## sha256

    $ shasum -a 256 test.tgz

## binary package
https://github.com/v2ray/homebrew-v2ray/blob/master/Formula/v2ray-core.rb

利用bin.install, etc.install copy

    def install
        # ENV.deparallelize  # if your formula fails when building in parallel

        # system "tar -Jvxf otfcc-mac64-0.2.3.tgz"
        bin.install "otfccbuild"
        bin.install "otfccdump"

        (etc/"v2ray").mkpath
        etc.install "config.json" => "v2ray/config.json"
    end



## depends on

    class Foo < Formula
        depends_on "pkg-config"
        depends_on "jpeg"
        depends_on "readline" => :recommended
        depends_on "gtk+" => :optional
        depends_on "httpd" => [:build, :test]
        depends_on :x11 => :optional
        depends_on :xcode => "9.3"
    end

# Use Formula
> refer to : https://segmentfault.com/a/1190000012826983

repo可以省略`homebrew-`

    brew tap <user/repo>
    brew untap <user/repo>

    brew install vim  # installs from homebrew/core
    brew install username/repo/vim  # installs from your custom repo

## tap example
https://github.com/v2ray/homebrew-v2ray/blob/master/Formula/v2ray-core.rb

    brew tap v2ray/v2ray
    brew install v2ray-core

or

    brew install v2ray/v2ray/v2ray-core

https://github.com/ahuigo/homebrew-ahui/blob/master/langdao-dict.rb

     brew install ahuigo/ahui/langdao-dict
     brew install --verbose --debug ahuigo/ahui/langdao-dict

# install dir
dir:

    brew --repo
        /usr/local/Homebrew
    brew --cache
        ~/Library/Caches/Homebrew/downloads

# brew via ss
export ALL_PROXY=socks5://127.0.0.1:1080