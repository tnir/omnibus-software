#
# Copyright 2012-2014 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "popt"
default_version "1.18"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "config_guess"

# versions_list: https://github.com/rpm-software-management/popt/releases filter=*.tar.gz
version("1.18") { source sha256: "5159bc03a20b28ce363aa96765f37df99ea4d8850b1ece17d1e6ad5c24fdc5d1" }
source url: "http://ftp.rpm.org/popt/releases/popt-1.x/popt-#{version}.tar.gz"
relative_path "popt-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  update_config_guess

  if version == "1.7.10.1" && (ppc64? || ppc64le?)
    patch source: "v1.7.10.1.ppc64le-configure.patch", plevel: 1
  end

  # --disable-nls => Disable localization support.
  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --disable-nls", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
