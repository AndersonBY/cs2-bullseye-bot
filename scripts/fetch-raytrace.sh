#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cache_dir="${repo_root}/.deps/raytrace-v1.0.16"
managed_asset="${cache_dir}/RayTrace-CSS-API-v1.0.16.tar.gz"
native_asset="${cache_dir}/RayTrace-MM-v1.0.16-linux.tar.gz"
managed_url="https://github.com/FUNPLAY-pro-CS2/Ray-Trace/releases/download/v1.0.16/RayTrace-CSS-API-v1.0.16.tar.gz"
native_url="https://github.com/FUNPLAY-pro-CS2/Ray-Trace/releases/download/v1.0.16/RayTrace-MM-v1.0.16-linux.tar.gz"
managed_sha="e865ca551da35af31dc70f271840d1dce932a84e1c1bd27aa5ad3191efe6e1d4"
native_sha="585cc10b9e2fcb47e475abd89c50a5164a333d735851e99f928eec83c2a2bc47"

mkdir -p "${cache_dir}" "${repo_root}/libs"

if [[ ! -f "${managed_asset}" ]]; then
  curl -fL --retry 3 --output "${managed_asset}" "${managed_url}"
fi
if [[ ! -f "${native_asset}" ]]; then
  curl -fL --retry 3 --output "${native_asset}" "${native_url}"
fi

printf '%s  %s\n' "${managed_sha}" "${managed_asset}" | sha256sum --check --status
printf '%s  %s\n' "${native_sha}" "${native_asset}" | sha256sum --check --status

extract_dir="${cache_dir}/managed"
rm -rf "${extract_dir}"
mkdir -p "${extract_dir}"
tar -xzf "${managed_asset}" -C "${extract_dir}"
install -m 0644 \
  "${extract_dir}/RayTrace-CSS-API-v1.0.16/counterstrikesharp/shared/RayTraceApi/RayTraceApi.dll" \
  "${repo_root}/libs/RayTraceApi.dll"

echo "RayTrace v1.0.16 dependencies verified; build reference installed at libs/RayTraceApi.dll"
