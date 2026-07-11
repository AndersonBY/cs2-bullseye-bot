#!/usr/bin/env bash
set -euo pipefail

tag="${1:?release tag is required, for example v1.2.3-mbsifu.1}"
output_arg="${2:-artifacts}"
if [[ ! "${tag}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+-mbsifu\.[0-9]+$ ]]; then
  echo "invalid release tag: ${tag}" >&2
  exit 2
fi

if [[ "${tag%%-mbsifu.*}" != "v2.1.4" ]]; then
  echo "release tag ${tag} does not match project version v2.1.4" >&2
  exit 2
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="$(mkdir -p "${repo_root}/${output_arg}" && cd "${repo_root}/${output_arg}" && pwd)"
staging="${repo_root}/.release-staging"
dotnet="${DOTNET:-dotnet}"
rm -rf "${staging}"
mkdir -p "${staging}/addons"

"${repo_root}/scripts/fetch-raytrace.sh"
"${dotnet}" build "${repo_root}/BotAimImprover.csproj" -c Release --nologo
plugin_dir="${staging}/addons/counterstrikesharp/plugins/BotAimImprover"
mkdir -p "${plugin_dir}"
install -m 0644 "${repo_root}/bin/Release/net10.0/BotAimImprover.dll" "${plugin_dir}/BotAimImprover.dll"
install -m 0644 "${repo_root}/bin/Release/net10.0/BotAimImprover.deps.json" "${plugin_dir}/BotAimImprover.deps.json"

managed_root="${repo_root}/.deps/raytrace-v1.0.16/managed/RayTrace-CSS-API-v1.0.16/counterstrikesharp"
native_root="${repo_root}/.deps/raytrace-v1.0.16/native"
rm -rf "${native_root}"
mkdir -p "${native_root}"
tar -xzf "${repo_root}/.deps/raytrace-v1.0.16/RayTrace-MM-v1.0.16-linux.tar.gz" -C "${native_root}"
mkdir -p "${staging}/addons/counterstrikesharp"
cp -a "${managed_root}/." "${staging}/addons/counterstrikesharp/"
cp -a "${native_root}/metamod" "${staging}/addons/metamod"
cp -a "${native_root}/RayTrace" "${staging}/addons/RayTrace"
find "${staging}" -type f -name 'CounterStrikeSharp.API.dll' -delete
find "${staging}" -type d -path '*/runtimes/win' -prune -exec rm -rf {} +
cp "${repo_root}/README.md" "${staging}/README.md"
cp "${repo_root}/LICENSE" "${staging}/LICENSE"
jq --arg version "${tag#v}" --arg build_revision "$(git -C "${repo_root}" rev-parse HEAD)" \
  '.version = $version | .build_revision = $build_revision' \
  "${repo_root}/packaging/plugin-manifest.json" > "${staging}/plugin-manifest.json"
cp "${staging}/plugin-manifest.json" "${output_dir}/plugin-manifest.json"

source_date_epoch="${SOURCE_DATE_EPOCH:-$(git -C "${repo_root}" show -s --format=%ct HEAD)}"
find "${staging}" -type f -exec touch -d "@${source_date_epoch}" {} +

archive="${output_dir}/cs2-bullseye-bot-${tag}-linux-x64.zip"
rm -f "${archive}" "${archive}.sha256"
(
  cd "${staging}"
  find . -type f -print | LC_ALL=C sort | zip -X -q "${archive}" -@
)
(
  cd "${output_dir}"
  sha256sum "$(basename "${archive}")" > "$(basename "${archive}").sha256"
)

"${repo_root}/scripts/validate-release.sh" "${archive}" "${output_dir}/plugin-manifest.json" "${archive}.sha256"
echo "created ${archive}"
