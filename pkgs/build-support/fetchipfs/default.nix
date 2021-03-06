{ stdenv
, curl
}:

{ ipfs
, url            ? ""
, curlOpts       ? ""
, outputHash     ? ""
, outputHashAlgo ? ""
, md5            ? ""
, sha1           ? ""
, sha256         ? ""
, sha512         ? ""
, meta           ? {}
, port           ? "8080"
, postFetch      ? ""
}:

assert sha512 != "" -> builtins.compareVersions "1.11" builtins.nixVersion <= 0;

let

  hasHash = (outputHash != "" && outputHashAlgo != "")
    || md5 != "" || sha1 != "" || sha256 != "" || sha512 != "";

in

if (!hasHash) then throw "Specify sha for fetchipfs fixed-output derivation" else stdenv.mkDerivation {
  name = ipfs;
  builder = ./builder.sh;
  buildInputs = [ curl ];

  # New-style output content requirements.
  outputHashAlgo = if outputHashAlgo != "" then outputHashAlgo else
      if sha512 != "" then "sha512" else if sha256 != "" then "sha256" else if sha1 != "" then "sha1" else "md5";
  outputHash = if outputHash != "" then outputHash else
      if sha512 != "" then sha512 else if sha256 != "" then sha256 else if sha1 != "" then sha1 else md5;

  outputHashMode = "recursive";

  inherit curlOpts
          postFetch
          ipfs
          url
          port;

  # Doing the download on a remote machine just duplicates network
  # traffic, so don't do that.
  preferLocalBuild = true;

  inherit meta;
}
