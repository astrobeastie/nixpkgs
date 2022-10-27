{ isabelle, path }:

let
  dir = "$out/isabelle/${isabelle-emacs.dirname}";
  iDir = "${isabelle-emacs}/${isabelle-emacs.dirname}";
in ''
  shopt -s extglob
  mkdir -p ${dir}/lib/classes

  cDir=$out/${isabelle-emacs.dirname}/contrib/${path}
  mkdir -p $cDir
  cp -r !(isabelle) $cDir

  cd ${dir}
  ln -s ${iDir}/!(lib|bin) ./
  ln -s ${iDir}/lib/!(classes) lib/
  ln -s ${iDir}/lib/classes/* lib/classes/

  mkdir bin/
  cp ${iDir}/bin/* bin/

  export HOME=$TMP
  bin/isabelle components -u $cDir
  bin/isabelle scala_build

  cd lib/classes
  for f in ${iDir}/lib/classes/*; do
    rm $(basename $f)
  done

  lDir=$out/${isabelle-emacs.dirname}/lib/classes/
  mkdir -p $lDir
  cp -r * $lDir
  cd $out
  rm -rf isabelle
''
